Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users_admin, controller: 'users'

  resources :comptes do 
    get :balance
  end
  
  get 'moncompte/index'

  resources :factures
  resources :prestations
  resources :tarifs
  resources :absences
  resources :reservations
  resources :tarif_types
  resources :prestation_types
  resources :enfants
  resources :structures
  resources :organisations
  resources :paiements

  namespace :admin do
    get :index
    get :ajout_prestations
    get :ajout_factures
    get :tarifs
    get :audit
    get :import
    get :exemple_fichier_import_xls
    get :envoyer_factures

    post :mode_demonstration
    post :ajout_prestations_do
    post :ajout_factures_do
    post :import_do
    post :envoyer_factures_do
  end

  namespace :guide do
    get :a_propos
    get :utilisation
  end
  
  root 'comptes#index'

end
