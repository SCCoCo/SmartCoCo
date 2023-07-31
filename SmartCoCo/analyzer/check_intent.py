import pandas as pd
from check_utils import *
from call_graph import *


code_col = ['factid', 'ct', 'fn', 'attr1', 'attr2', 'attr3', 'attr4']
comment_col = ['factid', 'ct', 'fn', 'attr1', 'attr2']
abstract_contracts = set()


def check_one_contract(contract, contract_path):
    global abstract_contracts

    res_file = f'./.temp/{contract}'
    com_df = read_comments_to_df(contract)
    code_df = read_code_to_df(contract)

    com_df.drop_duplicates(inplace=True)
    code_df.drop_duplicates(inplace=True)

    # In utils
    get_possible_modi(code_df)
    
    abstract_contracts = get_abstract_contracts(contract_path)
    # print(com_df)
    com_df = comment_propagate(contract, com_df)
    # print(com_df)
    com_df = comment_propagate_interface(com_df, code_df)
    # print(com_df)
    com_df.drop_duplicates(inplace=True)
    # print(com_df)
    cons, incons = check_consistency(com_df, code_df=code_df)
    
    cons = list(set(cons))
    incons = list(set(incons))

    cons = remove_cons_in_incons(cons, incons)

    with open(f'{res_file}/Consistent.txt', 'w+') as f:
        f.writelines(cons)

    with open(f'{res_file}/Inconsistent.txt', 'w+') as f:
        f.writelines(incons)

    return cons, incons




def remove_cons_in_incons(cons, incons):
    new_con = []
    new_incon = []
    for incon in incons:
        inconlst = incon.split('\t')
        matching = f'{inconlst[1]}\t{inconlst[2]}\t{inconlst[3]}\t{inconlst[4]}'
        new_incon.append(matching)
    for con in cons:
        inconlst = con.split('\t')
        matching = f'{inconlst[1]}\t{inconlst[2]}\t{inconlst[3]}\t{inconlst[4]}'
        if matching in new_incon:
            continue
        new_con.append(con)
    return new_con


def generate_candidate_fact_path(paths):
    res = {}
    for path in paths:
        for i in range(len(path)):
            if not res.__contains__(path[i]):
                res[path[i]] = []
            for j in range(len(path)):
                res[path[i]].append(path[j])
    return res


def get_comments_with_ct_fn(com_df, ct, fn):
    return com_df[(com_df['ct']==ct) & (com_df['fn']==fn)]


def generate_check_df(sct, sfn, ct_fns, vcode_df, code_df):
    check_df = pd.DataFrame(columns=vcode_df.columns)

    call_df = code_df[(code_df['factid']=='Call') & 
                                (code_df['ct']==sct) & (code_df['fn']==sfn)]
    # print(call_df)
    #  build call df (except safemath now handle 1 level enough)
    
    call_rel = {}
    sct_sfn = combine_cn_fn(sct, sfn)
    call_rel[sct_sfn] = {}
    for _, item in call_df.iterrows():
        ct, fn, param, ccn, cfn, cparam = item[1], item[2], item[3], item[4], item[5], item[6]
        if param == cparam or param == 'nil':
            continue
        ccn_cfn = combine_cn_fn(ccn, cfn)    
        if not call_rel[sct_sfn].__contains__(ccn_cfn):
            call_rel[sct_sfn][ccn_cfn] = []
        call_rel[sct_sfn][ccn_cfn].append([param, cparam])

    for ct_fn in ct_fns:
        ct, fn = split_cn_fn(ct_fn)

        ct_fn_df = vcode_df[(vcode_df['ct']==ct) & (vcode_df['fn']==fn)]

        if not call_rel[sct_sfn].__contains__(ct_fn):
            check_df = pd.concat([check_df, ct_fn_df], ignore_index=True)
        else:
            # if sfn == "transferFrom":
            #     print(call_rel[sct_sfn][ct_fn])
            check_df_not_para = ct_fn_df[~(ct_fn_df['factid']=='Require')]
            check_df_para = ct_fn_df[ct_fn_df['factid']=='Require']
            check_df = pd.concat([check_df, check_df_not_para], ignore_index=True)
            try:
                # start for param trans
                vis = set()
                for item in call_rel[sct_sfn][ct_fn]:
                    lparam, rparam = item[0], item[1]
                    # print(lparam, " ------ ", rparam)
                    if str([lparam, rparam]) in vis:
                        continue
                    vis.add(str([lparam, rparam]))

                    lparam_lst = eval(lparam)
                    rparam_lst = eval(rparam)
                    if len(lparam_lst) != len(rparam_lst):
                        check_df = pd.concat([check_df, check_df_para], ignore_index=True)
                    else:
                        ct_fn_df_copy = check_df_para.copy()
                        for i in range(len(lparam_lst)):
                            if lparam_lst[i].find('TMP') == -1 and lparam_lst[i].find('REF') == -1:
                                if lparam_lst[i] != rparam_lst[i]:
                                    ct_fn_df_copy['attr1'] = ct_fn_df_copy['attr1'].str.replace(f"'{rparam_lst[i]}'", f"'{lparam_lst[i]}'")
                                    
                        #             if sfn == "transferFrom":
                        #                 print(ct_fn_df_copy)
                        # # print("CHANGE")
                        # print(ct_fn_df_copy)
                        check_df = pd.concat([check_df, ct_fn_df_copy], ignore_index=True)
            except:
                print("var replace error")
                check_df = pd.concat([check_df, check_df_para], ignore_index=True)
    
    return check_df.drop_duplicates()


