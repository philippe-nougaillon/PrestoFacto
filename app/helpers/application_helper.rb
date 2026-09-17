module ApplicationHelper
    MATERIAL_SYMBOLS = {
        'balance-scale'      => 'balance',
        'book-open'          => 'menu_book',
        'calendar-alt'       => 'calendar_month',
        'calendar-check'     => 'event_available',
        'calendar-day'       => 'today',
        'calendar-times'     => 'event_busy',
        'check'              => 'check',
        'check-circle'       => 'check_circle',
        'check-square'       => 'check_box',
        'child'              => 'accessibility_new',
        'city'               => 'location_city',
        'comment'            => 'chat_bubble',
        'comment-dots'       => 'chat',
        'comments'           => 'forum',
        'edit'               => 'edit',
        'envelope'           => 'mail',
        'envelope-open'      => 'drafts',
        'euro-sign'          => 'euro_symbol',
        'exclamation'        => 'priority_high',
        'exclamation-circle' => 'error',
        'file-excel'         => 'table_view',
        'file-import'        => 'upload_file',
        'file-invoice'       => 'description',
        'file-pdf'           => 'picture_as_pdf',
        'home'               => 'home',
        'info-circle'        => 'info',
        'mail-bulk'          => 'forward_to_inbox',
        'money-bill-alt'     => 'payments',
        'paper-plane'        => 'send',
        'phone'              => 'call',
        'plus'               => 'add',
        'plus-circle'        => 'add_circle',
        'question-circle'    => 'help',
        'school'             => 'school',
        'search'             => 'search',
        'skull-crossbones'   => 'skull',
        'sort-down'          => 'arrow_drop_down',
        'sort-up'            => 'arrow_drop_up',
        'tachometer-alt'     => 'speed',
        'trash-alt'          => 'delete',
        'umbrella-beach'     => 'beach_access',
        'user'               => 'person',
        'user-friends'       => 'groups',
        'user-plus'          => 'person_add',
        'users'              => 'groups',
        'users-cog'          => 'manage_accounts',
        'utensils'           => 'restaurant'
    }.freeze

    # Espace mesuré sous le dessin de l'icône, en em, quand il diffère des 0,08 em de la grille Material.
    ESPACE_SOUS_ICONE = {
        'add' => 0.21, 'arrow_drop_down' => 0.38, 'arrow_drop_up' => 0.42, 'balance' => 0.13,
        'beach_access' => 0.13, 'call' => 0.13, 'check' => 0.25, 'check_box' => 0.13, 'delete' => 0.13,
        'drafts' => 0.13, 'edit' => 0.13, 'euro_symbol' => 0.13, 'forward_to_inbox' => 0.04, 'groups' => 0.25,
        'home' => 0.13, 'location_city' => 0.13, 'mail' => 0.17, 'manage_accounts' => 0.13, 'menu_book' => 0.16,
        'payments' => 0.17, 'person' => 0.17, 'person_add' => 0.17, 'priority_high' => 0.13, 'school' => 0.12,
        'search' => 0.13, 'send' => 0.16, 'speed' => 0.17
    }.freeze

    # Accepte une clé de MATERIAL_SYMBOLS ou directement un nom Material.
    def mi_icon(name, options = {})
        symbol = MATERIAL_SYMBOLS.fetch(name.to_s, name.to_s.tr('-', '_'))
        espace = ESPACE_SOUS_ICONE[symbol]
        icon = tag.span(symbol,
                        class: "material-symbols-outlined #{options[:class]}".strip,
                        style: ("--espace-sous-icone: #{espace}em" if espace),
                        title: options[:title],
                        aria: { hidden: options[:title].blank? })
        return icon if options[:text].blank?

        safe_join([icon, ' ', options[:text]])
    end

    def sort_link(column, title = nil)
        title ||= (@model_class ? @model_class.human_attribute_name(column) : column.titleize)

        direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
        link_title = sort_direction == "asc" ? "Trier croissant" : "Trier décroissant"

        link_to url_for(request.parameters.merge(column: column, direction: direction)),
                class: "inline-flex items-center gap-0.5 font-semibold text-slate-700 hover:text-primary no-underline",
                title: link_title do
            safe_join([
                title,
                (mi_icon(sort_direction == "asc" ? 'sort-up' : 'sort-down', class: 'text-base') if column == sort_column)
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
