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

    graph = Graph("Ick", vector_node, vector_edge)
    @test graph == Graph("Ick", vector_node, vector_edge)
    
    @test nodes(graph) == vector_node
    _edge3 = Edge(_node1, _node3; weight=5)
    push!(vector_edge, _edge3)
    add_edge!(graph,_edge3)
    graph2 = Graph("Ick", vector_node, vector_edge)
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

        graph1 = Graph("Ick", vector_node, vector_edge)

        graph = merge(graph1, graph1)
        @test graph == graph1

        _node4 = Node("Joe2"; data=3.14, index=4)
        _node5 = Node("Steve2"; data=exp(1), index=5)
        _node6 = Node("Jill2"; data=4.12, index=6)
        _edge3 = Edge(_node4, _node5; weight=6)
        _edge4 = Edge(_node4, _node6; weight=7)
        vector_node2 = [_node4, _node5, _node6]
        vector_edge2 = [_edge3, _edge4]

        graph2 = Graph("Ick2", vector_node2, vector_edge2)


        merge_nodes = unique(vcat(vector_node,vector_node2))
        merge_edges = vcat(vector_edge,vector_edge2)
        graph12 = Graph(name(graph1), merge_nodes, merge_edges)
        
        merged_graph = merge(graph1, graph2)
        @test graph12 == merged_graph
    end 

    # @testset "test composantes connexes" begin
        _node1 = Node("Joe"; data=3.14, index=1)
        _node2 = Node("Steve"; data=exp(1), index=2)
        _node3 = Node("Jill"; data=4.12, index=3)
        _edge1 = Edge(_node1, _node2; weight=4)
        _edge2 = Edge(_node2, _node3; weight=3)

        vector_node = [_node1, _node2, _node3]
        vector_edge = [_edge1, _edge2]
        graph = Graph("connected_component", vector_node, vector_edge)


        cc1 = ConnectedComponent(_node1)
        cc2 = ConnectedComponent(_node2)
        cc3 = ConnectedComponent(_node3)

        #produit une erreur
        # try 
        #     merge!(cc1,cc2, _edge2) 
        # catch e
        #     @test e == ErrorException("les deux sommets de l'arête n'appartient pas à une composante connexe distincte")
        # end 

        merge!(cc1,cc2, _edge1)
        merge!(cc1,cc3, _edge2)
        @test cc1 == graph

        #kruskal(graph)
    # end


    # @testset "test du main" begin
        

        couvrant_bays29 = main("instances/stsp/bays29.tsp")
        show(couvrant_bays29)

        couvrant_swiss42 = main("instances/stsp/swiss42.tsp")
        show(couvrant_swiss42)


        couvrant_gr24 = main("instances/stsp/gr24.tsp")
        show(couvrant_gr24)
        
        
        couvrant_dantzig42 = main("instances/stsp/dantzig42.tsp")
        show(couvrant_dantzig42)
    # end

