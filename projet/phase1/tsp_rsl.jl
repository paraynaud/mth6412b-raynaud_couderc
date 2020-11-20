


function rsl(g :: GraphList{T}) where T
    source=first(adj_list(g))[1]
    couvrant = prim(g; source=source)
    graph_couvrant = build_graph_list(couvrant)
    result_tsp = dfs_visit_iter(graph_couvrant, source)
    return result_tsp
end

function rsl(filename :: String)
    graph_list = create_graph_list_from_file(filename) #Créé un graphe de liste d'adjacence à partir de filename
    tournée = rsl(graph_list)
    
    return tournée
end 