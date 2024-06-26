Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations',  omniauth_callbacks: 'users/omniauth_callbacks'  }

  resources :users_admin, controller: 'users'

  resources :comptes do 
    get :balance
  end
  
  get 'moncompte/index'
  get 'moncompte/releve_compte'
  get 'moncompte/factures'
  get 'moncompte/absences'
  get 'moncompte/enfants'
  get 'moncompte/reservations'
  get 'moncompte/contacts'

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

  resources :reservations, except: %i[ show create update ] do
    collection do
      post :action
      post :create_visiteur
    end
  end

  resources :prestations do
    collection do
      post :action
    end
  end
  resources :tarifs
  resources :absences
  resources :tarif_types, except: %i[ index show ]
  resources :prestation_types, except: %i[ index show ]
  resources :structures, except: %i[ index new create ]
  resources :organisations do
    member do
      get :suppression_organisation
      post :suppression_organisation_do
    end
  end
  resources :paiements
  resources :facture_messages
  resources :messages do
    member do
      get :traiter
      get :archiver
    end
  end
  resources :vacances
  resources :mail_logs, only: %i[ index show ]
  resources :pointages, only: %i[ index edit update ] do
    collection do
      post :action
    end
  end

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
    get :dashboard
    get :stats

    post :ajout_prestations_do
    post :ajout_factures_do
    post :import_do
    post :envoyer_factures_do
  end

  controller :pages do
    get :accueil, to: 'pages#home'
    get :guide, to: 'pages#guide'
    get :actualites, to: 'pages#actualites'
    get :confidentialite, to: 'pages#confidentialite'
    post :conditions_generales_de_vente, to: 'pages#conditions_generales_de_vente'
  end

  root 'pages#accueil'

end