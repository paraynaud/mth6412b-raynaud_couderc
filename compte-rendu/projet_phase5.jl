### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 19fcfaf0-3e69-11eb-2963-e90608f1b3e2
### A Pluto.jl notebook ###
# v0.11.14

using Markdown

# ╔═╡ 20df85e0-3e69-11eb-2d6c-45f66b81a6ce
using InteractiveUtils

# ╔═╡ 20e30850-3e69-11eb-1e63-dd5ae6fb71f3
using PlutoUI

# ╔═╡ 9e667dd0-3e68-11eb-1d4d-5fd0934ae1b4
md" # Projet Phase n°5"



# ╔═╡ c2d54610-3e68-11eb-304e-751b9c9fab0d
md" Dans cette phase nous avons pu mettre en application nos algorithmes de tournées optimales. "

# ╔═╡ c97875b0-3e76-11eb-21fd-63db3e9ee8cb


# ╔═╡ 75151950-3e68-11eb-2927-c798ff65f7c3
md" ## Application à partir d'une tournée:"

# ╔═╡ 9c0e5cfe-3e68-11eb-3dfa-11bc6a04ee0f
function display(filename, line1, line2)
  with_terminal() do
    open(filename, "r") do file
      lines = readlines(file)
      for i in line1:line2
        println(stdout, lines[i])
      end
    end
  end
end

# ╔═╡ 58ed8d60-3e6e-11eb-1729-dbf6a7f59560
md" Le coeur de l'application se trouve dans le fichier reconstruct_pictures.jl.
On définit en premier les différentes instances fournies."

# ╔═╡ 9c3238b0-3e68-11eb-009b-81d69002f000
display("C:\\Users\\raynaudp\\Documents\\Poly\\cours\\MTH6412B\\code\\git_tmp\\mth6412b-raynaud_couderc\\reconstruct_pictures.jl", 1, 20)


# ╔═╡ 837dda80-3e6e-11eb-1d77-3dac62403ec8
md" On définit ensuite des fonctions auxiliaires. total\_weight permet de déterminer le coût d'une tournée à partir de ces arêtes, et fin\_rotation trouve la position du noeud 0, nécessaire pour créer le fichier .tour dans le bon ordre"

# ╔═╡ 9c4e4c30-3e68-11eb-33c8-a5994864cad6
display("C:\\Users\\raynaudp\\Documents\\Poly\\cours\\MTH6412B\\code\\git_tmp\\mth6412b-raynaud_couderc\\reconstruct_pictures.jl", 21, 40)

# ╔═╡ e1e332a0-3e6e-11eb-30b5-9df0a2f22fd5
md" La fonction reconstruct\_pictures créer le graphe sous forme de liste d'adjacencesur lequel on applique rsl. On détermine ensuite la position du noeud 0, puis on réalise une rotation sur le tableau afin de placer le noeud 0 en première position. On définit ensuite des fichiers temporaires." 

# ╔═╡ 420f5d80-3e6e-11eb-2a88-bfa71c0075c1
display("C:\\Users\\raynaudp\\Documents\\Poly\\cours\\MTH6412B\\code\\git_tmp\\mth6412b-raynaud_couderc\\reconstruct_pictures.jl", 41, 60)

# ╔═╡ 3d4005b0-3e6f-11eb-3391-0d17b8048f36
md" On forme explicitement le tour sous forme de liste d'entier, on calcule son coût puis on l'écrit à l'aide de la fonction write_tour. Ensuite il ne reste plus qu'à construire l'image obtenue à partir de la fonction reconstruct_picture."

# ╔═╡ 483b1b90-3e6e-11eb-1ce7-8539fa27b6a0
display("C:\\Users\\raynaudp\\Documents\\Poly\\cours\\MTH6412B\\code\\git_tmp\\mth6412b-raynaud_couderc\\reconstruct_pictures.jl", 61, 80)

# ╔═╡ d6962c30-3e6f-11eb-2210-afea6c1530c5
md" On a légèrement modifié le fichier tools.jl fournit de manière à obtenir un tour basé sur des entiers entre 1 et 601:"

# ╔═╡ d1e12fa0-3e6f-11eb-32c3-cbbaf2c44cba
display("C:\\Users\\raynaudp\\Documents\\Poly\\cours\\MTH6412B\\code\\git_tmp\\mth6412b-raynaud_couderc\\projet\\phase1\\tools.jl", 42, 42)

