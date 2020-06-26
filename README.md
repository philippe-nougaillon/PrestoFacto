### A propos de PrestoFActo

Cette application web permet à une organisation (Mairie, Association,...) de gérer les comptes de ses familles, les réservations des enfants et la facturation des prestations consommées.

Les prestations et les tarifs sont entièrement paramétrables et illimités.

### Comptes
à compléter

### Enfants
à compléter

### Réservation

Un enfant est associé à un compte (famille) qui est lui-même associé une structure (Ecole, Cantine, Garderie,...). 

Cet enfant peut avoir une ou plusieurs réservations, qui indiquent les jours de la semaine, les quantités désirées pour chaque type de prestations (Repas, Garderie, Activité, et tout ce que vous voudrez :).

Exemple: 
- Mathieu PETIT a une réservation pour un Repas, tous les jours sauf mercredi
- Mathieu PETIT a une réservation pour 1 heure de Garderie, tous les jours, le matin, sauf mercredi
- Mathieu PETIT a une réservation pour 1,5 heure de Garderie, tous les jours, le soir, sauf mercredi
- Mathieu PETIT a une réservation pour 1 jour de Centre, tous les jours pendant les vacances scolaires (HorsPériodeScolaire)

Une réservation a trois états: Ajoutée, Validée, Rejetée
Une réservation peut être activée/désactivée

### Comptabilisation

Chaque jour, très tôt le matin, a lieu la comptabilisation automatique des prestations consommées sur la base des réservations actives.

Les prestations ne sont PAS comptabilisées si une absence a été saisie pour ce jour.

Les prestations sont comptabilisées en fonction de la période, Scolaire/HorsScolaire : 
- sont comptabilisées les prestations dont la réservation n'est PAS "Hors Période Scolaire" si c'est un jour hors période de vacances scolaires
- sont comptabilisées les prestations dont la réservation est "Hors Période Scolaire" si ce n'est PAS un jour en période de vacances scolaires
- sont comptabilisées les prestations dont la réservation n'est PAS "Hors Période Scolaire" si ce jour n'est pas en période de vacances scolaires

### Facturation

Les prestations consommées seront facturées en fin de mois, par compte et par enfant, selon le tarif auquel est soumis l'enfant.
Les factures peuvent être envoyées par courriel.
Un export au format XLS (Excel 97-2003) est disponible. Il permet de générer un classeur contenant une feuille de calcul avec toutes vos factures, qui pourra être ouverte directement dans Excel.

### Paiements

Les paiements reçus sont enregistrés afin d'établir une balance de compte.
Chaque compte dispose d'un relevé qui liste l'ensemble des opérations (factures/paiements) et le soles après chaque opération.
La liste des paiements peut s'exporter au format XLS

### Import

Les données de compte, contact, enfant, réservation peuvent être importées d'un fichier au format Excel 97-2003 (.xls).
Ce fichier doit contenir les colonnes suivantes :
structure, nom_compte, civilité, adresse1, adresse2, cp, ville, num_allocataire, mémo_compte, nom_contact, fixe, portable, email, mémo_contact, nom_enfant, prénom, classe, date_naissance, menu_sp, menu_all, tarif_type, badge, prestation_type, début, fin, lundi, mardi, mercredi, jeudi, vendredi, matin, midi, soir, active, hors_période_scolaire

Exemple de fichier : [Fichier.xls]("/exemple_fichier_import_xls") 

### Audit des modifications

Chaque modification de donnée est enregistrée dans un journal, avec la date, l'utilisateur, la table, le champs et la valeur avant/après modification.

### Utilisateurs

Il existe trois types de comptes utilisateurs; Visiteur, Normal et Administrateur. 
Le compte 'Visiteur' est utilisé pour utiliser le portail Familles/Comptes. 
Le compte de type 'Normal' peut accéder à toutes les données mais sans pouvoir les modifier, au contraire de l'Administrateur qui a tous les droits.
