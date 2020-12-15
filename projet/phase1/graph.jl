import Base.show, Base.==, Base.merge, Base.isless, Base.copy


"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractGraph{T} end


# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name`, `nodes` et `edges`.

"""Renvoie le nom du graphe."""
@inline name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
@inline nodes(graph::AbstractGraph) = graph.nodes

"""Renvoie le nombre de noeuds du graphe."""
@inline nb_nodes(graph::AbstractGraph) = length(graph.nodes)

"""Renvoie un dictionnaire des arêtes graphe."""
@inline edges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre d'arêtes du graphe."""
@inline nb_edges(graph::AbstractGraph) = length( edges(graph) )

""" Renvoie le poids total des arêtes d'un graphe. Utilisé principalement pour recupérer les coût d'un arbre couvrant."""
total_weigth_edges(graph::AbstractGraph) = mapreduce( pair -> weight(pair[2]), +,collect(edges(graph)))


"""Type representant un graphe comme un ensemble de noeuds
Exemple :
    node1 = Node("Joe", 3.14,1)
    node2 = Node("Steve", exp(1),2)
    node3 = Node("Jill", 4.12,3)
    edge1 = Edge(node1, node2, 4)
    edge2 = Edge(node2, node3, 3)
    G = Graph("Ick", [node1, node2, node3], [edge1, edge2])

Attention, tous les noeuds doivent avoir des données de même type.
"""
mutable struct GraphDic{T} <: AbstractGraph{T}
  name::String
  nodes::Vector{Node{T}}
  edges::Dict{Tuple{Node{T},Node{T}}, Edge{T}}
end


function GraphDic(name::String, nodes::Vector{Node{T}}, edges::Vector{Edge{T}}) where T 
  dic_edges = Dict{Tuple{Node{T},Node{T}}, Edge{T}}()
  for edge in edges 
    dic_edges[(node1(edge), node2(edge))] = edge
  end 
  GraphDic{T}(name, nodes, dic_edges)
end 

""" définition de l'égalité entre graph""" 
@inline (==)(graph1::GraphDic, graph2::GraphDic) = (nodes(graph1) == nodes(graph2)) && (edges(graph1) == edges(graph2)) && (name(graph1) == name(graph2))

"""Ajoute un noeud au graphe."""
function add_node!(graph::GraphDic{T}, node::Node{T}) where T
  push!(graph.nodes, node)
  graph
end

"""Ajoute une arête au graphe. edges(graph) renvoie le Dict d'arêtes de graph"""
function add_edge!(graph::GraphDic{T}, edge::Edge{T}) where T
  edges(graph)[(node1(edge), node2(edge))] = edge
  graph
end

""" Vérifie la présence de node dans l'ensemble des sommets de graph"""
nodein(graph::GraphDic{T}, node::Node{T}) where T = findfirst( n -> n==node, nodes(graph)) != nothing


"""Affiche un graphe"""
function show(graph::AbstractGraph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges.")
  println("Nodes:")
  for node in nodes(graph)
    show(node)
  end
  println("Edges:")
  dic_edges = edges(graph)
  for key_edge in keys(dic_edges)
    show(dic_edges[key_edge])
  end
end

"""Affiche uniquement les noeuds d'un graphe. Si il y a trop d'arêtes la méthode show ne permet pas de voir les noeuds.""" 
function show_nodes(graph::AbstractGraph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges.")
  println("Nodes:")
  for node in nodes(graph)
    show(node)
  end
end

"""On merge deux Graph, l'union des 2 graphs est composé de l'union des sommets et des arêtes. On choisit de garder le nom de graph1 """
function merge(graph1::GraphDic{T}, graph2::GraphDic{T}) where T
  nodes_union = unique(vcat(nodes(graph1), nodes(graph2)))
  edges_union = merge(edges(graph1), edges(graph2))
  graph_name = name(graph1)
  merged_graph = GraphDic{T}(graph_name, nodes_union, edges_union)
  return merged_graph
end 


mutable struct Couple{T,Y} 
  fst :: T
  snd :: Y
end 

fst(c :: Couple{T,Y}) where T where Y = c.fst
snd(c :: Couple{T,Y}) where T where  Y = c.snd
isless(c1 ::  Couple{T,Y},c2 :: Couple{T,Y}) where T where Y =  snd(c1) < snd(c2)
==(c1 ::  Couple{T,Y},c2 :: Couple{T,Y}) where T where Y =  snd(c1) == snd(c2)

mutable struct GraphList{T} <: AbstractGraph{T}
  name :: String
  adj_list :: Dict{ MarkedNode{T}, Vector{ Couple{MarkedNode{T},Float64} } }
end

""" définition de l'égalité entre graph""" 
@inline (==)(graph1::GraphList, graph2::GraphList) = (nodes(graph1) == nodes(graph2)) && (adj_list(graph1) == adj_list(graph2)) && (name(graph1) == name(graph2))


adj_list(g :: GraphList{T}) where T = g.adj_list
""" renvoies les noeuds d'un graphe stocké sous forme de liste d'adjacence"""
nodes(g :: GraphList{T}) where T = collect(keys(adj_list(g))) :: Vector{MarkedNode{T}}

copy(g:: GraphList{T}) where T = GraphList(name(g), copy(adj_list(g)))
"""
    neighbours(graph,node)
renvoie la liste des voisins de node.
"""
function neighbours(g :: GraphList{T}, node :: MarkedNode{T}) where T
  neighbours = adj_list(g)[node]
  res = []
  for n in neighbours
    if fst(n) != node
      push!(res, n)
    end
  end
  return res
end 

function dfs_visit_iter(G::GraphList{T}, node::MarkedNode{T}) where T
    keys_node = collect(keys(adj_list(G)))
    reset_visit!.(keys_node)
    s = Stack{MarkedNode{T}}()
    push!(s, node)
    res_nodes = Vector{MarkedNode{T}}([])

    while is_empty(s) == false
        u = pop!(s)
        set_visited!(u)
        push!(res_nodes,u ) #ajout

        for neighbor in neighbours(G, u)
            visited(fst(neighbor)) || push!(s, fst(neighbor))
        end
    end
    return res_nodes 
end

function graph_minus_one_vertex(_graph :: GraphList{T}) where T
  # _graph = copy(graph)
  nodes_vector = nodes(_graph) 
  adjacency_list = adj_list(_graph)
  nodes_minus_one = nodes_vector[2:end]
  lone_node = nodes_vector[1]
  new_adj_list = Dict{ MarkedNode{T}, Vector{ Couple{MarkedNode{T},Float64} } }()
  for node in nodes_minus_one    
    _tmp = filter( node -> fst(node) != lone_node, adjacency_list[node])
    get!(new_adj_list, node, _tmp)       
    # Vector{Couple{MarkedNode{T},Float64}}(undef,0)
    # new_adj_list[node] = adjacency_list[node]
  end 
  new_graph = GraphList(name(_graph)*" without first node", new_adj_list)
  return (lone_node, new_graph)
end

function reset_visit(graph :: GraphList{T}) where T
  for node in nodes(graph)
    node.visited = false
  end
end

function show(g :: GraphList{T}) where T
  keys_node = collect(keys(adj_list(g)))
  for node in keys_node
    print("degrès: ", length(adj_list(g)[node]), " ")
    show(node)    
    for voisin in adj_list(g)[node]        
    print("### poids arête \t", snd(voisin), " \t")
    show(fst(voisin) )    

    end 
  end 
end 


 


