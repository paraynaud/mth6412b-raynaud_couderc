### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ a5273190-1d3a-11eb-2844-ed4ee6ea558c
using PlutoUI

# ╔═╡ b587d280-1d3d-11eb-1110-75dca0273711
md" # Phase n°4 du projet de MTH6412B"


# ╔═╡ 37f8c43e-1d3e-11eb-1598-b506e8057e39
md" ###### Rapport de Paul Raynaud et Romain Couderc"


# ╔═╡ 3f9a5972-1d3e-11eb-080e-d32826d26af3
md"Adresse du dépôt git:  https://github.com/paraynaud/mth6412b-raynaud_couderc" 


# ╔═╡ b7c17430-1d50-11eb-2600-9f61d093650b
md"Pour vérifier si le code tourne il faut lancer le fichier suivant: https://github.com/paraynaud/mth6412b-raynaud_couderc/blob/phase-4/test.jl"

# ╔═╡ 4cc467d0-1d3e-11eb-1db4-4d75cc0e18c7
md" ## 1) Implémentation de l'algorithme RSL" 


# ╔═╡ 6bdc753e-1d3e-11eb-12e3-9b0e66203008
md" ### a) Première version"

# ╔═╡ b3c98b40-1d3e-11eb-1697-8f598c44151d
md" Nous avons implémenté l'algorithme comme suit:

	- Premièrement, nous choisissons un noeud source dans le graphe g,
	- Ensuite, nous calculons l'arbre couvrant de g à partir de la source,
	- Puis nous faisons une visite en préordre des noeuds de l'arbre couvrant de 		taille minimale grâce à la fonction dfs_visit_iter()
	- Enfin, nous construisons les arêtes à partir de l'ordre des sommets grâce à la 	fonction edges_tsp()
"

# ╔═╡ 38451350-2e04-11eb-2990-2f0b7f5620fc
md" Voici les détails des fonctions utilisées, tout d'abord la fonction $dfs\_visit\_iter()$ qui détermine un parcours en préordre de l'arbre à partir d'une source donnée: 
"

# ╔═╡ 16dda230-2e05-11eb-1800-555ccecf4419
md" et la fonction $edges\_tsp()$ qui à partir d'une liste de noeud ordonnée et d'un graphe permet de relier les différents sommets dans l'ordre donné:"

# ╔═╡ 9937f050-1d3e-11eb-25a2-3bc34245e678
md" ### b) Amélioration de l'algorithme RSL"

# ╔═╡ 85056300-1d3f-11eb-0889-491b4390c38d
md" Nous nous sommes permis d'améliorer quelque peu les performances de l'algroithme RSL en implémentant une version gloutonne de l'heuristique 2-opt grâce à une fonction opt() que nous présentons ci dessous:"

# ╔═╡ 0aad9f10-1d4d-11eb-2046-7750731e1f30
md" ### c) Résultats expérimentaux"

# ╔═╡ 2f03fd50-1d4d-11eb-31e9-01cd0ccecd71
md" Nous avons mené des tests pour vérifier la cohérence de nos résultats, notamment nous avons testé si nous étions bien inférieure à deux fois la tournée optimale. Les weight1 correspondent à l'algorithme RSL sans l'heuristique et les Weight2 sont ceux avec. "

# ╔═╡ 86951ca0-2e07-11eb-1b4d-7903dd8a8502
md"
Tous les tests passent, ce qui signifient que nous respectons bien les bornes théoriques, de plus la version avec l'heuristique est bien meilleure au niveau de la précision de la borne, en effet: 

	 -Pour le test sur l'instance bays29, nous avons une erreur relative égale à 

		erreur_weight1 = (weight1 - optimum)/optimum *100 = 33 %
		erreur_weight2 = (weight2 - optimum)/optimum *100 = 4 %

	 -Pour le test sur l'instance bayg29, nous avons une erreur relative égale à 

		erreur_weight1 = (weight1 - optimum)/optimum *100 = 36 %
		erreur_weight2 = (weight2 - optimum)/optimum *100 = 22 %

	 -Pour le test sur l'instance pa561, nous avons une erreur relative égale à 

		erreur_weight1 = (weight1 - optimum)/optimum *100 = 44 %
		erreur_weight2 = (weight2 - optimum)/optimum *100 = 11 %

"

