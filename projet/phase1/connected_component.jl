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
@inline nb_edges(connected_component::AbstractConnectedComponent) = length(edges(sub_graph))

"""Définition de l'égalité entre graph""" 
@inline (==)(connected_component1::AbstractConnectedComponent, connected_component2::AbstractConnectedComponent) = (nodes(connected_component1) == nodes(connected_component2)) && (edges(connected_component1) == edges(connected_component2)) && (name(connected_component1) == name(connected_component2)) && (root(connected_component1) == root(connected_component2))

"""Vérifie l'existence de node dans connected_component"""
nodein(connected_component::AbstractConnectedComponent, node:: Node{T}) where T = nodein(connected_component.sub_graph, node)


mutable struct ConnectedComponent{T} <: AbstractConnectedComponent{T}
    sub_graph :: Graph{T}
    root :: Node{T}
    index::Int
end 

"""Renvoie la racine d'une composante connexe."""
@inline root(c_c :: ConnectedComponent) = c_c.root

"""Renvoie le graph d'une composante connexe."""
@inline sub_graph(c_c :: ConnectedComponent) = c_c.sub_graph

"""Renvoie l'indice d'une composante connexe."""
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

""" set_sub_graph!(connected_component, graph), setter du champ sub_graph de connected_component """
set_sub_graph!(cc :: ConnectedComponent{T}, g :: Graph{T}) where T = cc.sub_graph = g


"""
    merge!(vector_connected_component, edge) merge deux composantes connexes à partir de l'arête edge.
    Un sommet n'est présent que dans une seule composante connexe, on peut donc retrouver les sommets à partir de l'arête.
"""
function merge!(vector_cc :: Vector{ConnectedComponent{T}}, edge :: Edge{T}) where T
    _node1 = node1(edge)
    _node2 = node2(edge)

    index_cc1 = findfirst( cc -> nodein(cc, _node1), vector_cc)
    cc1 = vector_cc[index_cc1]
    index_cc2 = findfirst( cc -> cc != cc1 && nodein(cc, _node2), vector_cc)
    cc2 = vector_cc[index_cc2]

    new_sub_graph = merge(sub_graph(cc1), sub_graph(cc2))
    add_edge!(new_sub_graph, edge)
    set_sub_graph!(cc1, new_sub_graph)

    deleteat!(vector_cc, index_cc2)
    return cc1
end 

""" Affiche la composante connexe cc""" 
function show(cc :: ConnectedComponent)
    println("la racine est :", root(cc))
    show(sub_graph(cc))    
end


