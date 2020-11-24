
""" 
delete_edges!(edge_vector, connected_component)
Supprime les arêtes de edge_vector tel que les 2 sommets appartiennent à la composante connexe: connected component. 
Utile dans kruskal (première version)
"""
function delete_edges!(vector_edge :: Vector{Edge{T}}, cc:: ConnectedComponent{T}) where T
future_index = Int[]
for (i, edge) in enumerate(vector_edge)
  _node1 = node1(edge)
  _node2 = node2(edge)
  if nodein(cc, _node1) && nodein(cc, _node2)
    push!(future_index, i)
  end
end
deleteat!(vector_edge, future_index) 
end 

""" Supprime les arêtes d'un noeud pointant vers lui-même. Appliqué"""
function pre_treatement_edges!(vector_edges::Vector{Edge{T}}) where T 
  delete_index = Int[]
  for (i,edge) in enumerate(vector_edges)
    _node1 = node1(edge)
    _node2 = node2(edge)
    (_node1 == _node2) ? push!(delete_index, i) : continue
  end
  deleteat!(vector_edges, delete_index)
end 


"""
kruskal(graph)
Implémentation de l'algorithme de kruskal, trouvant pour un graph g son arbre couvrant de poids minimum.
"""
function kruskal_nul(g :: GraphDic{T}) where T
_nodes = nodes(g)
_edges = edges(g)

vector_edges = Vector{Edge{T}}( map( edge -> edge[2], collect(_edges ) ))
sort!(vector_edges)
pre_treatement_edges!(vector_edges)
#création d'une composante connexe par sommet
cc_vector = map( node -> ConnectedComponent(node), _nodes)

while isempty(vector_edges) == false    
  edge = vector_edges[1] #arête de coût minimum
  cc = merge!(cc_vector, edge) #fusion des 2 composantes connexes que l'arête relie
  delete_edges!(vector_edges, cc)  # suppression des arêtes faisant parties de la composante connexe cc
end

length(cc_vector) != 1 && @error("nombre de composante connexe différent de 1") # vérification du nombre de composante connexe
return cc_vector[1] # Renvoie la dernière composante connexe, qui peut-être traitée comme un GraphDic
end 


"""
  kruskal2(graph)
Deuxième implémentation de l'algoorithme de Kruskal. 
Cette implémentation de Krurskal utilisent les heuristiques d'améliorations.
"""
function kruskal2(g :: GraphDic{T}) where T
_nodes = nodes(g)
_edges = edges(g)

vector_edges = Vector{Edge{T}}( map( edge -> edge[2], collect(_edges ) ))
sort!(vector_edges)

cc_vector = ConnectedComponent2{T}[]
for (i, node) in enumerate(_nodes)
  set_index!(node, i)
  push!(cc_vector, ConnectedComponent2( data(node), index = i))
end

edges_res = Edge{T}[]

for edge in vector_edges    
  index_cc1 = index(node1(edge))
  index_cc2 = index(node2(edge))

  cc1 = cc_vector[index_cc1]
  cc2 = cc_vector[index_cc2]
  
  if (find!(cc1) != find!(cc2)) 
    push!(edges_res, edge)
    union!(cc1, cc2)
  end

end


graph = GraphDic("Arbre couvrant", _nodes, edges_res)
return graph

end 

# function create_marked_node_list(root :: Node, edges_vector)
#   index_node_vector = [1:length(edges_vector)...] #Initialiisation
#   markednode_result_vector = []
#   push!(markednode_result_vector, MarkedNode(root.data; name="root"))
#   for i in index_node_vector
#     edge = edges_vector[i]
#     if node()
#     end 
#   end 
#   cpt = 1 
#   for edge in edges_vector
#     index = index_node_vector[cpt]
#     cpt = cpt + 1
#   end 
# end 



