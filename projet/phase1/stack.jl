import Base.length, Base.push!, Base.pop!
import Base.show

"""Type abstrait dont d'autres types de piles dériveront."""
abstract type AbstractStack{T} end

"""Type représentant une pile avec des éléments de type T."""
mutable struct Stack{T} <: AbstractStack{T}
    items::Vector{T}
end

Stack{T}() where T = Stack(T[])

"""Ajoute `item` sur le dessus de la pile `s`."""
function push!(s::AbstractStack{T}, item::T) where T
    push!(s.items, item)
    s
end

"""Retire et renvoie l'objet du dessus de la pile."""
pop!(s::AbstractStack) = pop!(s.items)

"""Consulte l'objet du dessus de la pile."""
top(s::AbstractStack) = s.items[end]

"""Indique si la pile est vide."""
is_empty(s::AbstractStack) = length(s.items) == 0

"""Donne le nombre d'éléments sur la pile."""
length(s::AbstractStack) = length(s.items)

"""Affiche une pile."""
show(s::AbstractStack) = show(s.items)
