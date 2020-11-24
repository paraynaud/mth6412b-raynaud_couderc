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
show(node::AbstractNode) = println("Node ", name(node), ", data: ", data(node), " d'indice ", index(node), " distance: ", distance(node))

"""Type représentant les noeuds d'un graphe.

Exemple:

        noeud = MarkedNode([π, exp(1)], name="James")
        noeud = MarkedNode("guitar", name="James")
        noeud = MarkedNode(2, name="Lars")

"""
mutable struct MarkedNode{T} <: AbstractNode{T}
  name::String
  data::T
  visited::Bool
  distance::Float64
  parent::Union{MarkedNode{T},Nothing}
  index:: Int
  pi :: Float64
  best_pi :: Float64
  v :: Int
  last_v :: Int
  beta :: Float64  
end

""" Utilisation d'une variable globale lors de la création du graphe pour nous simplifier la distinction entre 2 noeud étant initialisé sans donnée"""
global _index_marked_node = 1

""" Cette fonction reset la variable globale, nécessaire si l'on souhaite définir plusieurs graphes de liste dans un même éxecution"""
function reset_index_marked_node()
  global _index_marked_node = 1
end 

"""Constructeur de MarkedNode """
function MarkedNode(data::T; name::String="", distance::Float64=Inf, _index::Int=_index_marked_node, pi::Float64=0.0, best_pi::Float64=0.0, v::Int= 0 , last_v::Int=-1, beta::Float64=Inf) where T
  global _index_marked_node +=1
  MarkedNode(name, data, false, max(0.0, distance), nothing, _index, pi, best_pi, v, last_v, beta)
end


"""Getter/Setter"""
function set_visited!(node::MarkedNode)
  node.visited = true
  node
end

function reset_visit!(node::MarkedNode)
  node.visited = false
  node  
end

function set_distance!(node::MarkedNode, d::Float64)
  node.distance = max(0.0, d)
  node
end

parent(node:: MarkedNode) = node.parent
function set_parent!(node::MarkedNode{T}, p::MarkedNode{T}) where T
  node.parent = p
  node
end

function set_parent_nothing!(node::MarkedNode{T}) where T
  node.parent = nothing
  node
end

pi(node::MarkedNode{T}) where T = node.pi
function set_pi!(node::MarkedNode{T}, new_pi::Float64) where T 
  node.pi = new_pi
  node 
end 

best_pi(node::MarkedNode{T}) where T = node.best_pi
function set_best_pi!(node::MarkedNode{T}, new_best_pi::Float64) where T 
  node.best_pi = new_best_pi
  node 
end 

v(node::MarkedNode) = node.v
function set_v!(node::MarkedNode, v::Int) 
  node.v = v
  node 
end 

last_v(node::MarkedNode) = node.last_v
function set_last_v!(node::MarkedNode, lv::Int) 
  node.last_v = lv
  node 
end 