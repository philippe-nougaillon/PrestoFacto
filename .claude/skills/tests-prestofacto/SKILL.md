---
name: tests-prestofacto
description: Conventions des tests du projet PrestoFacto (Minitest, Rails, fixtures, Pundit, Capybara). À lire AVANT d'écrire, de modifier ou de relire un test — contrôleur, modèle, job, mailer ou système — ainsi que pour ajouter une fixture ou placer un helper de test.
---

# Tests — PrestoFacto

**Minitest** (`test/`, fixtures dans `test/fixtures/`), tests système Capybara + Selenium, Pundit pour les autorisations.

## Règle d'arbitrage : le minimum de modifications prime

**On ne touche que ce que la demande exige.** Deux conséquences :

- **Pas de migration au fil de l'eau des noms de tests.** Toucher un fichier n'oblige pas à
  renommer les tests qu'on ne modifiait pas. Les nouveaux tests suivent la convention de nommage ;
  les anciens restent en l'état jusqu'à ce qu'on les modifie pour une autre raison.
- Ce qu'on repère en chemin et qui mériterait un correctif (test fragile, doublon, couverture
  manquante) **se signale en fin de réponse**, sans le faire.

## Nommage

**Le nom d'un test est une phrase qui énonce un comportement**, lisible par quelqu'un qui ne
connaît pas le code — pas une coordonnée technique (`update : date vide → 422`) :

```ruby
test "une période de plusieurs mois produit une seule facture par compte"
test "une date de fin vide est refusée"
test "une prestation déjà facturée n'est pas refacturée"
```

Le nom ne raconte pas le décor : le contexte est dans le corps du test.

**Chaque chose porte son nom, et un seul.** Aucune ambiguïté dans les noms de tests, de variables
et les messages d'assertion. Sur ce projet, trois objets voisins se confondent facilement :

| L'objet | Son nom | Jamais |
|---|---|---|
| `Prestation` | une **prestation** (ce qui est consommé et facturé) | un pointage, une réservation |
| `Pointage` | un **pointage** (le passage horodaté) | une prestation |
| `Reservation` | une **réservation** (le prévisionnel) | une prestation |

## Aucun commentaire dans un fichier de test

Le nom du fichier et celui de chaque test doivent suffire. Les précisions sur une fixture passent
par le **nom de la variable** (`prestation_hors_période`, `compte_sans_enfant`), pas par un commentaire.

Trois exceptions, et seulement celles-là :

1. une ligne en tête de fichier quand la **raison d'être** du fichier ne se devine pas ;
2. le commentaire **collé à un helper privé**, qui l'explique ;
3. le commentaire d'une ligne sur une **constante** déclarée en haut de classe.

C'est la porte de sortie quand une information est réellement nécessaire : elle se loge dans un
helper ou une constante nommée, jamais en commentaire flottant au milieu des assertions.

## Helpers et constantes

**Un helper utilisé par un seul fichier** vit sous `private`, en fin de classe, avec le commentaire
qui l'explique collé à lui. Utilisé par plusieurs fichiers, il devient un module sous `test/support/`
que les fichiers `require_relative` et `include` (ce répertoire n'existe pas encore : le créer au
premier besoin réel, pas avant).

**Une constante utilisée une seule fois n'existe pas** — on met sa valeur à l'endroit qui s'en sert.
Utilisée plusieurs fois, elle se déclare en haut de la classe, juste sous le `setup`, avec un
commentaire d'une ligne qui dit à quoi elle sert.

## Fixtures

Quand **aucune fixture ne porte l'attribut nécessaire** au test, **en créer une** plutôt que
d'écrire l'enregistrement dans le test ou de muter une fixture existante avec `update!`.

**Nom explicite qui dit l'attribut** : `facture_envoyée`, `compte_autre_organisation`, `enfant_sans_tarif`.

⚠ **Ne jamais modifier une fixture déjà utilisée ailleurs** — on en ajoute une à côté.

