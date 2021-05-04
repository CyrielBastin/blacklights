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
    imported = import_entities(file)
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
      # Nom, Catégorie parent, Numerotation, Type, Id
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
        type = case sheet.row(i)[3]
               when 'Activité'
                 'activity'
               when 'Matériel'
                 'equipment'
               when 'Evènement'
                 'event'
               else
                 ''
               end
        if already_exists?(:Category, sheet.row(i)[4])
          cat = Category.find(sheet.row(i)[4])
          unless cat.update(name: sheet.row(i)[0], parent_id: parent_id, type: type)
            potential_errors[:cell_error] = true
          end
        else
          category = Category.new(name: sheet.row(i)[0], parent_id: parent_id, type: type)
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
      # Nom, Email, Téléphone, Code postal, Ville, Pays, Contact supp. (Id), Id
      (2..sheet.last_row).each do |i|
        list_users = convert_activities(sheet.row(i)[6])
        if already_exists?(:Supplier, sheet.row(i)[7])
          sup = Supplier.find(sheet.row(i)[7])
          sup.supplier_users = []
          list_users.each do |user_id|
            next if user_id.nil?
            begin
              u = User.find(user_id)
              sup.supplier_users << SupplierUser.new(supplier_id: sheet.row(i)[7], user_id: u[:id])
            rescue ActiveRecord::RecordNotFound
            end
          end
          potential_errors[:cell_error] = true unless sup.update(name: sheet.row(i)[0], email: sheet.row(i)[1],
                                                                 phone_number: sheet.row(i)[2], zip_code: sheet.row(i)[3],
                                                                 city: sheet.row(i)[4], country: sheet.row(i)[5])
        else
          sup = Supplier.new(name: sheet.row(i)[0], email: sheet.row(i)[1],
                             phone_number: sheet.row(i)[2], zip_code: sheet.row(i)[3],
                             city: sheet.row(i)[4], country: sheet.row(i)[5])
          list_users.each do |user_id|
            next if user_id.nil?
            begin
              u = User.find(user_id)
              sup.supplier_users << SupplierUser.new(supplier_id: sheet.row(i)[7], user_id: u[:id])
            rescue ActiveRecord::RecordNotFound
            end
          end
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
      # Nom, Description, Catégorie, Publique ?, Matériel + qty, Id, Lieux disp.
      (2..sheet.last_row).each do |i|
        list_equipment = convert_element_qty(sheet.row(i)[4])
        category = Category.find_by(name: sheet.row(i)[2])
        visible = case sheet.row(i)[3]
                  when 'Oui'
                    true
                  else
                    false
                  end
        if already_exists?(:Activity, sheet.row(i)[5])
          act = Activity.find(sheet.row(i)[5])
          act.activity_equipment = []
          list_equipment.each do |e|
            eq = Equipment.find_by(name: e[:name])
            next if eq.nil?
            act.activity_equipment << ActivityEquipment.new(activity_id: act[:id],
                                                            equipment_id: eq[:id],
                                                            quantity: e[:quantity])
          end
          potential_errors[:cell_error] = true unless act.update(name: sheet.row(i)[0], description: sheet.row(i)[1],
                                                                 visible: visible,
                                                                 category_id: category.present? ? category[:id] : nil)
        else
          act = Activity.new(name: sheet.row(i)[0], description: sheet.row(i)[1], visible: visible,
                             category_id: category.present? ? category[:id] : nil)
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
      # Nom, Type, Capacité, Rue et num, Code p, Ville, Pays, Activités, Largeur, Longueur, Hauteur,
      # Contact (user Id), Id
      (2..sheet.last_row).each do |i|
        next if sheet.row(i)[11].nil?
        dimensions = build_dimensions(sheet.row(i)[8..10])
        type = convert_type(sheet.row(i)[1])
        user = nil
        begin
          user = User.find(sheet.row(i)[11])
        rescue ActiveRecord::RecordNotFound
        end
        list_activities = convert_activities(sheet.row(i)[7])
        if already_exists?(:Location, sheet.row(i)[12])
          loc = Location.find(sheet.row(i)[12])
          loc.dimension = dimensions
          loc.location_activities = []
          list_activities.each do |a_name|
            next if a_name.empty?
            a = Activity.find_by(name: a_name)
            next if a.nil?
            loc.location_activities << LocationActivity.new(location_id: loc, activity_id: a[:id])
          end
          unless loc.update(name: sheet.row(i)[0], type: type, capacity: sheet.row(i)[2], street: sheet.row(i)[3],
                            city: sheet.row(i)[5], zip_code: sheet.row(i)[4], country: sheet.row(i)[6],
                            user_id: user.present? ? user[:id] : nil)
            potential_errors[:cell_error] = true
          end
        else
          loc = Location.new(name: sheet.row(i)[0], type: type, capacity: sheet.row(i)[2], street: sheet.row(i)[3],
                             city: sheet.row(i)[5], zip_code: sheet.row(i)[4], country: sheet.row(i)[6],
                             user_id: user.present? ? user[:id] : nil)
          loc.dimension = dimensions
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
      # Nom, Type, Catégorie, Date début, Date fin, Clôture insc., Min par., Max par., Prix, Lieu, Activités, Matériel,
      # Contact (user Id), Id
      (2..sheet.last_row).each do |i|
        location = Location.find_by(name: convert_location(sheet.row(i)[9])[0], city: convert_location(sheet.row(i)[9])[1])
        list_activities = convert_element_qty(sheet.row(i)[10])
        list_equipment = convert_element_qty(sheet.row(i)[11])
        type = convert_type(sheet.row(i)[1])
        category = Category.find_by(name: sheet.row(i)[2])
        user = nil
        begin
          user = User.find(sheet.row(i)[12])
        rescue ActiveRecordError::RecordNotFound
        end
        if already_exists?(:Event, sheet.row(i)[13])
          e = Event.find(sheet.row(i)[13])
          e[:location_id] = location[:id] if location.present?
          e.event_activities = []
          list_activities.each do |hash|
            act = Activity.find_by(name: hash[:name])
            next if act.nil?
            e.event_activities << EventActivity.new(event_id: e, activity_id: act[:id], quantity: hash[:quantity])
          end
          e.event_equipment = []
          list_equipment.each do |hash|
            eq = Equipment.find_by(name: hash[:name])
            next if eq.nil?
            e.event_equipment << EventEquipment.new(event_id: e, equipment_id: eq[:id], quantity: hash[:quantity])
          end
          unless e.update(name: sheet.row(i)[0], type: type, category_id: category.present? ? category[:id] : nil,
                          start_date: convert_to_date_time(sheet.row(i)[3]), end_date: convert_to_date_time(sheet.row(i)[4]),
                          registration_deadline: convert_to_date_time(sheet.row(i)[5]), min_participant: sheet.row(i)[6],
                          max_participant: sheet.row(i)[7], price: to_english_repr(sheet.row(i)[8]),
                          user_id: user.present? ? user[:id] : nil)
            potential_errors[:cell_error] = true
          end
        else
          e = Event.new(name: sheet.row(i)[0], type: type, category_id: category.present? ? category[:id] : nil,
                        start_date: convert_to_date_time(sheet.row(i)[3]), end_date: convert_to_date_time(sheet.row(i)[4]),
                        registration_deadline: convert_to_date_time(sheet.row(i)[5]), min_participant: sheet.row(i)[6],
                        max_participant: sheet.row(i)[7], price: to_english_repr(sheet.row(i)[8]),
                        user_id: user.present? ? user[:id] : nil)
          e[:location_id] = location[:id] unless location.nil?
          e.event_activities = []
          list_activities.each do |hash|
            act = Activity.find_by(name: hash[:name])
            next if act.nil?
            e.event_activities << EventActivity.new(event_id: e, activity_id: act[:id], quantity: hash[:quantity])
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


  def import_event_registrations(file, event_id)
    sheet_name = ''
    potential_errors = init_errors(sheet_name)
    begin
      raise FileExistError if file.nil?
      file_ext = File.extname(file.original_filename)
      raise ExtensionNameError.new(file.original_filename, valid_extensions) unless valid_extensions.include?(file_ext)
      document = (file_ext == '.xlsx') ? Roo::Excelx.new(file.path) : Roo::OpenOffice.new(file.path)
      # Order for the columns in the sheet
      # User_id, Date confirmation, Prix, Date confirmation paiement
      (2..document.last_row).each do |i|
        user_id = nil
        begin
          user_id = User.find(document.row(i)[0])[:id]
        rescue ActiveRecord::RecordNotFound
        end
        r = Registration.new(event_id: event_id, user_id: user_id, confirmation_datetime: convert_to_date_time(document.row(i)[1]),
                             price: to_english_repr(document.row(i)[2]), payment_confirmation_datetime: convert_to_date_time(document.row(i)[3]))
        potential_errors[:cell_error] = true unless r.save
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


  def import_entities(file)
    sheet_name = 'Associations'
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
      # Nom, Catégorie, Utilisateurs (id), Lieux (id), Activités (id), Evènements (id), Id
      (2..sheet.last_row).each do |i|
        category = Category.find_by(name: sheet.row(i)[1])
        list_users = convert_activities(sheet.row(i)[2])
        list_locations = convert_activities(sheet.row(i)[3])
        list_activities = convert_activities(sheet.row(i)[4])
        list_events = convert_activities(sheet.row(i)[5])
        if already_exists?(:Entity, sheet.row(i)[6])
          ent = Entity.find(sheet.row(i)[6])
          ent.entity_users = []
          list_users.each do |user_id|
            next if user_id.nil?
            begin
              u = User.find(user_id)
              ent.entity_users << EntityUser.new(entity_id: sheet.row(i)[6], user_id: u[:id])
            rescue ActiveRecord::RecordNotFound
            end
          end
          ent.entity_locations = []
          list_locations.each do |loc_id|
            next if loc_id.nil?
            begin
              l = Location.find(loc_id)
              ent.entity_locations << EntityLocation.new(entity_id: sheet.row(i)[6], location_id: l[:id])
            rescue ActiveRecord::RecordNotFound
            end
          end
          ent.entity_activities = []
          list_activities.each do |act_id|
            next if act_id.nil?
            begin
              a = Activity.find(act_id)
              ent.entity_activities << EntityActivity.new(entity_id: sheet.row(i)[6], activity_id: a[:id])
            rescue ActiveRecord::RecordNotFound
            end
          end
          ent.entity_events = []
          list_events.each do |event_id|
            next if event_id.nil?
            begin
              e = Event.find(event_id)
              ent.entity_events << EntityEvent.new(entity_id: sheet.row(i)[6], event_id: e[:id])
            rescue ActiveRecord::RecordNotFound
            end
          end
          potential_errors[:cell_error] = true unless ent.update(name: sheet.row(i)[0],
                                                                 category_id: category.present? ? category[:id] : nil)
        else
          ent = Entity.new(name: sheet.row(i)[0], category_id: category.present? ? category[:id] : nil)
          ent.entity_users = []
          list_users.each do |user_id|
            next if user_id.nil?
            begin
              u = User.find(user_id)
              ent.entity_users << EntityUser.new(entity_id: sheet.row(i)[6], user_id: u[:id])
            rescue ActiveRecord::RecordNotFound
            end
          end
          ent.entity_locations = []
          list_locations.each do |loc_id|
            next if loc_id.nil?
            begin
              l = Location.find(loc_id)
              ent.entity_locations << EntityLocation.new(entity_id: sheet.row(i)[6], location_id: l[:id])
            rescue ActiveRecord::RecordNotFound
            end
          end
          ent.entity_activities = []
          list_activities.each do |act_id|
            next if act_id.nil?
            begin
              a = Activity.find(act_id)
              ent.entity_activities << EntityActivity.new(entity_id: sheet.row(i)[6], activity_id: a[:id])
            rescue ActiveRecord::RecordNotFound
            end
          end
          ent.entity_events = []
          list_events.each do |event_id|
            next if event_id.nil?
            begin
              e = Event.find(event_id)
              ent.entity_events << EntityEvent.new(entity_id: sheet.row(i)[6], event_id: e[:id])
            rescue ActiveRecord::RecordNotFound
            end
          end
          potential_errors[:cell_error] = true unless ent.save
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

  # @param [String] str
  # @return [String]
  def convert_type(str)
    case str
    when 'Public'
      'public'
    when 'Privé'
      'private'
    else
      ''
    end
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
                  height: to_english_repr(datas[2]), weight: datas[3].nil? ? nil : to_english_repr(datas[3]))
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

    string.to_s.split('+').collect(&:strip)
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
