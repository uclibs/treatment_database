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
      err.push h.external_repair_records.count if h.external_repair_records.count.positive?
    end

    # set headers for repeat fields
    err_csv = []

    def err_headings(ordinal)
      ["External Repair Record id #{ordinal + 1}",
       "External Repair repair_type #{ordinal + 1}",
       "External Repair performed_by_vendor_id #{ordinal + 1}",
       "External Repair conservation_record_id #{ordinal + 1}",
       "External Repair created_at #{ordinal + 1}",
       "External Repair other_note #{ordinal + 1}"]
    end

    err.max.times.each do |ordinal|
      err_csv.push err_headings(ordinal)
    end

    ihrr_csv = []

    def ihrr_headings(ordinal)
      ["In House Repair performed_by_user_id #{ordinal + 1}",
       "In House Repair minutes_spent #{ordinal + 1}",
       "In House Repair conservation_record_id #{ordinal + 1}",
       "In House Repair other_note #{ordinal + 1}",
       "In House Repair created_at #{ordinal + 1}",
       "In House Repair staff_code #{ordinal + 1}"]
    end

    ihrr.max.times.each do |ordinal|
      ihrr_csv.push ihrr_headings(ordinal)
    end

    staff_csv = []

    staff_headings = ['Staff ID',
                      'Staff performed_by_user_id',
                      'Staff created_at',
                      'Staff conservation_record_id']

    staff.max.times do
      staff_csv.push staff_headings
    end

    # set headers for singular records
    cons_headings = ['Conservation Record ID',
                     'Conservation Record date_received_in_preservation_services',
                     'Conservation Record title',
                     'Conservation Record author',
                     'Conservation Record imprint',
                     'Conservation Recordl call_number',
                     'Conservation Record item_record_number',
                     'Conservaiton Record department']

    tr_headings = ['Treatment Report ID',
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

    def crr_headings
      ['Cost Return Report Complete?',
       'Cost Return Report Returned to Origin?',
       'Cost Return Report ID',
       'Cost Return Report Shipping Cost',
       'Cost Return Report Repair Estimate',
       'Cost Return Report Repair Cost',
       'Cost Return Report Invoice Sent to Business Office',
       'Cost Return Report Note',
       'Cost Return Report Conservation Record ID',
       'Cost Return Report Created At',
       'Cost Return Report Updated At']
    end

    def in_house_repair_record_array(conservation_record, ihrr)
      records = []
      conservation_record.in_house_repair_records.all.each do |i|
        records << [user_display_name(i.performed_by_user_id),
                    i.minutes_spent.to_s,
                    i.conservation_record_id.to_s,
                    i.other_note,
                    i.created_at.to_s,
                    StaffCode.find_by(id: i.staff_code_id).code]
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
                    controlled_vocabulary_lookup(i.repair_type) || '',
                    controlled_vocabulary_lookup(i.performed_by_vendor_id) || '',
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
                    user_display_name(i.performed_by_user_id),
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
       controlled_vocabulary_lookup(cons_record.department) || '']
    end

    def cost_return_report_array(conservation_record)
      return ['', '', '', '', '', '', '', '', '', '', ''] if conservation_record.cost_return_report.nil?

      cost_return = conservation_record.cost_return_report
      [cost_return.complete,
       cost_return.returned_to_origin,
       cost_return.id,
       cost_return.shipping_cost,
       cost_return.repair_estimate,
       cost_return.repair_cost,
       cost_return.invoice_sent_to_business_office,
       cost_return.note,
       cost_return.conservation_record_id,
       cost_return.created_at,
       cost_return.updated_at]
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
        csv << (cons_headings + ihrr_csv.flatten + crr_headings + err_csv.flatten + staff_csv.flatten + tr_headings)
        # write data, line by line
        ConservationRecord.all.each do |conservation_record|
          csv << [conservation_record_array(conservation_record) + in_house_repair_record_array(conservation_record,
                                                                                                ihrr) + cost_return_report_array(conservation_record) + external_repair_record_array(conservation_record,
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
