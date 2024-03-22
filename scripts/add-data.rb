# Script to migrate missing abbreviated_treatment_report data

require 'csv'

def open_input_csv
  csv_file = '/tmp/abbreviated_treatment_report_migration/ARCHIVEDConservationData.csv'

  CSV.read(csv_file, col_sep: ',', headers: true, row_sep: :auto)
end

# Open csv supplied from command line
csv = open_input_csv

# Check CSV for correct field headers
unless csv.headers.any? { |i| ["Database ID", "Conservator's Note"].include? i }
  abort('**CSV Header Validation failed, check headers and in input CSV**')
end

csv.each do |row|
  #Use only rows with a Conservator's note present
  if row["Conservator's Note"]
    # find treatment record by related conservation record ID
    record = ConservationRecord.find row['Database ID']
    # check for existing treatment report record and create if not present
    unless record.treatment_report
      puts "Record #{row['Database ID']} missing Treatment Report ... Creating."
      TreatmentReport.create!(conservation_record_id: row["Database ID"])
      record.reload
    end
    # Assign conservator's note to var if empty
    if record.treatment_report.abbreviated_treatment_report.blank?
      record.treatment_report.abbreviated_treatment_report = row["Conservator's Note"]
      record.treatment_report.save!
      puts "*** Record #{row['Database ID']} updated"
    else
    # Pause and print message if abbr treatment rpt exists already
      puts "*** Record #{row['Database ID']} has existing abbreviated treatment report"
      puts "Press <return> to continue"
      gets
    end
  end
end
