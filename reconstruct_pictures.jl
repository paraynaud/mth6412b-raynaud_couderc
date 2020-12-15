using Dates 

code_path="projet/phase1/"

include(code_path * "ordered_include.jl")


# filename = "tsp/instances/nikos-cat.tsp"
# filename = "tsp/instances/alaska-railroad.tsp"
# filename = "tsp/instances/lower-kananaskis-lake.tsp"
# filename = "tsp/instances/abstract-light-painting.tsp"
# filename = "tsp/instances/blue-hour-paris.tsp"
# filename = "tsp/instances/marlet2-radio-board.tsp"
# filename = "tsp/instances/pizza-food-wallpaper.tsp"
# filename = "tsp/instances/the-enchanted-garden.tsp"
filename = "tsp/instances/tokyo-skytree-aerial.tsp"



# calculer la somme des poids des arêtes
function total_weight(edges) 
    sum = 0
    for i in 1:length(edges)
        sum = sum + edges[i].weight
    end 
    return sum
end 


# détermine l'indice du noeud 0 pour ensuite le placer en début de l'ordre
function find_rotation_node(_nodes) 
    idx = 0
    for (i,node) in enumerate(_nodes )
        if data(node) == 1 
            idx = i
            @show idx
        end 
    end
    return idx
end 


"""
    reconstruct_picture(filename)
reconstruit une image à partir du fichier tsp contenu dans filename.
"""
function reconstruct_picture_rsl(filename)
    #création du graphe et applicaiton de rsl
    graph= create_graph_list_from_file_app_tsp(filename)
    _nodes1, _edges1, _nodes2, _edges2 = rsl(graph)

    #On trouve l'élément 0 dans le tour puis on réarrange le tableau _nodes2 autour de cet indice pour trouver _nodes
    idx_0 = find_rotation_node(_nodes2)
    _nodes = circshift(_nodes2, -idx_0+1)
    
    #création des noms des fichiers temporaires
    name_file_without_tsp = split(filename, '.')[1]
    name_file = split(name_file_without_tsp, '/')[end]
    t = Dates.now()
    st = Dates.format(t, "d-u-H-M")
    tmp_file = "tmp/"*name_file*"-"*st*".tour"

    # on construit le tour à partir de _nodes
    # on calcul le coût par rapport aux arêtes
    # On écrit le tour dans un fichier temporaire
    _tour_order = map(node -> data(node), _nodes)
    _cost = Float32(total_weight(_edges2))
    write_tour(tmp_file, _tour_order, _cost)

    #création d'un fichier tempoaire, puis création de l'image issue de rsl
    tmp_output_file = "res/"*name_file*"-"*st*".png"  
    shuffled_image = "images/shuffled/"*name_file*".png"  
    bool_view = true
    reconstruct_picture(tmp_file, shuffled_image, tmp_output_file; view=bool_view)


end 


reconstruct_picture_rsl(filename)


# reconstruct_picture( "tsp/tours/nikos-cat.tour", "images/shuffled/nikos-cat.png", "tmp/exp-nikos-cat.png"; view = true) 