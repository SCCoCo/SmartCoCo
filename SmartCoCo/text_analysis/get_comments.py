import sys
from lib import upper_bound, check_in_lst
from comment_parser import comment_parser
from slither import Slither

def count_LF(content: str) -> int:
    cnt = 0
    for c in content: 
        if '\n' == c:
            cnt += 1
    return cnt 


def get_comments(contract_path, slither:Slither):
    comments = []
    res = comment_parser.extract_comments(contract_path, 'application/javascript')
    for comment in res:
        content, startline, _ = comment.text(), comment.line_number(), comment.is_multiline()
        lines = count_LF(content) 
        endline = startline + lines
        content = content.lstrip('/*\n ')
        content = content.rstrip('/\n ')

        comments.append([content, endline, lines])

    comment_sent =  match_comment_with_funtions(slither, comments)

    return comment_sent


def match_comment_with_funtions(slither:Slither, comments):
    # print(comments)
    res = []
    comment_line = [a[1] for a in comments]
    
    def get_comments_id_in_functions(cur_st, cur_ed):
        """
        currently, we think a comments for a function 
        is just above and in its body.
        """
        above_in_fun = []
        # above
        # check exist
        id_0 = check_in_lst(comment_line, cur_st - 1)
        if id_0 == -1:
            id_0 = check_in_lst(comment_line, cur_st - 2)
          
        if id_0 != -1:
            above_in_fun.append(id_0)
            cursor = id_0
            while cursor:
                if int(comment_line[cursor]) - int(comment_line[cursor-1]) == (comments[cursor][2] + 1):
                    # print(comment_line[cursor], comment_line[cursor-1], comments[cursor][2])
                    above_in_fun.append(cursor - 1)
                    cursor -= 1
                else:
                    break
                
        # not contain inlines in this section
        # st = upper_bound(comment_line, cur_st)
        # for idx in range(st, len(comment_line)):
        #     line = comment_line[idx]
        #     if line >= cur_st and line <= cur_ed:
        #         above_in_fun.append(idx) 
        #     if line > cur_ed:
        #         break
        
        return above_in_fun


    for contract in slither.contracts:
        contract_name = contract.name
        is_lib = contract.is_library
        if contract_name.upper().find('SAFEMATH') != -1 or is_lib:
            continue
        # print(contract_name, contract_start, contract_end)
        inherited = contract.functions_and_modifiers_inherited

        for function in contract.functions_and_modifiers:
            
            if function in inherited:
                continue

            fun_name = function.name

            if "slither" in fun_name:
                continue

            fun_start = function.source_mapping.lines[0]
            fun_end = function.source_mapping.lines[-1]
            # print(fun_name, fun_start, fun_end)
            # We implement inline comments but not in this work
            func_comment_ids = get_comments_id_in_functions(fun_start, fun_end)
            for i in func_comment_ids:
                comment_fact = [contract_name, fun_name, comments[i][0], comments[i][1]]
                # print(comment_fact)
                res.append(comment_fact)
    
    return res 



# def match_comment_with_funtions(slither:Slither, comments):
    
#     res = []
#     comment_line = [a[1] for a in comments]
    
#     def get_comments_id_in_functions(cur_st, cur_ed):
#         """
#         currently, we think a comments for a function 
#         is just above and in its body.
#         """
#         all_func_comments = []
#         # in the range
#         # get the first >= element
#         st = upper_bound(comment_line, cur_st)
        
#         for idx in range(st, len(comment_line)):
#             line = comment_line[idx]
#             if line >= cur_st and line <= cur_ed:
#                 all_func_comments.append(idx) 
#             if line > cur_ed:
#                 break
        
#         return all_func_comments
    

#     for contract in slither.contracts:
#         contract_name = contract.name
#         # contract_start = contract.source_mapping.lines[0]
#         # contract_end = contract.source_mapping.lines[-1]
#         # print(contract_name, contract_start, contract_end)
#         comment_start = contract.source_mapping.lines[0] + 1
        
#         # if len(contract.structures_declared) > 0:
#         #     # print("asdasdasdasd")
#         #     # print(contract.structures_declared, contract.structures_declared[-1])
#         #     # print(contract.structures_declared[-1].source_mapping)
#         #     choice = contract.structures_declared[-1].source_mapping.lines[-1] + 1
#         #     comment_start = max(comment_start, choice)
#         # if len(contract.events_declared) > 0:
#         #     choice = contract.events_declared[-1].source_mapping.lines[-1] + 1
#         #     comment_start = max(comment_start, choice)
#         # if len(contract.variables) > 0:
#         #     choice = contract.variables[-1].source_mapping.lines[-1] + 1
#         #     comment_start = max(comment_start, choice)
#         # if len(contract.enums_declared) > 0:
#         #     choice = contract.enums_declared[-1].source_mapping.lines[-1] + 1
#         #     comment_start = max(comment_start, choice)
        
#         inherited = contract.functions_and_modifiers_inherited
        
#         for function in contract.functions:
            
#             if function in inherited:
#                 continue

#             fun_name = function.name
#             # get the func and inline comments in code
#             fun_end = function.source_mapping.lines[-1]
#             comment_end = fun_end            
#             print(fun_name, comment_start, comment_end)
            
#             # if comment_end < comment_start:
#             #     break
            
#             func_comment_ids = get_comments_id_in_functions(comment_start, comment_end)
#             for i in func_comment_ids:
#                 comment_fact = f'{contract_name},{fun_name},{comments[i][0]},{comments[i][1]}'
#                 print(comment_fact)
#                 res.append(comment_fact)
#             comment_start = fun_end + 1
    
#     return res 