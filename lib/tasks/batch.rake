# frozen_string_literal: true

require 'csv'

# create empty hashes in global vars to store input vocab and ids

@departments = {}
@repair_type = {}
@vendor = {}
@staff_code = {}
@housing = {}
@treatment_time = {}

# open csv files to load input vocab with ids

CSV.foreach('lib/assets/departments.csv', headers: true, return_headers: false) do |i|
  @departments[(i[0])] = i[1]
end

CSV.foreach('lib/assets/types_of_repairs.csv', headers: true, return_headers: false) do |i|
  @repair_type[(i[0])] = i[1]
end

CSV.foreach('lib/assets/contract_conservators.csv', headers: true, return_headers: false) do |i|
  @vendor[(i[0])] = i[1]
end

CSV.foreach('lib/assets/housing.csv', headers: true, return_headers: false) do |i|
  @housing[(i[0])] = i[1]
end

CSV.foreach('lib/assets/performed_treatment_time.csv', headers: false) do |i|
  @treatment_time[(i[0])] = i[1]
end

def open_input_csv
  return if ENV['CSV_LOCATION'].blank?

  CSV.read(ENV['CSV_LOCATION'], col_sep: ',', headers: true, row_sep: :auto)
end

# method to use input id for target id lookup

def vocab(input_type, input_key)
  ControlledVocabulary.find_by(vocabulary: input_type, key: input_key).id if input_key.present?
end

def user_lookup(name)
  class << self
    def assign_temp_user(name)
      puts "User account #{name} not found"
      User.find_by(display_name: 'Temporary User').id
    end
  end

  user = User.find_by(display_name: name)
  user.present? ? user.id : assign_temp_user(name) # assign temp user
end

def staff_code_lookup(code)
  if code.present?
    StaffCode.find_by(code: code).id
  else
    '4'
  end
end

def create_in_house_repair_reports(row)
  if row['Type In-house Repair'].present?
    InHouseRepairRecord.create!(repair_type: vocab('repair_type', row['Type In-house Repair']),
                                performed_by_user_id: user_lookup(row['Preformed In-house Repair']),
                                minutes_spent: row['Time In-house Repair'],
                                conservation_record_id: row['Database ID'],
                                staff_code_id: staff_code_lookup(row['Staff Code']))
    puts '   - Attached in-house repair'
  end
  if row['Type In-house Repair 2'].present?
    InHouseRepairRecord.create!(repair_type: vocab('repair_type', row['Type In-house Repair 2']),
                                performed_by_user_id: user_lookup(row['Preformed In-house Repair 2']),
                                minutes_spent: row['Time In-house Repair 2'],
                                conservation_record_id: row['Database ID'],
                                staff_code_id: staff_code_lookup(row['Staff Code2']))
    puts '   - Attached in-house repair'
  end
  if row['Type In-house Repair 3'].present?
    InHouseRepairRecord.create!(repair_type: vocab('repair_type', row['Type In-house Repair 3']),
                                performed_by_user_id: user_lookup(row['Preformed In-house Repair 3']),
                                minutes_spent: row['Time In-house Repair 3'],
                                conservation_record_id: row['Database ID'],
                                staff_code_id: staff_code_lookup(row['Staff Code3']))
    puts '   - Attached in-house repair'
  end
  if row['Type In-house Repair other'].present? # rubocop:disable Style/GuardClause
    InHouseRepairRecord.create!(repair_type: vocab('repair_type', 'Other'),
                                performed_by_user_id: user_lookup(row['Preformed In-house Repair other']),
                                minutes_spent: row['Time In-house Repair other'],
                                conservation_record_id: row['Database ID'],
                                other_note: row['Type In-house Repair other'],
                                staff_code_id: staff_code_lookup(row['Staff Codes other']))
    puts '   - Attached in-house repair'
  end
end

def create_external_repair_reports(row)
  if row['Type Vendor Repair'].present?
    ExternalRepairRecord.create!(repair_type: vocab('repair_type', row['Type Vendor Repair']),
                                 performed_by_vendor_id: vocab('vendor', row['Preformed by Vendor']),
                                 conservation_record_id: row['Database ID'])
    puts '   - Attached external repair'
  end
  if row['Type Vendor Repair 2'].present?
    ExternalRepairRecord.create!(repair_type: vocab('repair_type', row['Type Vendor Repair 2']),
                                 performed_by_vendor_id: vocab('vendor', row['Preformed by Vendor 2']),
                                 conservation_record_id: row['Database ID'])
    puts '   - Attached external repair'
  end
  if row['Type Vendor Repair 3'].present?
    ExternalRepairRecord.create!(repair_type: vocab('repair_type', row['Type Vendor Repair 3']),
                                 performed_by_vendor_id: vocab('vendor', row['Preformed by Vendor 3']),
                                 conservation_record_id: row['Database ID'])
    puts '   - Attached external repair'
  end
  if row['Type Vendor Repair other'].present? # rubocop:disable Style/GuardClause
    ExternalRepairRecord.create!(repair_type: vocab('repair_type', 'Other'),
                                 performed_by_vendor_id: vocab('vendor', row['Preformed by Vendor other']),
                                 conservation_record_id: row['Database ID'],
                                 other_note: row['Type Vendor Repair other'])
    puts '   - Attached external repair'
  end
