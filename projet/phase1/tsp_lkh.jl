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



function main_khl(filename)
	graph = create_graph_list_from_file(filename)
	diviser_t = 2.0 #défaut à 2
	diviser_period = 2.0 #défaut à 2
	new_graph = create_candidate_set(graph; _diviser_t=diviser_t, _diviser_period=diviser_period)
	show(new_graph)
	@show check_weight_graph(new_graph)
	# opt(graph, new_graph,)

end 


function create_candidate_set(graph; kwargs...) 
	
	lone_node, m1t = ascent(graph; kwargs...)
	println("résultat de ascent")
	show(m1t)
	@show check_weight_graph(m1t)
	println("fin résultat de ascent\n\n\n")

	lower_bound = check_weight_graph(m1t)
	dimension = length(nodes(graph))
	excess = 1/dimension
	max_alpha :: Float64 = excess * abs(lower_bound)	
	# max_alpha = 5.0
	max_candidates = 5.0
	println("\n\n\n max_alpha:", max_alpha, "\n\n\n")
	new_graph = generate_candidates(max_candidates, max_alpha, graph, m1t, lone_node)
	return new_graph
end 
# function generate_candidates(max_candidates :: Float64, max_alpha:: Float64, graph :: GraphList{T}, m1t, lone_node :: MarkedNode{T}) where T



function tree_cost(graph)
    list_adjacence = adj_list(graph)
    nodes_vector = nodes(graph)    
    sum=0
	for node in nodes_vector
		tmp = 0
        for voisin in list_adjacence[node]    
			# sum += snd(voisin) + pi(fst(voisin)) + pi(node)
			tmp += snd(voisin) + pi(fst(voisin)) + pi(node)
		end
		tmp = tmp/2  		
		sum += tmp    
	end 
	for node in nodes_vector
		sum -= 2*pi(node)         
	end 
    return sum
end 

function ascent(graph :: GraphList{T}; _diviser_t::Float64=2, _diviser_period::Float64=2) where T
	dimension = length(nodes(graph))
	_nodes = nodes(graph)
	# MarkedNode node	

	initial_period = max(100, dimension/2)	
	period = initial_period
	initial_phase :: Bool = true
	lone_node, m1t = minimum_1_tree(graph)
	
	w = tree_cost(m1t)
	(norm(_nodes) == 0) && return m1t
	max_alpha = 5.0
	max_candidates = 5.0
	sub_graph = generate_candidates(max_candidates, max_alpha, graph, m1t, lone_node)
	best_w = w

	for node in _nodes
		set_best_pi!(node, pi(node))
		set_last_v!(node, v(node))
	end 
	
	initial_step_size = 1 
	t = initial_step_size
	cpt = 1
	while t>0 && norm(nodes(m1t))/dimension > 0.01  
		p ::Int = 1 
		cpt2 = 1
		while t > 0 && p <= period 
			for node in _nodes 
				(v(node) != 0) && set_pi!(node, pi(node) + t/10 * (7*v(node) + 3*last_v(node)) )
				set_last_v!(node, v(node))
			end 
			lone_node, m1t = minimum_1_tree(sub_graph)

			w = tree_cost(m1t)
						
			(norm(_nodes) == 0) && begin println("la norme est: ", norm(_nodes)); show(m1t); return m1t end 
			if w > best_w
				best_w = w 
				for node in _nodes 
					set_best_pi!(node, pi(node))
				end 
				initial_phase && (t*=2)
				(p == period) && (period *=2)
			elseif initial_phase && (p > initial_period/2)
				initial_phase = false
				p = 0 
				t *= 3/4
			end 
			p += 1
			cpt2 += 1
		end 
		period /= _diviser_period
		t /= _diviser_t
		cpt += 1
	end 

	for node in _nodes 
		set_pi!(node, best_pi(node))		
	end 

	return lone_node, m1t
end 




