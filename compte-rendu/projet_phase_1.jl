### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ c6520cf0-01b0-11eb-20fd-f3154ca499a7
md" # Phase n°1 du projet de MTH6412B"


# ╔═╡ 14e7d930-01b1-11eb-1346-0d59a5f02af8
md" ###### Rapport de Paul Raynaud et Romain Couderc"

# ╔═╡ b2db0670-01bc-11eb-14cc-7f2df97c2c4d
md"Adresse du dépôt git:  https://github.com/paraynaud/mth6412b-raynaud_couderc" 

# ╔═╡ 3c106a40-01b1-11eb-167c-d59d26382071
md" ## I) L'implémentation du type _edge_"

# ╔═╡ cff15170-01b1-11eb-2483-dd7df4dd77d3
md"Nous avons choisis de définir une arête suivant trois éléments:
* Le premier noeud de l'arête,
* Le deuxième, 
* et son poids.

On a défini plusieurs méthodes associées à ce type, notamment: 
* Trois méthodes permettant de récupérer les éléments du type _edge_, 
* Une méthode permettant l'affichage du type _edge_. 

Nous avons également écrit quelques tests afin de vérifier que chaque méthode suive le comportement défini. "

# ╔═╡ f5c07790-01b2-11eb-208e-2da41d154bd9
md" ## II) Extension du type _graph_"

# ╔═╡ 90946470-01b3-11eb-12d6-17120caf2c74
md" Afin d'intégrer les arêtes dans le type _graph_, nous avons choisi de les stocker sous forme de dictionnaire où:
* La clef est le couple de noeud correspondant à l'arête en question, 
* La valeur est le poids de l'arête. 


Nous avons choisi cette structure de donnée car nous ne savons pas encore le problème exacte que nous devrons résoudre. Cette structure nécessite un espace de stockage d'au plus la taille de la matrice d'adjacence et un accès à un poid d'une arête en temps constant. Dans un premier temps, cela nous semble suffisant, si au fur du projet, nous nous rendons compte que cette structure nous ralentit, nous opterons alors pour un stockage sous forme matricielle. "

# ╔═╡ b1c12ba0-01b4-11eb-2e45-8962eb4f1386
md" Nous avons ensuite implémenté plusieurs méthodes: 
* Une méthode qui permet de récupérer le dictionnaire d'arête. 
* Une seconde qui permet d'ajouter une arête au graphe (elle utilise la méthode précédente et les méthodes permettant de récupérer les noeuds d'une arête). 
* On a surchargé l'opérateur == pour comparer directement deux graphes. 
"

# ╔═╡ 9f0303f0-01b7-11eb-3544-17a88ab59c28
md" ## Extension de la méthode _show_ du type _graph_ "

# ╔═╡ 98b517de-01b7-11eb-32e7-3babdc6934a5
md" Pour étendre la méthode _show_ du type _graph_, nous avons utilisé le _show_ du type edge et nous avons intégré dans la méthode _show_ du type _graph_. "

# ╔═╡ dccc7850-01b8-11eb-3432-752c0331d69c
md" ## Extension de la méthode _read_ _edges_ "

# ╔═╡ 0e916802-01b9-11eb-05e8-979e9268480a
md" En analysant le code existant, nous avons remarqué qu'il y avait une ligne: 
 data = split(line) qui stockait dans data le poids des arêtes. Cependant, ces données étaient volontairement ignorées, nous avons donc fait en sorte de les prendre en compte en ajoutant un élément au couple _edge_ pour former un triplet contenant le poids. "

# ╔═╡ 5a4b20f0-01ba-11eb-25a0-7f07d9e4c8ae
md" ## Fonction principale"

# ╔═╡ ab4bd2b0-01ba-11eb-15ab-e7b80d29e60e
md"Nous avons écrit une fonction principale réalisant ce qui était demandé, nous avons également compléter notre travail avec un fichier _test.jl_ qui nous permet de tester nos différentes méthodes." 

# ╔═╡ Cell order:
# ╟─c6520cf0-01b0-11eb-20fd-f3154ca499a7
# ╟─14e7d930-01b1-11eb-1346-0d59a5f02af8
# ╟─b2db0670-01bc-11eb-14cc-7f2df97c2c4d
# ╟─3c106a40-01b1-11eb-167c-d59d26382071
# ╟─cff15170-01b1-11eb-2483-dd7df4dd77d3
# ╟─f5c07790-01b2-11eb-208e-2da41d154bd9
# ╟─90946470-01b3-11eb-12d6-17120caf2c74
# ╟─b1c12ba0-01b4-11eb-2e45-8962eb4f1386
# ╟─9f0303f0-01b7-11eb-3544-17a88ab59c28
# ╟─98b517de-01b7-11eb-32e7-3babdc6934a5
# ╟─dccc7850-01b8-11eb-3432-752c0331d69c
# ╟─0e916802-01b9-11eb-05e8-979e9268480a
# ╟─5a4b20f0-01ba-11eb-25a0-7f07d9e4c8ae
# ╟─ab4bd2b0-01ba-11eb-15ab-e7b80d29e60e
