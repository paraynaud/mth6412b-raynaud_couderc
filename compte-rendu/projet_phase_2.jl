### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ c6520cf0-01b0-11eb-20fd-f3154ca499a7
md" # Phase n°2 du projet de MTH6412B"


# ╔═╡ 14e7d930-01b1-11eb-1346-0d59a5f02af8
md" ###### Rapport de Paul Raynaud et Romain Couderc"

# ╔═╡ b2db0670-01bc-11eb-14cc-7f2df97c2c4d
md"Adresse du dépôt git:  https://github.com/paraynaud/mth6412b-raynaud_couderc" 

# ╔═╡ 3c106a40-01b1-11eb-167c-d59d26382071
md" ## I) L'implémentation du type _ConnectedComponent_"

# ╔═╡ cff15170-01b1-11eb-2483-dd7df4dd77d3
md"Nous avons premièrement créé un type abstrait _AbstractConnectedComponent_ qui dérive du type AbstractGraph. Ensuite, nous avons choisis de définir un type _ConnectedComponent_ suivant trois éléments:
* Sa racine,
* Un sous graphe, 
* et un index.

On a défini plusieurs _getter_ associées à ce type, notamment: 
* Trois _getter_ permettant de récupérer les éléments du type _ConnectedComponent_.  
* Un _getter_ permettant de connaitre le nombre d'arête du sous graphe. 
* Un _getter_ permettant de connaitre le nombre de noeuds du sous graphe. 
* Un _getter_ permettant de récupérer les arêtes du sous graphe. 
* Un _getter_ permettant de récupérer les noeuds du sous graphe. 
* Un _getter_ permettant de récupérer le nom du sous graphe. 

On a défini également un _setter_ permettant de remplacer le sous graphe d'un _ConnectedComponent_. 

Nous avons également surcharger l'opérateur _==_ pour qu'on puisse comparer deux _ConnectedComponent_. 

Une méthode _nodein_ permettant de savoir si un noeud est présent dans une composante connexe. 

Enfin, nous avons fait une méthode _merge!_ qui prend en argument un vecteur de _ConnectedCompenent_ et une arête. Cette méthode réalise les tâches suivantes: 
* Elle récupère les deux noeuds associés à l'arête. 
* Elle identifie les deux composantes connexes associées à chacun des noeuds, ces composantes connexes sont différentes (voir ci après). 
* On fusionne les deux composantes connexes (i.e. on prend l'union des sommets et des arêtes) et on ajoute l'arête en argument à ce graphe. 
* Enfin, on attribue la nouvelle composante ainsi créer à la première composante qu'on renvoie et on supprime la seconde composante connexe.


Nous avons également écrit quelques tests afin de vérifier que chaque méthode suive le comportement défini. "

# ╔═╡ f5c07790-01b2-11eb-208e-2da41d154bd9
md" ## II) Implémentation de l'algorithme de Kruskal"

# ╔═╡ b1c12ba0-01b4-11eb-2e45-8962eb4f1386
md"
Nous allons détailler ici notre implémenation de l'algorithme de Kruskal qui prend en argument un graphe g:
* On commence par charger les neouds et les arêtes du graphe g.
* On transforme notre dictionnaire d'arêtes en un vecteur d'arête.
* On applique directement la méthode _sort!_ à ce vecteur d'arête car on avait préalablement surcharger l'opérateur _<=_ pour les arêtes ( en tenant compte seulement du poids de l'arête).
* On fait un prétraitement de ce vecteur trié en supprimant toutes les arêtes ayant les deux mêmes noeuds. 
* Ensuite, à partir des n noeuds récupérés, on crée les n composantes connexes associées. 
* Puis tant que le vecteur des arêtes est non vide: 
* On prend la première arête, le vecteur des n composantes connexes et on applique notre méthode _merge_.
* Puis on applique la fonction _deleteedges_ qui supprime les arêtes qui serait présente à l'intérieur de notre nouvelle composante connexe (c'est pourquoi la méthode _merge!_ ne traite que des arêtes dont les composantes connexes des deux sommets sont différentes). 

* Finalement, si le nombre de composante connexe est différent de 1, nous renvoyons une erreur et sinon nous retournons l'unique composante connexe qui est l'arbre couvrant de coût minimum. 

Pour tester sur l'exemple des notes du cours, nous avons créé une nouvelle instance course_note.tsp et qui nous a permis de tester notre algorihtme de Kruskal. Nous trouvons un arbre couvrant de poids 37 qui est le poids que l'on trouve avec le cours. 
"

# ╔═╡ 34ff50d0-0739-11eb-0aad-19a373e1f380
md" ## III) Tests unitaires"

# ╔═╡ 919da490-0739-11eb-3628-0331d5af7c14
md"
Nous avons fait de nombreux tests unitaires (principalement les getter, les setter et les opérations que nous avons redéfini) qui se trouvent dans le fichier test.jl, je ne vais pas les détailler ici mais ils sont présentés clairement dans le fichier. 
"

# ╔═╡ 19b91670-073a-11eb-2773-bb98abb0e984
md" ## IV) Test sur des instances de TSP symmétriques"

# ╔═╡ 4d5a8e50-073a-11eb-29df-3ba2a992ea30
md"
Nous avons testé notre algorithme de Kruskal sur plusieurs instances de TSP symmétriques, notamment: 
* bays29.tsp
* swiss42.tsp
* gr24.tsp
* dantzig42.tsp
* pa561.tsp

Tous les tests nous donnent un graphe avec n sommets et n-1 arêtes donc on trouve un arbre, nous ne pouvons pas déterminer si cet arbre est de poids minimum mais nous pensons que c'est le cas. 

Toutes les instances sont résolus en moins d'une seconde sauf l'instance pa561.tsp qui est la plus grosse et dont on trouve l'arbre couvrant de poids minimal en 38 secondes. Cela nous parait un temps assez important, voir un peu trop important et il faudrait peut être revoir notre implémentation de graphe pour que ce soit plus rapide (il nous faudrait alors changer toute la structure du projet ce qui est assez fastidieux). 

"


# ╔═╡ Cell order:
# ╟─c6520cf0-01b0-11eb-20fd-f3154ca499a7
# ╟─14e7d930-01b1-11eb-1346-0d59a5f02af8
# ╟─b2db0670-01bc-11eb-14cc-7f2df97c2c4d
# ╟─3c106a40-01b1-11eb-167c-d59d26382071
# ╟─cff15170-01b1-11eb-2483-dd7df4dd77d3
# ╟─f5c07790-01b2-11eb-208e-2da41d154bd9
# ╟─b1c12ba0-01b4-11eb-2e45-8962eb4f1386
# ╟─34ff50d0-0739-11eb-0aad-19a373e1f380
# ╟─919da490-0739-11eb-3628-0331d5af7c14
# ╟─19b91670-073a-11eb-2773-bb98abb0e984
# ╟─4d5a8e50-073a-11eb-29df-3ba2a992ea30
