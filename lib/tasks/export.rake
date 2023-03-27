# frozen_string_literal: true

namespace :export do
  desc 'Export all data in CSV format'
  task all_data: :environment do
    require 'csv'
    require 'tempfile'
    include ApplicationHelper

    # get max counts on associated models
    ihrr = [0]
    staff = [0]
    err = [0]

    ConservationRecord.all.each do |h|
      ihrr.push h.in_house_repair_records.count if h.in_house_repair_records.count.positive?
      staff.push h.con_tech_records.count if h.con_tech_records.count.positive?
      err.push h.con_tech_records.count if h.external_repair_records.count.positive?
    end

    # set headers for repeat fields
    err_csv = []
    err.max.times do
      err_headings = ['External Repair Record id',
                      'External Repair repair_type',
                      'External Repair performed_by_vendor_id',
                      'External Repair conservation_record_id',
                      'External Repair created_at',
                      'External Repair other_note']
      err_csv.push err_headings
    end

    ihrr_csv = []
    ihrr.max.times do
      ihrr_headings = ['In House Repair performed_by_user_id',
                       'In House Repair minutes_spent',
                       'In House Repair conservation_record_id',
                       'In House Repair other_note',
                       'In House Repair created_at',
                       'In House Repair staff_code_id']
      ihrr_csv.push ihrr_headings
    end

    staff_csv = []
    staff.max.times do
      staff_headings = ['Staff id',
                        'Staff performed_by_user_id',
                        'Staff created_at',
                        'Staff conservation_record_id']
      staff_csv.push staff_headings
    end

    # set headers for singular records
    cons_headings = ['Conservation Record id',
                     'Conservation Record date_received_in_preservation_services',
                     'Conservation Record title',
                     'Conservation Record author',
                     'Conservation Record imprint',
                     'Conservation Recordl call_number',
                     'Conservation Record item_record_number',
                     'Conseration Record digitization',
                     'Conservation Record created_at',
                     'Conservation Record updated_at',
                     'Conservaiton Record departmen']

    tr_headings = ['Treatment Record id',
                   'Treatment Report description_general_remarks',
                   'Treatment Report description_binding',
                   'Treatment Report description_textblock',
                   'Treatment Report description_primary_support',
                   'Treatment Report description_medium',
                   'Treatment Report description_attachments_inserts',
                   'Treatment Report description_housing',
                   'Treatment Report condition_summary',
                   'Treatment Report condition_binding',
                   'Treatment Report condition_textblock',
                   'Treatment Report condition_primary_support',
                   'Treatment Report condition_medium',
                   'Treatment Report condition_housing_id',
                   'Treatment Report condition_housing_narrative',
                   'Treatment Report condition_attachments_inserts',
                   'Treatment Report condition_previous_treatment',
                   'Treatment Report condition_materials_analysis',
                   'Treatment Report treatment_proposal_proposal',
                   'Treatment Report treatment_proposal_housing_need_id',
                   'Treatment Report treatment_proposal_factors_influencing_treatment',
                   'Treatment Report treatment_proposal_performed_treatment',
                   'Treatment Report treatment_proposal_housing_provided_id',
                   'Treatment Report treatment_proposal_housing_narrative',
                   'Treatment Report treatment_proposal_storage_and_handling_notes',
                   'Treatment Report treatment_proposal_total_treatment_time',
                   'Treatment Report created_at',
                   'Treatment Report updated_at',
                   'Treatment Report conservation_record_id',
                   'Treatment Report abbreviated_treatment_report']

    def in_house_repair_record_array(conservation_record, ihrr)
      records = []
      conservation_record.in_house_repair_records.all.each do |i|
        records << [User.find(i.performed_by_user_id).display_name.to_s,
                    i.minutes_spent.to_s,
                    i.conservation_record_id.to_s,
                    i.other_note,
                    i.created_at.to_s,
                    i.staff_code_id.to_s]
      end
      # Fill in empty spaces
      (ihrr.max - conservation_record.in_house_repair_records.count).times do
        records << ['', '', '', '', '', '']
      end
      records.flatten
    end

    def external_repair_record_array(conservation_record, err)
      records = []
      conservation_record.external_repair_records.all.each do |i|
        records << [i.id.to_s,
                    ControlledVocabulary.find(i.repair_type).key.to_s,
                    ControlledVocabulary.find(i.performed_by_vendor_id).key.to_s,
                    i.conservation_record_id.to_s,
                    i.created_at.to_s,
                    i.other_note]
      end
      # Fill in empty spaces
      (err.max - conservation_record.external_repair_records.count).times do
        records << ['', '', '', '', '', '']
      end
      records.flatten
    end

    def staff_array(conservation_record, staff)
      records = []
      conservation_record.con_tech_records.all.each do |i|
        records << [i.id.to_s,
                    User.find(i.performed_by_user_id).display_name.to_s,
                    i.created_at.to_s,
                    i.conservation_record_id.to_s]
      end
      # Fill in empty spaces
      (staff.max - conservation_record.con_tech_records.count).times do
        records << ['', '', '', '']
      end

      records.flatten
    end

    def conservation_record_array(cons_record)
      [cons_record.id.to_s,
       cons_record.date_received_in_preservation_services.to_s,
       cons_record.title,
       cons_record.author,
       cons_record.imprint,
       cons_record.call_number,
       cons_record.item_record_number,
       cons_record.digitization.to_s,
       cons_record.created_at.to_s,
       cons_record.updated_at.to_s,
       ControlledVocabulary.find(cons_record.department).key.to_s]
    end

    def treatment_report_array(conservation_record)
      return [] if conservation_record.treatment_report.nil?

      treatment_report = conservation_record.treatment_report
      [treatment_report.id.to_s,
       treatment_report.description_general_remarks,
       treatment_report.description_binding,
       treatment_report.description_textblock,
       treatment_report.description_primary_support,
       treatment_report.description_medium,
       treatment_report.description_attachments_inserts,
       treatment_report.description_housing,
       treatment_report.condition_summary,
       treatment_report.condition_binding,
       treatment_report.condition_textblock,
       treatment_report.condition_primary_support,
       treatment_report.condition_medium,
       treatment_report.condition_housing_id.to_s,
       treatment_report.condition_housing_narrative,
       treatment_report.condition_attachments_inserts,
       treatment_report.condition_previous_treatment,
       treatment_report.condition_materials_analysis,
       treatment_report.treatment_proposal_proposal,
       controlled_vocabulary_lookup(treatment_report.treatment_proposal_housing_need_id) || '',
       treatment_report.treatment_proposal_factors_influencing_treatment,
       treatment_report.treatment_proposal_performed_treatment,
       controlled_vocabulary_lookup(treatment_report.treatment_proposal_housing_provided_id) || '',
       treatment_report.treatment_proposal_housing_narrative,
       treatment_report.treatment_proposal_storage_and_handling_notes,
       treatment_report.treatment_proposal_total_treatment_time.to_s,
       treatment_report.created_at.to_s,
       treatment_report.updated_at.to_s,
       treatment_report.conservation_record_id.to_s,
       treatment_report.abbreviated_treatment_report]
    end

    Tempfile.new('csv_file').tap do |file|
      # create csv file
      CSV.open(file, 'wb', force_quotes: true) do |csv|
        # write headers
        csv << (cons_headings + ihrr_csv.flatten + err_csv.flatten + staff_csv.flatten + tr_headings)
        # write data, line by line
        ConservationRecord.all.each do |conservation_record|
          csv << [conservation_record_array(conservation_record) + in_house_repair_record_array(conservation_record,
                                                                                                ihrr) + external_repair_record_array(conservation_record,
                                                                                                                                     err) + staff_array(conservation_record,
                                                                                                                                                        staff) + treatment_report_array(conservation_record)].flatten
        end
      end
      # save and serve file
      @report = Report.new
      @report.csv_file.attach(io: File.open(file.path), filename: "#{DateTime.current.strftime('%Y%m%dT%H%M%S')}_export.csv")
      @report.save
    end
  end
end
