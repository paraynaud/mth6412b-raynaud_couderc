# using BenchmarkTools, Test

code_path="projet/phase1/"

include(code_path * "ordered_include.jl")

function total_weight(edges)
    sum = 0
    for i in 1:length(edges)
        sum = sum + edges[i].weight
    end 
    return sum
end 


function total_weight_nodes(vector_nodes)
    sum = 0
    for node in vector_nodes
        distance(node) == Inf && @warn("distance inf ", node)
        sum = sum + distance(node)
    end 
    return sum
end 


function check_weight_graph(graph)
    list_adjacence = adj_list(graph)
    nodes_vector = nodes(graph)    
    sum=0
    for node in nodes_vector
        tmp = 0
        for voisin in list_adjacence[node]    
			tmp += snd(voisin) 
		end
		tmp = tmp/2  		
		sum += tmp    
	end 
    return sum
end 

# filename = "instances/stsp/pa561.tsp"
# filename = "instances/stsp/bayg29.tsp"
 filename = "instances/stsp/course_note.tsp"
# filename = "instances/stsp/dantzig42.tsp"
# filename = "instances/stsp/gr17.tsp"



# graph = create_graph_dic_from_file(filename)

list_adjacence = create_graph_list_from_file(filename)

# graph_couvrant = prim(list_adjacence)
# total =  total_weight2(list_adjacence, graph_couvrant)



# for _ in 1:100 

main_khl(filename)


    # diviser_t = 2.0 #défaut à 2
    # diviser_period = 2.0 #défaut à 2
    # res = ascent(list_adjacence; _diviser_t=diviser_t, _diviser_period=diviser_period)
    # @show check_weight_graph(res)

# end 



# for _ in 1:100
#     res_nodes1, res_edges1, res_nodes2, res_edges2 = rsl(filename)
#     @show total_weight(res_edges1)
#     @show total_weight(res_edges2)
# end




# function check_pas_de_doublon(vec :: Vector)
#     b = true 
#     n = length(vec)
#     for i in 1:length(vec)-1
#         for j in i+1:n
#             b = b && (vec[i] != vec[j])
#         end 
#         if b == false 
#             return false 
#         end
#     end 
# end 