⚠ **Toujours relancer la suite complète après un ajout.** Une fixture de plus casse tout test qui
compte des enregistrements en dur. C'est alors **le test fragile qu'on rend robuste** (compter à
partir de la base au lieu d'un littéral), **pas la fixture qu'on retire**.

⚠ **Les fixtures de ce projet portent des `id:` explicites** (`organisations(:asso_cantine)` a
`id: 1`). Une association s'y écrit donc `organisation_id: 1` et **non** `organisation: asso_cantine` :
le label se résoudrait en identifiant haché et violerait la clé étrangère.

## `flunk`, jamais `skip`

**Quand un test ne passe pas alors que la logique métier veut qu'il passe, on écrit `flunk` avec la
raison** — jamais un `skip`, jamais une assertion tordue pour faire passer.

```ruby
flunk "La facture d'un compte sans enfant n'affiche aucun total, à corriger"
```

Le message dit **ce qui manque**, pas « ça ne marche pas ». Il vaut aussi pour signaler un test
**à écrire** : on le pose là où il devra vivre, avec ce qu'il devra prouver.

Le `skip` reste réservé à une décision métier en attente ; le `flunk`, à un défaut de l'application.

## Hiérarchie : contrôleur < intégration < système

Trois niveaux, du moins cher au plus cher. **Un comportement ne se teste qu'à un seul.**

| Niveau | Ce qu'il couvre |
|---|---|
| **Contrôleur** | chaque cas particulier d'**une** action : ce qu'elle doit faire, et ce qu'elle doit refuser |
| **Intégration** | un parcours dans la couche contrôleur : **plusieurs actions enchaînées** |
| **Système** | les parcours **critiques**, et uniquement ce qui n'est testable à aucun niveau inférieur : le JavaScript, la CSS, le clic réel |

**La règle de décision, dans cet ordre :** ça tient dans une seule action → contrôleur. Il faut
enchaîner des actions → intégration. Il faut un navigateur → système.

**Jamais deux niveaux pour la même chose.** Un test système qui refait ce qu'un test de contrôleur
prouve déjà se supprime : il coûte bien plus cher, il flake, et le jour où le comportement change
il faut corriger deux endroits.

## Tests de contrôleur

Un test de contrôleur vérifie **un seul contrat**, sur **une seule action**. Dès qu'on enchaîne
deux actions, c'est un test d'intégration.

**Les cinq assertions** dans lesquelles on puise, sans en inventer d'autres :

1. **La réponse aboutit** — `assert_response :success`, ou `assert_redirected_to` pour une redirection.
2. **La redirection mène à la bonne page** — jamais « quelque part ».
3. **La donnée du record est rendue** — sa référence, son montant, son intitulé, avec `assert_select`.
   **Jamais le titre de la page ni un intitulé de section** : ce sont des libellés de gabarit, ils
   changent pour des raisons d'ergonomie et feraient tomber le test sans qu'aucun contrat soit rompu.
4. **L'alerte correspond à la situation** — le `flash[:notice]` ou `flash[:alert]` exact que l'action pose.
5. **L'état en base a changé, ou n'a pas changé** — avec un `reload` avant de lire.

**Le premier test d'une action est le nominal le plus dépouillé possible** — l'action appelée avec
le minimum de paramètres, une seule assertion sur la réponse. Les cas particuliers viennent après.

**L'ordre du fichier suit l'ordre du contrôleur** : les actions dans l'ordre où elles y sont
écrites, tous les tests d'une action groupés.

**Chaque dérivé de l'action est testé** : toute condition écrite dans l'action donne son test,
branches d'erreur comprises.

**Un fichier par contrôleur**, `test/controllers/<record>_controller_test.rb`.

⚠ **Rien de ce qui vient de Rails ou d'une gem ne se teste** — Devise, Pundit, `workflow`,
`friendly_id`, `audited` : c'est censé fonctionner. On teste l'usage qu'on en fait, pas la gem.

## Frontières

**On ne teste ni la vue, ni le modèle, ni les policies depuis un test de contrôleur.** Asserter
**quels** records sont dans la réponse = contrôleur ; asserter **comment** ils sont affichés = système.

Si une erreur tombe dans une action mais vient d'ailleurs (méthode de modèle, tâche rake), on
**signale sans corriger** tant qu'on écrit les tests du contrôleur.

**Priorité : les crashs atteignables par un utilisateur via l'interface.** Premier critère d'arbitrage.

## Outillage absent de ce projet

Ne pas écrire de test qui en dépend :

- **`assigns(...)`** — la gem `rails-controller-testing` n'est pas installée. On asserte sur le
  rendu ou sur la base, pas sur les variables d'instance.
- **SimpleCov** — pas de mesure de couverture. Pour savoir ce qui est rouge, relancer la suite.
- **`test/support/`** — n'existe pas encore. Le créer au premier helper réellement partagé entre
  plusieurs fichiers, pas avant.
- **Marquage des tests critiques** — aucun modèle de menace n'a été arrêté pour ce projet : ne pas
  marquer de tests critiques tant que la question n'est pas tranchée.

## État de la suite

`bin/rails test` démarre. La contrainte `gem "minitest", "< 6"` du Gemfile est nécessaire : minitest 6
a renommé des éléments d'API dont Rails 7.2 dépend encore, et le correctif amont n'est pas
rétroporté sur 7.2 — à lever au passage à Rails 8.

⚠ ~28 échecs pré-existants subsistent dans des tests de scaffold jamais adaptés (Vacances,
Pointages, MailLogs, Messages, Pages, Contact) : routes inexistantes, pas de `sign_in`. Ils sont
connus et seront repris plus tard — ne pas les confondre avec une régression.
