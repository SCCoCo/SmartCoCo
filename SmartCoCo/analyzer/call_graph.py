def constract_call_graph(code_df):
    # only care about enter points
    graph = {}
    cn_dot_fn = "{}.{}"
    interfaces = code_df[code_df['factid'] == 'IsInterface']['ct'].tolist()
    # interfaces.remove('SafeMath')
    modifiers = get_modifiers(code_df)
    call_df = code_df[code_df['factid'] == 'Call']
    # print(call_df)
    for _, item in call_df.iterrows():
        cn, fn, _, tcn, tfn, _ = item[1], item[2], item[3], item[4], item[5], item[6]
        
        if fn.find('constructor') != -1:
            continue

        if tcn in interfaces:
            continue
        
        cn_fn = cn_dot_fn.format(cn, fn)
        tcn_tfn = cn_dot_fn.format(tcn, tfn)
        
        if tcn_tfn in modifiers:
            continue

        if graph.__contains__(cn_fn):
            graph[cn_fn].append(tcn_tfn)
        else:
            graph[cn_fn] = [tcn_tfn]

    return graph


def get_modifiers(df):
    modifiers = []
    modis = df[df['factid']=='CtHasMod']
    for _, item in modis.iterrows():
        modifiers.append(f'{item[1]}.{item[2]}')
    return modifiers



def check_lst_subset(curpath, topath):
    return set(topath).issubset(set(curpath))

def get_all_path(call_graph, u, cur_path=[]):
    
    cur_path = cur_path + [u]
    
    # return condition
    if not call_graph.__contains__(u):
        return [cur_path] 
    else:
        # solve cycle
        v = call_graph[u]
        if check_lst_subset(cur_path, v):
            return [cur_path]

    # avoid special call graph this is imposs
    if len(cur_path) > 100:
        return [cur_path]

    paths = []    
    
    for v in call_graph[u]:
        if v not in cur_path:
            new_paths = get_all_path(call_graph, v, cur_path)
            for path in new_paths:
                paths.append(path)

    return paths

# print(get_all_path(path, 1, []))