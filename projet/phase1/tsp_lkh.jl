function main()
	graph = read_problemData()
	create_candidate_set(graph)
	BestCost = DBL_MAX
	runs = 10
	for Run in 1:runs 
		Cost :: Float64 = find_tour();
		if (cost < best_cost) 
			record_best_tour()
			best_bost = cost
		end 
	end		
	print_best_tour()
end 


function create_candidate_set(graph) 
	lower_bound = ascent(graph)
	dimension = length(nodes(graph))
	excess = 1/dimension
	max_alpha :: BigFloat = excess * abs(lower_bound)
	max_candidates = 5
	generate_candidates(max_candidates, max_alpha)
end 

function norm(nodes)
	sum = 0 
	for node in nodes
		sum += v(node)^2
	end 
	return sum
end

function tree_cost(_nodes)
	sum = 0
	for node in _nodes
		sum += distance(node) - 2*pi(node)
	end
	return sum
end

function ascent(graph :: GraphList{T}) where T
	dimension = length(nodes(graph))
	_nodes = nodes(graph)
	# MarkedNode node	

	initial_period = max(100, dimension)	
	period = initial_period
	initial_phase :: Bool = true
	m1t =  minimum_1_tree(graph)
	w = tree_cost(nodes(m1t))
	@show w
	(norm(_nodes) == 0) && return m1t
	long_max = 5
	ascent_candidates = 50
	# generate_candidates(ascent_candidates, long_max)
	best_w = w

	for node in _nodes
		set_best_pi!(node, pi(node))
		set_last_v!(node, v(node))
	end 
	
	initial_step_size = 1 
	t = initial_step_size
	while t>0 && norm(nodes(m1t))/dimension > 0.01
		p ::Int = 1 
		while t > 0 && p <= period
			for node in _nodes 
				(v(node) != 0) && set_pi!(node, t/10 * (7*v(node) + 3*last_v(node)) )
				set_last_v!(node, v(node))
			end 
			m1t = minimum_1_tree(graph)
			w = tree_cost(nodes(m1t))
			(norm(_nodes) == 0) && return m1t
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
		end 
		period /= 2
		t /= 2
	end 
	for node in _nodes 
		set_pi!(node, best_pi(node))		
	end 
	return m1t
end 




# function generate_candidates(max_candidates :: Float64, max_alpha:: Float64) 
# 	Node *From, *To;
# 	alpha :: Float64 = 0 ;
# 	Candidate *Edge;
	
# 	ForAllNodes(From)
# 	From->Mark = 0;
# 	ForAllNodes(From) {
# 	if (From != FirstNode) {
# 	From->Beta = LONG_MIN;
# 	for (To = From; To->Dad != 0; To = To->Dad) {
# 	To->Dad->Beta = max(To->Beta, To->Cost);
# 	To->Dad->Mark = From;
# 	}
# 	}
# 	ForAllNodes(To, To != From) {
# 	if (From == FirstNode)
# 	Alpha = To == From->Father ? 0 :
# 	C(From,To) - From->NextCost;
# 	else if (To == FirstNode)
# 	Alpha = From == To->Father ? 0:
# 	C(From,To) - To->NextCost;
# 	else {
# 	if (To->Mark != From)
# 	To->Beta = max(To->Dad->Beta, To->Cost);
# 	Alpha = C(From,To) - To->Beta;
# 	}
# 	if (Alpha <= MaxAlpha)
# 	InsertCandidate(To, From->CandidateSet);
# 	}
# 	}
# 	if (SymmetricCandidates)
# 	ForAllNodes(From)
# 	ForAllCandidates(To, From->CandidateSet)
# 	if (!IsMember(From, To->CandidateSet))
# 	InsertCandidate(From, To->CandidateSet);
# 	}
# end 