def special_check_role(com_df):
    res = {}
    try:
        roles = {}
        role_df = com_df[com_df['factid']=="role"][['ct', 'attr1']]
        for _, item in role_df.iterrows():
            ct, attr = item[0], item[1]
            if not roles.__contains__(ct):
                roles[ct] = [attr]
            else:
                roles[ct].append(attr)

        for ct, v in roles.items():
            if len(list(set(v))) > 1:
                res[ct] = False
            else:
                res[ct] = True        
        return res
    except:
        print("error")
        return res

valued_fact_types = ['Emit', 'Require', 'FnHasMod']
external_tag = ['external', 'public']
is_only_one_role = {}

#  fix a bug caused by slither
def get_abstract_contracts(contract):
    global abstract_contracts 
    with open(contract, 'r+') as f:
        doc = f.read()
    RE_ABS = re.compile("abstract contract (\w+)")
    pat = re.findall(RE_ABS, doc)
    return set(pat)


def get_all_implemeted_functions(code_df):
    s = set()
    ct_have_implemented_fn = code_df[code_df['factid']=='IsImplemented']
    for _, item in ct_have_implemented_fn.iterrows():
        ct, fn = item[1], item[2]
        s.add(combine_cn_fn(ct, fn))
    return s

def check_consistency(com_df, code_df):
    global is_only_one_role
    consistent_report = []
    inconsistent_report = []
    # call_graph 
    graph = constract_call_graph(code_df)
    # print(graph)
    value_code_df = code_df[code_df['factid'].isin(valued_fact_types)]
    # print(value_code_df)
    all_external_funs = get_all_external_funcs(code_df)
    # get_contracts
    # print(all_external_funs)
    is_only_one_role = special_check_role(com_df)
    implemented_funcs = get_all_implemeted_functions(code_df)
    
    for ex_ct_fn in all_external_funs:
        if ex_ct_fn not in implemented_funcs:
            continue
        
        paths = get_all_path(graph, ex_ct_fn, [])
        # from a path to generate paths
        candidate_path = generate_candidate_fact_path(paths)

        for k, v in candidate_path.items():
            ct_fn = k

            if ct_fn not in implemented_funcs:
                continue
            
            ct, fn = split_cn_fn(ct_fn)
            path = list(set(v))
            check_comment_facts = get_comments_with_ct_fn(com_df, ct, fn)
            # print("ok check_comment_facts", check_comment_facts)
            if len(check_comment_facts) != 0:        
                check_code_facts = generate_check_df(ct, fn, path, value_code_df, code_df)
                # print("ok check_code_facts", check_code_facts)
                sub_consis, sub_inconsis = check_consistency_for_one_fun(check_comment_facts, 
                                                                     check_code_facts)        
                # print(sub_consis, sub_inconsis)
                consistent_report.extend(sub_consis) 
                inconsistent_report.extend(sub_inconsis)           
        
    return consistent_report, inconsistent_report



def check_consistency_for_one_fun(com_df, valid_code_df):
    consistent_report = []
    inconsistent_report = []
    # print(com_df)
    for _, comment in com_df.iterrows():
        ctype, contract, function, content = comment[0], comment[1], comment[2], comment[3] 
        
        res, facts = check_constraint(comment, valid_code_df)

        if is_positive_res(res):
            s = f'CONSISTENT\t{contract}\t{function}\t{ctype}\t{content}\t{res}\t{facts}\n'
            consistent_report.append(s)
        else:
            # print(comment, res, facts)    
            s = f'INCONSISTENT\t{contract}\t{function}\t{ctype}\t{content}\t{res}\t{facts}\n'
            inconsistent_report.append(s)
            
    return consistent_report, inconsistent_report


def check_constraint(comment, selected_df):
    global is_only_one_role

    res = 0
    selected_errors = []

    type, ct, fn, attr, attr2 = comment[0], comment[1], comment[2], comment[3], comment[4]
    # selected_df = get_df_with_ctfn(code_df, ct, fn)

    selected_df.sort_values(by="fn", key=lambda x: x==fn, ascending=False)

    if type == "role":
        for _, fact in selected_df.iterrows():
            flag = is_only_one_role[ct]
            ent, res = check_role(attr, fact, flag)
            if is_positive_res(res):
                return res, [fact.to_list()]
            if is_positive_res(ent):
                selected_errors.append(fact.to_list())

    elif type == 'require':
        re_selected_df = selected_df[(selected_df['factid']=='Require')]
        re_selected_df = re_selected_df.sort_values(by="ct", key=lambda x: x=="SafeMath")
        for _, fact in re_selected_df.iterrows():
            ent, res = check_req(attr, fact)
            if is_positive_res(res):
                return res, [fact.to_list()]                 
            if is_positive_res(ent):
                selected_errors.append(fact.to_list())
        for _, fact in re_selected_df.iterrows():
            ent, res = check_req_overestimate(attr, fact)
            if is_positive_res(res):
                return res, [fact.to_list()]                 


    elif type == 'event':
        # print(selected_df[(selected_df['factid']=='Emit')])
        # print(ct, fn, attr)
        if attr2.find('False') != -1:
            return 1, ['Might']
        
        for _, fact in selected_df[(selected_df['factid']=='Emit')].iterrows():            
            ent, res = check_emit(attr, fact)

            if is_positive_res(res):
                return res, [fact.to_list()]
            if is_positive_res(ent):
                # print(ct, fn, attr)
                selected_errors.append(fact.to_list())
    
    # print(res, selected_errors)
    return res, selected_errors


