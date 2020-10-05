import Base.==, Base.merge!, Base.show

abstract type AbstractConnectedComponent{T} <: AbstractGraph{T} end

# on présume qu'un composante connexe possedera
# des champs `sub_graph` et `root`.

"""Renvoie le nom du graphe."""
@inline name(connected_component::AbstractConnectedComponent) = name(connected_component.sub_graph)

"""Renvoie la liste des noeuds du graphe."""
@inline nodes(connected_component::AbstractConnectedComponent) = nodes(connected_component.sub_graph)

"""Renvoie le nombre de noeuds du graphe."""
@inline nb_nodes(connected_component::AbstractConnectedComponent) = nb_nodes(connected_component.sub_graph)

"""Renvoie un dictionnaire des arêtes graphe."""
@inline edges(connected_component::AbstractConnectedComponent) = edges(connected_component.sub_graph)

"""Renvoie le nombre d'arêtes du graphe."""
@inline nb_edges(connected_component::AbstractConnectedComponent) = sub_graph(connected_component.sub_graph)

""" définition de l'égalité entre graph""" 
@inline (==)(connected_component1::AbstractConnectedComponent, connected_component2::AbstractConnectedComponent) = (nodes(connected_component1) == nodes(connected_component2)) && (edges(connected_component1) == edges(connected_component2)) && (name(connected_component1) == name(connected_component2)) && (root(connected_component1) == root(connected_component2))

nodein(connected_component::AbstractConnectedComponent, node:: Node{T}) where T = nodein(connected_component.sub_graph, node)
nodeat(connected_component::AbstractConnectedComponent, node:: Node{T}) where T = nodeat(connected_component.sub_graph, node)

mutable struct ConnectedComponent{T} <: AbstractConnectedComponent{T}
    sub_graph :: Graph{T}
    root :: Node{T}
    index::Int
end 

"""Renvoie la racine d'une composante connexe."""
@inline root(c_c :: ConnectedComponent) = c_c.root
@inline sub_graph(c_c :: ConnectedComponent) = c_c.sub_graph
@inline index(c_c :: ConnectedComponent) = c_c.index

"""
    Définition d'un nouveau constructeur.
"""
global _index_cc = 0
ConnectedComponent(root::Node{T};
                   sub_graph::Graph{T}=Graph("connected_component",
                                            [root],
                                            Edge{T}[]),
                   index::Int=_index_cc) where T  = begin global _index_cc +=1; ConnectedComponent( sub_graph, root, index) end 
#on créé une composante connexe en générant un graph directement à partir de la racine

set_sub_graph!(cc :: ConnectedComponent{T}, g :: Graph{T}) where T = cc.sub_graph = g

function check_edge(edge::Edge{T}, nodes1::Vector{Node{T}}, nodes2::Vector{Node{T}}) where T
    _node1 = node1(edge)
    _node2 = node2(edge)
    exist_n1_l1 = (findfirst(x-> x==_node1, nodes1) != nothing)
    exist_n1_l2 = (findfirst(x-> x==_node1, nodes2) != nothing)
    exist_n2_l1 = (findfirst(x-> x==_node2, nodes1) != nothing)
    exist_n2_l2 = (findfirst(x-> x==_node2, nodes2) != nothing)

    if ((exist_n1_l1 && exist_n2_l2) || (exist_n1_l2 && exist_n2_l1)) 
        return true
    else
        error("les deux sommets de l'arête n'appartient pas à une composante connexe distincte")
    end 
end 

#todo opération merge de composante connexes (cc1,cc2,edge1), celles de graph également.
function merge!(vector_cc :: Vector{ConnectedComponent{T}}, edge :: Edge{T}) where T
    _node1 = node1(edge)
    _node2 = node2(edge)

    show(edge)
    show(_node1)
    show(_node2)
    # show.(vector_cc)

    index_cc1 = findfirst( cc -> nodein(cc, _node1), vector_cc)
    cc1 = vector_cc[index_cc1]
    index_cc2 = findfirst( cc -> cc != cc1 && nodein(cc, _node2), vector_cc)
    cc2 = vector_cc[index_cc2]


    # check_edge(edge, nodes(cc1), nodes(cc2))
    new_sub_graph = merge(sub_graph(cc1), sub_graph(cc2))
    add_edge!(new_sub_graph, edge)
    set_sub_graph!(cc1, new_sub_graph)

    deleteat!(vector_cc, index_cc2)
    return cc1
end 

function show(cc :: ConnectedComponent)
    println("la racine est :", root(cc))
    show(sub_graph(cc))    
end


