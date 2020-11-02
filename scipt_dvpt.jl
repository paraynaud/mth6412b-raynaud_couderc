using BenchmarkTools, Test

code_path="projet/phase1/"

include(code_path*"ordered_include.jl")




# _node1 = Node("Joe"; data=3.14, index=1)
# _node2 = Node("Steve"; data=exp(1), index=2)
# _node3 = Node("Jill"; data=4.12, index=3)
# _edge1 = Edge(_node1, _node2; weight=4)
# _edge2 = Edge(_node2, _node3; weight=3)
# _edge2 = Edge(_node1, _node3; weight=2)


# vector_node = [_node1, _node2, _node3]
# vector_edge = [_edge1, _edge2]
# graph = Graph("Ick", vector_node, vector_edge)



filename = "instances/stsp/pa561.tsp"


graph = create_graph_dic_from_file(filename)
list_adjacence = create_graph_list_from_file(filename)


bench_dic = @benchmark ( kruskal2(graph))


bench_list = @benchmark prim(list_adjacence)
couvrant = prim(list_adjacence)

function total_weight(arbre_couvrant)
    sum = 0
    for i in arbre_couvrant
        sum = sum + distance(i)
    end 
    return sum
end 
@show total_weight(couvrant)