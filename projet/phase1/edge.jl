import Base.show, Base.==, Base.isless
using Test

"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T} end


# on présume que tous les arêtes dérivant d'AbstractEdge
# posséderont un champ `node1` .
# posséderont un champ `node2` .
# posséderont un champ `weight` .


"""Renvoie le poids d'une arête."""
@inline weight(edge::AbstractEdge) = edge.weight

"""Renvoie le premier sommet de l'arête """
@inline node1(edge::AbstractEdge) = edge.node1

"""Renvoie le second sommet de l'arête """
@inline node2(edge::AbstractEdge) = edge.node2

"""Affiche une arête."""
@inline show(edge::AbstractEdge) = println("Arête de poids ", string(weight(edge)), ": ", name(node1(edge)), " <------> ", name(node2(edge)), )


@inline (==)(edge1 :: AbstractEdge, edge2 :: AbstractEdge) = weight(edge1) == weight(edge2)

@inline isless(edge1 :: AbstractEdge, edge2 :: AbstractEdge) = weight(edge1) <= weight(edge2)

"""Type représentant les arêtes d'un graphe.

Exemple:

        noeud1 = Node("James", [π, exp(1)])
        noeud2 = Node("Kirk", "guitar")
        arête = Edge(noeud1, noeud2, 2)

"""
mutable struct Edge{T} <: AbstractEdge{T}
  node1::AbstractNode{T}
  node2::AbstractNode{T}
  weight::Union{Float64,Nothing}
end

function Edge(node1::AbstractNode{T}, node2::AbstractNode{T}; weight::Y) where T where Y
  if typeof(Y)==Nothing
    weight=nothing
    Edge(node1,node2,weight)
  else
    Edge(node1,node2,Float64(weight))
  end
end 







