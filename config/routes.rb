Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users_admin, controller: 'users'

  resources :comptes do 
    get :balance
  end
  
  get 'moncompte/index'

  resources :factures do
    collection do
      post :action
    end
  end

  resources :enfants do
    collection do
      post :action
      post :action_execute
    end
  end

  resources :reservations do
    collection do
      post :create_visiteur
    end
  end

  resources :prestations
  resources :tarifs
  resources :absences
  resources :tarif_types
  resources :prestation_types
  resources :structures
  resources :organisations
  resources :paiements
  resources :blogs
  resources :facture_messages
  resources :messages

  namespace :admin do
    get :index
    get :ajout_prestations
    get :ajout_factures
    get :tarifs
    get :audit
    get :import
    get :exemple_fichier_import_xls
    get :envoyer_factures
    get :mode_demonstration

    post :ajout_prestations_do
    post :ajout_factures_do
    post :import_do
    post :envoyer_factures_do
  end

  namespace :pages do
    get :accueil
    get :a_propos
    get :guide
    get :blog
    get :confidentialite
    get :conditions_generales_de_vente
  end
  
  root 'pages#accueil'

end
