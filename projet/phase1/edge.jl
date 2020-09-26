import Base.show

"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{Y} end

"""Type représentant les arêtes d'un graphe.

Exemple:

        noeud1 = Node("James", [π, exp(1)])
        noeud2 = Node("Kirk", "guitar")
        arête = Edge(noeud1, noeud2, 2)

"""
mutable struct Edge{T,Y} <: AbstractEdge{Y}
  node1::AbstractNode{T}
  node2::AbstractNode{T}
  weight::Y
end

# on présume que tous les arêtes dérivant d'AbstractEdge
# posséderont un champ `node1` .
# posséderont un champ `node2` .
# posséderont un champ `weight` .

"""Renvoie le poids d'une arête."""
weight(edge::AbstractEdge) = edge.weight

"""Renvoie le premier sommet de l'arête """
node1(edge::AbstractEdge) = edge.node1

"""Renvoie le second sommet de l'arête """
node2(edge::AbstractEdge) = edge.node2

"""Affiche une arête."""
show(edge::AbstractEdge) = println("Arête de poids ", string(weight(edge)), ": ", name(node1(edge)), " <------> ", name(node2(edge)), )