function generate_order(m1t, lone_node)
	_adj_list_m1t = adj_list(m1t)
	order = [] 
	tmp = []

	push!(tmp, lone_node)
	_nodes = nodes(m1t)

	
	_idx_source = findfirst( node -> node != lone_node && parent(node)==nothing, _nodes )
	set_parent!(_nodes[_idx_source], lone_node) 

	while length(order) != length(nodes(m1t))
		_node = pop!(tmp)
		_idx_add_nodes =  findall( node -> parent(node) == _node, _nodes)
		if length(_idx_add_nodes) != 0
			add_nodes = view(_nodes, _idx_add_nodes)
			filtered_add_nodes = filter(node -> (node in tmp ) == false, add_nodes)
			tmp = vcat(tmp, filtered_add_nodes)		
		end 
		push!(order, _node)		
	end 

	set_parent_nothing!(_nodes[_idx_source]) 


	return order
end 




function generate_candidates(max_candidates :: Float64, max_alpha:: Float64, graph :: GraphList{T}, m1t, lone_node :: MarkedNode{T}) where T

	_adj_list_graph = adj_list(graph)
	_adj_list_m1t = adj_list(m1t)
	_nodes = nodes(graph)
	dimension = length(_nodes)
	beta = Array{Float64}(undef,dimension, dimension)

	order = generate_order(m1t, lone_node)

	_idx_source = findfirst( node -> node != lone_node && parent(node)==nothing, _nodes )
	set_parent!(_nodes[_idx_source], lone_node) 

	for node in order
		for (i,couple_voisin) in enumerate(_adj_list_graph[node])
			j = floor(i)
			if fst(couple_voisin) == node 
				beta[floor(index(node)),floor(index(node))] = -Inf

			elseif (couple_voisin in _adj_list_m1t[node])
				beta[j,index(node)] = snd(_adj_list_graph[node][j])
				beta[floor(index(node)),floor(j)] = snd(_adj_list_graph[node][floor(j)])

			elseif (fst(couple_voisin) == lone_node) || (node == lone_node)
				c_max_edge = maximum(snd.(_adj_list_m1t[lone_node])) 
				if (node == lone_node) 
					idx_voisin = findfirst( couple -> fst(couple) == fst(couple_voisin), _adj_list_graph[lone_node])
					beta[floor(j),floor(index(node))] = c_max_edge - snd(_adj_list_graph[lone_node][idx_voisin])					 
					beta[floor(index(node)),floor(j)] = c_max_edge - snd(_adj_list_graph[lone_node][idx_voisin])					 
				else 
					idx_node = findfirst( couple -> fst(couple) == node, _adj_list_graph[lone_node])
					beta[floor(j),floor(index(node))] = c_max_edge - snd(_adj_list_graph[lone_node][idx_node])
					beta[floor(index(node)),floor(j)] = c_max_edge - snd(_adj_list_graph[lone_node][idx_node])
				end 				

			else 
				idx_node = findfirst( couple -> fst(couple) == parent(fst(couple_voisin)), _adj_list_graph[fst(couple_voisin)])
				beta[index(node),j] = max(beta[index(node),index(parent(fst(couple_voisin)))], snd(_adj_list_graph[fst(couple_voisin)][idx_node]) )
				beta[j,index(node)] = max(beta[index(node),index(parent(fst(couple_voisin)))], snd(_adj_list_graph[fst(couple_voisin)][idx_node]) )
			end 
		end 
	end 

	alpha = Array{Float64}(undef,dimension, dimension)

	for node in _nodes 
		for (i, couple_voisin) in enumerate(_adj_list_graph[node])
			# idx_node = findfirst( couple -> fst(couple) == fst(couple_voisin), _adj_list_graph[node])
			j = index(fst(couple_voisin))
			alpha[index(node),j] = snd(_adj_list_graph[node][j]) - beta[index(node),j] 
		end 		
	end 

	new_adj_list = Dict{ MarkedNode{T}, Vector{ Couple{MarkedNode{T},Float64} } }()
	for _node in _nodes 
		get!(new_adj_list, _node, Vector{Couple{MarkedNode{T},Float64}}(undef,0))   
	end 

	for _node in _nodes 
		cpt = 0
		
		sorted_list = sort!(_adj_list_graph[_node])

		for (i, _iter_couple) in enumerate(sorted_list)
			j = index(fst(_iter_couple))
			if alpha[index(_node),j] <= max_alpha && cpt < max_candidates
				push!(new_adj_list[_node], _iter_couple)
				cpt += 1
			end 
		end 
	end 


	set_parent_nothing!(_nodes[_idx_source]) 



	new_graph = GraphList("new graph", new_adj_list)
	return new_graph
end 
	