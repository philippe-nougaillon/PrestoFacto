module ApplicationHelper

    def sort_link(column, title = nil)
        title ||= (@model_class ? @model_class.human_attribute_name(column) : column.titleize)
        
        direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
        
        icon = sort_direction == "asc" ? "fas fa-sort-up" : "fas fa-sort-down"
        icon = column == sort_column ? icon : ""
        
        link_title = sort_direction == "asc" ? "Trier croissant" : "Trier décroissant"

        link_to "<span title=\"#{h link_title}\">#{h title} <i class=\"#{icon}\"></i></span>".html_safe, 
                url_for(request.parameters.merge(column: column, direction: direction))
    end

    def navbar_nav_item(name, icon, path)
        render(inline: %{
            <li class="nav-item pr-3">
                <%= link_to '#{ url_for(path) }', 
                            class: 'nav-link text-#{ (@ctrl == name) ? 'dark active shadow-sm' : 'secondary' }' do %>
                    <%= fa_icon '#{ icon }', text: ' #{ name.humanize }' %>
                <% end %>
            </li>
        })
    end
    
    def nav_breadcrumb
        render(inline: %{
            <nav class="navbar navbar-expand-sm bg-light">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <%= link_to root_url, class: 'nav-link' do %>
                            <%= fa_icon 'home' %>
                        <% end %>
                    </li>
                                        
                    <% if current_user %>
                        <li class="nav-item">
                            <a class="nav-link disabled" href="#">>></a>
                        </li>  

                        <li class="nav-item">
                            <%= link_to @ctrl.humanize, url_for(controller: @ctrl), class: 'nav-link' %>
                        </li>

                        <% if id = params[:id] %>
                            <li class="nav-item">
                                <a class="nav-link disabled" href="#">>></a>
                            </li>              
                            
                            <li class="nav-item">
                                <%= link_to id.humanize, url_for(controller: @ctrl, action: :show, id: id), class: 'nav-link' %>
                            </li>
                        <% end %>
                    <% end %>
                </ul>
            </nav>
        })
    end    

end
