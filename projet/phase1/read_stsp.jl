using Plots

"""Analyse un fichier .tsp et renvoie un dictionnaire avec les données de l'entête."""
function read_header(filename::String)

  file = open(filename, "r")
  header = Dict{String}{String}()
  sections = ["NAME", "TYPE", "COMMENT", "DIMENSION", "EDGE_WEIGHT_TYPE", "EDGE_WEIGHT_FORMAT",
  "EDGE_DATA_FORMAT", "NODE_COORD_TYPE", "DISPLAY_DATA_TYPE"]

  # Initialize header
  for section in sections
    header[section] = "None"
  end

  for line in eachline(file)
    line = strip(line)
    data = split(line, ":")
    if length(data) >= 2
      firstword = strip(data[1])
      if firstword in sections
        header[firstword] = strip(data[2])
      end
    end
  end
  close(file)
  return header
end

"""Analyse un fichier .tsp et renvoie un dictionnaire des noeuds sous la forme {id => [x,y]}.
Si les coordonnées ne sont pas données, un dictionnaire vide est renvoyé.
Le nombre de noeuds est dans header["DIMENSION"]."""
function read_nodes(header::Dict{String}{String}, filename::String)

  nodes = Dict{Int}{Vector{Float64}}()
  node_coord_type = header["NODE_COORD_TYPE"]
  display_data_type = header["DISPLAY_DATA_TYPE"]


  if !(node_coord_type in ["TWOD_COORDS", "THREED_COORDS"]) && !(display_data_type in ["COORDS_DISPLAY", "TWOD_DISPLAY"])
    return nodes
  end

  file = open(filename, "r")
  dim = parse(Int, header["DIMENSION"])
  k = 0
  display_data_section = false
  node_coord_section = false
  flag = false

  for line in eachline(file)
    if !flag
      line = strip(line)
      if line == "DISPLAY_DATA_SECTION"
        display_data_section = true
      elseif line == "NODE_COORD_SECTION"
        node_coord_section = true
      end

      if (display_data_section || node_coord_section) && !(line in ["DISPLAY_DATA_SECTION", "NODE_COORD_SECTION"])
        data = split(line)
        nodes[parse(Int, data[1])] = map(x -> parse(Float64, x), data[2:end])
        k = k + 1
      end

      if k >= dim
        flag = true
      end
    end
  end
  close(file)
  return nodes
end

"""Fonction auxiliaire de read_edges, qui détermine le nombre de noeud à lire
en fonction de la structure du graphe."""
function n_nodes_to_read(format::String, n::Int, dim::Int)
  if format == "FULL_MATRIX"
    return dim
  elseif format in ["LOWER_DIAG_ROW", "UPPER_DIAG_COL"]
    return n+1
  elseif format in ["LOWER_DIAG_COL", "UPPER_DIAG_ROW"]
    return dim-n
  elseif format in ["LOWER_ROW", "UPPER_COL"]
    return n
  elseif format in ["LOWER_COL", "UPPER_ROW"]
    return dim-n-1
  else
    error("Unknown format - function n_nodes_to_read")
  end
end

"""Analyse un fichier .tsp et renvoie l'ensemble des arêtes sous la forme d'un tableau."""
function read_edges(header::Dict{String}{String}, filename::String)
  edges = []
  edge_weight_format = header["EDGE_WEIGHT_FORMAT"]
  known_edge_weight_formats = ["FULL_MATRIX", "UPPER_ROW", "LOWER_ROW",
  "UPPER_DIAG_ROW", "LOWER_DIAG_ROW", "UPPER_COL", "LOWER_COL",
  "UPPER_DIAG_COL", "LOWER_DIAG_COL"]

  if !(edge_weight_format in known_edge_weight_formats)
    @warn "unknown edge weight format" edge_weight_format
    return edges
  end

  file = open(filename, "r")
  dim = parse(Int, header["DIMENSION"])
  edge_weight_section = false
  k = 0
  n_edges = 0
  i = 0
  n_to_read = n_nodes_to_read(edge_weight_format, k, dim)
  flag = false

  for line in eachline(file)
    line = strip(line)
    if !flag
      if occursin(r"^EDGE_WEIGHT_SECTION", line)
        edge_weight_section = true
        continue
      end

      if edge_weight_section
        data = split(line)
        n_data = length(data)
        start = 0
        while n_data > 0
          n_on_this_line = min(n_to_read, n_data)
          for j = start : start + n_on_this_line - 1
            n_edges = n_edges + 1
            if edge_weight_format in ["UPPER_ROW", "LOWER_COL"]
              edge = (k+1, i+k+2, data[j+1])
            elseif edge_weight_format in ["UPPER_DIAG_ROW", "LOWER_DIAG_COL"]
              edge = (k+1, i+k+1, data[j+1])              
            elseif edge_weight_format in ["UPPER_COL", "LOWER_ROW"]
              edge = (i+k+2, k+1, data[j+1])
            elseif edge_weight_format in ["UPPER_DIAG_COL", "LOWER_DIAG_ROW"]
              edge = (i+1, k+1, data[j+1])
            elseif edge_weight_format == "FULL_MATRIX"
              edge = (k+1, i+1, data[j+1])
            else
              warn("Unknown format - function read_edges")
            end
            push!(edges, edge)
            i += 1
          end

          n_to_read -= n_on_this_line
          n_data -= n_on_this_line

          if n_to_read <= 0
            start += n_on_this_line
            k += 1
            i = 0
            n_to_read = n_nodes_to_read(edge_weight_format, k, dim)
          end

          if k >= dim
            n_data = 0
            flag = true
          end
        end
      end
    end
  end
  close(file)
  return edges
