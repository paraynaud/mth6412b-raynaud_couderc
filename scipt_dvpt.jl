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




graph = main("instances/stsp/bayg29.tsp")
arbre_couvrant = kruskal(graph)

