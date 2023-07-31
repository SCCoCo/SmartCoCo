import Levenshtein
import re


CORRECT = 1
SAT_EDIST = 2
SAT_SUBSTR = 3
UNSAT_PART = 4
UNSAT = 5

def parse_cmp(expr):
    try:
        res = eval(expr)
        if len(res) >= 3:
            return list(res)
        return ["?", "?", "?"]
    except:
        return ["?", "?", "?"]


def read_com_from_file(ftype:str, filename):
    facts = []
    with open(filename, 'r+') as f:
        for line in f.readlines():
            try:
                line = line.strip()
                if line == "":
                    continue
                content = line.split('\t')
                # print(line, content)
                assert len(content) >= 3, "not match rules"
                one_fact = [ftype] + content
                # print(one_fact)  
                facts.append(one_fact)
            except:
                continue
    return facts


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


def check_req(attr, fact):
    ent, correct = 0, 0
    ftype, cn, fn, attrb = fact[0], fact[1], fact[2], fact[3]
    if ftype == 'Require':
        # print("1:", attrb)
        expra = parse_cmp(attr)
        exprb = parse_cmp(attrb)
        opb = exprb[0]

        if opb == "?":
            return 0, 0
        
        if len(exprb) >= 3:
            try:
                ent, correct = check_exp(expra, exprb)
            except:
                ent, correct = 0, 0

    return ent, correct


possible_role_modi = {}

def get_possible_modi(code_df):
    global possible_role_modi
    modifiers = code_df[code_df['factid']=='CtHasMod']
    ct_fns = []
    for _, item in modifiers.iterrows():
        ct_fns.append([item[1], item[2]])
    
    for ctfn in ct_fns:
        try:
            has_sender = False
            ct, fn = ctfn[0], ctfn[1]
            reqs = code_df[(code_df['factid']=='Require') & (code_df['ct']==ct) 
                            & (code_df['fn']==fn)]['attr1'].tolist()
            if str(reqs).lower().find('msg') != -1 or str(reqs).lower().find('tx') != -1 or str(reqs).lower().find('role') != -1:
                has_sender = True
            if has_sender or fn.lower().find('only') != -1:
                if not possible_role_modi.__contains__(fn):
                    possible_role_modi[fn] = []
                possible_role_modi[fn].append(str(reqs))
        except:
            print("not find modi")

    return True


def check_role(attr, fact, flag):
    global possible_role_modi
    attr = remove_symbols(attr)
    attr = attr.lower()
    ent, cor = 0, 0
    ftype, ct, fn, attrb, msg = fact[0], fact[1], fact[2], fact[3], fact[4]
    src_attrb = attrb
    attrb = attrb.lower()

    if flag: 
        ent, cor = check_role("owner", fact, False)
        if is_positive_res(cor):
            return ent, cor 

    if ftype == "FnHasMod": 
        attrb = attrb.replace("only", "")
        cor = check(attr, attrb)
        if is_positive_res(cor):
            return ent, cor

        if (attr.lower().find('owner')!=-1 or attr.lower().find('admin')!=-1) and (attrb.find('owner')!=-1 or attrb.find('admin')!=-1):
            # print(attr, attrb)
            cor = 1
        elif attrb.find('restrict') != -1 or attrb.find('by') != -1:
            cor = 1
        else:
            punc_pos = attrb.find('(')
            if punc_pos != -1:
                attrb = attrb[:punc_pos]
            cor = check(attr, attrb) 
            
        if is_positive_res(cor):
            return ent, cor

        if src_attrb in possible_role_modi:
            ent = 1
            req_stats = possible_role_modi[src_attrb]
            for req_stat in req_stats:
                if req_stat.lower().find(attr) != -1:
                    cor = 1
                    break
                
        if is_positive_res(cor):
            return ent, cor

    elif ftype == "Require":
            # print("R1:", attr, attrb)
            attrb = attrb.replace(".", "")
            if attrb.find("role")!= -1 and attrb.find("msgsender") != -1:
                ent, cor = 1, 2
            elif attrb.find("msgsender") != -1:
                ent = 1
                
                expr = parse_cmp(attrb)
                role_ent = expr[1]
                if role_ent.find('msgsender') != -1:
                    role_ent = expr[2]

                if (attr.find('owner')!=-1 or attr.find('admin')!=-1) and (attrb.find('owner')!=-1 or attrb.find('admin')!=-1):
                    ent, cor = 1, 1
                elif check(attr, role_ent) or attrb.find(attr) != -1 or attrb.find("own") != -1:
                    ent, cor = 1, 1
                elif msg.find(attr) != -1:
                    ent, cor = 1, 1

            if is_positive_res(cor):
                return ent, cor 

            cor  = check(attr, str(attrb))

    return ent, cor   


