# frozen_string_literal: true

require 'csv'

# create empty hashes in global vars to store input vocab and ids

@departments = {}
@repair_type = {}

# open csv files to load input vocab with ids

CSV.foreach('lib/assets/departments.csv', headers: true, return_headers: false) do |i|
  @departments[(i[0])] = i[1]
end

CSV.foreach('lib/assets/types_of_repairs.csv', headers: true, return_headers: false) do |i|
  @repair_type[(i[0])] = i[1]
end

def open_input_csv
  CSV.read(ENV['CSV_LOCATION'], col_sep: ',', headers: true, row_sep: :auto)
end

# method to use input id for target id lookup

def vocab(input_type, input_key)
  ControlledVocabulary.find_by(vocabulary: input_type, key: input_key).id if input_key.present?
end

namespace :batch do
  desc 'Load repair_type controlled vocabulary'
  task repair_type_controlled_vocabulary: :environment do
    puts '## Controlled Vocab repair_type Batch Load complete'
    require 'csv'
    filename = 'lib/assets/types_of_repairs.csv'

    CSV.foreach(filename, col_sep: ',', headers: true) do |row|
      ControlledVocabulary.create!(vocabulary: 'repair_type', key: row[1], active: true)
      puts "Created controlled vocab for repair_type: #{row[1]}"
    end
  end

  desc 'Load department controlled vocabulary'
  task department_controlled_vocabulary: :environment do
    puts '## Department repair_type Batch Load complete'
    require 'csv'
    filename = 'lib/assets/departments.csv'
    CSV.foreach(filename, col_sep: ',', headers: true) do |row|
      ControlledVocabulary.create!(vocabulary: 'department', key: row[1], active: true)
      puts "Created controlled vocab for department: #{row[1]}"
    end
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
      puts row['Database ID']
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
    end
    puts '## Conservation Record Batch load completed ##'
  end
end
