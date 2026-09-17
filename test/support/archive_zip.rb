module ArchiveZip

  # Les entrées d'une archive ZIP tenue en mémoire : { nom de l'entrée => contenu binaire }
  def entrées_de_l_archive(archive)
    entrées = {}
    Zip::File.open_buffer(StringIO.new(archive)) do |zip|
      zip.each { |entrée| entrées[entrée.name] = entrée.get_input_stream.read }
    end
    entrées
  end
end
