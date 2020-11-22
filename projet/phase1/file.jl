import Base.push!, Base.popfirst!, Base.length, Base.show, Base.isempty


abstract type  AbstractQueue{T} end

"""Type représentant une file avec des éléments de type T."""
mutable struct Queue{T} <: AbstractQueue{T}
    items::Vector{T}
end

items(q :: Queue{T}) where T = q.items

Queue{T}() where T = Queue(T[])

"""Ajoute `item` à la fin de la file `s`."""
function push!(q::AbstractQueue{T}, item::T) where T
    push!(q.items, item)
    q
end

"""Retire et renvoie l'objet du début de la file."""
popfirst!(q::AbstractQueue) = popfirst!(q.items)

"""Indique si la file est vide."""
is_empty(q::AbstractQueue) = length(q.items) == 0

"""Donne le nombre d'éléments sur la file."""
length(q::AbstractQueue) = length(q.items)

"""Affiche une file."""
show(q::AbstractQueue) = show(q.items)

""" renvoie l'élement de la queue possédant la priorité la plus faible"""
min_weight(queue::AbstractQueue) = minimum(queue.items)


function delete_item(queue::AbstractQueue, item)    
    # index = findfirst(x -> item==x, queue.items)
    _index = index(queue, item)
    deleteat!(queue.items, _index)
    queue
end

""" Créée une une file de priorité (queue) à partir d'un vecteur de MarkedNode"""
function create_marked_node_queue( vector_marked_node :: Vector{MarkedNode{T}}, s :: MarkedNode{T}) where T
    queue = Queue{PriorityItem{MarkedNode{T}}}()
    # (node -> println("distance ", distance(node))).(vector_marked_node)
    for marked_node in vector_marked_node
        if marked_node != s
            item = PriorityItem(Inf, marked_node)
        else
            item = PriorityItem(0.0, marked_node)
        end
        push!(queue, item)
        # item = PriorityItem(distance(marked_node), marked_node)
        # push!(queue, item)
    end
    return queue
end 

""" Détermines l'index de node dans la queue, fonction pour manipuler plus simplement les Dictionnaires"""
function index(queue :: Queue{PriorityItem{MarkedNode{T}}}, node :: MarkedNode{T}) where T
    index = -1
    cpt = 1
    for priority_item in items(queue)
        if priority_item == node
            index = cpt
        end 
        cpt+=1
    end 
    index >= 1 || error("le noeud ne se trouve pas dans la liste")
    return index
end 

""" Met à jour la file de priorité queue, vérifie si le noeud n'appartient pas à l'arbre couvrant avant de le mettre à jour """
function update!(queue :: Queue{PriorityItem{MarkedNode{T}}}, node :: MarkedNode{T}, new_priority :: Float64) where T
    if visited(node) == false 
        _index = index(queue, node )    
        _items = items(queue)
        _items[_index] = PriorityItem(new_priority, node)   
        sort!(_items)
    end 
    queue
end 

function get_priority_item(queue :: Queue{PriorityItem{MarkedNode{T}}}, node :: MarkedNode{T}) where T
    _index = index(queue, node)
    return items(queue)[_index]
end 

show(queue :: Queue{PriorityItem{MarkedNode{T}}}) where T = show.(items(queue))
 
