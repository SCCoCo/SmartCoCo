import sys
sys.path.append('.')
from typing import Set, List
import re
from datalog.predefine import EmitFact
from datalog.dlexpr import Bool


RE_EMIT = re.compile("EMITS?( A | AN | )([\w\(\)\{\}]+) EVENTS?", re.I)
RE_EMIT_AND = re.compile("EMITS? ([\w\(\)\{\}]+) AND ([\w\(\)\{\}]+) EVENTS?", re.I)
RE_LOG = re.compile("SENDS? [AN ]*(\w+) log", re.I)

event_sent_filter = ['while', "if ", 'when', 'unless']

event_sent_maybe_filters = ['may', 'might']

event_filter_words = ['log', 'event', 'a', 'an', 'the', 'this', 'in', 'on', 'as', 'at']


def extract_event_facts(cn, fn, doc):
    must_flag = True
    dl_facts: Set[EmitFact] = set()
    
    if filter_event_sent(doc):
        return dl_facts

    if event_check_maybe(doc):
        must_flag = False

    pat = re.search(RE_EMIT, doc)
    if pat is not None:
        event = pat.group(2)
        # print(event)
        if filter_event_word(event):
            return dl_facts
        dl_facts.add(EmitFact(cn, fn, event, str(must_flag)))

    if "AND" in doc:
        pat = re.search(RE_EMIT_AND, doc)
        if pat is not None:
            eventa, eventb = pat.group(1), pat.group(2)
            dl_facts.add(EmitFact(cn, fn, eventa, str(must_flag)))
            dl_facts.add(EmitFact(cn, fn, eventb, str(must_flag)))
                

    return dl_facts


def filter_event_word(event):
    event = event.lower().lstrip()
    if event in event_filter_words:
        return True
    return False


def filter_event_sent(event):
    event = event.lower().lstrip()
    for filter in event_sent_filter:
        if event.find(filter) != -1:
            return True
    return False


def event_check_maybe(doc):
    doc = doc.lower()
    for filter in event_sent_maybe_filters:
        if doc.find(filter) != -1:
            return True
    return False