def get_all_external_funcs(code_df):
    global abstract_contracts
    ex_funs = set()
    contracts = []
    all_contracts = get_contracts_names(code_df)
    
    # not abstract
    ready_contracts = []
    for contract in all_contracts:
        if contract not in abstract_contracts:
            ready_contracts.append(contract)
    
    # has imple ct
    ct_have_implemented_fn = code_df[code_df['factid']=='IsImplemented']['ct'].tolist()
    ct_have_implemented_fn = list(set(ct_have_implemented_fn))
    for contract in ready_contracts:
        if contract in ct_have_implemented_fn:
            contracts.append(contract)
    
    external_fns = code_df[(code_df['factid']=='HasFn') & code_df['ct'].isin(contracts) & 
                           (code_df['attr1'].isin(external_tag))]
    for _, fun in external_fns.iterrows():
        _, ct, fn = fun[0], fun[1], fun[2]
        ex_funs.add(combine_cn_fn(ct, fn))
    return ex_funs


def get_contracts_names(df):
    return df[df['factid']=='IsContract']['ct'].tolist()


def get_external_funcs_in_ct(df, ct):
    return df[(df['factid']=='HasFn') & (df['ct'] == ct) & 
              (df['attr1']=='external')]['fn'].tolist()

def read_comments_to_df(contract):
    all_comments = []
    intent = f'./.temp/{contract}/intent'
    
    ievents = read_com_from_file('event', f'{intent}/IEvent.dl')
    all_comments.extend(ievents)

    irequire = read_com_from_file('require', f'{intent}/IRequire.dl')
    all_comments.extend(irequire)
    
    irequire = read_com_from_file('role', f'{intent}/IRole.dl')
    all_comments.extend(irequire)
    # print(all_comments)
    aligned_comment = align_diff_facts(all_comments, comment_col)
    # print(aligned_comment)
    return pd.DataFrame(data=aligned_comment, columns=comment_col, index=None)

 
def read_code_to_df(contract):
    all_code_facts = []
    codefile = f'./.temp/{contract}/all_fact.txt'
    all_code_facts = read_code_from_file(codefile)
    # print(all_code_facts)
    aligned_code = align_diff_facts(all_code_facts, code_col)
    # print(aligned_code)
    return pd.DataFrame(data=aligned_code, columns=code_col, index=None)


def align_diff_facts(srclst, col):
    aligned_lst = []
    col_len = len(col)
    # print(len(srclst))
    for line in srclst:
        # print(len(line))
        if len(line) < col_len:
            line.extend([None for i in range(col_len - len(line))])
        aligned_lst.append(line)
    return aligned_lst

def get_df_with_ctfn(df, ct, fn):
    return df[(df['ct']==ct) & (df['fn']==fn)]


def copy_df_to_nctfn_from_ctfn(df, newct, newfn, ct, fn):
    temp_df = df[(df['ct']==ct) & (df['fn']==fn)].copy()
    temp_df['ct'] = newct
    temp_df['fn'] = newfn
    return temp_df

def copy_df_nct_from_ct(df, newct, ct):
     temp_df = df[(df['ct']==ct)].copy()
     temp_df['ct'] = newct
     return temp_df


def comment_propagate(contract, com_df):
    intent = f'./.temp/{contract}/intent'
    isee = read_com_from_file('see', f'{intent}/ISee.dl')
    for see in isee:
        # print(see)
        ct, fn, ict, ifn = see[1], see[2], see[3], see[4]
        temp_df = copy_df_to_nctfn_from_ctfn(com_df, ct, fn, ict, ifn)
        # print(temp_df)
        com_df = pd.concat([com_df, temp_df], ignore_index=True)
        # print(com_df)
    return com_df


def comment_propagate_interface(com_df, code_df):
    interfaces = code_df[code_df['factid'] == 'IsInterface']['ct'].tolist()
    inherits = code_df[code_df['factid'] == 'Inherit']
    for _, item in inherits.iterrows():
        fa, child = item[1], item[2]
        if fa in interfaces:
            temp_df = copy_df_nct_from_ct(com_df, child, fa)
            com_df = pd.concat([com_df, temp_df], ignore_index=True)
    return com_df

