
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
function prim(g :: GraphList{T}; source=first(adj_list(g))[1]) where T 
  #Initialiisation
  set_distance!(source, 0.0)
  nodes = [k for k in keys(adj_list(g)) ]
  queue = create_marked_node_queue(nodes)
  arbre_couvrant = Vector{eltype(nodes)}([])

  while is_empty(queue) == false
    node_min = data(min_weight(queue)) # on récupère l'élément de coût minimal de la file de priorité
    push!(arbre_couvrant, node_min) # On ajoute cette élément dans la liste des sommets formant l'arbre couvrant
    delete_item(queue, node_min) # suppression du noeud minimum dans la file de priorité
    set_visited!(node_min) # set l'attribut visited de node_min à true

    #Mise à jour de la file de priorité à partir des voisin du noeud ajouté.
    voisins = neighbours(g, node_min) #récupération des voisin de node_min
    for couple_voisin_poids in voisins            
      poids = snd(couple_voisin_poids)
      voisin = fst(couple_voisin_poids)
      if visited(voisin) == false && distance(voisin) >= poids # mise à jour du noeud si celui ci n'appartient pas encore à l'arbre couvrant
        set_distance!(voisin, poids)
        set_parent!(voisin, node_min)
        update!(queue, voisin, poids) #mise à jour dans la file de priorité
      end 
    end  
  end
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

