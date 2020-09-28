include("ordered_include.jl")

@testset "test complets" begin
    @testset "test edge" begin
    noeud1 = Node("James", [π, exp(1)], 1)
    noeud2 = Node("Kirk", [7.0,1.0], 2)
    noeud2 = Node("Spoke", [3.0,0.0], 3)
    arête = Edge(noeud1, noeud2, 2) 
    arête2 = Edge(noeud1, noeud2, 5)   
    @test weight(arête) == 2
    @test node1(arête) == noeud1
    @test node2(arête) == noeud2
    @test arête != arête2
    end

    @testset "test de la création d'un graph" begin
    _node1 = Node("Joe", 3.14,1)
    _node2 = Node("Steve", exp(1),2)
    _node3 = Node("Jill", 4.12,3)
    _edge1 = Edge(_node1, _node2, 4)
    _edge2 = Edge(_node2, _node3, 3)
    vector_node = [_node1, _node2, _node3]
    vector_edge = [_edge1, _edge2]

    graph = Graph("Ick", vector_node, vector_edge)
    @test graph == Graph("Ick", vector_node, vector_edge)
    
    @test nodes(graph) == vector_node
    _edge3 = Edge(_node1, _node3, 5)
    push!(vector_edge, _edge3)
    add_edge!(graph,_edge3)
    graph2 = Graph("Ick", vector_node, vector_edge)
    @test edges(graph) == edges(graph2)
    @test nodes(graph) == nodes(graph2)
    @test name(graph) == name(graph2)
    @test graph == graph2


    end


    @testset "test du main" begin
        
    graph_swiss42 = main("instances/stsp/swiss42.tsp")
    #show(graph_swiss42)
    end
end