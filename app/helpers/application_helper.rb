module ApplicationHelper

    def sort_link(column, title = nil)
        title ||= (@model_class ? @model_class.human_attribute_name(column) : column.titleize)
        
        direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
        
        icon = sort_direction == "asc" ? "fas fa-sort-up" : "fas fa-sort-down"
        icon = column == sort_column ? icon : ""
        
        link_title = sort_direction == "asc" ? "Trier croissant" : "Trier décroissant"

        link_to "<span class='btn btn-sm' title=\"#{h link_title}\">#{h title} <i class=\"#{icon}\"></i></span>".html_safe, 
                url_for(request.parameters.merge(column: column, direction: direction))
    end

    def navbar_item(action_name, path, label = nil)
        is_active = params[:action] == action_name
        render(inline: %{
            <li class="nav-item">
                <%= link_to '#{ url_for(path) }', 
                            class: "nav-link text-#{ is_active ? 'dark active text-decoration-underline text-underline-offset-4' : 'secondary' }", style: "text-underline-offset: 5px;" do %>
                    #{ label ? label : action_name.humanize }
                <% end %>
            </li>
        })
    end

    def navbar_nav_item(controller_name, icon, icon_color, path, label = nil, turbo)

        is_active = params[:controller] == controller_name

        render(inline: %{
            <li class="nav-item" #{turbo ? "data-turbo='false'" : ""}>
                <%= link_to '#{ url_for(path) }', 
                            class: "nav-link text-#{ is_active ? 'dark active text-decoration-underline text-underline-offset-4' : 'secondary' }", style: "text-underline-offset: 5px;" do %>
                    <%= fa_icon '#{ icon }', class: "me-1 text-#{ icon_color }" %>#{ label ? label : controller_name.humanize }
                <% end %>
            </li>
        })
    end
end