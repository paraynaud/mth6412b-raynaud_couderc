code_path="projet/phase1/"

include(code_path*"ordered_include.jl")

    @testset "test edge" begin
			noeud1 = Node("James"; data=[π, exp(1)], index=1)
			noeud2 = Node("Kirk"; data=[7.0,1.0], index=2)
			noeud2 = Node("Spoke"; data=[3.0,0.0], index=3)
			arête = Edge(noeud1, noeud2; weight=2) 
			arête2 = Edge(noeud1, noeud2; weight=5)   
			@test weight(arête) == 2
			@test node1(arête) == noeud1
			@test node2(arête) == noeud2
			@test arête != arête2
			end

			@testset "test de la création d'un graph" begin
			_node1 = Node("Joe"; data=3.14, index=1)
			_node2 = Node("Steve"; data=exp(1), index=2)
			_node3 = Node("Jill"; data=4.12, index=3)
			_edge1 = Edge(_node1, _node2; weight=4)
			_edge2 = Edge(_node2, _node3; weight=3)
			vector_node = [_node1, _node2, _node3]
			vector_edge = [_edge1, _edge2]

			graph = GraphDic("Ick", vector_node, vector_edge)
			@test graph == GraphDic("Ick", vector_node, vector_edge)
			
			@test nodes(graph) == vector_node
			_edge3 = Edge(_node1, _node3; weight=5)
			push!(vector_edge, _edge3)
			add_edge!(graph,_edge3)
			graph2 = GraphDic("Ick", vector_node, vector_edge)
			@test edges(graph) == edges(graph2)
			@test nodes(graph) == nodes(graph2)
			@test name(graph) == name(graph2)
			@test graph == graph2

    end


    @testset "test merge" begin
			_node1 = Node("Joe"; data=3.14, index=1)
			_node2 = Node("Steve"; data=exp(1), index=2)
			_node3 = Node("Jill"; data=4.12, index=3)
			_edge1 = Edge(_node1, _node2; weight=4)
			_edge2 = Edge(_node2, _node3; weight=3)
			vector_node = [_node1, _node2, _node3]
			vector_edge = [_edge1, _edge2]

			graph1 = GraphDic("Ick", vector_node, vector_edge)

			graph = merge(graph1, graph1)
			@test graph == graph1

			_node4 = Node("Joe2"; data=3.14, index=4)
			_node5 = Node("Steve2"; data=exp(1), index=5)
			_node6 = Node("Jill2"; data=4.12, index=6)
			_edge3 = Edge(_node4, _node5; weight=6)
			_edge4 = Edge(_node4, _node6; weight=7)
			vector_node2 = [_node4, _node5, _node6]
			vector_edge2 = [_edge3, _edge4]

			graph2 = GraphDic("Ick2", vector_node2, vector_edge2)


			merge_nodes = unique(vcat(vector_node,vector_node2))
			merge_edges = vcat(vector_edge,vector_edge2)
			graph12 = GraphDic(name(graph1), merge_nodes, merge_edges)
			
			merged_graph = merge(graph1, graph2)
			@test graph12 == merged_graph
    end 

    @testset "test composantes connexes" begin
			_node1 = Node("Joe"; data=3.14, index=1)
			_node2 = Node("Steve"; data=exp(1), index=2)
			_node3 = Node("Jill"; data=4.12, index=3)
			_edge1 = Edge(_node1, _node2; weight=4)
			_edge2 = Edge(_node2, _node3; weight=3)

			vector_node = [_node1, _node2, _node3]
			vector_edge = [_edge1, _edge2]
			graph = GraphDic("connected_component", vector_node, vector_edge)


			cc1 = ConnectedComponent(_node1)
			cc2 = ConnectedComponent(_node2)
			cc3 = ConnectedComponent(_node3)

			merge!([cc1,cc2], _edge1)
			merge!([cc1,cc3], _edge2)
			@show typeof(cc1)
			# @test cc1 == graph

			@test root(cc1) == _node1
			@test name(cc1) == "connected_component"

			cc4 = ConnectedComponent2(0.0)
			cc5 = ConnectedComponent2(1.0)
			cc6 = ConnectedComponent2(2.0)
			
			@test cc4 != cc5

			union!(cc4,cc5) 
			union!(cc6,cc5) 
			@test union!(cc6,cc5) == cc4
			@test union!(cc6,cc5) == cc4

			@test size(cc4) == 1
			@test size(cc5) == 0
			@test size(cc6) == 0

			@test find!(cc5) == find!(cc5)
			@test find!(cc5) == cc4

    end


    @testset "test markednode" begin
			couple1 = Couple(3,2)
			couple2 = Couple(3,6)
			couple3 = Couple(4,7)
			couple4 = Couple(4,10)
			
			mn1 = MarkedNode(couple1)
			mn2 = MarkedNode(couple2, name="Ok.")
			mn3 = MarkedNode(couple3, name="Bien vu!")
			mn4 = MarkedNode(couple4, name="Wow!")

			set_visited!(mn1)
			set_visited!(mn4)
			set_distance!(mn2, 5.0)
			set_distance!(mn3, 6.0)
			set_parent!(mn2, mn1)
			set_parent!(mn4, mn3)

			array_mn = [mn1, mn2, mn3, mn4]
			@test visited.(array_mn) == [true,false,false,true]
			@test distance.(array_mn) == [Inf,5.0,6.0,Inf]
			@test parent.(array_mn) == [nothing,mn1,nothing,mn3]
			@test name.(array_mn) == ["","Ok.","Bien vu!","Wow!"]
			
    end


    @testset "test PriorityItem" begin
			couple1 = Couple(3,2)
			couple2 = Couple(3,6)

			@test fst(couple1) == 3
			@test fst(couple1) == fst(couple2)
			@test snd(couple1) == 2
			@test snd(couple2) == 6

			p1 = PriorityItem(1.0, couple1 )
			p2 = PriorityItem(2.0, couple2 )

			@test p1 != p2
			@test p1 == p1
			@test priority(p1) == 1.0
			@test data(p1) == couple1
			@test min(p1,p2) == p1
    end


    @testset " test sur les files de priorité" begin
			couple1 = Couple(3,2)
			couple2 = Couple(3,6)
			couple3 = Couple(4,7)
			couple4 = Couple(4,10)

			p1 = PriorityItem(1.0, couple1 )
			p2 = PriorityItem(2.0, couple2 )
			p3 = PriorityItem(8.0, couple3 )
			p4 = PriorityItem(5.0, couple4 )

			queue = Queue([p1,p2,p3])
			
			@test min_weight(queue) == p1
			@test length(queue) == 3

			push!(queue, p4)
			@show queue
			@test queue.items == [p1,p2,p3,p4]

    end 


	@testset "test des algos arbres couvrants" begin

			function total_weight(arbre_couvrant)
				sum = 0
				for i in arbre_couvrant
					sum = sum + distance(i)
				end 
				return sum
			end
			
			course_note = "instances/stsp/course_note.tsp"
			couvrant_course_kruskal = main_kruskal2(course_note)
			couvrant_course_prim = main_prim(course_note)		

			course_note_liste = create_graph_list_from_file(course_note)
			couvrant_course_prim2 = prim(course_note_liste)

			@test total_weigth_edges(couvrant_course_kruskal) == 37
			@test total_weight(couvrant_course_prim) == 37
			# @test total_weight2(list_adjacence_course, couvrant_course_prim) == 37

			bays29 = "instances/stsp/bays29.tsp"
			couvrant_bays29_kruskal = main_kruskal2(bays29)
			couvrant_bays29_prim = main_prim(bays29)
			@test total_weigth_edges(couvrant_bays29_kruskal) == 1557
			@test total_weight(couvrant_bays29_prim) == 1557
			

			bayg29 = "instances/stsp/bayg29.tsp"
			couvrant_bayg29_kruskal = main_kruskal2(bayg29)
			couvrant_bayg29_prim = main_prim(bayg29)
			@test total_weigth_edges(couvrant_bayg29_kruskal) == 1319
			@test total_weight(couvrant_bayg29_prim) == 1319

			swiss42 = "instances/stsp/swiss42.tsp"
			couvrant_swiss42_kruskal = main_kruskal2(swiss42)
			couvrant_swiss42_prim = main_prim(swiss42)
			couvrant_swiss42_prim_2 = main_prim(swiss42)
			# @test couvrant_swiss42_prim_2 == couvrant_swiss42_prim
			# @test sum((==).(couvrant_swiss42_prim_2, couvrant_swiss42_prim)) == 42
			# @show (==).(couvrant_swiss42_prim_2, couvrant_swiss42_prim)
			@test total_weigth_edges(couvrant_swiss42_kruskal) == 1079
			@test total_weight(couvrant_swiss42_prim) == 1079

			gr24 = "instances/stsp/gr24.tsp"
			couvrant_gr24_kruskal = main_kruskal2(gr24)
			couvrant_gr24_prim = main_prim(gr24)
			@test total_weigth_edges(couvrant_gr24_kruskal) == 1011
			@test total_weight(couvrant_gr24_prim) == 1011
							
			dantzig42 = "instances/stsp/dantzig42.tsp"
			couvrant_dantzig42_kruskal = main_kruskal2(dantzig42)
			couvrant_dantzig42_prim = main_prim(dantzig42)
			@test total_weigth_edges(couvrant_dantzig42_kruskal) == 591
			@test total_weight(couvrant_dantzig42_prim) == 591

			pa561 = "instances/stsp/pa561.tsp"
			couvrant_pa561_kruskal = main_kruskal2(pa561)
			couvrant_pa561_prim = main_prim(pa561)
			@test total_weigth_edges(couvrant_pa561_kruskal) == 2396
			@test total_weight(couvrant_pa561_prim) == 2396
        
    end



