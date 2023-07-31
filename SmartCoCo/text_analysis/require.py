from typing import Set, List
import sys
sys.path.append('.')
from datalog.dlexpr import Cmp, BinOp, Expr, NegExpr
from datalog.predefine import ParameterFact
import re
from text_utils import *
from coreNLP import pos_tagger


EQ = "EQ"
NEQ = "NEQ"
GT = "GT"
GEQ = "GEQ"
LT = "LT"
LEQ = "LEQ"
AND = "AND"
OR = "OR"
NOT = "NOT"
# EQ = BinOp.EQ
# NEQ = BinOp.NEQ
# GT = BinOp.GT
# GEQ = BinOp.GEQ
# LT = BinOp.LT
# LEQ = BinOp.LEQ
# NOT = BinOp.NEQ
# Reverts if the index is greater or equal to the total number of tokens.
# TODO 仍有问题

RE_NEQ_BE = re.compile("([\w` ]+) CAN ?NOT BE ([\w` ]+)", re.I)
RE_AND = re.compile("([\w`]+) AND ([\w`]+)", re.I)

RE_LEQ_MOST = re.compile("([\w` ]*) AT MOST ([\w` ]+)", re.I)
RE_LEQ_NOT_GREATER = re.compile("([\w`]*) CAN ?NOT BE (GREATER|HIGHER) THAN ([\w ]+)", re.I)
RE_LEQ_NO_MORE = re.compile("([\w` ]*) NO (GREATER|MORE|HIGHER) THAN ([\w` ]*).?", re.I)

RE_GEQ_LEAST = re.compile("([\w` ]*) AT LEAST ([\w` ]+).?", re.I)
RE_GEQ_LESS = re.compile("([\w`]*) CAN ?NOT BE LESS THAN ([\w` ]*).?", re.I)

RE_GT = re.compile("([\w` ]*) (GREATER|MORE|HIGHER) THAN ([\w` ]*).?", re.I)

RE_LT = re.compile("([\w` ]*) LESS THAN ([\w` ]+)", re.I)

RE_EQ_SAME = re.compile("([\w`]*) AND ([\w` ]*) HAVE THE SAME ([\w`]*)", re.I)
RE_EQ_EQ = re.compile("(.+) (MUST|SHOULD) (EQUAL TO|EQUAL) ([\w()]+)", re.I)

# RE_REVERT = re.compile("Reverts if ([\w ]+) is greater or equal to ([\w ]+).")


filter_left_expr = ['v', 'r', 's']
filter_expr_name = ['char', 'gas', 'erc']
filter_expr_sent = ['if ', 'whether']

def extract_req_facts(cn, fn, doc, params):
    dl_facts:set(ParameterFact) = set() 
    # candidate

    if filter_require_sent(doc.lower()):
        return dl_facts

    fact_doc = []

    #match posssible 
    res = get_specific_pattern(LEQ, RE_LEQ_MOST, doc, params)
    for r in res:
        fact_doc.append(r)


    res = get_specific_pattern(LEQ, RE_LEQ_NOT_GREATER, doc, params, 1, 3)
    for r in res:
        fact_doc.append(r)


    res = get_specific_pattern(LEQ, RE_LEQ_NO_MORE, doc, params, 1, 3)
    for r in res:
        fact_doc.append(r)

    res = get_specific_pattern(GEQ, RE_GEQ_LEAST, doc, params)
    for r in res:
        fact_doc.append(r)

    if doc.lower().find('not') == -1 and doc.lower().find('no ') == -1:
        res = get_specific_pattern(GT, RE_GT, doc, params, 1, 3)
        for r in res:
            fact_doc.append(r)

        res = get_specific_pattern(LT, RE_LT, doc, params)
        for r in res:
            fact_doc.append(r)
    
    res = get_specific_pattern(EQ, RE_EQ_SAME, doc, params)
    for r in res:
        fact_doc.append(r)


    res = get_specific_pattern(EQ, RE_EQ_EQ, doc, params, 1, 4)
    for r in res:
        fact_doc.append(r)


    if len(dl_facts) == 0:
        res = get_specific_pattern(NEQ, RE_NEQ_BE, doc, params)
        for r in res:
            fact_doc.append(r)        
    
    # solve
    for r in fact_doc:
        r = r.strip()
        if r != "":
            dl_facts.add(ParameterFact(cn, fn, r))
    return dl_facts


def solve_expr(r):
    r = r.replace('address', '')
    r_pos = get_pos(r)
    r = keep_noun_words(r_pos)
    r = r.replace('zero', '0')
    return r

def is_param(req, params):
    has_param = []
    req = req.replace('`', '')
    req = req.replace('"', '')
    req = req.replace("'", '')
    req = req.replace(",", ' ,')
    req = req.strip()
    reqlst = req.split()
    for param in params:
        if param in reqlst:
            has_param.append(param)
            if not (' and ' in req or ', ' in req):
                break 
    return has_param

def get_specific_pattern(type, rep, doc, params, l=1, r=2):
    
    res = []
    
    pat = rep.search(doc)
    if pat is not None:
        left = pat.group(l)
        right = pat.group(r)
        # print(rep, pat)
    else:
        return []

    nright = solve_expr(right)

    if check_empty(nright):
        return []
    
    if filter_require(nright):
        return []

    lefts = is_param(left, params)

    for left in lefts:
        if not filter_left_require(left):
            if doc.lower().find("the same") != -1:
                patch = pat.group(3)
                left += f'.{patch}'
                nright += f'.{patch}'
            res.append(str([type, left, nright]))
    return res


def filter_left_require(expr):
    expr = expr.lower()
    if expr in filter_left_expr:
        return True
    return False


def filter_require(expr):
    lower_expr = expr.lower()
    for filter in filter_expr_name:
        if lower_expr.find(filter) != -1:
            return True
    return False

def filter_require_sent(expr):
    lower_expr = expr.lower()
    for filter in filter_expr_sent:
        if lower_expr.find(filter) != -1:
            return True
    return False
