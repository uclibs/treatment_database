# frozen_string_literal: true

require 'csv'

def open_input_csv
  CSV.read(ENV['CSV_LOCATION'], col_sep: ',', headers: true, row_sep: :auto)
end

namespace :batch do
  namespace :load do
    # rails batch:load:conservation_records CSV_LOCATION="/tmp/sample_batch_metadata.csv"
    desc 'Load multiple Conservation records from CSV'
    task conservation_records: :environment do
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
        conservation_record.department = row['Department']
        conservation_record.save!
      end
      puts '## Batch load completed ##'
    end
  end
end
