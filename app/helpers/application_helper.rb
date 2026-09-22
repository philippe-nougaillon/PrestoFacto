module ApplicationHelper
    def sort_link(column, title = nil)
        title ||= (@model_class ? @model_class.human_attribute_name(column) : column.titleize)

        direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
        link_title = sort_direction == "asc" ? "Trier croissant" : "Trier décroissant"

        link_to url_for(request.parameters.merge(column: column, direction: direction)),
                class: "inline-flex items-center gap-0.5 font-semibold text-slate-700 hover:text-primary no-underline",
                title: link_title do
            safe_join([
                title,
                (embedded_svg("icons/#{sort_direction == "asc" ? 'arrow_drop_up' : 'arrow_drop_down'}.svg", class: "w-4 h-4") if column == sort_column)
            ].compact)
        end
    end

    def page_theme
        vitrine_publique? ? 'aikku' : 'corporate'
    end

    def vitrine_publique?
        return true if devise_controller? && !user_signed_in?
        return true if controller_name == 'pages'

        # Formulaire de contact
        controller_name == 'messages' && %w[new create].include?(action_name)
    end

    def navbar_link_classes(active)
        base = "h-16 px-3 flex items-center gap-1.5 text-secondary text-sm whitespace-nowrap " \
               "border-primary hover:border-b-2 hover:text-primary transition-colors"
        active ? "#{base} text-primary! border-b-2 bg-base-100!" : base
    end

    def dock_link_classes(active)
        active ? "dock-active text-primary! shadow" : "text-secondary hover:shadow"
    end

    def embedded_svg(filename, options = {})
        file_path = Rails.root.join('public', filename)
        file_path = Rails.root.join('app', 'assets', 'images', filename) unless File.exist?(file_path)
        return ''.html_safe unless File.exist?(file_path)

        doc = Nokogiri::HTML::DocumentFragment.parse(File.read(file_path))
        svg = doc.at_css('svg')
        return ''.html_safe if svg.nil?

        svg['class'] = "#{svg['class']} #{options[:class]}" if options[:class].present?

        if options[:title].present?
            svg['role'] = 'img'
            svg['aria-label'] = options[:title]
            title_node = Nokogiri::XML::Node.new('title', doc)
            title_node.content = options[:title]
            svg.prepend_child(title_node)
        else
            svg['aria-hidden'] = 'true'
        end

        doc.to_html.html_safe
    end
end