end

"""Renvoie les noeuds et les arêtes du graphe."""
function read_stsp(filename::String)
  Base.print("Reading of header : ")
  header = read_header(filename)
  @show header
  println("✓")
  dim = parse(Int, header["DIMENSION"])
  edge_weight_format = header["EDGE_WEIGHT_FORMAT"]

  Base.print("Reading of nodes : ")
  graph_nodes = read_nodes(header, filename)
  @show graph_nodes
  println("✓")

  Base.print("Reading of edges : ")
  edges_brut = read_edges(header, filename)
  graph_edges = []
  for k = 1 : dim
    edge_list = Int[]
    push!(graph_edges, edge_list)
  end

  for edge in edges_brut
    if edge_weight_format in ["UPPER_ROW", "LOWER_COL", "UPPER_DIAG_ROW", "LOWER_DIAG_COL"]
      push!(graph_edges[edge[1]], edge[2])
    else
      push!(graph_edges[edge[2]], edge[1])
    end
  end

  for k = 1 : dim
    graph_edges[k] = sort(graph_edges[k])
  end
  println("✓")
  return graph_nodes, graph_edges
end

"""Affiche un graphe étant données un ensemble de noeuds et d'arêtes.

Exemple :

    graph_nodes, graph_edges = read_stsp("bayg29.tsp")
    plot_graph(graph_nodes, graph_edges)
    savefig("bayg29.pdf")
"""
function plot_graph(nodes, edges)
  fig = plot(legend=false)

  # edge positions
  for k = 1 : length(edges)
    for j in edges[k]
      plot!([nodes[k][1], nodes[j][1]], [nodes[k][2], nodes[j][2]],
          linewidth=1.5, alpha=0.75, color=:lightgray)
    end
  end

  # node positions
  xys = values(nodes)
  x = [xy[1] for xy in xys]
  y = [xy[2] for xy in xys]
  scatter!(x, y)

  fig
end

"""Fonction de commodité qui lit un fichier stsp et trace le graphe."""
function plot_graph(filename::String)
  graph_nodes, graph_edges = read_stsp(filename)
  plot_graph(graph_nodes, graph_edges)
end





function create_graph_dic_from_file(filename::String)
  Base.print("Reading of header : ")
  header = read_header(filename)
  #@show header
  println("✓")
  dim = parse(Int, header["DIMENSION"])
  edge_weight_format = header["EDGE_WEIGHT_FORMAT"]

  Base.print("Reading of nodes : ")
  graph_nodes = read_nodes(header, filename)
  println("✓")

  Base.print("Reading of edges : ")
  edges_brut = read_edges(header, filename)
  println("✓")


  Base.print("Transcripting of nodes : ")
  T = valtype(graph_nodes)
  nodes_vector = Vector{Node{T}}(undef,dim)

  if isempty(graph_nodes) #les données des noeuds ne sont pas spécifiées
    map!( i -> Node("$i", data=T(), index=i), nodes_vector, [1:dim;]) # création de dim sommets par défaut, pour remplacer l'absence de données 
  else #les données des noeuds sont spécifiées
    keys_graph_node = keys(graph_nodes)
    for key in keys_graph_node
      node = Node("$key"; data=graph_nodes[key], index=key) 
      nodes_vector[key] = node
    end 
  end 
  println("✓")


  Base.print("Transcripting of edges : ")
  edges_brut = read_edges(header, filename)
  edges_vector = Vector{Edge{T}}([])
  for data_edge ::Tuple{Int,Int,String} in edges_brut
    index1 = data_edge[1] :: Int
    index2 = data_edge[2] :: Int
    weight = parse(Float64,data_edge[3])
    if isempty(graph_nodes)
      node1 = Node("$index1"; data=T(), index=index1) :: Node{T}
      node2 = Node("$index2"; data=T(), index=index2) :: Node{T}
    else
      node1 = Node("$index1"; data=graph_nodes[index1], index=index1) :: Node{T}
      node2 = Node("$index2"; data=graph_nodes[index2], index=index2) :: Node{T}
    end
    edge = Edge(node1,node2; weight=weight)
    push!(edges_vector, edge)
  end 
  println("✓")

  name = header.vals[end]
  graph = GraphDic(name, nodes_vector, edges_vector)

  return graph
