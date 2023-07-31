import os
import sys
import traceback
sys.path.append(os.path.relpath('.'))
sys.path.append(os.path.relpath('./text_analysis'))

from lib import *
import argparse
from slither import Slither
from time import time
from code_schema import code2Schema
from text_analysis import extract_com_one_contract
from check_intent import check_one_contract
from multiprocessing import Pool
import shutil
from func_timeout import func_set_timeout
from config import Config

temp_path_prefix = f'./.temp'

IS_WRITE_DOWN = True

@func_set_timeout(600)
def process_one_contract(contract_path):
    try:
        contract = os.path.basename(contract_path)
        res_temp_path = os.path.join(temp_path_prefix, contract)
        check_or_mkdir(res_temp_path)

        succ, res = analyze_contract(contract_path)
        
        if IS_WRITE_DOWN:
            with open('./.temp/result.txt', 'a+') as f:
                f.write(res)
        
        if succ is True:
            shutil.copy(contract_path, res_temp_path)       
        else:
            check_and_deletedir(res_temp_path)
        return 0
    except:
        print("run error unknown~")
        return 0
        

def analyze_contract(contract_path):
    """
    contract_path : './sdasdsad/asdasdas/xxxx.sol'
    """
    use_time = 0
    fact_num = 0
    comment_num, extract_com_num, con_num, incon_num, version = 0, 0, 0, 0, 0
    contract = os.path.basename(contract_path)
    print(f"{contract}: \n")
    
    # create dir for one file 
    res_temp_path = os.path.join(temp_path_prefix, contract)

    st_time = time()
    
    try:
        version, solc_path = solidity.get_solc_path(contract_path)
    except Exception as e:
        print(f'ERROR001: connot find the compiler! Exception:{e}')
        # print(traceback.print_exc())
        print('Please add -v all/version to install the solc.')
        return False, f'{contract},ERROR-1:{version},{comment_num},{extract_com_num},{con_num},{incon_num},{use_time},{fact_num}\n'
    

    # Get solc binary path
    try:
        slither_obj = Slither(contract_path, solc=solc_path)
    except Exception as e:
        print(f"ERROR002: connot transfer to AST! Exception:{e}")
        # print(traceback.print_exc())
        return False, f'{contract},ERROR-2,{comment_num},{extract_com_num},{con_num},{incon_num},{use_time},{fact_num}\n'
    
    # end_time = time()
    # use_time = end_time - st_time 

    
    # print(f'=============Code Facts=============')
    # generate code facts and  comments facts 
    # TODO CODE FACT
    try:
        fact_num = code2Schema(slither_obj, contract)
    except Exception as e:
        print(False, f"ERROR004: connot build Code Facts! Exception:{e}")
        # print(traceback.print_exc())
        return False, f'{contract},ERROR-4,{comment_num},{extract_com_num},{con_num},{incon_num},{use_time},{fact_num}\n'
    

    # print(f'=========Solve comment facts========')
    # COMMENT FACT TODO: extract facts
    try: 
        comment_num, extract_com_num = extract_com_one_contract(contract_path, contract, slither_obj)
        if extract_com_num == 0:
            return False, f'{contract},ERROR-EM,{comment_num},{extract_com_num},{con_num},{incon_num},{use_time},{fact_num}\n'
    except Exception as e:
        print(f"ERROR003: connot build comment constraints! Exception:{e}")
        # print(traceback.print_exc())
        return False, f'{contract},ERROR-3,{comment_num},{extract_com_num},{con_num},{incon_num},{use_time},{fact_num}\n'
    # write_down_comment_fact(con_temp_path, comments)


    # print(f'=======Propagate and Consistency check======')
    try:
        con, incon = check_one_contract(contract, contract_path)
        con_num, incon_num = len(con), len(incon) 
    except Exception as e:
        print(f"ERROR005: connot do consistency detection! Exception:{e}")
        print(traceback.print_exc())
        return False, f'{contract},ERROR-5,{comment_num},{extract_com_num},{con_num},{incon_num},{use_time},{fact_num}\n'
    
    end_time = time()
    use_time = end_time - st_time    
    print(f'=========END END========')

    return True, f'{contract},Success-1,{comment_num},{extract_com_num},{con_num},{incon_num},{use_time},{fact_num}\n'



def write_down_incon_total(incon):
    with open(f'./.temp/tot_incon.csv', 'a+') as f:
        f.writelines(incon)
            

def find_all_sol_files(target_dir, target_suffix=".sol"):
    find_res = []
    for root_path, dirs, files in os.walk(target_dir):
        for file in files:
            if file.endswith(target_suffix):
                find_res.append(os.path.join(root_path, file))
    return find_res 


def main_run():
    parser = argparse.ArgumentParser(description="SmartCoCo args")

    parser.add_argument('-f', '--file', type=str, required=True, help='contract file or folder')
    parser.add_argument('-v', '--version', type=str, default='0')

    args = parser.parse_args()
    contract = args.file
    version = args.version

    if version != '0':
        if version == 'all':
            print(f'ready to install all solc')
            install_all_solc_versions()
        else:
            try:
                print(f'ready to install : solc{version}')
                install_specific_version(version)
            except:
                print("error solc version")
    
    check_or_mkdir('./.temp')
    
    # create a new result log to temp dir
    if IS_WRITE_DOWN:
        with open('./.temp/result.txt', 'w+') as f:
            f.write('contract,status,comment_num,extract_com_num,con_num,incon_num,use_time,fact_num\n')

        with open('./.temp/tot_incon.csv', 'w+') as f:
            f.write('INCONSISTENT,contract,function,content,res,facts')


    if os.path.isdir(contract):
        contracts = find_all_sol_files(contract)
        print("file_to_be_ana_nums:")
        print(len(contracts))
    # If it's a single contract, analyze it
    elif os.path.isfile(contract):
        contracts = [contract]
    else:
        err('Non existent contract or directory: %s' % contract)
        sys.exit(1) 

    contracts_to_be_analyzed = []

    if len(contracts) > 1:
        for contract_path in contracts:
            contracts_to_be_analyzed.append(contract_path)
    else:
        contract_path = contracts[0]
        contracts_to_be_analyzed.append(contract_path)
    
    # print(contracts_to_be_analyzed)
    # print(len(contracts_to_be_analyzed))
    with Pool(int(Config.POOL_NUM)) as pool: 
        pool.map(process_one_contract, contracts_to_be_analyzed)

    with open('./process_finish.txt', 'w+') as f:
        print(f'finished:{time()}')

    return 0


def install_all_solc_versions():
    for version in solcx.get_compilable_solc_versions():
        solcx.install_solc(version, show_progress=True)


def install_specific_version(version):
    solcx.install_solc(version, show_progress=True)

# install_all_solc_versions()
main_run()
