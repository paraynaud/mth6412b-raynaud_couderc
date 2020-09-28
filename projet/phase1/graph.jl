import Base.show, Base.==
using Test



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

"""Ajoute une arête au graphe. edges(graph) renvoie le Dict d'arêtes de graph"""
function add_edge!(graph::Graph{T}, edge::Edge{T,Y}) where T where Y
  edges(graph)[(node1(edge), node2(edge))] = edge
  graph
end

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name` et `nodes` et `edges`.

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


"""Affiche uniquement les noeuds d'un graphe. Si il y a trop d'arêtes la méthode show ne permet pas de voir les noeuds.""" 
function show_nodes(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges.")
  println("Nodes:")
  for node in nodes(graph)
    show(node)
  end
end

""" définition de l'égalité entre graph""" 
(==)(graph1::Graph, graph2::Graph) = (nodes(graph1) == nodes(graph2)) && (edges(graph1) == edges(graph2)) && (name(graph1) == name(graph2))





