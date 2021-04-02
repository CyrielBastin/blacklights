require 'roo'

# Module to import Spreadsheet into the database.
module ImportModel
  include DuplicateHelper

  def import_all
    imported = import_categories
    return imported if imported[:had_errors]
    imported = import_suppliers
    return imported if imported[:had_errors]
    imported = import_equipment
    return imported if imported[:had_errors]
    imported = import_activities
    return imported if imported[:had_errors]
    imported = import_locations
    return imported if imported[:had_errors]
    imported = import_events
    return imported if imported[:had_errors]

    { had_errors: false }
  end

  def import_categories
    sheet_name = 'Catégories'
    potential_errors = init_errors(sheet_name)
    begin
      category_sheet = open_import_sheet(sheet_name)
    rescue RangeError
      add_sheet_title_error(potential_errors, sheet_name)
      return potential_errors
    end
    row_header = { name: 'Nom', parent_name: 'Catégorie parente', category_for: 'Catégorie pour' }
    row_number = 1
    begin
      category_sheet.each(row_header) do |row|
        if row_number == 1
          row_number += 1
          next
        end
        if row[:parent_name].present?
          parent = Category.find_by(name: row[:parent_name])
          if parent.nil?
            potential_errors[:had_errors] = true
            next
          end
        end
        next if already_exists?(:Category, :name, row[:name])

        category = Category.new(name: row[:name], category_for: row[:category_for],
                                parent_id: row[:parent_name].nil? ? nil : Category.find_by(name: row[:parent_name]).id)
        if category.valid?
          category.save
        else
          potential_errors[:had_errors] = true
        end
      end

      add_data_error(potential_errors) if potential_errors[:had_errors] == true
      potential_errors
    rescue Roo::HeaderRowNotFoundError => e
      add_column_error(potential_errors, e.message, sheet_name, row_header)
      potential_errors
    end
  end

  def import_suppliers
    sheet_name = 'Fournisseurs'
    potential_errors = init_errors(sheet_name)
    begin
      supplier_sheet = open_import_sheet(sheet_name)
    rescue RangeError
      add_sheet_title_error(potential_errors, sheet_name)
      return potential_errors
    end
    row_header = { name: 'Entreprise', lastname: 'Nom de famille', firstname: 'Prénom', phone_number: 'Téléphone',
                   email: 'Email', street: 'Rue et numéro', zip_code: 'Code postal', city: 'Ville', country: 'Pays' }
    row_number = 1
    suppliers_to_push = []
    begin
      supplier_sheet.each(row_header) do |row|
        if row_number == 1
          row_number += 1
          next
        end
        next if already_exists?(:Supplier, :name, row[:name])

        supplier = Supplier.new(name: row[:name])
        supplier.contact = build_contact(row)
        if supplier.valid?
          suppliers_to_push << supplier
        else
          potential_errors[:had_errors] = true
        end
      end
      suppliers_to_push.each(&:save)
      add_data_error(potential_errors) if potential_errors[:had_errors] == true
      potential_errors
    rescue Roo::HeaderRowNotFoundError => e
      add_column_error(potential_errors, e.message, sheet_name, row_header)
      potential_errors
    end
  end

  def import_equipment
    sheet_name = 'Matériel'
    potential_errors = init_errors(sheet_name)
    begin
      equipment_sheet = open_import_sheet(sheet_name)
    rescue RangeError
      add_sheet_title_error(potential_errors, sheet_name)
      return potential_errors
    end
    row_header = { name: 'Nom', description: 'Description', unit_price: 'Prix (€)',
                   category_name: 'Catégorie', supplier_name: 'Fournisseur',
                   width: 'Largeur (cm)', length: 'Longueur (cm)', height: 'Hauteur (cm)', weight: 'Poids (g)' }
    row_number = 1
    equipment_to_push = []
    begin
      equipment_sheet.each(row_header) do |row|
        if row_number == 1
          row_number += 1
          next
        end
        next if already_exists?(:Equipment, :name, row[:name])

        category = Category.find_by(name: row[:category_name])
        supplier = Supplier.find_by(name: row[:supplier_name])
        equipment = Equipment.new(name: row[:name], description: row[:description], unit_price: row[:unit_price],
                                  category_id: category.nil? ? nil : category[:id],
                                  supplier_id: supplier.nil? ? nil : supplier[:id])
        equipment.dimension = build_dimensions(row)
        if equipment.valid?
          equipment_to_push << equipment
        else
          potential_errors[:had_errors] = true
        end
      end

      equipment_to_push.each(&:save)
      add_data_error(potential_errors) if potential_errors[:had_errors] == true
      potential_errors
    rescue Roo::HeaderRowNotFoundError => e
      add_column_error(potential_errors, e.message, sheet_name, row_header)
      potential_errors
    end
  end

  def import_activities
    sheet_name = 'Activités'
    potential_errors = init_errors(sheet_name)
    begin
      activity_sheet = open_import_sheet(sheet_name)
    rescue RangeError
      add_sheet_title_error(potential_errors, sheet_name)
      return potential_errors
    end
    row_header = { name: 'Nom', description: 'Description', list_equipment: 'Matériel + quantité' }
    row_number = 1
    activities_to_push = []
    begin
      activity_sheet.each(row_header) do |row|
        if row_number == 1
          row_number += 1
          next
        end
        next if already_exists?(:Activity, :name, row[:name])

        equipment_quantity = convert_element_qty(row[:list_equipment])
        activity = Activity.new(name: row[:name], description: row[:description])
        activity.activity_equipment = []
        equipment_quantity.each do |hash|
          equipment = Equipment.find_by(name: hash[:name])
          next if equipment.nil?
          activity.activity_equipment << ActivityEquipment.new(activity_id: activity,
                                                               equipment_id: equipment[:id],
                                                               quantity: hash[:quantity])
        end
        if activity.valid?
          activities_to_push << activity
        else
          potential_errors[:had_errors] = true
        end
      end

      activities_to_push.each(&:save)
      add_data_error(potential_errors) if potential_errors[:had_errors] == true
      potential_errors
    rescue Roo::HeaderRowNotFoundError => e
      add_column_error(potential_errors, e.message, sheet_name, row_header)
      potential_errors
    end
  end

  def import_locations
    sheet_name = 'Lieux'
    potential_errors = init_errors(sheet_name)
    begin
      location_sheet = open_import_sheet(sheet_name)
    rescue RangeError
      add_sheet_title_error(potential_errors, sheet_name)
      return potential_errors
    end
    row_header = { name: 'Nom', type: 'Type', list_activities: 'Activités disponibles',
                   width: 'Largeur (m)', length: 'Longueur (m)', height: 'Hauteur (m)',
                   lastname: 'Nom de famille', firstname: 'Prénom', phone_number: 'Téléphone', email: 'Email',
                   street: 'Rue et numéro', zip_code: 'Code postal', city: 'Ville', country: 'Pays' }
    row_number = 1
    locations_to_push = []
    begin
      location_sheet.each(row_header) do |row|
        if row_number == 1
          row_number += 1
          next
        end
        next if already_exists?(:Location, :name, row[:name])

        location = Location.new(name: row[:name], type: row[:type])
        location.dimension = build_dimensions(row)
        location.contact = build_contact(row)
        list_activities = convert_activities(row[:list_activities])
        location.location_activities = []
        list_activities.each do |activity_name|
          next if activity_name.empty?

          activity = Activity.find_by(name: activity_name)
          next if activity.nil?

          location.location_activities << LocationActivity.new(location_id: location, activity_id: activity[:id])
        end
        if location.valid?
          locations_to_push << location
        else
          potential_errors[:had_errors] = true
        end
      end

      locations_to_push.each(&:save)
      add_data_error(potential_errors) if potential_errors[:had_errors] == true
      potential_errors
    rescue Roo::HeaderRowNotFoundError => e
      add_column_error(potential_errors, e.message, sheet_name, row_header)
      potential_errors
    end
  end

  def import_events
    sheet_name = 'Evènements'
    potential_errors = init_errors(sheet_name)
    begin
      event_sheet = open_import_sheet(sheet_name)
    rescue RangeError
      add_sheet_title_error(potential_errors, sheet_name)
      return potential_errors
    end
    row_header = { name: 'Nom', start_date: 'Date de début', end_date: 'Date de fin',
                   registration_deadline: 'Clôture des inscriptions', min_participant: 'Min. participants',
                   max_participant: 'Max. participants', price: 'Prix (€)', location_name: 'Lieu',
                   list_activities: 'Activités + simultanée', list_equipment: 'Matériel supplémentaire + quantité',
                   lastname: 'Nom de famille', firstname: 'Prénom', phone_number: 'Téléphone', email: 'Email',
                   street: 'Rue et numéro', zip_code: 'Code postal', city: 'Ville', country: 'Pays' }
    row_number = 1
    events_to_push = []
    begin
      event_sheet.each(row_header) do |row|
        if row_number == 1
          row_number += 1
          next
        end
        exists = Event.find_by(name: row[:name], start_date: row[:start_date], end_date: row[:end_date])
        next unless exists.nil?

        event = Event.new(name: row[:name], start_date: convert_to_date_time(row[:start_date]),
                          end_date: convert_to_date_time(row[:end_date]), registration_deadline: convert_to_date_time(row[:registration_deadline]),
                          min_participant: row[:min_participant], max_participant: row[:max_participant], price: row[:price])
        event.contact = build_contact(row)
        location = Location.find_by(name: row[:location_name])
        event[:location_id] = location[:id] unless location.nil?
        list_activities = convert_element_qty(row[:list_activities]); event.event_activities = []
        list_activities.each do |hash|
          next unless already_exists?(:Activity, :name, hash[:name])
          event.event_activities << EventActivity.new(event_id: event, activity_id: activity[:id], simultaneous_activities: hash[:quantity])
        end
        list_equipment = convert_element_qty(row[:list_equipment]); event.event_equipment = []
        list_equipment.each do |hash|
          next unless already_exists?(:Equipment, :name, hash[:name])
          event.event_equipment << EventEquipment.new(event_id: event, equipment_id: equipment[:id], quantity: hash[:quantity])
        end
        if event.valid?
          events_to_push << event
        else
          potential_errors[:had_errors] = true
        end
      end

      events_to_push.each(&:save)
      add_data_error(potential_errors) if potential_errors[:had_errors] == true
      potential_errors
    rescue Roo::HeaderRowNotFoundError => e
      add_column_error(potential_errors, e.message, sheet_name, row_header)
      potential_errors
    end
  end

  private

  def open_import_sheet(sheet_name)
    document = Roo::Spreadsheet.open('import_models/models.xlsx')

    document.sheet(sheet_name)
  end

  def build_contact(hash)
    coordinates = Coordinate.new(street: hash[:street], zip_code: hash[:zip_code], city: hash[:city], country: hash[:country])
    contact = Contact.new(lastname: hash[:lastname], firstname: hash[:firstname], phone_number: hash[:phone_number], email: hash[:email])
    contact.coordinate = coordinates

    contact
  end

  def build_dimensions(hash)
    Dimension.new(width: hash[:width], length: hash[:length],
                  height: hash[:height], weight: hash[:weight].present? ? hash[:weight] : 0.01)
  end

  # Here, we receive a string containing the equipment or activity with their quantity
  # example : "Raquette (13.0), Ruban adhésif (25.0), ..."
  # We convert that string to an array of hashes
  # ===> [{ name: 'Raquette', quantity: 13.0 }, { name: 'Ruban adhésif', quantity: 25.0 }, ...]
  def convert_element_qty(string)
    return [] if string.nil?

    arr = string.split(',').collect(&:strip)
    result = []
    arr.each do |str|
      next if str.empty?

      md = str.match(/(.+)(\(.+\))/)
      name = md[1].strip
      quantity = md[2][1...-1]
      result << { name: name, quantity: quantity }
    end

    result
  end

  def convert_activities(string)
    return [] if string.nil?

    arr = string.split(',')
    arr.collect(&:strip)
  end

  def convert_to_date_time(str)
    return '' if str.nil?
    return '' unless str.match %r{[0-9]{2}/[0-9]{2}/[0-9]{4},.{3}[0-9]{2}:[0-9]{2}}

    date_time_arr = str.split(',')
    date_french = date_time_arr[0]
    time_french = date_time_arr[1][3..]
    split_date = date_french.split('/')
    date = "#{split_date[2]}-#{split_date[1]}-#{split_date[0]}"
    time = "#{time_french}:00"

    "#{date} #{time}"
  end

  def init_errors(sheet_name)
    { had_errors: false, errors: ["Erreur dans la Spreadsheet ! -->  Feuille \"#{sheet_name}\"",
                                  '--------------------------', ''] }
  end

  def add_sheet_title_error(err_hash, sheet_name)
    err_hash[:had_errors] = true
    err_hash[:errors] << "Feuille \"#{sheet_name}\" non trouvée dans le fichier !"
  end

  def add_column_error(err_hash, err_msg, page_name, col_hash)
    err_hash[:had_errors] = true
    err_hash[:errors] << "Oups, on dirait que les colonnes suivantes n'ont pas été trouvées #{err_msg}."
    str = ''
    col_hash.each do |_key, value|
      str += "\"#{value}\", "
    end
    err_hash[:errors] << "La feuille \"#{page_name}\" dois posséder les colonnes #{str[...-2]}."
    err_hash[:errors] << 'Ces colonnes doives être présentes dans cet ordre la et sur la 1ère ligne de la feuille !'
  end

  def add_data_error(err_hash)
    err_hash[:errors] << 'Il semblerait qu\'il y ait eue quelques erreurs par rapport aux données fournies !'
    err_hash[:errors] << 'Toutes les données n\'ont pas pu être importées !'
  end

end
