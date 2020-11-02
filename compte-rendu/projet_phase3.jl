### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ a5273190-1d3a-11eb-2844-ed4ee6ea558c
using PlutoUI

# ╔═╡ b587d280-1d3d-11eb-1110-75dca0273711
md" # Phase n°3 du projet de MTH6412B"


# ╔═╡ 37f8c43e-1d3e-11eb-1598-b506e8057e39
md" ###### Rapport de Paul Raynaud et Romain Couderc"


# ╔═╡ 3f9a5972-1d3e-11eb-080e-d32826d26af3
md"Adresse du dépôt git:  https://github.com/paraynaud/mth6412b-raynaud_couderc" 


# ╔═╡ b7c17430-1d50-11eb-2600-9f61d093650b


# ╔═╡ 4cc467d0-1d3e-11eb-1db4-4d75cc0e18c7
md" ## 1) Implémentation des heuristiques d'accélaration" 


# ╔═╡ 6bdc753e-1d3e-11eb-12e3-9b0e66203008
md" ### a) La fonction union!"

# ╔═╡ b3c98b40-1d3e-11eb-1697-8f598c44151d
md" La première heuristique d'accélaration que nous avons implémenté est celle de l'union via le rang. Nous l'avons implémenté comme suit en suivant exactement le principe énoncé dans les instructions:"

# ╔═╡ 9937f050-1d3e-11eb-25a2-3bc34245e678
md" ### b) La fonction find!"

# ╔═╡ 85056300-1d3f-11eb-0889-491b4390c38d
md" La fonction find! dont l'implémentation est donné ci dessous nous permet de faire la compression de chemin énoncé dans les instructions. Le parent direct de chacun des noeuds sur le chemin de recherche devient la racine. "

# ╔═╡ 0aad9f10-1d4d-11eb-2046-7750731e1f30
md" ### c) La nouvelle version de Kruskal"

# ╔═╡ 2f03fd50-1d4d-11eb-31e9-01cd0ccecd71
md" Avec les deux heuristiques précédentes, nous avons pu coder la nouvelle version de Kruskal qui est la suivante: "

# ╔═╡ 3c991570-1d40-11eb-31a7-7b2d786b07df
md" ### d) Test sur les deux heuristiques précédentes"

# ╔═╡ 4b8b60b0-1d40-11eb-1100-b33197899ae6
md" Afin de nous assurer que les deux précédentes heuristiques fonctionnaient comme nous le voulions, nous avons complété nos test sur les composantes connexes (les tests sur la nouvelle fonction kruskal sont présentés à la dernière section). Voici les différents tests effectués: " 

# ╔═╡ c3c56c60-1d40-11eb-09f4-fb0f982c18ec
md" Ces deux heuristiques donnent une améliorations remarquable tant au niveau du temps de calcul que de la mémoire utilisée pour le calcul des arbres couvrant de coût minimum. Voici les résultats des benchmarks que nous avons effectué sur la plus grosse instance de test nommée pa561.tsp. Nous avons testé notre version de Kruskal précédente et la nouvelle version comprenant les heuristiques, voici les résultats:
" 

# ╔═╡ 839a59ee-1d42-11eb-3fac-57b0f7dbb033
md"	Ancienne version: 
		  memory estimate:  1.18 GiB
		  allocs estimate:  78204077
		  --------------
		  minimum time:     49.913 s (0.25% GC)
		  median time:      49.913 s (0.25% GC)
		  mean time:        49.913 s (0.25% GC)
		  maximum time:     49.913 s (0.25% GC)
		  --------------
		  samples:          1
		  evals/sample:     1

	Nouvelle version:
		  memory estimate:  7.25 MiB
		  allocs estimate:  29268
		  --------------
		  minimum time:     108.596 ms (0.00% GC)
		  median time:      134.323 ms (0.00% GC)
		  mean time:        141.898 ms (0.96% GC)
		  maximum time:     253.245 ms (0.00% GC)
		  --------------
		  samples:          36
		  evals/sample:     1
"

# ╔═╡ 789b4c70-1d43-11eb-07df-cb186b0d8094
md" ### e) Réponse à la question sur le rang"

# ╔═╡ 69bc93c0-1d44-11eb-324e-83affbe587e2
md"Premièrement, notons que le rang d'un sommet est toujours inférieure à celui de sa racine. Le fait que le rang d'un noeud soit toujours inférieur à |S|-1 est assez trivial, en effet il s'agit du pire cas où l'union consiste simplement à empiler les noeuds les uns après les autres derrière la racine. On obtient donc une liste chainée de noeud dont le rang va de 0 à |S|-1. Dans le cas de notre implémentation de l'union, cette borne supérieure n'est pas atteinte, nous allons voir en effet dans le paragraphe suivant qu'avec notre implémentation le rang de la racine sera au plus de $Ent(log_2(|S|))$ où $Ent()$ correspond à la partie entière inférieure."

