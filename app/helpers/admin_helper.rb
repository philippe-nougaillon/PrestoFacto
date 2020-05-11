module AdminHelper

    def prettify(audit)    
        pretty_changes = []
        
        audit.audited_changes.each do |c|
            key = c.first.humanize
            if audit.action == 'update'
                unless c.last.first.blank? && c.last.last.blank?    
                    pretty_changes << "#{key} modifié de '#{c.last.first}' à '#{c.last.last}'"
                end
            else 
                unless c.last.blank?
                    pretty_changes << "#{key} #{audit.action == 'create' ? 'initialisé à' : 'était'} '#{c.last}'"
                end
            end
        end
        pretty_changes
    end

end