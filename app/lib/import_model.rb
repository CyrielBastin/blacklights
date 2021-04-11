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
    imported = import_registrations(file)
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
      # Nom, Parent_name, Catégorie pour, Id
      (2..sheet.last_row).each do |i|
        parent_id = nil
        if sheet.row(i)[1].present?
          parent = Category.find_by(name: sheet.row(i)[1])
          if parent.nil?
            potential_errors[:cell_error] = true
            next
          else
            parent_id = parent[:id]
          end
        end
        if already_exists?(:Category, sheet.row(i)[3])
          cat = Category.find(sheet.row(i)[3])
          unless cat.update(name: sheet.row(i)[0], parent_id: parent_id, category_for: sheet.row(i)[2])
            potential_errors[:cell_error] = true
          end
        else
          category = Category.new(name: sheet.row(i)[0], category_for: sheet.row(i)[2],
                                  parent_id: sheet.row(i)[1].nil? ? nil : Category.find_by(name: sheet.row(i)[1]).id)
          potential_errors[:cell_error] = true unless category.save
        end
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
      # Order for the columns in the sheet
      # Entreprise, Nom de famille, Prénom, Téléphone, Email, Rue et numéro, Code postal, Ville, Pays, Id
      (2..sheet.last_row).each do |i|
        contact = build_contact(sheet.row(i)[1..8])
        if already_exists?(:Supplier, sheet.row(i)[9])
          sup = Supplier.find(sheet.row(i)[9])
          sup.contact = contact
          potential_errors[:cell_error] = true unless sup.update(name: sheet.row(i)[0])
        else
          sup = Supplier.new(name: sheet.row(i)[0])
          sup.contact = contact
          potential_errors[:cell_error] = true unless sup.save
        end
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
      # Order for the columns in the sheet
      # Nom, Description, Prix, Nom catégorie, Nom fournisseur, Largeur, Longueur, Hauteur, Poids, Id
      (2..sheet.last_row).each do |i|
        category = Category.find_by(name: sheet.row(i)[3])
        supplier = Supplier.find_by(name: sheet.row(i)[4])
        dimensions = build_dimensions(sheet.row(i)[5..8])
        if already_exists?(:Equipment, sheet.row(i)[9])
          eq = Equipment.find(sheet.row(i)[9])
          eq.dimension = dimensions
          unless eq.update(name: sheet.row(i)[0], description: sheet.row(i)[1], unit_price: to_english_repr(sheet.row(i)[2]),
                           category_id: category.nil? ? nil : category[:id],
                           supplier_id: supplier.nil? ? nil : supplier[:id])
            potential_errors[:cell_error] = true
          end
        else
          eq = Equipment.new(name: sheet.row(i)[0], description: sheet.row(i)[1], unit_price: to_english_repr(sheet.row(i)[2]),
                             category_id: category.nil? ? nil : category[:id],
                             supplier_id: supplier.nil? ? nil : supplier[:id])
          eq.dimension = dimensions
          potential_errors[:cell_error] = true unless eq.save
        end
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
      # Order for the columns in the sheet
      # Nom, Description, Matériel + qty, Id, Lieux disp.
      (2..sheet.last_row).each do |i|
        list_equipment = convert_element_qty(sheet.row(i)[2])
        if already_exists?(:Activity, sheet.row(i)[3])
          act = Activity.find(sheet.row(i)[3])
          act.activity_equipment = []
          list_equipment.each do |e|
            eq = Equipment.find_by(name: e[:name])
            next if eq.nil?
            act.activity_equipment << ActivityEquipment.new(activity_id: act,
                                                            equipment_id: eq[:id],
                                                            quantity: e[:quantity])
          end
          potential_errors[:cell_error] = true unless act.update(name: sheet.row(i)[0], description: sheet.row(i)[1])
        else
          act = Activity.new(name: sheet.row(i)[0], description: sheet.row(i)[1])
          act.activity_equipment = []
          list_equipment.each do |e|
            eq = Equipment.find_by(name: e[:name])
            next if eq.nil?
            act.activity_equipment << ActivityEquipment.new(activity_id: act,
                                                            equipment_id: eq[:id],
                                                            quantity: e[:quantity])
          end
          potential_errors[:cell_error] = true unless act.save
        end
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
      # Order for the columns in the sheet
      # Nom, Capacité, Rue et num, Ville, Code p, Pays, Type, Activités, Largeur, Longueur, Hauteur,
      # Nom de f., Prénom, Tél, Email, Rue, Code postal, Ville, Pays, Id
      (2..sheet.last_row).each do |i|
        dimensions = build_dimensions(sheet.row(i)[8..10])
        contact = build_contact(sheet.row(i)[11..18])
        list_activities = convert_activities(sheet.row(i)[7])
        if already_exists?(:Location, sheet.row(i)[19])
          loc = Location.find(sheet.row(i)[19])
          loc.dimension = dimensions
          loc.contact = contact
          loc.location_activities = []
          list_activities.each do |a_name|
            next if a_name.empty?
            a = Activity.find_by(name: a_name)
            next if a.nil?
            loc.location_activities << LocationActivity.new(location_id: loc, activity_id: a[:id])
          end
          unless loc.update(name: sheet.row(i)[0], capacity: sheet.row(i)[1], street: sheet.row(i)[2], city: sheet.row(i)[3],
                            zip_code: sheet.row(i)[4], country: sheet.row(i)[5], type: sheet.row(i)[6])
            potential_errors[:cell_error] = true
          end
        else
          loc = Location.new(name: sheet.row(i)[0], capacity: sheet.row(i)[1], street: sheet.row(i)[2], city: sheet.row(i)[3],
                             zip_code: sheet.row(i)[4], country: sheet.row(i)[5], type: sheet.row(i)[6])
          loc.dimension = dimensions
          loc.contact = contact
          loc.location_activities = []
          list_activities.each do |a_name|
            next if a_name.empty?
            a = Activity.find_by(name: a_name)
            next if a.nil?
            loc.location_activities << LocationActivity.new(location_id: loc, activity_id: a[:id])
          end
          potential_errors[:cell_error] = true unless loc.save
        end
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
      # Order for the columns in the sheet
      # Nom, Date début, Date fin, Clôture insc., Min par., Max par., Prix, Lieu, Activités, Matériel,
      # Nom de f., Prénom, Tél, Email, Rue, Code postal, Ville, Pays, Id
      (2..sheet.last_row).each do |i|
        contact = build_contact(sheet.row(i)[10..17])
        location = Location.find_by(name: convert_location(sheet.row(i)[7])[0], city: convert_location(sheet.row(i)[7])[1])
        list_activities = convert_element_qty(sheet.row(i)[8])
        list_equipment = convert_element_qty(sheet.row(i)[9])
        if already_exists?(:Event, sheet.row(i)[18])
          e = Event.find(sheet.row(i)[18])
          e.contact = contact
          e[:location_id] = location[:id] if location.present?
          e.event_activities = []
          list_activities.each do |hash|
            act = Activity.find_by(name: hash[:name])
            next if act.nil?
            e.event_activities << EventActivity.new(event_id: e, activity_id: act[:id], simultaneous_activities: hash[:quantity])
          end
          e.event_equipment = []
          list_equipment.each do |hash|
            eq = Equipment.find_by(name: hash[:name])
            next if eq.nil?
            e.event_equipment << EventEquipment.new(event_id: e, equipment_id: eq[:id], quantity: hash[:quantity])
          end
          unless e.update(name: sheet.row(i)[0], start_date: convert_to_date_time(sheet.row(i)[1]),
                          end_date: convert_to_date_time(sheet.row(i)[2]), registration_deadline: convert_to_date_time(sheet.row(i)[3]),
                          min_participant: sheet.row(i)[4], max_participant: sheet.row(i)[5], price: to_english_repr(sheet.row(i)[6]))
            potential_errors[:cell_error] = true
          end
        else
          e = Event.new(name: sheet.row(i)[0], start_date: convert_to_date_time(sheet.row(i)[1]),
                            end_date: convert_to_date_time(sheet.row(i)[2]), registration_deadline: convert_to_date_time(sheet.row(i)[3]),
                            min_participant: sheet.row(i)[4], max_participant: sheet.row(i)[5], price: to_english_repr(sheet.row(i)[6]))
          e.contact = contact
          e[:location_id] = location[:id] unless location.nil?
          e.event_activities = []
          list_activities.each do |hash|
            act = Activity.find_by(name: hash[:name])
            next if act.nil?
            e.event_activities << EventActivity.new(event_id: e, activity_id: act[:id], simultaneous_activities: hash[:quantity])
          end
          e.event_equipment = []
          list_equipment.each do |hash|
            eq = Equipment.find_by(name: hash[:name])
            next if eq.nil?
            e.event_equipment << EventEquipment.new(event_id: e, equipment_id: eq[:id], quantity: hash[:quantity])
          end
          potential_errors[:cell_error] = true unless e.save
        end
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


  def import_registrations(file)
    sheet_name = 'Réservations'
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
      # Event name, e.location, e.date, e.id, User nom complet, u.email, u.id,
      # Date confirmation, Prix, Confirmation paiement, Id
      (2..sheet.last_row).each do |i|
        unless already_exists?(:Event, sheet.row(i)[3]) && already_exists?(:User, sheet.row(i)[6])
          potential_errors[:cell_error] = true
          next
        end
        event_id = Event.find(sheet.row(i)[3])[:id]
        user_id = User.find(sheet.row(i)[6])[:id]
        if already_exists?(:Registration, sheet.row(i)[10])
          r = Registration.find(sheet.row(i)[10])
          unless r.update(event_id: event_id, user_id: user_id, confirmation_datetime: convert_to_date_time(sheet.row(i)[7]),
                          price: to_english_repr(sheet.row(i)[8]), payment_confirmation_datetime: convert_to_date_time(sheet.row(i)[9]))
            potential_errors[:cell_error] = true
          end
        else
          r = Registration.new(event_id: event_id, user_id: user_id, confirmation_datetime: convert_to_date_time(sheet.row(i)[7]),
                               price: to_english_repr(sheet.row(i)[8]), payment_confirmation_datetime: convert_to_date_time(sheet.row(i)[9]))
          potential_errors[:cell_error] = true unless r.save
        end
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

    string.split('+').collect(&:strip)
  end

  # @param string [String]
  # @return [Array] [String, String]
  def convert_location(string)
    return [] if string.nil?

    string.split(',').collect(&:strip)
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