# ╔═╡ 61d1cb20-1d45-11eb-0308-7908fac4210a
md" Comme énoncer précédemment, nous allons montrer que l'implémentation de l'union tel que présenté en a) donne un rang pour les racines (et donc pour les sommets) d'au plus $Ent(log_2(|S|))$. Pour le montrer nous allons procéder par récurrence sur le nombre de sommet (en supposant qu'il y en a une puissance de 2 pour simplifier): 

	- Pour |S| = 1, la proposition est vérifié car $rang(racine) = 0 = log_2(|S|)$. 

	- Supposons que la proposition est vérifié pour $|S| = 2^k$, montrons que la 		proposition est vrai pour $|S| = 2^{k+1}$. Nous avons donc deux ensembles $S_1$
	et $S_2$ de taille $2^k$ à unir. Par hypothèse de de récurrence, ces ensembles 		ayant été déterminés par notre implémentation de l'union, le rang de leur 			racine est  au 	plus $log_2(2^k) = k$. Il y alors deux cas: 

		-soit les rangs des racine sont distincts et dans ce cas, les rangs des deux        	racines sont inchangés et donc le rang de notre union de sommets est 					inférieure à k etdonc à $k+1 = log_2(2^{k+1})$. L'hypothèse de récurrence 			est vérifiée. 

	    - soit les rangs des racines sont égaux, l'une des racines augmente son rang 		   de 1, donc le rang de cette racine est au plus de $k+1 = log_2(2^{k+1})$. 		   L'hypothèse de récurrence est là encore vérifiée. 

Le rang des racines est donc inférieure à $Ent(log_2(|S|))$, or ce sont les rangs des racines qui sont les plus élevés dans les ensembles des sommets. On peut donc conclure que le rang d'un sommet sera toujours inférieur à $Ent(log_2(|S|))$.

	

"

# ╔═╡ f6112930-1d49-11eb-011e-d9b3764b8126
md" ## II) Implémentation de l'algorithme Prim"

# ╔═╡ 210bd0e0-1d4a-11eb-1847-2f058fe7ca64
md" ### Implémentation de nouveaux types: MarkedNode, Queue et PriorityItem"

# ╔═╡ 7678dd6e-1d4a-11eb-1b1c-d70b11ffb4dc
md" Afin d'implémenter l'algorithme Prim, nous avons eu besoin de nouveaux types: 

	- Premièrement, les noeuds classiques ne correspondaient plus au besoin de l'implémentation, nous avons donc créé des MarkedNode qui dérive de AbstractNode et qui possède en plus un champ visited et un champ distance. 

	- Deuxièmement, il nous fallait également deux nouveaux types permettant de coder une file de priorité, c'est ce que nous avons fait en créant les types Queue et PriorityItem. Ces deux types sont principalement basé sur les types développés exposés dans le cours. "

# ╔═╡ ff35bf6e-1d4a-11eb-117c-f7ecce96edd1
md" Ces types étant nouveaux, il était nécessaire de les tester, nous avons donc effectuer les tests suivants afin de vérifier leur bon fonctionnement:"

# ╔═╡ 56084f70-1d4b-11eb-0263-8171c55124b4
md" Un fois les vérifications effectuées, nous avons alors implémenté l'algorithme de Prim comme indiquer dans l'énoncé, voici notre implémentation: "

# ╔═╡ ce2f4850-1d4b-11eb-2e3d-631a8bd80dfe
md" ## III) Test sur les instances de TSP"

# ╔═╡ 000faf40-1d4c-11eb-0f5e-91335dbab28f
md" Afin de vérifier que nos algorithmes (la nouvelle version de kruskal et Prim) fonctionnaient correctement, nous avons fini par faire des tests sur l'exemple du cours et sur les instances de TSP symmétriques. Voici les différents tests effectués: "

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
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\connected_component.jl", 121, 137)

# ╔═╡ dd05ebb0-1d3f-11eb-1ce3-715ffb83d079
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\connected_component.jl", 142, 149)

# ╔═╡ 65aaed00-1d4d-11eb-2a00-234b09f0954d
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\graph.jl", 170, 206)

# ╔═╡ 936738a0-1d40-11eb-1c2c-59e275f67331
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\test.jl", 75, 116)

# ╔═╡ 2f0dac30-1d4b-11eb-13cc-2b2130e764c5
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\test.jl", 119, 186)

# ╔═╡ 77d7dbc0-1d4b-11eb-2be5-1bcf60fbac9d
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\projet\\phase1\\graph.jl", 243, 272)

# ╔═╡ 3017fad2-1d4c-11eb-3328-ed91107abce8
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\test.jl", 189, 235)

# ╔═╡ 50c06c40-1d4c-11eb-0fe0-8f31777a7056
md"Bien sur, nous n'avons pu résister à l'envie de comparer les performances de l'algorithme de Kruskal et l'algorithme de Prim. Nous avons donc effectué les benchmarks suivants (toujours sur l'instance pa561.tsp): "

