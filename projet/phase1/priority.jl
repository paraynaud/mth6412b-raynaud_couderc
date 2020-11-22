import Base.isless, Base.==, Base.min


abstract type AbstractPriorityItem{T} end



mutable struct PriorityItem{T} <: AbstractPriorityItem{T}
    priority::Float64
    data::T
end

""" Redéfinition des comparaisons""" 
isless(p::PriorityItem, q::PriorityItem) = priority(p) < priority(q)
(==)(p::PriorityItem, q::PriorityItem) = priority(p) == priority(q)
(==)(p::T, q::PriorityItem{T}) where T = p == data(q)  
(==)(q::PriorityItem{T}, p::T) where T = p == data(q) 


function PriorityItem(priority::Float64, data::T) where T
    PriorityItem{T}(max(0, priority), data)
end


""" Getter de PriorityItem """
priority(p::PriorityItem) = p.priority
data(p::PriorityItem) = p.data
min(p::PriorityItem, q::PriorityItem) = (isless(p,q)) ? p : q

function priority!(p::PriorityItem, priority::Float64)
    p.priority = max(0, priority)
    p
end


show(p::PriorityItem) = begin print("priorité: ", priority(p), " ") ; show(data(p)) end 

