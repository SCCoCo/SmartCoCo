import sys
# sys.path.append('./')
from typing import Set, List
import re
from datalog.predefine import SeeFnFact
from datalog.dlexpr import Bool

SEE_FN = re.compile('SEE {(\w+)-(\w+)}', re.I)
INHERIT_FN = re.compile('@inheritdoc (\w+)',  re.I)


def extract_seefn_facts(cn, fn, doc):

    dl_facts = set()
    res = re.search(SEE_FN, doc)
    if res is None:
        pass
    else:
        dl_facts.add(SeeFnFact(cn, fn, res.group(1), res.group(2)))
    
    res = re.search(INHERIT_FN, doc)
    if res is None:
        pass
    else:
        dl_facts.add(SeeFnFact(cn, fn, res.group(1), fn))
    
    return dl_facts
