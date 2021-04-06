# frozen_string_literal: true

# This module handles the errors when trying to import datas into the database
# Those errors occurs when clicking on the button 'Import' on 'index.html.haml' for each model
module ImportError

  class ImportFileError < RuntimeError
    def initialize(msg = nil)
      super
    end
  end

  class FileExistError < ImportFileError
    def initialize(msg = 'Vous devez d\'abord choisir un fichier avant d\'importer des données')
      super
    end
  end

  class ExtensionNameError < ImportFileError
    # @param file_name: string
    # @param valid_extensions: array<string>
    def initialize(file_name, valid_extensions)
      pack_ext = ''
      valid_extensions.each do |ext|
        pack_ext += "\"#{ext}\", "
      end
      super "Type de fichier non pris en charge : #{file_name} ! Les extensions valides sont : #{pack_ext[...-2]}"
    end
  end

  class SheetNameError < ImportFileError
    def initialize(sheet_name)
      super "Il manque la feuille \"#{sheet_name}\" dans votre fichier"
    end
  end

  class CellValueError < ImportFileError
    def initialize(msg = 'Certaines données dans votre feuille de calcul sont erronnées et n\'ont pas pu être importées')
      super
    end
  end

end