end

def cost_return_report(row)
  CostReturnReport.create! do |crr|
    crr.shipping_cost = row['Cost of Shipping to Vendor'].tr('$', '').to_i if row['Cost of Shipping to Vendor'].present?
    crr.repair_estimate = row['Cost Estimate of Repair'].tr('$', '').to_i if row['Cost Estimate of Repair'].present?
    crr.repair_cost = row['Actual Cost Billed for Repair'].tr('$', '').to_i if row['Actual Cost Billed for Repair'].present?
    if row['Date invoice sent to Business office'].present?
      crr.invoice_sent_to_business_office = Date.strptime(row['Date invoice sent to Business office'], '%m/%d/%Y')
    end
    crr.complete = row['COMPLETE (Returned to origin)']
    crr.returned_to_origin = Date.strptime(row['Date Returned to Origin'], '%m/%d/%Y') if row['Date Returned to Origin'].present?
    crr.note = row['Note']
    crr.conservation_record_id = row['Database ID']
    puts '   - Attached cost return report'
  end
end

def con_tech_record(row)
  if row['Reviewed by'].present?
    ConTechRecord.create!(performed_by_user_id: user_lookup(row['Reviewed by']),
                          conservation_record_id: ConservationRecord.find_by(item_record_number: row['Item Record #']).id)
    puts '   - Attached con_tech_record'
  end
  return if row['Technicians'].blank?

  # split names by seperators and create con-tech records for each
  row['Technicians'].split(%r{[&,-/]}) do |name|
    ConTechRecord.create!(performed_by_user_id: user_lookup(name.strip),
                          conservation_record_id: ConservationRecord.find_by(item_record_number: row['Item Record #']).id)
    puts '   - Attached con_tech_record'
  end
end

