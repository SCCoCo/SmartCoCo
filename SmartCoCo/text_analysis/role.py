from typing import Set, List
import sys
sys.path.append('./')
from text_utils import *
from datalog.predefine import HasRole
import re

RE_AVAILA = re.compile("Only available to the ([\w ]+).", re.I)
RE_CALL_BY = re.compile("ONLY CALLE?D? BY ([\w ]+).?", re.I)
RE_ONLY = re.compile("ONLY ([\w ]+) CAN?", re.I)
RE_ALLOW_ACCESS = re.compile("ALLOWS?([\w+ ]*)ACCESS TO", re.I)
RE_ALLOW = re.compile("ALLOWS? ([\w+ ]+) TO", re.I)
RE_ROLE = re.compile("(HAVE|HAS|WITH) A?N?([\w ]+) ROLE", re.I)

filter_role_name = ['token owner', 'spender', 'anyone','potential','someone','anybody', 'if ', 'when', 'but', 'whether', 'after', 'before', 'to allow', 'do not', 'allow reset', 'and allow', 'not allow']

second_filter = ['transfer', 'buyer', 'customer', 'consumer', 'lp', 'liquidator', 'int', 'market', 'withdrawal','pool', 'community', 'asset', 'player', 'purchase', 'seller', 'contributions', 'user', 'contract', 'clients', 'slot', "liquidity", "token", 'app', 'beneficia', 'fee',
                  'crowdsale',  'call', 'module','allowance','frontend', 'operation', 'way', 'payment', 'eth', 'collateral','erc', 'btc', 'dai', "function", 'array', 'account', 'one', 'nft', 'sign', 'sender', 'party', 'parti', 'investor', 'buyer',
                    "anonymous",'transaction', 'fund', 'person', 'taker', 'people', "address", "wallet", "holder", "functionality", "recipient", "other", 'control']


def extract_role_facts(cn, fn, doc:str):
    
    dl_facts:set[HasRole] = set()

    roles = []
    
    if fn == 'constructor' or fn == cn:
        return dl_facts

    if filter_role(doc.lower()):
        return dl_facts

    pat = re.search(RE_ONLY, doc)
    if pat != None:
        role = pat.group(1)
        roles.append(role)


    pat = re.search(RE_AVAILA, doc)
    if pat != None:
        role = pat.group(1)
        roles.append(role)


    pat = re.search(RE_ONLY, doc)
    if pat != None:
        role = pat.group(1)
        roles.append(role)

    pat = re.search(RE_ALLOW_ACCESS, doc)
    if pat != None:
        print(role)
        role = pat.group(1)
        roles.append(role)
    else:    
        pat = re.search(RE_ALLOW, doc)
        if pat != None:
            role = pat.group(1)
            roles.append(role)
        

    pat = re.search(RE_ROLE, doc)
    if pat != None:
        # print(pat)
        role = pat.group(2)
        roles.append(role)


    pat = re.search(RE_CALL_BY, doc)
    if pat != None:
        role = pat.group(1)
        roles.append(role)

    for role in roles:
        role = role.strip()
        if role == "":
            continue
        sent_tag = get_pos(role)
        # print(sent_tag)
        ok, role = solve_role_sent(sent_tag)
        # print(ok, role)
        if second_filter_role(role):
            continue
        if ok and role != '':
            dl_facts.add(HasRole(cn, fn, role.lower()))

    return dl_facts


def filter_role(role):
    role = role.lower()
    for filter in filter_role_name:
        if role.find(filter) != -1:
            return True
    return False


def second_filter_role(role):
    if role == "":
        return True
    
    role = role.lower()
    for filter in second_filter:
        if role.find(filter) != -1:
            return True
        
    return False
