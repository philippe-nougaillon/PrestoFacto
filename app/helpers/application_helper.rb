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

    def navbar_nav_item(name, icon)
        render(inline: %{
            <li class="nav-item">
                <%= link_to url_for(controller: '#{name}'), 
                            class: 'nav-link #{@ctrl == name ? 'active bg-light' : 'text-secondary'}' do %>
                    <i class='fas fa-fw fa-#{icon}'></i>
                    #{name.humanize} 
                <% end %>
            </li>
        })
    end 

end
