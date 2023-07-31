from text_utils import generate_comment_info, write_to_intent_fact
from event import extract_event_facts
from require import extract_req_facts
from role import extract_role_facts
from seefn import extract_seefn_facts
from get_comments import get_comments
from slither import Slither
from lib import *
import pandas as pd

def extract_com_one_contract(contract_path, contract_name, slither_obj:Slither):
    # print(f'=============get_comments=============')
    comments_sent = get_comments(contract_path, slither_obj)
    # print(f'=============Solve comment facts=============')
    comment_num, extract_com_num = run_sentences(contract_name, comments_sent)
    return comment_num, extract_com_num


def preprocess_sent(sentence):
    """
    to use NLP way deco sent
    integrate into other steps 
    TODO REFACTOR
    """
    pass

def read_code_param_fact_to_df(contract):
    codefile = f'./.temp/{contract}/codefacts/HasParam.facts'
    all_param_facts = read_code_from_file(codefile)
    return pd.DataFrame(data=all_param_facts, columns=['ct', 'fn', 'param'], index=None)


def read_code_from_file(filename):
    facts = []
    with open(filename, 'r+') as f:
        for line in f.readlines():
            try:
                line = line.strip()
                if line == "":
                    continue
                content = line.split('\t')
                assert len(content) >= 1, "not match rules"
                one_fact = content
                facts.append(one_fact)
            except:
                continue
    return facts

def get_params(ct, fn, fact):
    return fact[(fact['ct']==ct) & (fact['fn']==fn)]['param'].tolist()




def run_sentences(contract, sentences): 
    load = set()
    role = set()
    req = set()
    event = set()
    comment_num = len(sentences)

    param_fact = read_code_param_fact_to_df(contract)

    for sentence in sentences:
        
        cn, fn, doc = generate_comment_info(sentence)
        newdoc = rebuild_sentence(doc)
        newdoc_lines = newdoc.split('\n')
        for doc in newdoc_lines:
            doc = doc.strip()
            if doc == "" or doc == " ":
                continue
            # try is used to avoid CORENLP haddle error
            try:
                load_target = extract_seefn_facts(cn, fn, doc)
                load = load.union(load_target)
            except:
                pass
            
            try: 
                # check access control(role) in comment --> type 1
                role_facts = extract_role_facts(cn, fn, doc)
                # print(role_facts)
                role = role.union(role_facts)
            except:
                pass

            try: 
                # check requirement in comment --> type 2
                params = get_params(cn, fn, param_fact)
                # print(cn, fn, params)
                # print(doc)
                req_facts = extract_req_facts(cn, fn, doc, params)
                # print(req_facts)
                req = req.union(req_facts)
            except:
                pass

            try:
                # check event in comment --> type 3
                event_facts = extract_event_facts(cn, fn, doc)
                event = event.union(event_facts)
            except:
                pass
    
    # print(role)
    # write down intent facts
    check_or_mkdir(f'./.temp/{contract}/intent')
    write_to_intent_fact(contract, 'ISee', load)
    write_to_intent_fact(contract, 'IRole', role)
    write_to_intent_fact(contract, 'IRequire', req)
    # print(event, len(event))
    write_to_intent_fact(contract, 'IEvent', event)

    extract_com_num = len(load) + len(role) + len(req) + len(event)
  
    return comment_num, extract_com_num



def rebuild_sentence(sent):
    new_sent:list[str] = []
    sent_row = sent.split('\n')
    
    for line in sent_row:
        if (line.find("@return") != -1 or line.find("Return") != -1) and (not (line.find("event") != -1)):
            continue
        
        new_sent.append(line)

    re_sent = ""
    for i in range(len(new_sent)):
        cur_row:str = new_sent[i]
        cur_row = cur_row.lstrip('.*/ `')
        cur_row = cur_row.rstrip('\n ')
        
        if cur_row == "" or cur_row == " ":
            continue

        next_flag = False
        if i < len(new_sent) - 1:
            if new_sent[i+1].find('@') != -1:
                next_flag = True
            for char in new_sent[i+1]:
                if char == '-':
                    next_flag = True
                    break
                if char.isalpha():
                    if char.isupper():
                        next_flag = True
                    break
        
        if cur_row.endswith('.') or next_flag:
            re_sent += f'{cur_row}\n'
        else:
            re_sent += f' {cur_row}'
        
        re_sent = re_sent.replace(';', '\n')
    
    return re_sent