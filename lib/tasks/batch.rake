# frozen_string_literal: true

require 'csv'

# create empty hashes in global vars to store input vocab and ids

@departments = {}
@repair_type = {}
@vendor = {}

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

def open_input_csv
  CSV.read(ENV['CSV_LOCATION'], col_sep: ',', headers: true, row_sep: :auto)
end

# method to use input id for target id lookup

def vocab(input_type, input_key)
  ControlledVocabulary.find_by(vocabulary: input_type, key: input_key).id if input_key.present?
end

def user_lookup(name)
  user = User.find_by(display_name: name)
  user.present? ? user.id : User.find_by(display_name: 'Temporary User').id # assign temp user
end

def create_in_house_repair_reports(row)
  if row['Type In-house Repair'].present?
    InHouseRepairRecord.create!(repair_type: vocab('repair_type', @repair_type[row['Type In-house Repair']]),
                                performed_by_user_id: user_lookup(row['Preformed In-house Repair']),
                                minutes_spent: row['Time In-house Repair'],
                                conservation_record_id: row['Database ID'])
    puts '   - Attached in-house repair'
  end
  if row['Type In-house Repair 2'].present?
    InHouseRepairRecord.create!(repair_type: vocab('repair_type', @repair_type[row['Type In-house Repair 2']]),
                                performed_by_user_id: user_lookup(row['Preformed In-house Repair 2']),
                                minutes_spent: row['Time In-house Repair 2'],
                                conservation_record_id: row['Database ID'])
    puts '   - Attached in-house repair'
  end
  if row['Type In-house Repair 3'].present?
    InHouseRepairRecord.create!(repair_type: vocab('repair_type', @repair_type[row['Type In-house Repair 3']]),
                                performed_by_user_id: user_lookup(row['Preformed In-house Repair 3']),
                                minutes_spent: row['Time In-house Repair 3'],
                                conservation_record_id: row['Database ID'])
    puts '   - Attached in-house repair'
  end
  if row['Type In-house Repair other'].present? # rubocop:disable Style/GuardClause
    InHouseRepairRecord.create!(repair_type: vocab('repair_type', 'Other'),
                                performed_by_user_id: user_lookup(row['Preformed In-house Repair other']),
                                minutes_spent: row['Time In-house Repair other'],
                                conservation_record_id: row['Database ID'],
                                other_note: row['Type In-house Repair other'])
    puts '   - Attached in-house repair'
  end
end

def create_external_repair_reports(row)
  if row['Type Vendor Repair'].present?
    ExternalRepairRecord.create!(repair_type: vocab('repair_type', @repair_type[row['Type Vendor Repair']]),
                                 performed_by_vendor_id: vocab('vendor', @vendor[row['Preformed by Vendor']]),
                                 conservation_record_id: row['Database ID'])
    puts '   - Attached external repair'
  end
  if row['Type Vendor Repair 2'].present?
    ExternalRepairRecord.create!(repair_type: vocab('repair_type', @repair_type[row['Type Vendor Repair 2']]),
                                 performed_by_vendor_id: vocab('vendor', @vendor[row['Preformed by Vendor 2']]),
                                 conservation_record_id: row['Database ID'])
    puts '   - Attached external repair'
  end
  if row['Type Vendor Repair 3'].present?
    ExternalRepairRecord.create!(repair_type: vocab('repair_type', @repair_type[row['Type Vendor Repair 3']]),
                                 performed_by_vendor_id: vocab('vendor', @vendor[row['Preformed by Vendor 3']]),
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
    CSV.foreach('lib/assets/users.csv', headers: true, return_headers: false) do |i|
      user = User.create(display_name: i[0], email: i[1], role: i[2])
      user.save(validate: false)
      puts user
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
    csv.each do |row|
      conservation_record = ConservationRecord.new
      puts "Conservation Record created: #{row['Database ID']}"
      conservation_record.id = row['Database ID'].to_i
      conservation_record.date_received_in_preservation_services = row['Date received in Preservation Services']
      conservation_record.title = row['Title']
      conservation_record.author = row['Author']
      conservation_record.imprint = row['Imprint']
      conservation_record.call_number = row['Call Number']
      conservation_record.item_record_number = row['Item Record #']
      conservation_record.digitization = row['Digitization'].to_i.positive?
      # Use $departments global array to lookup input_key > vocab_term > target_id
      conservation_record.department = vocab('department', @departments[row['Department']])
      conservation_record.save!
      # Add repair records
      create_in_house_repair_reports(row)
      create_external_repair_reports(row)
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
      if row['Condition Housing'].present?
        treatment_report.condition_housing_id = ControlledVocabulary.find_by(vocabulary: 'housing',
                                                                             key: row['Condition Housing']).id
      end
      treatment_report.condition_housing_narrative = row['Condition Housing Narrative']
      treatment_report.condition_attachments_inserts = row['Condition Attachments Inserts']
      treatment_report.condition_previous_treatment = row['Condition Previous Statement']
      treatment_report.condition_materials_analysis = row['Condition Materials Analysis']
      treatment_report.treatment_proposal_proposal = row['Treatment Proposal']
      treatment_report.treatment_proposal_factors_influencing_treatment = row['Notes and Cautions']
      if row['Treatment Proposal Housing'].present?
        treatment_report.treatment_proposal_housing_need_id = ControlledVocabulary.find_by(vocabulary: 'housing',
                                                                                           key: row['Treatment Proposal Housing']).id
      end
      treatment_report.treatment_proposal_performed_treatment = row['Performed Treatment']

      if row['Proposed Housing'].present?
        treatment_report.treatment_proposal_housing_provided_id = ControlledVocabulary.find_by(vocabulary: 'housing',
                                                                                               key: row['Performed Housing']).id
      end

      treatment_report.treatment_proposal_housing_narrative = row['Performed Housing Provided']
      treatment_report.treatment_proposal_storage_and_handling_notes = row['Performed Storage and Handlling Notes']
      treatment_report.treatment_proposal_total_treatment_time = row['Performed Treatment Time']
      if (conservation_record = ConservationRecord.find_by(item_record_number: row['Item Record #']))
        treatment_report.conservation_record_id = conservation_record.id
        treatment_report.save!
        puts "Created treatment report #{row['Treatment ID']} -- Conservation Record #{conservation_record.id}"
      else
        puts ">> Treatment Report #{row['Treatment ID']} not created -- Conservation Record number: #{row['Item Record #']}"
      end
    end
  end
end