end 



""" Construit un graphe stocké sous forme de liste d'adjacence, de type GraphList défini dans graph.jl"""
function create_graph_list_from_file(filename::String)
  Base.print("Reading of header : ")
  header = read_header(filename)
  #@show header
  println("✓")
  dim = parse(Int, header["DIMENSION"])
  edge_weight_format = header["EDGE_WEIGHT_FORMAT"]

  Base.print("Reading of nodes : ")
  graph_nodes = read_nodes(header, filename)
  println("✓")

  Base.print("Reading of edges : ")
  edges_brut = read_edges(header, filename)
  println("✓")


  Base.print("Transcripting of nodes : ")
  T = valtype(graph_nodes)
  nodes_vector = Vector{MarkedNode{T}}(undef,dim)


  reset_index_marked_node()
  if isempty(graph_nodes) #les données des noeuds ne sont pas spécifiées
    map!( i -> MarkedNode(T()), nodes_vector, [1:dim;]) # création de dim sommets par défaut, pour remplacer l'absence de données 
  else #les données des noeuds sont spécifiées
    keys_graph_node = keys(graph_nodes)
    for key in keys_graph_node
      node = MarkedNode(graph_nodes[key]) 
      nodes_vector[key] = node
    end 
  end 
  println("✓")

  Base.print("Transcripting of edges : ")
  edges_brut = read_edges(header, filename)
  dic = Dict{ MarkedNode{T}, Vector{ Couple{MarkedNode{T},Float64} } }()

  for i in nodes_vector
    get!(dic, i, Vector{Couple{MarkedNode{T},Float64}}(undef,0))   
  end 


  for data_edge ::Tuple{Int,Int,String} in edges_brut
    weight = parse(Float64,data_edge[3])
    index1 = data_edge[1] :: Int
    index2 = data_edge[2] :: Int
    if isempty(graph_nodes)    
      node1 = MarkedNode(T(); _index=index1) :: MarkedNode{T}
      node2 = MarkedNode(T(); _index=index2) :: MarkedNode{T}  
      key1 = nodes_vector[findfirst(x -> x == node1, nodes_vector) ]
      key2 = nodes_vector[findfirst(x -> x == node2, nodes_vector) ]
    else
      node1 = MarkedNode(graph_nodes[index1];_index=index1) :: MarkedNode{T}
      node2 = MarkedNode(graph_nodes[index2];_index=index2) :: MarkedNode{T}
      key1 = nodes_vector[findfirst(x -> data(x) == data(node1), nodes_vector) ]
      key2 = nodes_vector[findfirst(x -> data(x) == data(node2), nodes_vector) ]
    end
    
    if (edge_weight_format == "LOWER_DIAG_ROW") || (edge_weight_format == "UPPER_ROW")
      push!(dic[key1], Couple(key2, weight)) 
      push!(dic[key2], Couple(key1, weight)) 
    elseif  (edge_weight_format == "FULL_MATRIX") 
      push!(dic[key1], Couple(key2, weight)) 
    else 
      error("TSP format not supported")
    end 

  end 

  println("✓")

  name = header.vals[end]
  graph = GraphList(name, dic)

  return graph
end 


"""Construit un graph à partir des instance de TSP symétrique dont les poids sont données au format EXPLICIT, 
puis applique l'algorithme de prim de manière à obtenir un arbre couvrant"""
function main_prim(filename::String)

  graph_list = create_graph_list_from_file(filename) #Créé un graphe de liste d'adjacence à partir de filename
  arbre_couvrant = prim(graph_list) #applique Prim à ce même graphe pour trouver un arbre couvrant
  
  return arbre_couvrant
end 


"""Construit un graph à partir des instance de TSP symétrique dont les poids sont données au format EXPLICIT"""
function main_kruskal(filename::String)

  graph_list = create_graph_list_from_file(filename) #Créé un graphe de liste d'adjacence à partir de filename
  arbre_couvrant = kruskal(graph_list)
  
  return arbre_couvrant
end 



"""Construit un graph à partir des instance de TSP symétrique dont les poids sont données au format EXPLICIT"""
function main_kruskal2(filename::String)

  graph = create_graph_dic_from_file(filename)
  arbre_couvrant = kruskal2(graph)
  
  return arbre_couvrant
end 
