require 'roo'

# Module to import Spreadsheet to the database.
# Each method import_* will return <true> if no errors occured during the import
# If errors occured, they will return an array of strings each string containing informations about the error
module ImportModel

  def import_all
    import_categories
    import_suppliers
    import_equipment
    import_activities
    import_locations
    import_events
  end

  def import_categories
    potential_errors = { had_errors: false, errors: ['Erreur dans la Spreadsheet !', '--------------------------', ''] }
    begin
      category_sheet = open_import_sheet('Catégories')
    rescue RangeError
      potential_errors[:had_errors] = true
      potential_errors[:errors] << 'Feuille "Catégories" non trouvée dans le fichier !'
      return potential_errors
    end
    row_number = 1
    begin
      category_sheet.each(name: 'Nom', parent_name: 'Catégorie parente', category_for: 'Catégorie pour') do |c_hash|
        if row_number == 1
          row_number += 1
          next
        end

        if c_hash[:parent_name].nil?
          category = Category.new(name: c_hash[:name], category_for: c_hash[:category_for])
          add_to_errors(potential_errors, row_number, category) unless category.save
        else
          parent = Category.find_by(name: c_hash[:parent_name])
          add_to_errors(potential_errors, row_number, parent, c_hash[:parent_name]) if parent.nil?
          category = Category.new(name: c_hash[:name], category_for: c_hash[:category_for])
          add_to_errors(potential_errors, row_number, category) unless category.save
        end
        row_number += 1
      end

      return potential_errors
    rescue Roo::HeaderRowNotFoundError => e
      potential_errors[:had_errors] = true
      potential_errors[:errors] << "Oups, on dirait que les colonnes suivantes n'ont pas été trouvées #{e.message}."
      potential_errors[:errors] << 'La feuille "Catégories" dois posséder les colonnes "Nom", "Catégorie parente", "Catégorie pour".'
      potential_errors[:errors] << 'Ces colonnes doives être présentes dans l\'ordre donné et sur la 1ère ligne de la feuille.'
      return potential_errors
    end

  end

  def import_suppliers
    supplier_sheet = open_import_sheet('Fournisseurs')
    supplier_sheet.each(name: 'Entreprise',
                        lastname: 'Nom de famille', firstname: 'Prénom', phone_number: 'Téléphone', email: 'Email',
                        street: 'Rue et numéro', zip_code: 'Code postal', city: 'Ville', country: 'Pays') do |s_hash|
      next if s_hash[:name] == 'Entreprise'

      supplier = Supplier.new(name: s_hash[:name])
      supplier.contact = build_contact(s_hash)
      supplier.save
    end
  end

  def import_equipment
    equipment_sheet = open_import_sheet('Matériel')
    equipment_sheet.each(name: 'Nom', description: 'Description', unit_price: 'Prix (€)',
                         category_name: 'Catégorie', supplier_name: 'Fournisseur',
                         width: 'Largeur (cm)', length: 'Longueur (cm)', height: 'Hauteur (cm)', weight: 'Poids (g)') do |e_hash|
      next if e_hash[:name] == 'Nom'

      category = Category.find_by(name: e_hash[:category_name])
      supplier = Supplier.find_by(name: e_hash[:supplier_name])
      equipment = Equipment.new(name: e_hash[:name], description: e_hash[:description], unit_price: e_hash[:unit_price],
                                category_id: category.id, supplier_id: supplier.id)
      equipment.dimension = build_dimensions(e_hash)
      equipment.save
    end
  end

  def import_activities
    activity_sheet = open_import_sheet('Activités')
    activity_sheet.each(name: 'Nom', description: 'Description', list_equipment: 'Matériel + quantité') do |a_hash|
      next if a_hash[:name] == 'Nom'

      equipment_quantity = convert_element_qty(a_hash[:list_equipment])
      activity = Activity.new(name: a_hash[:name], description: a_hash[:description])
      activity.activity_equipment = []
      equipment_quantity.each do |hash|
        equipment_id = Equipment.find_by(name: hash[:name]).id
        activity.activity_equipment << ActivityEquipment.new(activity_id: activity, equipment_id: equipment_id,
                                                             quantity: hash[:quantity])
      end
      activity.save
    end
  end

  def import_locations
    location_sheet = open_import_sheet('Lieux')
    location_sheet.each(name: 'Nom', type: 'Type',
                        list_activities: 'Activités disponibles',
                        width: 'Largeur (m)', length: 'Longueur (m)', height: 'Hauteur (m)',
                        lastname: 'Nom de famille', firstname: 'Prénom', phone_number: 'Téléphone', email: 'Email',
                        street: 'Rue et numéro', zip_code: 'Code postal', city: 'Ville', country: 'Pays') do |l_hash|
      next if l_hash[:name] == 'Nom'

      location = Location.new(name: l_hash[:name], type: l_hash[:type])
      location.dimension = build_dimensions(l_hash)
      location.contact = build_contact(l_hash)
      list_activities = convert_activities(l_hash[:list_activities])
      location.location_activities = []
      list_activities.each do |activity_name|
        next if activity_name.empty?

        activity = Activity.find_by(name: activity_name)
        location.location_activities << LocationActivity.new(location_id: location, activity_id: activity.id) if activity.present?
      end
      location.save
    end
  end

  def import_events
    event_sheet = open_import_sheet('Evènements')
    event_sheet.each(name: 'Nom', start_date: 'Date de début', end_date: 'Date de fin', registration_deadline: 'Clôture des inscriptions',
                     min_participant: 'Min. participants', max_participant: 'Max. participants', price: 'Prix (€)',
                     location_name: 'Lieu',
                     list_activities: 'Activités + simultanée', list_equipment: 'Matériel supplémentaire + quantité',
                     lastname: 'Nom de famille', firstname: 'Prénom', phone_number: 'Téléphone', email: 'Email',
                     street: 'Rue et numéro', zip_code: 'Code postal', city: 'Ville', country: 'Pays') do |e_hash|
      next if e_hash[:name] == 'Nom'

      event = Event.new(name: e_hash[:name], start_date: convert_to_date_time(e_hash[:start_date]),
                        end_date: convert_to_date_time(e_hash[:end_date]), registration_deadline: convert_to_date_time(e_hash[:registration_deadline]),
                        min_participant: e_hash[:min_participant], max_participant: e_hash[:max_participant], price: e_hash[:price])
      event.contact = build_contact(e_hash)
      event.location_id = Location.find_by(name: e_hash[:location_name]).id
      list_activities = convert_element_qty(e_hash[:list_activities]); event.event_activities = []
      list_activities.each do |hash|
        activity_id = Activity.find_by(name: hash[:name]).id
        event.event_activities << EventActivity.new(event_id: event, activity_id: activity_id, simultaneous_activities: hash[:quantity])
      end
      list_equipment = convert_element_qty(e_hash[:list_equipment]); event.event_equipment = []
      list_equipment.each do |hash|
        equipment_id = Equipment.find_by(name: hash[:name]).id
        event.event_equipment << EventEquipment.new(event_id: event, equipment_id: equipment_id, quantity: hash[:quantity])
      end
      event.save
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

      md = str.match /(.+)(\(.+\))/
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
    date_time_arr = str.split(',')
    date_french = date_time_arr[0]
    time_french = date_time_arr[1][3..]
    split_date = date_french.split('/')
    date = "#{split_date[2]}-#{split_date[1]}-#{split_date[0]}"
    time = "#{time_french}:00"

    "#{date} #{time}"
  end

  def add_to_errors(potential_errors, line_number, object, associated_name = '')
    potential_errors[:had_errors] = true
    if object.nil?
      potential_errors[:errors] << "Erreur à la ligne #{line_number} -> #{associated_name} n'existe pas"
    else
      object.attributes.each do |attr_key, _attr_value|
        arr_err = object.errors.full_messages_for(attr_key.to_s)
        potential_errors[:errors] << "Erreur à la ligne #{line_number} -> #{arr_err.join(', ')}" unless arr_err.empty?
      end
    end
  end

end