# ╔═╡ 7b29824e-1d4c-11eb-3733-a30188b878cd
display("C:\\Users\\coudercr\\Desktop\\Cours_poly_montreal\\MTH6412B\\projet_phase_2\\mth6412b-raynaud_couderc\\scipt_dvpt.jl", 24, 36)

# ╔═╡ a033aac0-1d4d-11eb-163a-bfe0f30a8c61
md"Cela nous fournit les résultats suivants (pour l'algorithme de Prim, les résultats pour l'algorithme de Kruskal amélioré a été présenté au dessus): 

	-Prim :
	  memory estimate:  54.97 KiB
	  allocs estimate:  584
	  --------------
	  minimum time:     8.230 ms (0.00% GC)
	  median time:      11.823 ms (0.00% GC)
	  mean time:        12.309 ms (0.00% GC)
	  maximum time:     25.128 ms (0.00% GC)
	  --------------
	  samples:          406
	  evals/sample:     1

"

# ╔═╡ 4a8707ae-1d4e-11eb-0c4d-2b11c6300d23
md"Les résultats sont encore meilleurs qu'avec l'algorithme de Kruskal amélioré, cela est logique car il semblerait que la compléxité de l'algorithme de Prim est $O(V^2)$ alors que celui de Kruskal amélioré est en $O(E log(E)$. Or ici le graphe que nous traitons est assez dense et donc $E$ est à peu près égale à $V^2$. Le résultat sur le nombre de mémoire alloué est également assez impressionnant. Il faut noter cependant que nous n'utilisons pas la même structure de donnée pour le graphe pour les deux algorithmes. En effet, nous avions dans un premier temps fait une structure basé sur un dictionnaire d'arête (celui utilisé par kruskal) alors que pour Prim nous avons utilisé une autre structure de graphe qui est liste d'adjacence. La différence de performance entre les deux algorithmes pourrait également provenir de cela."

# ╔═╡ Cell order:
# ╟─b587d280-1d3d-11eb-1110-75dca0273711
# ╟─37f8c43e-1d3e-11eb-1598-b506e8057e39
# ╟─3f9a5972-1d3e-11eb-080e-d32826d26af3
# ╠═b7c17430-1d50-11eb-2600-9f61d093650b
# ╟─4cc467d0-1d3e-11eb-1db4-4d75cc0e18c7
# ╟─6bdc753e-1d3e-11eb-12e3-9b0e66203008
# ╟─b3c98b40-1d3e-11eb-1697-8f598c44151d
# ╟─fcb54c8e-1d3e-11eb-1b2e-15134c23a96a
# ╟─a5273190-1d3a-11eb-2844-ed4ee6ea558c
# ╟─9937f050-1d3e-11eb-25a2-3bc34245e678
# ╟─85056300-1d3f-11eb-0889-491b4390c38d
# ╟─dd05ebb0-1d3f-11eb-1ce3-715ffb83d079
# ╟─0aad9f10-1d4d-11eb-2046-7750731e1f30
# ╟─2f03fd50-1d4d-11eb-31e9-01cd0ccecd71
# ╟─65aaed00-1d4d-11eb-2a00-234b09f0954d
# ╟─3c991570-1d40-11eb-31a7-7b2d786b07df
# ╟─4b8b60b0-1d40-11eb-1100-b33197899ae6
# ╟─936738a0-1d40-11eb-1c2c-59e275f67331
# ╟─c3c56c60-1d40-11eb-09f4-fb0f982c18ec
# ╟─839a59ee-1d42-11eb-3fac-57b0f7dbb033
# ╟─789b4c70-1d43-11eb-07df-cb186b0d8094
# ╟─69bc93c0-1d44-11eb-324e-83affbe587e2
# ╟─61d1cb20-1d45-11eb-0308-7908fac4210a
# ╟─f6112930-1d49-11eb-011e-d9b3764b8126
# ╟─210bd0e0-1d4a-11eb-1847-2f058fe7ca64
# ╟─7678dd6e-1d4a-11eb-1b1c-d70b11ffb4dc
# ╟─ff35bf6e-1d4a-11eb-117c-f7ecce96edd1
# ╟─2f0dac30-1d4b-11eb-13cc-2b2130e764c5
# ╟─56084f70-1d4b-11eb-0263-8171c55124b4
# ╟─77d7dbc0-1d4b-11eb-2be5-1bcf60fbac9d
# ╟─ce2f4850-1d4b-11eb-2e3d-631a8bd80dfe
# ╟─000faf40-1d4c-11eb-0f5e-91335dbab28f
# ╟─3017fad2-1d4c-11eb-3328-ed91107abce8
# ╟─ac4083f2-1d3a-11eb-0318-7f9dc8f198de
# ╟─50c06c40-1d4c-11eb-0fe0-8f31777a7056
# ╟─7b29824e-1d4c-11eb-3733-a30188b878cd
# ╟─a033aac0-1d4d-11eb-163a-bfe0f30a8c61
# ╟─4a8707ae-1d4e-11eb-0c4d-2b11c6300d23
