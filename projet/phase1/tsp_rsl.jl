"""
		edges_tsp(g, nodes)
Construit la liste des arêtes utilisé par une tournée à partir à la list des points.		
le graphe g est nécessaire car on ne peut pas utiliser uniquement l'attribut distance des noeuds étant donné que l'on relit certains noeuds à autre chose que leurs parents.
"""
function edges_tsp(g :: GraphList{T}, nodes::Vector{MarkedNode{T}}) where T
	res_edges = []
	for i in range(1, stop = length(nodes))
		node1 = nodes[i]
		i == length(nodes) ? node2 = nodes[1] : node2 = nodes[i+1] 	# if ? then : else
		voisins = neighbours(g, node1)
		idx = findfirst(x -> fst(x) == node2, voisins)
		weight = snd(voisins[idx])
		push!(res_edges, Edge(node1, node2, weight))
	end
	return res_edges
end 

"""opt(graph, nodes, edges)
Réalise des 2-opt pour déterminer une meilleure solution de tournée sur la tournée initiallement représentée par nodes et edges.
"""
function opt(g :: GraphList{T}, nodes :: Vector, edges ::Vector) where T         
	improve = true
	while improve
		improve = false
		for i in 1:length(nodes)-1
			for j in i:length(nodes)-1
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
						edges[i] = Edge(node_1, node_3, weight3)
						edges[j] = Edge(node_2, node_4, weight4)                        
						reverse!(edges, i+1,  j -1)
						reverse!(nodes, i+1,  j)                        
						improve = true
					end
				end
			end 
		end   
	end
	return nodes, edges
end


"""
		rsl(g) 
Construit une tournée à partir du graphe g en utilisant l'algoithme rsl et en appliquant à la fin des moves 2-opt
"""
function rsl(g :: GraphList{T}) where T
	source=first(adj_list(g))[1]
	couvrant = prim(g; source=source)
	graph_couvrant = build_graph_list(couvrant)
	res_nodes1 = dfs_visit_iter(graph_couvrant, source)
	res_edges1 = edges_tsp(g, res_nodes1)
	res_nodes2, res_edges2 = opt(g, copy(res_nodes1), copy(res_edges1))
	return res_nodes1, res_edges1, res_nodes2, res_edges2
end


"""
		rsl(filename) 
Construit une tournée à partir du graphe g construit du fichier filename en utilisant l'algoithme rsl et en appliquant à la fin des moves 2-opt
"""
function rsl(filename :: String)
    graph_list = create_graph_list_from_file(filename) #Créé un graphe de liste d'adjacence à partir de filename
    return rsl(graph_list)
end 


#to do rsl_opt + les tests avec 