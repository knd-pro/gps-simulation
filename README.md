# Simulation GPS

Projet permettant de positioner un point en coordonnées GPS sur un globe terrestre en 3D.

Réalisations :
- Point GPS : sphère avec matériel d'émission rouge. La position du point (longitude, latitude et altitude) est modifiable en Edit Mode 
  dans l'inspecteur avec des sliders,<br>
  en cliquant sur le MainManager. En Game Mode, une GUI a été mise en place pour modifier la longitude
  et la latitude à l'aide de 2 sliders et des InputField.<br>
  J'ai essayé de faire fonctionner la GUI en Edit Mode également, mais finalement j'ai opté pour l'édition via l'inspecteur dans le MainManager.
 
- Visualisation du globe terrestre : la texture water_NM.png a été assigné au champs "Normal Map" dans l'inspecteur sur l'objet Earth.<br>
  Le shader EarthShader a été modifié pour prendre en compte la normal map dans le calcul de la lumière.<br>
  Pour cela je me suis inspiré du code que l'on peut trouver ici (lignes 189 et 209) :<br>
  [https://github.com/shantanubhadoria/Unity3D-Shaders-Basic/blob/master/Shaders/7%20Normal%20Map.shader](https://github.com/shantanubhadoria/Unity3D-Shaders-Basic/blob/master/Shaders/7%20Normal%20Map.shader)<br>
  Cela m'a permis de calculer la direction des normales de la normalmap et de combiner le résultat avec la normal de lumière principale (produit scalaire).<br>
  Par la suite, j'ai pu également inclure la normal map dans le calcul de la lumière speculaire dans l'océan.<br>
  Je ne cache pas ne pas être très expérimenté dans l'écriture de shaders, d'où l'usage d'offets et de multiplicateurs pour ajuster la lumière (position et intensité).<br>
  J'ai également essayé d'inclure sans succès le masque de l'océan, en chargeant la texture water_mask.png au runtime dans le script waterMaskHandler.cs que j'ai ajouté à l'objet Earth.<br>
  Au niveau du shader, j'ai utilisé une condition if-else pour n'afficher la lumière spéculaire que lorsqu'on est dans l'océan, c'est-à-dire lorsque la couleur du pixel du masque est blanche (j'ai mis rouge > 0.6, valeur trouvée en tâtonnant car à 0.7 on n'entre pas dans la boucle).
  
- J'ai codé les classes mainHUD et mainManager et waterMaskHandler. Je me suis servi principalement de la doc d'Unity et de [forum.unity.com](forum.unity.com) pour m'aider (fonctions de base pour un shader, charger une normalmap)
  
Temps de réalisation: 1 journée<br>
Résolution : 1280 x 720<br>
Framerate : 30 fps

Si la résolution n'est pas en 1280 x 720, penser à supprimer dans le registre, la clé "Ordinateur\HKEY_CURRENT_USER\Software\DefaultCompany\TestRecrutementMCM".
J'ai changé la résolution par défaut dans les player settings, mais si un programme Unity ayant le même nom a été lancé avec une résolution différente auparavant, la résolution par défaut sera ignorée.

Projet effectué avec :
```
Unity 2021.3.9f1 (Linux)
```