# ╔═╡ 02f6b520-2e0c-11eb-385a-797fc3226aab
md"En ce qui concerne les temps de calculs voici les résultats des benchmarks sur la plus grosse instance à notre disposition (pa561) pour chacun des algorithmes: 

	RSL sans heuristique: 
	  memory estimate:  284.73 KiB
	  allocs estimate:  5165
	  --------------
	  minimum time:     15.803 ms (0.00% GC)
	  median time:      17.691 ms (0.00% GC)
	  mean time:        18.026 ms (0.13% GC)
	  maximum time:     25.901 ms (0.00% GC)
	  --------------
	  samples:          278
	  evals/sample:     1

	RSL avec heuristique: 
	  memory estimate:  52.31 MiB
	  allocs estimate:  3409077
	  --------------
	  minimum time:     10.556 s (0.02% GC)
	  median time:      10.556 s (0.02% GC)
	  mean time:        10.556 s (0.02% GC)
	  maximum time:     10.556 s (0.02% GC)
	  --------------
	  samples:          1
	  evals/sample:     1

Comme nous pouvons nous y attendre le résultat avec heuristique est bien plus lent mais il augmente grandement la précision. 
"

# ╔═╡ f6112930-1d49-11eb-011e-d9b3764b8126
md" ## II) Implémentation de l'algorithme HK"

# ╔═╡ 91dd2390-2e12-11eb-2e98-8bf64219496d
md" Notre stratégie fut la suivante: 
	 -Premièrement obtenir une borne inférieure sur le coût d'une tournée minimale 		grâce à la technique développée par HK.
	 -Deuxièmement grâce à cette borne, générer un sous graphe permettant de mettre en 		oeuvre notre heuristique 2-opt. Cela permettra de trouver une tounrée minimal de précision meilleure et de ne pas mettre autant de temps que pour la version gloutonne utilisée précedemment. 

# ╔═╡ 0fd36a00-2e10-11eb-20d5-a3951ebdf7ae
md" Cette fonction est assez compliqué est fait appel à plusieurs fonctions, je vais les exposer ci dessous. La première étape est de calculer un minimum 1-tree à partir du graphe donné, c'est ce que l'on fait avec la fonction $minimum\_one\_tree()$: "

# ╔═╡ e8c04040-2e10-11eb-21a8-ef5086b2b9b5
md"Une fois que l'on a déterminé un minimum 1-tree, on génère un premier sous graphe sur lequel nous allons effectuer l'ascencion grâce à la fonction $generate\_candidates()$ : 
"

# ╔═╡ c9687540-2e11-11eb-192b-678c9376304b
md"Malheureusement par manque de temps nous n'avons pas pu mettre en place entièrement notre statégie, nous n'avons pu implémenter que la méthode de montée de sous gradient. Néanmoins celle ci fournit de premiers résultats numériques que nous avons mis dans test.jl."

# ╔═╡ ac4083f2-1d3a-11eb-0318-7f9dc8f198de
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

# ╔═╡ fcb54c8e-1d3e-11eb-1b2e-15134c23a96a
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_rsl.jl", 67, 75)

# ╔═╡ ca2a5190-2e04-11eb-1ef9-a70e8acc0ec1
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\graph.jl", 149, 166)

# ╔═╡ 81e932b0-2e05-11eb-024f-f9acfdddc548
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_rsl.jl", 6, 17)

# ╔═╡ dd05ebb0-1d3f-11eb-1ce3-715ffb83d079
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_rsl.jl", 19, 35)

# ╔═╡ f724a460-2e05-11eb-1fbb-eb14f55fcb54
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_rsl.jl", 35, 50)

# ╔═╡ 0e5bc9b2-2e06-11eb-39b0-b7cbc87a16f8
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_rsl.jl", 50, 60)

# ╔═╡ 65aaed00-1d4d-11eb-2a00-234b09f0954d
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\test.jl", 288, 307)

# ╔═╡ 2f0dac30-1d4b-11eb-13cc-2b2130e764c5
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_lkh.jl", 78, 94)

# ╔═╡ 74c66bc0-2e0f-11eb-33c1-afd71c21fae0
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_lkh.jl", 94, 108)

# ╔═╡ b09712d0-2e0f-11eb-1931-8b0d86a95060
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_lkh.jl", 109, 125)

# ╔═╡ c93a7250-2e0f-11eb-3b9e-0df5748761ac
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_lkh.jl", 126, 145)

