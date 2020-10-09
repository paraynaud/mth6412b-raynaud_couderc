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

"""Affiche un noeud."""
show(node::AbstractNode) = println("Node ", name(node), ", data: ", data(node), " d'indice ", index(node))

