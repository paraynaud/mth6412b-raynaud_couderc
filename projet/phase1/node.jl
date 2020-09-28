import Base.show
using Test


"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end

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


node_test = Node("f",4,3)

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Renvoie le nom du noeud."""
name(node::AbstractNode) = node.name

"""Renvoie les données contenues dans le noeud."""
data(node::AbstractNode) = node.data

"""Affiche un noeud."""
function show(node::AbstractNode)
  println("Node ", name(node), ", data: ", data(node))
end