@testset "test rsl" begin
	function check_pas_de_doublon(vec :: Vector)
		b = true 
		n = length(vec)
		for i in 1:length(vec)-1
			for j in i+1:n
				b = b && (vec[i] != vec[j])
			end 
			if b == false 
				return b 
			end
		end 
		return b
	end 

	function total_weight(edges)
		sum = 0
		for i in 1:length(edges)
			sum = sum + edges[i].weight
		end 
		return sum
	end 
    
    
    
    # filename = "instances/stsp/course_note.tsp"
    # res_course_note = rsl(filename)

    # @test length(res_course_note) == 9
    # @test check_pas_de_doublon(res_course_note)


    filename = "instances/stsp/bays29.tsp"
	res_nodes1, res_edges1, res_nodes2, res_edges2 = rsl(filename)	
	weight1 = total_weight(res_edges1)
	weight2 = total_weight(res_edges2)
	@test 2020 <= weight1 <= 2*2020
	@test 2020 <= weight2 <= 2*2020

	filename = "instances/stsp/bayg29.tsp"
	res_nodes1, res_edges1, res_nodes2, res_edges2 = rsl(filename)	
	weight1 = total_weight(res_edges1)
	weight2 = total_weight(res_edges2)
	@test 1610 <= weight1 <= 2*1610
	@test 1610 <= weight2 <= 2*1610

	filename = "instances/stsp/pa561.tsp"
	res_nodes1, res_edges1, res_nodes2, res_edges2 = rsl(filename)	
	weight1 = total_weight(res_edges1)
	weight2 = total_weight(res_edges2)
	@test 2763 <= weight1 <= 2*2763
	@test 2763 <= weight2 <= 2*2763

    # @test length(res_bayg29) == 29
    # @test check_pas_de_doublon(res_bayg29)


    # filename = "instances/stsp/pa561.tsp"
    # res_pa561 = rsl(filename)
    # @test length(res_pa561) == 561
	# @test check_pas_de_doublon(res_pa561)
	
end



@testset " test ascent" begin 

	
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

	filename = "instances/stsp/course_note.tsp"

	lone_node,res = ascent(filename)
	@test check_weight_graph(res) <= 61


end 