"""
    prim(graph; source=s)
Implémentation de l'arlgorithme de Prim, si la source n'est pas définie l'algorithme en attribue une.
Renvoie un vecteur des 
"""
function prim(g :: GraphList{T}; source = first(adj_list(g))[1]) where T 
  #Initialisation
  _nodes = nodes(g)
  # idx_source = findfirst(x -> index(x) == 1, _nodes)
  # source = _nodes[idx_source]  
  
  queue = create_marked_node_queue(_nodes, source)
  arbre_couvrant = Vector{eltype(_nodes)}([])
  _liste_adjacence = adj_list(g)

  while is_empty(queue) == false
    node_min = data(min_weight(queue)) # on récupère l'élément de coût minimal de la file de priorité
    priority_item_node_min = get_priority_item(queue, node_min)
    priority_node_min = priority(priority_item_node_min)

    if node_min == source 
      set_distance!(node_min, 0.0)
    else 
      _idx_predecesseur = findfirst((couple -> fst(couple)==parent(node_min)), _liste_adjacence[node_min])
      _distance = snd(_liste_adjacence[node_min][_idx_predecesseur])
      set_distance!(node_min, _distance)
    end 
    push!(arbre_couvrant, node_min) # On ajoute cette élément dans la liste des sommets formant l'arbre couvrant
    delete_item(queue, node_min) # suppression du noeud minimum dans la file de priorité
    set_visited!(node_min) # set l'attribut visited de node_min à true

    #Mise à jour de la file de priorité à partir des voisin du noeud ajouté.
    voisins = neighbours(g, node_min) #récupération des voisin de node_min
    for couple_voisin_poids in voisins            
      poids = snd(couple_voisin_poids)
      voisin = fst(couple_voisin_poids)
      if visited(voisin) == false 
        priority_item_voisin = get_priority_item(queue, voisin)
        priority_voisin = priority(priority_item_voisin)
        if priority_voisin >= poids # mise à jour du noeud si celui ci n'appartient pas encore à l'arbre couvrant        
          set_parent!(voisin, node_min)
          update!(queue, voisin, poids, node_min) #mise à jour dans la file de priorité
        end 
      end 
    end  
  end
  reset_visit(g)
  arbre_couvrant
end 


function build_graph_list(arbre_crouvrant :: Vector{MarkedNode{T}}) where T
  edges = Dict{ MarkedNode{T}, Vector{ Couple{MarkedNode{T},Float64} } }()
  for node in arbre_crouvrant
    get!(edges, node, Vector{Couple{MarkedNode{T},Float64}}(undef,0))   
  end 

  for node in arbre_crouvrant
    if parent(node) != nothing 
      push!(edges[parent(node)], Couple(node,0.0))
      push!(edges[node], Couple(parent(node),0.0))
    end 
  end 

  graph_result = GraphList{T}("graphe arbre couvrant ", edges)
  return graph_result 
end 



function minimum_1_tree(graph :: GraphList{T}) where T
  
  (lone_node, graph_tmp) = graph_minus_one_vertex(graph)
  
  _nodes_tmp = nodes(graph_tmp)  

  _sorted_edges_lone_node = sort(adj_list(graph)[lone_node])
  _source = fst(_sorted_edges_lone_node[1])
  
  
  _res_nodes = prim(graph_tmp; source=_source)

  
  (lone_node in parent.(_res_nodes)) && println("pas bon quand meme")
  new_adj_list = create_edges(_res_nodes, graph)

  get!(new_adj_list, lone_node, Vector{Couple{MarkedNode{T},Float64}}(undef,0))   

  
  if _sorted_edges_lone_node[1] == _source 
    _sommet_v = fst(_sorted_edges_lone_node[2])
  else 
    _sommet_v = fst(_sorted_edges_lone_node[1])
  end 

  
  set_v!(_source, v(_source)+1)
  set_v!(_sommet_v, v(_sommet_v)+1)
  set_v!(lone_node, 0)

  _idx_source = findfirst(couple -> fst(couple) == _source, adj_list(graph)[lone_node]) 
  _distance_source = snd(adj_list(graph)[lone_node][_idx_source])  

  _idx_sommet_v = findfirst(couple -> fst(couple) == _sommet_v, adj_list(graph)[lone_node]) 
  _distance_sommet_v = snd(adj_list(graph)[lone_node][_idx_sommet_v])
      
  push!(new_adj_list[lone_node], Couple(_sommet_v, _distance_sommet_v))
  push!(new_adj_list[lone_node], Couple(_source, _distance_source))

  push!(new_adj_list[_sommet_v], Couple(lone_node, _distance_sommet_v))
  push!(new_adj_list[_source], Couple(lone_node, _distance_source))


  one_tree = GraphList{T}("1-tree", new_adj_list)
  return lone_node, one_tree
end 
  


function create_edges(_res_nodes :: Vector{MarkedNode{T}}, g) where T 
  new_adj_list = Dict{ MarkedNode{T}, Vector{ Couple{MarkedNode{T},Float64} } }()
  
  for node in _res_nodes
    set_v!(node, -2)
    get!(new_adj_list, node, Vector{Couple{MarkedNode{T},Float64}}(undef,0))   
  end 

  length( filter(node -> parent(node) == nothing, _res_nodes)) > 1 && error("plus d'une source")

  for node in _res_nodes		
    if parent(node) != nothing
      _node1 = parent(node)
      _node2 = node 


      idx_node2 = findfirst(couple -> fst(couple) == _node2, adj_list(g)[_node1])
      _weight_edge = snd(adj_list(g)[_node1][idx_node2])
            
      push!(new_adj_list[_node1], Couple(_node2, _weight_edge)) 
      set_v!(_node1, v(_node1)+1)
      push!(new_adj_list[_node2], Couple(_node1, _weight_edge)) 
      set_v!(_node2, v(_node2)+1)
    end 
  end 
  return new_adj_list
end 
