# using BenchmarkTools, Test

code_path="projet/phase1/"

include(code_path * "ordered_include.jl")





# filename = "instances/stsp/pa561.tsp"
# filename = "instances/stsp/bayg29.tsp"
filename = "instances/stsp/course_note.tsp"


graph = create_graph_dic_from_file(filename)
list_adjacence = create_graph_list_from_file(filename)

# show(list_adjacence)

couvrant_list = prim(list_adjacence)

graph_couvrant = build_graph_list(couvrant_list)
# show(graph_couvrant)

# keys_node = collect(keys(adj_list(graph_couvrant)))
# depart_node = adj_list(graph_couvrant)[keys_node[1]][1]
# dfs_visit_iter(graph_couvrant, fst(depart_node))


res = rsl(list_adjacence)

show.(res )


function check_pas_de_doublon(vec :: Vector)
    b = true 
    n = length(vec)
    for i in 1:length(vec)-1
        for j in i+1:n
            b = b && (vec[i] != vec[j])
        end 
        if b == false 
            return false 
        end
    end 
end 

@show check_pas_de_doublon(res)

# all_5 = findall(node -> node.index == 5, res)
# bench_dic = @benchmark (kruskal2(graph))
# bench_list = @benchmark prim(list_adjacence)
# couvrant_dic = kruskal2(graph)