# ╔═╡ 94ed0d90-2e10-11eb-1385-2b560d91ef44
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\couvrant_min.jl", 184, 200)

# ╔═╡ cc138d80-2e10-11eb-187d-d9b0d1a6a76f
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\couvrant_min.jl", 201, 220)

# ╔═╡ da772d50-2e10-11eb-3578-b33ff0a4575b
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\couvrant_min.jl", 220, 230)

# ╔═╡ 32582010-2e11-11eb-10ec-9b0433edac20
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_lkh.jl", 178, 195)

# ╔═╡ 708f8df0-2e11-11eb-0f70-c335b42db718
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_lkh.jl", 196, 210)

# ╔═╡ 7820cf70-2e11-11eb-32eb-9fd26419a4e4
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_lkh.jl", 211, 230)

# ╔═╡ 7fdec640-2e11-11eb-0199-d3570a66b4d3
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_lkh.jl", 231, 245)

# ╔═╡ 8bab6780-2e11-11eb-3600-f56ce8b67bc2
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\tsp_lkh.jl", 246, 258)

# ╔═╡ Cell order:
# ╟─b587d280-1d3d-11eb-1110-75dca0273711
# ╟─37f8c43e-1d3e-11eb-1598-b506e8057e39
# ╟─3f9a5972-1d3e-11eb-080e-d32826d26af3
# ╠═b7c17430-1d50-11eb-2600-9f61d093650b
# ╟─4cc467d0-1d3e-11eb-1db4-4d75cc0e18c7
# ╟─6bdc753e-1d3e-11eb-12e3-9b0e66203008
# ╟─b3c98b40-1d3e-11eb-1697-8f598c44151d
# ╠═fcb54c8e-1d3e-11eb-1b2e-15134c23a96a
# ╟─38451350-2e04-11eb-2990-2f0b7f5620fc
# ╟─ca2a5190-2e04-11eb-1ef9-a70e8acc0ec1
# ╟─16dda230-2e05-11eb-1800-555ccecf4419
# ╟─81e932b0-2e05-11eb-024f-f9acfdddc548
# ╟─a5273190-1d3a-11eb-2844-ed4ee6ea558c
# ╟─9937f050-1d3e-11eb-25a2-3bc34245e678
# ╠═85056300-1d3f-11eb-0889-491b4390c38d
# ╟─dd05ebb0-1d3f-11eb-1ce3-715ffb83d079
# ╟─f724a460-2e05-11eb-1fbb-eb14f55fcb54
# ╟─0e5bc9b2-2e06-11eb-39b0-b7cbc87a16f8
# ╟─0aad9f10-1d4d-11eb-2046-7750731e1f30
# ╟─2f03fd50-1d4d-11eb-31e9-01cd0ccecd71
# ╟─65aaed00-1d4d-11eb-2a00-234b09f0954d
# ╟─86951ca0-2e07-11eb-1b4d-7903dd8a8502
# ╟─02f6b520-2e0c-11eb-385a-797fc3226aab
# ╟─f6112930-1d49-11eb-011e-d9b3764b8126
# ╠═91dd2390-2e12-11eb-2e98-8bf64219496d
# ╟─2f0dac30-1d4b-11eb-13cc-2b2130e764c5
# ╟─74c66bc0-2e0f-11eb-33c1-afd71c21fae0
# ╟─b09712d0-2e0f-11eb-1931-8b0d86a95060
# ╠═c93a7250-2e0f-11eb-3b9e-0df5748761ac
# ╟─0fd36a00-2e10-11eb-20d5-a3951ebdf7ae
# ╟─94ed0d90-2e10-11eb-1385-2b560d91ef44
# ╟─cc138d80-2e10-11eb-187d-d9b0d1a6a76f
# ╟─da772d50-2e10-11eb-3578-b33ff0a4575b
# ╟─e8c04040-2e10-11eb-21a8-ef5086b2b9b5
# ╟─32582010-2e11-11eb-10ec-9b0433edac20
# ╟─708f8df0-2e11-11eb-0f70-c335b42db718
# ╟─7820cf70-2e11-11eb-32eb-9fd26419a4e4
# ╟─7fdec640-2e11-11eb-0199-d3570a66b4d3
# ╟─8bab6780-2e11-11eb-3600-f56ce8b67bc2
# ╠═c9687540-2e11-11eb-192b-678c9376304b
# ╟─ac4083f2-1d3a-11eb-0318-7f9dc8f198de