namespace :batch do
  desc 'Load repair_type controlled vocabulary'
  task repair_type_controlled_vocabulary: :environment do
    puts '## Controlled Vocab repair_type - Batch Load complete'
    require 'csv'
    filename = 'lib/assets/types_of_repairs.csv'

    CSV.foreach(filename, col_sep: ',', headers: true) do |row|
      ControlledVocabulary.create!(vocabulary: 'repair_type', key: row[1], active: true)
      puts "Created controlled vocab for repair_type: #{row[1]}"
    end
  end

  desc 'Load department controlled vocabulary'
  task department_controlled_vocabulary: :environment do
    puts '## Controlled vocab deparment - Batch Load complete'
    require 'csv'
    filename = 'lib/assets/departments.csv'
    CSV.foreach(filename, col_sep: ',', headers: true) do |row|
      ControlledVocabulary.create!(vocabulary: 'department', key: row[1], active: true)
      puts "Created controlled vocab for department: #{row[1]}"
    end
  end

  desc 'Load staff code  controlled vocabulary'
  task staff_code_controlled_vocabulary: :environment do
    puts '## Controlled Vocab staff code - Batch Load complete'
    require 'csv'
    filename = 'lib/assets/types_of_staff_code.csv'
    CSV.foreach(filename, col_sep: ',', headers: true) do |row|
      StaffCode.create!(code: row[1], points: row[2])
      puts "Created controlled vocab for staff code: #{row[1]}"
    end
  end

  desc 'Load housing controlled vocabulary'
  task housing_controlled_vocabulary: :environment do
    puts '## Controlled Vocab housing - Batch Load complete'
    require 'csv'
    filename = 'lib/assets/housing.csv'
    CSV.foreach(filename, col_sep: ',', headers: true) do |row|
      ControlledVocabulary.create!(vocabulary: 'housing', key: row[1], active: true)
      puts "Created controlled vocab for housing: #{row[1]}"
    end
  end

  desc 'Load Contract Conservators controlled vocabulary'
  task contract_conservators_controlled_vocabulary: :environment do
    puts '## Controlled Vocab contract conservators - Batch Load complete'
    require 'csv'
    filename = 'lib/assets/contract_conservators.csv'
    CSV.foreach(filename, col_sep: ',', headers: true) do |row|
      ControlledVocabulary.create!(vocabulary: 'vendor', key: row[1], active: true)
      puts "Created controlled vocab for contract conservator: #{row[1]}"
    end
  end

  desc 'Load_Users'
  task load_users: :environment do
    file = ENV['CSV_LOCATION'].presence || 'lib/assets/users.csv'
    CSV.foreach(file, headers: true, return_headers: false) do |i|
      user = User.create(display_name: i[0], email: i[1], role: i[2])
      user.save(validate: false)
      puts "Account created: #{user.display_name}"
    end
    puts '##  User load complete'
  end

  # call rake task with:
  #
  # rails batch:load:conservation_records CSV_LOCATION="/tmp/sample_batch_metadata.csv"

  desc 'Load multiple Conservation records from CSV'
  task conservation_records: :environment do
    # Rake::Task["batch:department_controlled_vocabulary"].execute

    csv = open_input_csv
    if (File.readlines('lib/assets/conservation_record_headers.txt').map(&:chomp).sort <=> csv.headers.sort) != 0
      abort('**CSV Header Validation failed, check headers and in input CSV**')
    end

    csv.each do |row|
      conservation_record = ConservationRecord.new
      puts "Conservation Record created: #{row['Database ID']}"
      conservation_record.id = row['Database ID'].to_i
      if row['Date received in Preservation Services'].present?
        conservation_record.date_received_in_preservation_services = Date.strptime(row['Date received in Preservation Services'], '%m/%d/%Y')
      end
      conservation_record.title = row['Title']
      conservation_record.author = row['Author']
      conservation_record.imprint = row['Imprint']
      conservation_record.call_number = row['Call Number']
      conservation_record.item_record_number = row['Item Record #']
      conservation_record.digitization = row['Digitization'].to_i.positive?
      # Use $departments global array to lookup input_key > vocab_term > target_id
      conservation_record.department = vocab('department', row['Department'])
      conservation_record.save!
      # Add repair records
      create_in_house_repair_reports(row)
      create_external_repair_reports(row)
      # Add cost return report data
      cost_return_report(row)
    end
    puts '## Conservation Record Batch load completed ##'
  end

  desc 'Load treatment report records from CSV'
  task treatment_reports: :environment do
    csv = open_input_csv

    # Validate CSV headers
    if (File.readlines('lib/assets/treatment_report_headers.txt').map(&:chomp).sort <=> csv.headers.sort) != 0
      abort('**CSV Header Validation failed, check headers and in input CSV**')
    end

    csv.each do |row|
      treatment_report = TreatmentReport.new
      #      treatment_report.id = row['Treatment ID'].to_i
      treatment_report.description_general_remarks = row['Description General Remarks']
      treatment_report.description_binding = row['Description Binding']
      treatment_report.description_textblock = row['Description Textblock']
      treatment_report.description_primary_support = row['Description Primary Support']
      treatment_report.description_medium = row['Description Media']
      treatment_report.description_attachments_inserts = row['Description Attachments|Inserts']
      treatment_report.description_housing = row['Description Housing']
      treatment_report.condition_summary = row['Condition Summary']
      treatment_report.condition_binding = row['Condition Binding']
      treatment_report.condition_textblock = row['Condition Textblock']
      treatment_report.condition_primary_support = row['Condition Primary Support']
      treatment_report.condition_medium = row['Condition Medium']
      treatment_report.condition_housing_id = vocab('housing', @housing[row['Condition Housing']]) if row['Condition Housing'].present?
      treatment_report.condition_housing_narrative = row['Condition Housing Narrative']
      treatment_report.condition_attachments_inserts = row['Condition Attachments|Inserts']
      treatment_report.condition_previous_treatment = row['Condition Foreign substances']
      treatment_report.condition_materials_analysis = row['Condition Testing']
      treatment_report.treatment_proposal_proposal = row['Treatment Proposal']
      treatment_report.treatment_proposal_factors_influencing_treatment = row['Notes and Cautions']
      if row['Treatment Proposed Housing'].present?
        treatment_report.treatment_proposal_housing_need_id = vocab('housing', @housing[row['Treatment Proposed Housing']])
      end
      treatment_report.treatment_proposal_performed_treatment = row['Performed Treatment']

      treatment_report.treatment_proposal_housing_provided_id = vocab('housing', @housing[row['Performed Housing']]) if row['Performed Housing'].present?

      treatment_report.treatment_proposal_housing_narrative = row['Performed Housing Provided']
      treatment_report.treatment_proposal_storage_and_handling_notes = row['Performed Storage and Handlling Notes']
      treatment_report.treatment_proposal_total_treatment_time = @treatment[row['Performed Treatment Time']] if row['Performed Treatment Time'].present?
      if (conservation_record = ConservationRecord.find_by(item_record_number: row['Item Record #']))
        treatment_report.conservation_record_id = conservation_record.id
        treatment_report.save!
        puts "Created treatment report #{row['Treatment ID']} -- Conservation Record #{conservation_record.id}"
        # Add technicians
        con_tech_record(row)
      else
        puts ">> Treatment Report #{row['Treatment ID']} not created -- Conservation Record number: #{row['Item Record #']}"
      end
    end
  end
end
