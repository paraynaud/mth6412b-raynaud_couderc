import Base.show


include("node.jl")
include("edge.jl")


"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractGraph{T} end

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
mutable struct Graph{T,Y} <: AbstractGraph{T}
  name::String
  nodes::Vector{Node{T}}
  edges::Dict{Tuple{Node{T},Node{T}}, Edge{T,Y}}
end

function Graph(name::String, nodes::Vector{Node{T}}, edges::Vector{Edge{T,Y}}) where T where Y 
  dic_edges = Dict{Tuple{Node{T},Node{T}}, Edge{T,Y}}()
  for edge in edges 
    dic_edges[(node1(edge), node2(edge))] = edge
  end 
  Graph{T,Y}(name, nodes, dic_edges)
end 

"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T}, node::Node{T}) where T
  push!(graph.nodes, node)
  graph
end

"""Ajoute une arête au graphe."""
function add_edge!(graph::Graph{T}, edge::Edge{T,Y}) where T where Y
  edges(graph)[(node1(edge), node2(edge))] = edge
  graph
end

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name` et `nodes`.

"""Renvoie le nom du graphe."""
name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
nodes(graph::AbstractGraph) = graph.nodes

"""Renvoie le nombre de noeuds du graphe."""
nb_nodes(graph::AbstractGraph) = length(graph.nodes)

"""Renvoie un dictionnaire des arêtes graphe."""
edges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre d'arêtes du graphe."""
nb_edges(graph::AbstractGraph) = length( edges(graph) )

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

function show_nodes(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges.")
  println("Nodes:")
  for node in nodes(graph)
    show(node)
  end
end


_node1 = Node("Joe", 3.14,1)
_node2 = Node("Steve", exp(1),2)
_node3 = Node("Jill", 4.12,3)
_edge1 = Edge(_node1, _node2, 4)
_edge2 = Edge(_node2, _node3, 3)
vector_node = [_node1, _node2, _node3]
vector_edge = [_edge1, _edge2]
graph = Graph("Ick", vector_node, vector_edge)

_edge3 = Edge(_node1, _node3, 5)
add_edge!(graph,_edge3)
#show(graph)