def check_emit(attr, fact):
    ent, res = 0, 0
    ftype, factname, might = fact[0], fact[3], fact[4]
    # print(might)
    # print(attr, ftype, factname)
    if ftype == "Emit":
        ent = 1
        res = check(attr, factname) 

    return ent, res

expr_symbols = ['EQ', 'NEQ', 'GT', 'LT', 'GEQ', 'LEQ']
def check_exp(expra, exprb):
    ent, correct = 0, 0
    opa, opb = expra[0], exprb[0]
    
    if opb == "AND":
        for i in range(1, len(exprb)):
            if exprb[i] in expr_symbols:
                try:
                    # print(expra, exprb[i])
                    ent, correct = check_exp(expra, [exprb[i], exprb[i+1], exprb[i+2]])
                    if is_positive_res(correct):
                        return ent, correct
                except:
                    print('error')


    la, lb = expra[1], exprb[1]
    ra, rb = expra[2], exprb[2]

    if rb == "address(0)":
        rb = "0"

    if opa == 'EQ':
        ent, correct = checkEQ_NEQ(opa, la, ra, opb, lb, rb)
    elif opa == 'NEQ':
        ent, correct = checkEQ_NEQ(opa, la, ra, opb, lb, rb)
    elif opa == 'GT':
        ent, correct = checkGT(opa, la, ra, opb, lb, rb)
    elif opa == 'LT':
        ent, correct = checkLT(opa, la, ra, opb, lb, rb)
    elif opa == 'GEQ':
        ent, correct = checkGEQ(opa, la, ra, opb, lb, rb)
    elif opa == 'LEQ':
        ent, correct = checkLEQ(opa, la, ra, opb, lb, rb)
    
    return ent, correct


def check_req_overestimate(attr, fact):
    ent, correct = 0, 0
    ftype, cn, fn, attrb = fact[0], fact[1], fact[2], fact[3]
    
    if ftype == 'Require':
        expra = parse_cmp(attr)
        exprb = parse_cmp(attrb)
        opa, opb = expra[0], exprb[0]
        la, lb = expra[1], exprb[1]
        ra, rb = expra[2], exprb[2]
        
        if rb == "?":
            return 0, 0

        if lb.lower() == 'caller':
            lb = 'msgsender'
        # print(opb, ra, rb)
        if rb == "address(0)":
            rb = "0"
        # Little Overestimate for specific consistent check
        
        ent, correct = contain_op_exp_check(opa, la, ra, opb, lb, rb)
        
        if is_positive_res(correct):
            return ent, correct

        if check_owned_of(opa, la, ra, opb, lb, rb):
            return 2, 3

        if (not is_positive_res(correct)):
            if cn.upper().find("SAFEMATH") != -1 and opa == 'GEQ':
                if opb not in ['EQ', 'NEQ']:
                    ent, correct = 2, 3
            else:
                correct = check(attr, str(attrb))

    return ent, correct


def check_owned_of(opa, la, ra, opb, lb, rb):
    if (opa == 'EQ' and opb == 'NEQ') or (opa == 'NEQ' and opb == 'EQ') :
        if lb.find('ownerOf') != -1 or rb.find('ownerOf') != -1:
            if la.find('0') != -1 or ra.find('0') != -1:
                return True
    return False


def contain_op_exp_check(opa, la, ra, opb, lb, rb):
    ent, correct = 0, 0
    ra = remove_symbols(ra)
    rb = remove_symbols(rb)
    if opa == opb and ((not ra.isdigit()) or (not rb.isdigit())):
        ent = 2
        correct = min(check(la, lb), check(ra, rb))
        if is_positive_res(correct):
            return ent, correct
        
        if opa in ['EQ', 'NEQ']:
            correct = min(check(la, rb), check(ra, lb))
            
    return ent, correct



