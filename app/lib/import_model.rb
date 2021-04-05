require 'roo'

# Module to import Spreadsheet into the database.
module ImportModel
  include ImportError
  include DuplicateHelper
  include ConvertFloat

  def import_all(file)
    potential_errors = init_errors('')
    begin
      raise FileExistError if file.nil?
      file_ext = File.extname(file.original_filename)
      raise ExtensionNameError.new(file.original_filename, valid_extensions) unless valid_extensions.include?(file_ext)
    rescue ImportFileError => e
      potential_errors[:had_errors] = true
      potential_errors[:err_messages] << e.message
      return potential_errors
    end
    imported = import_categories(file)
    return imported if imported[:had_errors]
    imported = import_suppliers(file)
    return imported if imported[:had_errors]
    imported = import_equipment(file)
    return imported if imported[:had_errors]
    imported = import_activities(file)
    return imported if imported[:had_errors]
    imported = import_locations(file)
    return imported if imported[:had_errors]
    imported = import_events(file)
    return imported if imported[:had_errors]

    potential_errors
  end


  def import_categories(file)
    sheet_name = 'Catégories'
    potential_errors = init_errors(sheet_name)
    begin
      raise FileExistError if file.nil?
      file_ext = File.extname(file.original_filename)
      raise ExtensionNameError.new(file.original_filename, valid_extensions) unless valid_extensions.include?(file_ext)
      document = (file_ext == '.xlsx') ? Roo::Excelx.new(file.path) : Roo::OpenOffice.new(file.path)
      sheet = nil
      begin
        sheet = document.sheet(sheet_name)
      rescue RangeError # The RangeError occurs when <sheet_name> doesn't exist in the document
      end
      raise SheetNameError.new(sheet_name) if sheet.nil?
      # Order for the columns in the sheet
      # Nom, Parent_name, Catégorie pour
      (2..sheet.last_row).each do |i|
        if sheet.row(i)[1].present?
          parent = Category.find_by(name: sheet.row(i)[1])
          if parent.nil?
            potential_errors[:cell_error] = true
            next
          end
        end
        next if already_exists?(:Category, :name, sheet.row(i)[0])

        category = Category.new(name: sheet.row(i)[0], category_for: sheet.row(i)[2],
                                parent_id: sheet.row(i)[1].nil? ? nil : Category.find_by(name: sheet.row(i)[1]).id)
        potential_errors[:cell_error] = true unless category.save
      end
      if potential_errors[:cell_error] == true
        potential_errors[:had_errors] = true
        raise CellValueError
      end
    rescue ImportFileError => e
      potential_errors[:had_errors] = true
      potential_errors[:err_messages] << e.message
    end

    potential_errors
  end


  def import_suppliers(file)
    sheet_name = 'Fournisseurs'
    potential_errors = init_errors(sheet_name)
    begin
      raise FileExistError if file.nil?
      file_ext = File.extname(file.original_filename)
      raise ExtensionNameError.new(file.original_filename, valid_extensions) unless valid_extensions.include?(file_ext)
      document = (file_ext == '.xlsx') ? Roo::Excelx.new(file.path) : Roo::OpenOffice.new(file.path)
      sheet = nil
      begin
        sheet = document.sheet(sheet_name)
      rescue RangeError # The RangeError occurs when <sheet_name> doesn't exist in the document
      end
      raise SheetNameError.new(sheet_name) if sheet.nil?
      suppliers_to_save = []
      # Order for the columns in the sheet
      # Entreprise, Nom de famille, Prénom, Téléphone, Email, Rue et numéro, Code postal, Ville, Pays
      (2..sheet.last_row).each do |i|
        next if already_exists?(:Supplier, :name, sheet.row(i)[0])

        supplier = Supplier.new(name: sheet.row(i)[0])
        supplier.contact = build_contact(sheet.row(i)[1..])
        if supplier.valid?
          suppliers_to_save << supplier
        else
          potential_errors[:cell_error] = true
        end
      end
      suppliers_to_save.each(&:save)
      if potential_errors[:cell_error] == true
        potential_errors[:had_errors] = true
        raise CellValueError
      end
    rescue ImportFileError => e
      potential_errors[:had_errors] = true
      potential_errors[:err_messages] << e.message
    end

    potential_errors
  end


  def import_equipment(file)
    sheet_name = 'Matériel'
    potential_errors = init_errors(sheet_name)
    begin
      raise FileExistError if file.nil?
      file_ext = File.extname(file.original_filename)
      raise ExtensionNameError.new(file.original_filename, valid_extensions) unless valid_extensions.include?(file_ext)
      document = (file_ext == '.xlsx') ? Roo::Excelx.new(file.path) : Roo::OpenOffice.new(file.path)
      sheet = nil
      begin
        sheet = document.sheet(sheet_name)
      rescue RangeError # The RangeError occurs when <sheet_name> doesn't exist in the document
      end
      raise SheetNameError.new(sheet_name) if sheet.nil?
      equipment_to_save = []
      # Order for the columns in the sheet
      # Nom, Description, Prix, Nom catégorie, Nom fournisseur, Largeur, Longueur, Hauteur, Poids
      (2..sheet.last_row).each do |i|
        next if already_exists?(:Equipment, :name, sheet.row(i)[0])

        category = Category.find_by(name: sheet.row(i)[3])
        supplier = Supplier.find_by(name: sheet.row(i)[4])
        equipment = Equipment.new(name: sheet.row(i)[0], description: sheet.row(i)[1], unit_price: to_english_repr(sheet.row(i)[2]),
                                  category_id: category.nil? ? nil : category[:id],
                                  supplier_id: supplier.nil? ? nil : supplier[:id])
        equipment.dimension = build_dimensions(sheet.row(i)[5..])

        if equipment.valid?
          equipment_to_save << equipment
        else
          potential_errors[:cell_error] = true
        end
      end
      equipment_to_save.each(&:save)
      if potential_errors[:cell_error] == true
        potential_errors[:had_errors] = true
        raise CellValueError
      end
    rescue ImportFileError => e
      potential_errors[:had_errors] = true
      potential_errors[:err_messages] << e.message
    end

    potential_errors
  end


  def import_activities(file)
    sheet_name = 'Activités'
    potential_errors = init_errors(sheet_name)
    begin
      raise FileExistError if file.nil?
      file_ext = File.extname(file.original_filename)
      raise ExtensionNameError.new(file.original_filename, valid_extensions) unless valid_extensions.include?(file_ext)
      document = (file_ext == '.xlsx') ? Roo::Excelx.new(file.path) : Roo::OpenOffice.new(file.path)
      sheet = nil
      begin
        sheet = document.sheet(sheet_name)
      rescue RangeError # The RangeError occurs when <sheet_name> doesn't exist in the document
      end
      raise SheetNameError.new(sheet_name) if sheet.nil?
      activities_to_save = []
      # Order for the columns in the sheet
      # Nom, Description, Matériel + qty
      (2..sheet.last_row).each do |i|
        next if already_exists?(:Activity, :name, sheet.row(i)[0])
        activity = Activity.new(name: sheet.row(i)[0], description: sheet.row(i)[1])
        list_equipment = convert_element_qty(sheet.row(i)[2])
        activity.activity_equipment = []
        list_equipment.each do |equipment|
          eq = Equipment.find_by(name: equipment[:name])
          next if eq.nil?
          activity.activity_equipment << ActivityEquipment.new(activity_id: activity,
                                                               equipment_id: eq[:id],
                                                               quantity: equipment[:quantity])
        end
        if activity.valid?
          activities_to_save << activity
        else
          potential_errors[:cell_error] = true
        end
      end
      activities_to_save.each(&:save)
      if potential_errors[:cell_error] == true
        potential_errors[:had_errors] = true
        raise CellValueError
      end
    rescue ImportFileError => e
      potential_errors[:had_errors] = true
      potential_errors[:err_messages] << e.message
    end

    potential_errors
  end


  def import_locations(file)
    sheet_name = 'Lieux'
    potential_errors = init_errors(sheet_name)
    begin
      raise FileExistError if file.nil?
      file_ext = File.extname(file.original_filename)
      raise ExtensionNameError.new(file.original_filename, valid_extensions) unless valid_extensions.include?(file_ext)
      document = (file_ext == '.xlsx') ? Roo::Excelx.new(file.path) : Roo::OpenOffice.new(file.path)
      sheet = nil
      begin
        sheet = document.sheet(sheet_name)
      rescue RangeError # The RangeError occurs when <sheet_name> doesn't exist in the document
      end
      raise SheetNameError.new(sheet_name) if sheet.nil?
      locations_to_save = []
      # Order for the columns in the sheet
      # Nom, Type, Activités, Largeur, Longueur, Hauteur, Nom de f., Prénom, Tél, Email, Rue, Code postal, Ville, Pays
      (2..sheet.last_row).each do |i|
        next if already_exists?(:Location, :name, sheet.row(i)[0])
        location = Location.new(name: sheet.row(i)[0], type: sheet.row(i)[1])
        location.dimension = build_dimensions(sheet.row(i)[3..5])
        location.contact = build_contact(sheet.row(i)[6..])
        list_activities = convert_activities(sheet.row(i)[2])
        location.location_activities = []
        list_activities.each do |activity_name|
          next if activity_name.empty?

          activity = Activity.find_by(name: activity_name)
          next if activity.nil?

          location.location_activities << LocationActivity.new(location_id: location, activity_id: activity[:id])
        end
        if location.valid?
          locations_to_save << location
        else
          potential_errors[:cell_error] = true
        end
      end
      locations_to_save.each(&:save)
      if potential_errors[:cell_error] == true
        potential_errors[:had_errors] = true
        raise CellValueError
      end
    rescue ImportFileError => e
      potential_errors[:had_errors] = true
      potential_errors[:err_messages] << e.message
    end

    potential_errors
  end


  def import_events(file)
    sheet_name = 'Evènements'
    potential_errors = init_errors(sheet_name)
    begin
      raise FileExistError if file.nil?
      file_ext = File.extname(file.original_filename)
      raise ExtensionNameError.new(file.original_filename, valid_extensions) unless valid_extensions.include?(file_ext)
      document = (file_ext == '.xlsx') ? Roo::Excelx.new(file.path) : Roo::OpenOffice.new(file.path)
      sheet = nil
      begin
        sheet = document.sheet(sheet_name)
      rescue RangeError # The RangeError occurs when <sheet_name> doesn't exist in the document
      end
      raise SheetNameError.new(sheet_name) if sheet.nil?
      events_to_save = []
      # Order for the columns in the sheet
      # Nom, Date début, Date fin, Clôture insc., Min par., Max par., Prix, Lieu, Activités, Matériel, Nom de f., Prénom, Tél, Email, Rue, Code postal, Ville, Pays
      (2..sheet.last_row).each do |i|
        exists = Event.find_by(name: sheet.row(i)[0], start_date: convert_to_date_time(sheet.row(i)[1]),
                               end_date: convert_to_date_time(sheet.row(i)[2]))
        next unless exists.nil?

        event = Event.new(name: sheet.row(i)[0], start_date: convert_to_date_time(sheet.row(i)[1]),
                          end_date: convert_to_date_time(sheet.row(i)[2]), registration_deadline: convert_to_date_time(sheet.row(i)[3]),
                          min_participant: sheet.row(i)[4], max_participant: sheet.row(i)[5], price: to_english_repr(sheet.row(i)[6]))
        event.contact = build_contact(sheet.row(i)[10..])
        location = Location.find_by(name: sheet.row(i)[7])
        event[:location_id] = location[:id] unless location.nil?
        list_activities = convert_element_qty(sheet.row(i)[8]); event.event_activities = []
        list_activities.each do |hash|
          next unless already_exists?(:Activity, :name, hash[:name])
          activity = Activity.find_by(name: hash[:name])
          next if activity.nil?
          event.event_activities << EventActivity.new(event_id: event, activity_id: activity[:id], simultaneous_activities: hash[:quantity])
        end
        list_equipment = convert_element_qty(sheet.row(i)[9]); event.event_equipment = []
        list_equipment.each do |hash|
          next unless already_exists?(:Equipment, :name, hash[:name])
          equipment = Equipment.find_by(name: hash[:name])
          next if equipment.nil?
          event.event_equipment << EventEquipment.new(event_id: event, equipment_id: equipment[:id], quantity: hash[:quantity])
        end
        if event.valid?
          events_to_save << event
        else
          potential_errors[:cell_error] = true
        end
      end
      events_to_save.each(&:save)
      if potential_errors[:cell_error] == true
        potential_errors[:had_errors] = true
        raise CellValueError
      end
    rescue ImportFileError => e
      potential_errors[:had_errors] = true
      potential_errors[:err_messages] << e.message
    end

    potential_errors
  end

  # ##################################################################################################
  private
  # ##################################################################################################

  # Returns an array containing the valid extensions for an imported file
  def valid_extensions
    %w[.xlsx .ods]
  end

  # @param datas: array<string>
  def build_contact(datas)
    coordinates = Coordinate.new(street: datas[4], zip_code: datas[5], city: datas[6], country: datas[7])
    contact = Contact.new(lastname: datas[0], firstname: datas[1], phone_number: datas[2], email: datas[3])
    contact.coordinate = coordinates

    contact
  end

  # @param datas: array<string>
  def build_dimensions(datas)
    Dimension.new(width: to_english_repr(datas[0]), length: to_english_repr(datas[1]),
                  height: to_english_repr(datas[2]), weight: datas[3].nil? ? 0.01 : to_english_repr(datas[3]))
  end

  # Here, we receive a string containing the equipment or activity with their quantity
  # example : "Raquette (13.0), Ruban adhésif (25.0), ..."
  # We convert that string to an array of hashes
  # ===> [{ name: 'Raquette', quantity: 13.0 }, { name: 'Ruban adhésif', quantity: 25.0 }, ...]
  def convert_element_qty(string)
    return [] if string.nil?

    arr = string.split('+').collect(&:strip)
    result = []
    arr.each do |str|
      next if str.empty?

      md = str.match(/(.+)(\(\d+[\.,]?\d*\))/)
      return [] if md.nil?
      name = md[1].strip
      quantity = to_english_repr md[2][1...-1]
      result << { name: name, quantity: quantity }
    end

    result
  end

  def convert_activities(string)
    return [] if string.nil?

    arr = string.split('+')
    arr.collect(&:strip)
  end

  def convert_to_date_time(str)
    return '' if str.nil?
    return '' unless str.match %r{\d{2}/\d{2}/\d{4},.{3}\d{2}:\d{2}} # 14/12/2022, à 17:45

    date_time_arr = str.split(',')
    date_french = date_time_arr[0]
    time_french = date_time_arr[1][3..]
    split_date = date_french.split('/')
    date = "#{split_date[2]}-#{split_date[1]}-#{split_date[0]}"
    time = "#{time_french}:00"

    "#{date} #{time}"
  end

  # @param sheet_name: string
  def init_errors(sheet_name)
    { had_errors: false,
      err_messages: ['Erreur avec le fichier importé !', " --> Feuille \"#{sheet_name}\"",
                     '----------------------------', ''],
      cell_error: false }
  end

end
