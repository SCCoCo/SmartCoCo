import os
from coreNLP import pos_tagger


def generate_comment_info(comment):
    comment_info = comment
    cn = comment_info[0]
    fn = comment_info[1]
    doc = comment_info[2]
    return cn, fn, doc
    

def text_remove_symbols(s:str):
    s = s.lstrip('-_\'` *\{\}[]".')
    s = s.rstrip('-()\'` *\{\}[]".s')
    s = s.replace(' ', '')
    return s


def get_pos(endoc):
    endoc = endoc.lstrip(" `+*")
    endoc = endoc.rstrip(" `+*")
    if endoc == "":
        return []
    return pos_tagger.tag(endoc.split())


keep_pos_word = ['NN', 'IN', 'CD', 'RB', 'TO', 'VBN']

def is_keep_pos(pos):
    for keep in keep_pos_word:
        if pos.find(keep) != -1:
            return True
    return False

keep_pos_word_role = ['NN', 'JJ', 'VBN', 'DT']

def is_keep_pos_role(pos):
    for keep in keep_pos_word_role:
        if pos.find(keep) != -1:
            return True
    return False


def keep_noun_words(sent_pos):
    has_noun = False
    new_sent = []
    for item in sent_pos:
        # print(item)
        word, pos = item[0], item[1]
        if pos == 'IN' or pos == '': # should not be a clous
            return ""

        if is_keep_pos(pos):
            new_sent.append(word)

        if pos.find('NN') != -1 or pos == 'CD':
            has_noun = True

    if has_noun and 'to' in new_sent:
        new_sent.remove('to')

    if has_noun == False:
        return ""

    return ' '.join(new_sent)


def keep_subject_words(sent_pos):
    has_noun = False
    new_sent = []
    for item in sent_pos:
        # print(item)
        word, pos = item[0], item[1]
        if pos == 'IN' or pos == '': # should not be a clous
            return ""

        if is_keep_pos(pos):
            if pos.find('NN') != -1:
                has_noun = True
            new_sent.append(word)

    if has_noun and 'to' in new_sent:
        new_sent.remove('to')

    if has_noun == False:
        return ""

    return ' '.join(new_sent)


def is_noun(pos):
    if pos.find('NN') != -1:
        return True
    return False


def solve_role_sent(sent_pos):
    new_sent = []
    has_noun = False
    first_word_pos = sent_pos[0][1]
    if first_word_pos.find('IN') != -1:
        return False, ""
    
    for item in sent_pos:
        word, pos = item[0], item[1]

        if is_keep_pos_role(pos):
            if is_noun(pos) and not word.endswith('ing'):
                has_noun = True
                new_sent.append(word)
        else:
            break
        
    if len(new_sent) == 0 or has_noun == False:
        return False, ""
    
    return True, ' '.join(new_sent)


def check_empty(sent):
    if sent == "" or sent == " ":
        return True
    return False


def transfer_zero_address(sent):
    sent = sent.replace("address(0)", '0')
    return sent


def split_and_operation(comment):
    pos = comment.find("AND")
    left = comment[:pos]
    right = comment[pos+3:]
    return left, right


def write_to_intent_fact(contract, fact_name, facts):
    with open(f'./.temp/{contract}/intent/{fact_name}.dl', 'w+') as f:
        f.writelines([str(x) + os.linesep for x in facts])

