import Base.show, Base.==
using Test


"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end



(==)(node1 :: AbstractNode, node2 :: AbstractNode) = (name(node1) == (name(node2) )  &&  (data(node1)==data(node2)) && (index(node1) == index(node2)) )
"""Type représentant les noeuds d'un graphe.

Exemple:

        noeud = Node("James", [π, exp(1)],1)
        noeud = Node("Kirk", "guitar",1)
        noeud = Node("Lars", 2,1)

"""
mutable struct Node{T} <: AbstractNode{T}
  name::String
  data::T
  index::Int
end


global _index_node = 1
Node(name::String; data::T=-1, index::Int=_index_node) where T  = begin global _index_node +=1; Node(name, data :: T, index) end 



# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Renvoie le nom du noeud."""
@inline name(node::AbstractNode) = node.name

"""Renvoie les données contenues dans le noeud."""
@inline data(node::AbstractNode) = node.data

"""Renvoie les données contenues dans le noeud."""
@inline index(node::AbstractNode) = node.index

""" set_index!(node, i), setter du champ index de Node """
set_index!(node :: Node{T}, i :: Int) where T = node.index = i

""" visited(node) renvoie le champs visited d'un AbstractNode """
@inline visited(node :: AbstractNode{T}) where T = node.visited

""" distance(node) renvoie le champs distance d'un AbstractNode """
@inline distance(node :: AbstractNode{T}) where T = node.distance 

"""Affiche un noeud."""
show(node::AbstractNode) = println("Node ", name(node), ", data: ", data(node), " d'indice ", index(node))


mutable struct MarkedNode{T} <: AbstractNode{T}
  name::String
  data::T
  visited::Bool
  distance::Float64
  parent::Union{MarkedNode{T},Nothing}
  index:: Int
end
  
global _index_marked_node = 1

function MarkedNode(data::T; name::String="", distance::Float64=Inf, _index::Int=_index_marked_node) where T
  global _index_marked_node +=1
  MarkedNode(name, data, false, max(0.0, distance), nothing, _index)
end

function reset_index_marked_node()
  global _index_marked_node = 1
end 
  
function set_visited!(node::MarkedNode)
  node.visited = true
  node
end

is_visited(node::MarkedNode) = (node.visited == true)

function set_distance!(node::MarkedNode, d::Float64)
  node.distance = max(0.0, d)
  node
end

function set_parent!(node::MarkedNode{T}, p::MarkedNode{T}) where T
  node.parent = p
  node
end