# ╔═╡ 241705fe-3e70-11eb-2d13-639b4fc13b1e
md"en supprimant le +1" 

# ╔═╡ 5fb419f0-3e70-11eb-0895-4397cd8664d9
md" Au cours de la phase 5 nous nous sommes rendu compte que la fonction read-stsp que nous avions developper jusqu'à ne fonctionner pas directement. Par conséquent on a codé une version simplifié dédié au problèmes spécifique de cette phase create\_graph\_list\_from\_file\_app_tsp()"

# ╔═╡ e0de81f0-3e70-11eb-0a35-85d7862dfdfe
md" ## Résultats"

# ╔═╡ e0bb4280-3e70-11eb-0e81-0b044f5971cb
md" Nous n'avons pas réussi à intégrer les images directement au notebook, elles seront dans une fichier séparé."


# ╔═╡ 26d13ca2-3e73-11eb-0ba4-67defdff1145
md" On remarque que RSL accompagné de 2-opt produit des \"bons résultats\" dans le sens où l'on est formelement capable (en tant qu'humain) de reconnaître la même photo. De plus lorsque la solution du TSP est proche de la solution optimale les colonnes se groupent par bandes. Ces bandes apparaissent générallement dans la photo original, mais il arrive que ces bandes soient permutés, voir la pizza ou le chat. "

# ╔═╡ 61c6fef0-3e71-11eb-1a4a-f97c38636794
md" On peut voir ces bandes comme des parties sous-parties de la tournée optimale mais placé au mauvais endroit de la tournée (qui entraîne la non-optimalité)."

# ╔═╡ 61adf8b0-3e71-11eb-1121-f9644d585aad
md" Pour certaines images le résultat est identique à l'image initial comme par exemple pour blue-hour-Paris, tandis que pour d'autres des pans de l'image sont permutés (pizza) ou inversé (lac)."

# ╔═╡ e0982a20-3e70-11eb-09c6-27c29d5a265f


# ╔═╡ Cell order:
# ╠═19fcfaf0-3e69-11eb-2963-e90608f1b3e2
# ╠═20df85e0-3e69-11eb-2d6c-45f66b81a6ce
# ╠═20e30850-3e69-11eb-1e63-dd5ae6fb71f3
# ╟─9e667dd0-3e68-11eb-1d4d-5fd0934ae1b4
# ╟─c2d54610-3e68-11eb-304e-751b9c9fab0d
# ╠═c97875b0-3e76-11eb-21fd-63db3e9ee8cb
# ╟─75151950-3e68-11eb-2927-c798ff65f7c3
# ╠═9c0e5cfe-3e68-11eb-3dfa-11bc6a04ee0f
# ╟─58ed8d60-3e6e-11eb-1729-dbf6a7f59560
# ╠═9c3238b0-3e68-11eb-009b-81d69002f000
# ╟─837dda80-3e6e-11eb-1d77-3dac62403ec8
# ╟─9c4e4c30-3e68-11eb-33c8-a5994864cad6
# ╟─e1e332a0-3e6e-11eb-30b5-9df0a2f22fd5
# ╟─420f5d80-3e6e-11eb-2a88-bfa71c0075c1
# ╟─3d4005b0-3e6f-11eb-3391-0d17b8048f36
# ╟─483b1b90-3e6e-11eb-1ce7-8539fa27b6a0
# ╟─d6962c30-3e6f-11eb-2210-afea6c1530c5
# ╠═d1e12fa0-3e6f-11eb-32c3-cbbaf2c44cba
# ╟─241705fe-3e70-11eb-2d13-639b4fc13b1e
# ╟─5fb419f0-3e70-11eb-0895-4397cd8664d9
# ╟─e0de81f0-3e70-11eb-0a35-85d7862dfdfe
# ╟─e0bb4280-3e70-11eb-0e81-0b044f5971cb
# ╟─26d13ca2-3e73-11eb-0ba4-67defdff1145
# ╟─61c6fef0-3e71-11eb-1a4a-f97c38636794
# ╠═61adf8b0-3e71-11eb-1121-f9644d585aad
# ╠═e0982a20-3e70-11eb-09c6-27c29d5a265f