def remove_symbols(s:str):
    s = s.replace("the", "")
    s = s.replace(".", "")
    s = s.lstrip('-_\'` *\{\}[]".')
    s = s.rstrip('-()\'` *\{\}[]".s')
    s = s.replace(' ', '')
    return s



def check(a:str, b:str):
    a, b = remove_symbols(a), remove_symbols(b)
    a, b = a.lower(), b.lower()
    # print("a,b:", a, b)
    # 数字特判
    if a.isdigit() and b.isdigit():
        if str(a) == str(b) :
            return CORRECT
        return UNSAT
    
    # 其他字符串判断   
    if a == b:
        return CORRECT
    dist = Levenshtein.ratio(a, b)
    if dist >= 0.8:
        return SAT_EDIST
    if is_substr(a, b):
        return SAT_SUBSTR
    return UNSAT


def is_substr(a:str, b:str):
    if a.startswith(b) or a.endswith(b):
        return True
    if b.startswith(a) or b.endswith(a):
        return True
    return False


def is_positive_res(res):
    if res == 1 or res == 2 or res == 3:
        return True
    return False

def generate_check_res(lcheck, rcheck):
    is_entity = min(lcheck, rcheck)
    is_correct = max(lcheck, rcheck)
    return is_entity, is_correct

# la == ra  lb == rb 
def check_exp_2param(opa, la, ra, opb, lb, rb):
    l_check, r_check = check(la, lb), check(ra, rb)
    is_entity, is_correct = generate_check_res(l_check, r_check)
    if is_positive_res(is_correct):
        return True, 0, is_correct
    return False, is_entity, is_correct

# la == rb ra == lb
def check_exp_cross_2param(opa, la, ra, opb, lb, rb):
    cro_l_check, cro_r_check = check(la, rb), check(ra, lb)
    cro_is_entity, cro_is_correct = generate_check_res(cro_l_check, cro_r_check)
    if is_positive_res(cro_is_correct):
        return True, 0, cro_is_correct
    return False, cro_is_entity, cro_is_correct


def checkEQ_NEQ(opa, la, ra, opb, lb, rb):
    res, entity, correct = check_exp_2param(opa, la, ra, opb, lb, rb)
    if res:
        return entity, correct
    
    cres, centity, ccorrect = check_exp_cross_2param(opa, la, ra, opb, lb, rb)
    if cres:
        return centity, ccorrect
    
    return min(entity, centity), max(correct, ccorrect)


def checkGT(opa, la, ra, opb, lb, rb):
    entity, correct = 0, 0
    if opb == 'GT':
        _, entity, correct = check_exp_2param(opa, la, ra, opb, lb, rb)
    elif opb == 'LT':   
        _, entity, correct = check_exp_cross_2param(opa, la, ra, opb, lb, rb)
    return entity, correct


def checkLT(opa, la, ra, opb, lb, rb):
    entity, correct = 0, 0
    if opb == 'LT':
        _, entity, correct = check_exp_2param(opa, la, ra, opb, lb, rb)
    elif opb == 'GT':   
        _, entity, correct = check_exp_cross_2param(opa, la, ra, opb, lb, rb)
    return entity, correct


def checkGEQ(opa, la, ra, opb, lb, rb):
    entity, correct = 0, 0
    if opb == 'GEQ':
        _, entity, correct = check_exp_2param(opa, la, ra, opb, lb, rb)
    elif opb == 'LTE':   
        _, entity, correct = check_exp_cross_2param(opa, la, ra, opb, lb, rb)
    return entity, correct


def checkLEQ(opa, la, ra, opb, lb, rb):
    entity, correct = 0, 0
    if opb == 'LEQ':
        _, entity, correct = check_exp_2param(opa, la, ra, opb, lb, rb)
    elif opb == 'GTE':   
        _, entity, correct = check_exp_cross_2param(opa, la, ra, opb, lb, rb)
    return entity, correct


def split_cn_fn(cn_fn:str):
    res = cn_fn.split('.')
    return res[0], res[1]


def combine_cn_fn(ct, fn):
    return f'{ct}.{fn}'

