### A propos de PrestoFActo

Logiciel gratuit de facturation de cantine et des activités pré-scolaires

Cette application web permet à une organisation (mairie, association, école...) de gérer les comptes de ses familles, les réservations des enfants et la facturation des prestations consommées.

Les prestations et les tarifs sont entièrement paramétrables et illimités.


### Organisation

- Une organisation (Mairie, Association,...) est composée d'un nom, d'une adresse, une zone (vacances scolaires) et d'un logo
- Une organisation a une ou plusieurs structures
- Un compte utilisateur de type administrateur est associé à une organisation lors de l'inscription 
- Cet administrateur peut paramétrer les données variables de l'organisation comme les Structures, les Type de prestations (Repas, Garderie, Activité,...) ou les Tarifs
- Un administrateur peut ajouter d'autres utilisateurs

### Structures

- Une structure est composée d'un nom (Ecole, Cantine, Garderie, Halte, Centre périscolaire,...)
- Une structure contient des classes
- Une organisation peut avoir plusieurs structures (illimité)

### Comptes

- Un compte est attaché à une organisation
- Un compte est composé d'un nom, d'une adresse, un numéro d'allocataire et un mémo
- Un compte contient les coordonnées des personnes à contacter
- Un compte contient les enfants
- Un compte contient les factures
- Un compte contient les paiements
- Un compte affiche un solde en € (somme des factures - somme des paiements)
- Un compte affiche une balance (liste des factures et des paiements)

### Enfants

- Un enfant est associé à un compte (famille)
- Un enfant est lié à une classe
- Un enfant est composé d'un nom, prénom, date de naissance, N° de badge, préférences alimentaires (sans porc, sans allergènes) et d'un tarif
- Un enfant a des réservations

### Absences</h4>

- Une absence est liée à un enfant
- Une absence est composée d'un début, d'une fin, d'une période (matin/midi/soir)

### Réservations

- Une réservation est composée d'un type de prestation, d'une date de début et de fin, d'une quantité par jour de la semaine (lundi au vendredi), de la période (matin/midi/soir)
- Une réservation est en période scolaire ou hors période scolaire
- Une réservation peut être active ou inactive

### Prestations

À lieu, chaque matin, dès potron-minet, la comptabilisation automatique des prestations consommées la veille

Cette comptabilisation est effectuée sur la base des réservations actives

Les prestations sont comptabilisées en fonction de la période, Scolaire/HorsScolaire :

- sont comptabilisées les prestations dont la réservation n'est PAS "Hors Période Scolaire" si c'est un jour hors période de vacances scolaires

- sont comptabilisées les prestations dont la réservation est "Hors Période Scolaire" si ce n'est PAS un jour en période de vacances scolaires

- sont comptabilisées les prestations dont la réservation n'est PAS "Hors Période Scolaire" si ce jour n'est pas en période de vacances scolaires

Les prestations ne sont PAS comptabilisées si une absence existe pour ce jour

Une ligne par prestation est ajoutée à la liste des prestations de l'enfant quand toutes les conditions précédentes sont remplies

Au besoin, une prestation peut être supprimée par l'administrateur afin de ne pas apparaître sur la prochaine facture

### Factures

- Les prestations consommées sont facturées à la demande, pour tous les comptes d'une organisation

- Une facture est créée par mois et par compte. Y figure le détail des prestations par enfant

- Les prestations sont facturées selon le tarif auquel est soumis l'enfant

- Les factures peuvent être envoyées, en lot, via courriel

- Un export au format XLS (Excel 97-2003) est disponible. Il génère une feuille de calcul listant en détails toutes les factures d'une organisation

### Tarifs

- Un tarif est le prix d'un type de Prestation selon un type de Tarif

- Les types de prestations (Cantine, Garderie, etc.) sont configurables à votre convenance

- Les types de tarifs (Plein, Demi-tarif, QF1/2/3/4/5, etc...) aussi

### Paiements

- Les paiements reçus sont enregistrés afin d'établir une balance de compte

- Chaque compte dispose d'un relevé qui liste l'ensemble des opérations (factures/paiements) et le soles après chaque opération

- La liste des paiements peut s'exporter au format XLS


### Import

Les données de compte, contact, enfant, réservation peuvent être importées d'un fichier au format Excel 97-2003 (.xls).

Ce fichier doit contenir les colonnes suivantes :
structure, nom_compte, civilité, adresse1, adresse2, cp, ville, num_allocataire, mémo_compte, nom_contact, fixe, portable, email, mémo_contact, nom_enfant, prénom, classe, date_naissance, menu_sp, menu_all, tarif_type, badge, prestation_type, début, fin, lundi, mardi, mercredi, jeudi, vendredi, matin, midi, soir, active, hors_période_scolaire

Exemple de fichier : [Fichier.xls]("/exemple_fichier_import_xls") 

### Audit des modifications

Chaque modification de donnée est enregistrée dans un journal, avec la date, l'utilisateur, la table, le champs et la valeur avant/après modification.

### Utilisateurs

Il existe trois types de comptes utilisateurs; Visiteur, Normal et Administrateur. 

Le compte 'Visiteur' est utilisé donner l'accès au portail Familles/Comptes. 

Le compte de type 'Normal' peut accéder à toutes les données mais sans pouvoir les modifier, au contraire de l'Administrateur qui a tous les droits.

Pour en savoir plus, veuillez consulter [le guide d'utilisation](https://prestofacto.philnoug.com/guide/utilisation)
