function norm(nodes)
	sum = 0 
	for node in nodes
		sum += v(node)^2
	end 
	return sum
end

function ascent(graph :: GraphList{T}; _diviser_t::Float64=2.0, _diviser_period::Float64=2.0) where T
	dimension = length(nodes(graph))
	_nodes = nodes(graph)
	# MarkedNode node	

	initial_period = 5
	period = initial_period
    initial_phase :: Bool = true
    

    source = first(adj_list(graph))[1]
    # w, m1t = minimum_1_tree2(graph; source=source)		
    w, m1t = minimum_1_tree2(graph)		
    source = m1t[1] #la suorce est le premier élément de la liste
    _norm = norm(_nodes)
    (_norm == 0) && return w
      
	max_alpha = 5.0
	max_candidates = 5.0
    sub_graph = generate_candidates(max_candidates, max_alpha, graph, source, m1t)


    best_w = w
    w0 = w 
    best_norm = _norm

	for node in _nodes
		set_best_pi!(node, pi(node))
		set_last_v!(node, v(node))
	end 
	
    initial_step_size = 1.0
    precision = 100.0
    t = initial_step_size * precision
    
    cpt = 1
    # norm(nodes(m1t))/dimension > 0.01  
	while (t>0.0 ) && (norm(_nodes) != 0) && (period > 0.0) && cpt < 20
		p ::Int = 1 
		cpt2 = 1
		while t > 0.0 && p <= period && norm(_nodes) != 0 && cpt2 < 20
			for node in m1t 
				(v(node) != 0) && set_pi!(node, pi(node) + t/10 * (7*v(node) + 3*last_v(node)) )
				set_last_v!(node, v(node))
            end 
            
            
             w, m1t = minimum_1_tree2(graph; source=source)
             println(w)
            # w, m1t = minimum_1_tree2(graph)
                     
            # g = GraphList("test", create_edges(m1t, adj_list(graph)))
            # show(g)
            
            _norm = norm(_nodes)
            if (w > best_w) || (w == best_w &&  _norm < best_norm)
                best_w = w 
                best_norm = _norm
				for node in m1t 
					set_best_pi!(node, pi(node))
                end 
                
				initial_phase && (t*=2)
                if (p == period) && (period *2 > initial_period)
                    period = initial_period 
                end 
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
    
    norm(_nodes) == 0 && println("la norme est nulle")
    t <= 0 && println("t est nul", t, period)
    period <= 0 && println("period est nul")

    for node in _nodes 
        print(best_pi(node))
        set_pi!(node, best_pi(node))		
        set_best_pi!(node,0.0)
    end 
    
    w, m1t = minimum_1_tree2(graph; source=source)		

	return w, m1t
end 


function generate_candidates(max_candidates :: Float64, max_alpha:: Float64, graph :: GraphList{T}, source, m1t) where T

	_adj_list_graph = adj_list(graph)
	_nodes = nodes(graph)
	dimension = length(_nodes)
	beta = Array{Float64}(undef,dimension, dimension)


    idx_noeud_succ = findfirst(node -> successor(node) != nothing, m1t)
    selected_leaf = m1t[idx_noeud_succ]
	
    for (i_from, node_from) in enumerate(m1t)
        for (i_to, node_to) in enumerate(m1t)
            if i_from == i_to     
                # @show typeof(i_from)       
                # @show typeof(floor(i_to))       
                beta[i_from, i_to] = -Inf
            elseif i_from == idx_noeud_succ || i_to == idx_noeud_succ #le noeud possède l'arête supplémentaire à l'arbre couvrant
                c_node_succ_parent = parent(selected_leaf)
                c_node_succ_successor = successor(selected_leaf)                
                idx_parent = findfirst( couple -> fst(couple) == c_node_succ_parent, _adj_list_graph[selected_leaf])
                dist_to_parent =  snd(_adj_list_graph[selected_leaf][idx_parent])
                idx_successor = findfirst( couple -> fst(couple) == c_node_succ_successor, _adj_list_graph[selected_leaf])
                dist_to_successor =  snd(_adj_list_graph[selected_leaf][idx_successor])
                dist = max(dist_to_successor, dist_to_parent)
                beta[i_from,i_to] = dist
            elseif parent(node_from) == node_to || parent(node_to) == node_from # le cas ou l'arc appartient déjà à m1t
                _idx = findfirst( couple -> fst(couple) == parent(node_to), _adj_list_graph[node_to])
                _dist =  snd(_adj_list_graph[node_to][_idx])
                beta[i_from,i_to] = _dist
            else # cas compliqué
                _parent_i_from = parent(node_from)
                _index_parent_i_from = findfirst(node -> node == _parent_i_from, m1t)                 
                _idx = findfirst( couple -> fst(couple) == _parent_i_from, _adj_list_graph[node_from])
                _dist =  snd(_adj_list_graph[node_from][_idx])
                beta[i_from,i_to] = max( beta[i_from,_index_parent_i_from], _dist) 
            end
        end 
    end 
    
    alpha = Array{Float64}(undef,dimension, dimension)
    
    for (i_from, node_from) in enumerate(m1t)
        for (i_to, node_to) in enumerate(m1t)
            _idx = findfirst( couple -> fst(couple) == node_to, _adj_list_graph[node_from])
            _dist = snd(_adj_list_graph[node_from][_idx])
            alpha[i_from,i_to] =  _dist - beta[i_from,i_to]
        end
    end 

    #création d'un nouveau dictionnaire, un nouveau GraphList
    new_adj_list = Dict{ MarkedNode{T}, Vector{ Couple{MarkedNode{T},Float64} } }()
    for _node in m1t 
		get!(new_adj_list, _node, Vector{Couple{MarkedNode{T},Float64}}(undef,0))   
    end 
    
    # On selectionne les arêtes ayant le alpha requis tel que celles-ci soit inférieurs à max_candidate
    # Etant donné que l'on a basé nos indices sur les positions dans m1t, la manipulation des données est assez pénible.
    for (i_from, node_from) in enumerate(m1t)
        alpha_tmp = alpha[i_from,:]
        _indices_min_alpha = sortperm(alpha_tmp)
        sorted_alpha_tmp = map(indice -> alpha_tmp[indice], _indices_min_alpha)
        filtered_sorted_alpha_tmp =  filter( alpha_i -> alpha_i <= max_alpha, sorted_alpha_tmp )
        if length(filtered_sorted_alpha_tmp) > max_candidates
            final_indices = _indices_min_alpha[1:Int(max_candidates)]
        else 
            final_indices = _indices_min_alpha[1:length(filtered_sorted_alpha_tmp)]
        end 
        selected_nodes = m1t[final_indices]
        for node in selected_nodes
            _idx = findfirst( couple -> fst(couple) == node, _adj_list_graph[node_from])
            push!(new_adj_list[node_from], _adj_list_graph[node_from][_idx]) 
        end 
    end 

	new_graph = GraphList("new graph", new_adj_list)
	return new_graph
end 