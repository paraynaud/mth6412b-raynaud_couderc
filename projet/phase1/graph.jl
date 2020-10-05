import Base.show, Base.==, Base.merge


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

""" définition de l'égalité entre graph""" 
@inline (==)(graph1::AbstractGraph, graph2::AbstractGraph) = (nodes(graph1) == nodes(graph2)) && (edges(graph1) == edges(graph2)) && (name(graph1) == name(graph2))







"""Type representant un graphe comme un ensemble de noeuds.

Exemple :

    node1 = Node("Joe", 3.14,1)
    node2 = Node("Steve", exp(1),2)
    node3 = Node("Jill", 4.12,3)
    edge1 = Edge(node1, node2, 4)
    edge2 = Edge(node2, node3, 3)
    G = Graph("Ick", [node1, node2, node3], [edge1, edge2])

Attention, tous les noeuds doivent avoir des données de même type.
"""
mutable struct Graph{T} <: AbstractGraph{T}
  name::String
  nodes::Vector{Node{T}}
  edges::Dict{Tuple{Node{T},Node{T}}, Edge{T}}
end


function Graph(name::String, nodes::Vector{Node{T}}, edges::Vector{Edge{T}}) where T 
  dic_edges = Dict{Tuple{Node{T},Node{T}}, Edge{T}}()
  for edge in edges 
    dic_edges[(node1(edge), node2(edge))] = edge
  end 
  Graph{T}(name, nodes, dic_edges)
end 


"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T}, node::Node{T}) where T
  push!(graph.nodes, node)
  graph
end

"""Ajoute une arête au graphe. edges(graph) renvoie le Dict d'arêtes de graph"""
function add_edge!(graph::Graph{T}, edge::Edge{T}) where T
  edges(graph)[(node1(edge), node2(edge))] = edge
  graph
end

nodein(graph::Graph{T}, node::Node{T}) where T = findfirst( n -> n==node, nodes(graph)) != nothing
nodeat(graph::Graph{T}, node::Node{T}) where T = findfirst( n -> n==node, nodes(graph))


"""Affiche un graphe"""
function show(graph::Graph)
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
function show_nodes(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges.")
  println("Nodes:")
  for node in nodes(graph)
    show(node)
  end
end

"""On merge deux Graph, l'union des 2 graphs est composé de l'union des sommets et des arêtes. On choisit de garder le nom de graph1 """
function merge(graph1::Graph{T}, graph2::Graph{T}) where T
  nodes_union = unique(vcat(nodes(graph1), nodes(graph2)))
  edges_union = merge(edges(graph1), edges(graph2))
  graph_name = name(graph1)
  merged_graph = Graph{T}(graph_name, nodes_union, edges_union)
  return merged_graph
end 


include("connected_component.jl")



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

function pre_treatement_edges!(vector_edges::Vector{Edge{T}}) where T 
  delete_index = Int[]
  for (i,edge) in enumerate(vector_edges)
    _node1=node1(edge)
    _node2=node2(edge)
    (_node1 == _node2) ? push!(delete_index,i) : continue
  end
  deleteat!(vector_edges, delete_index)
end 

function kruskal(g :: Graph{T}) where T
  _nodes = nodes(g)
  _edges = edges(g)
  
  vector_edges = Vector{Edge{T}}( map( edge -> edge[2], collect(_edges ) ))
  sort!(vector_edges)
  pre_treatement_edges!(vector_edges)

  
  cc_vector = map( node -> ConnectedComponent(node), _nodes)
  # show.(cc_vector)
  # for (i,edge) in enumerate(_edges)
  #   show(edge)
  # end 


  while isempty(vector_edges) == false    
    edge = vector_edges[1]
    cc = merge!(cc_vector, edge)
    delete_edges!(vector_edges, cc)  
  end
  
  length(cc_vector) != 1 && @error("nombre de composante connexe différent de 1")
  return cc_vector[1]
end 
