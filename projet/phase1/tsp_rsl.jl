
function  edges_tsp(g :: GraphList{T}, nodes::Vector) where T
    res_edges = []
    for i in range(1, stop = length(nodes))
        if i == length(nodes)
            node1 = nodes[i]
            node2 = nodes[1] 
        else 
            node1 = nodes[i]
            node2 = nodes[i+1] 
        end
        voisins = neighbours(g, node1)
        idx = findfirst(x -> fst(x) == node2, voisins)
        weight = snd(voisins[idx])
        push!(res_edges, Edge(node1, node2, weight))
    end
    return res_edges
end 

function opt(g :: GraphList{T}, nodes :: Vector, edges ::Vector) where T
    # show.(nodes) 
    # show.(edges)
    improve = true
    while improve
        improve = false
        for i in 1:length(nodes)-1
            for j in 1:length(nodes)-1
                if j != i && j != i+1 && j!= i-1
                    node_1 = nodes[i]
                    node_2 = nodes[i+1]
                    node_3 = nodes[j]
                    node_4 = nodes[j+1]
                    voisins1 = neighbours(g, node_1)
                    voisins2 = neighbours(g, node_4)

                    idx = findfirst(x -> fst(x) == node_2, voisins1)
                    weight1 = snd(voisins1[idx])

                    idx = findfirst(x -> fst(x) == node_3, voisins2)
                    weight2 = snd(voisins2[idx])

                    idx = findfirst(x -> fst(x) == node_3, voisins1)
                    weight3 = snd(voisins1[idx])

                    idx = findfirst(x -> fst(x) == node_2, voisins2)
                    weight4 = snd(voisins2[idx])

                    if weight1 + weight2 > weight3 + weight4
                        # @show i, j
                        # idx1 = findfirst(x -> (node1(x) == node_1 && node2(x) == node_2) || (node1(x) == node_2 && node2(x) == node_1)  , edges)
                        # idx2 = findfirst(x -> (node1(x) == node_3 && node2(x) == node_4) || (node1(x) == node_4 && node2(x) == node_3) , edges)
                        # @show idx1, idx2
                        # edges[idx1] = Edge(node_1, node_3, weight3)
                        # edges[idx2] = Edge(node_2, node_4, weight4)
                        edges[i] = Edge(node_1, node_3, weight3)
                        edges[j] = Edge(node_2, node_4, weight4)
                        idx_min = min(i+1, j)
                        idx_max = max(i+1, j)
                        reverse!(edges, idx_min,  idx_max -1)
                        reverse!(nodes, idx_min,  idx_max)
                        # reverse!(nodes, i+1,  j)
                        # show.(nodes) 
                        # show.(edges)
                        improve = true
                    end
                end
            end 
        end   
    end
    return nodes, edges
end

function rsl(g :: GraphList{T}) where T
    source=first(adj_list(g))[1]
    couvrant = prim(g; source=source)
    graph_couvrant = build_graph_list(couvrant)
    res_nodes1 = dfs_visit_iter(graph_couvrant, source)
    res_edges1 = edges_tsp(g, res_nodes1)
    res_nodes2, res_edges2 = opt(g, copy(res_nodes1), copy(res_edges1))
    return res_nodes1, res_edges1, res_nodes2, res_edges2
end


function rsl(filename :: String)
    graph_list = create_graph_list_from_file(filename) #Créé un graphe de liste d'adjacence à partir de filename
    return rsl(graph_list)
end 