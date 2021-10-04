# frozen_string_literal: true

module ActivityHelper
  def version_summarizer(version)
    display_name = 'Someone'
    display_name = User.find(version.whodunnit).display_name unless version.whodunnit.nil?
    "#{display_name} #{event_to_summary(version.event)} the #{item_type_to_summary(version.item_type)}: #{name_to_summary(version)}"
  end

  def event_to_summary(event)
    case event
    when 'create'
      'created'
    when 'update'
      'updated'
    when 'destroy'
      'deleted'
    else
      'did something to'
    end
  end

  def item_type_to_summary(item_type)
    case item_type
    when 'ConservationRecord'
      'conservation record'
    when 'TreatmentReport'
      'treatment report'
    when 'ExternalRepairRecord'
      'external repair record'
    when 'InHouseRepairRecord'
      'in house repair record'
    when 'User'
      'user'
    when 'CostReturnReport'
      'cost return report'
    else
      'some item'
    end
  end

  def name_to_summary(version)
    case version.item_type
    when 'ConservationRecord'
      if ConservationRecord.exists?(id: version.item_id)
        link_to ConservationRecord.find(version.item_id).title, conservation_record_path(version.item_id)
      else
        version.object.nil? ? ' ' : version.object.try(:split, 'title: ').last.try(:split, 'author: ').first.chomp
      end
    when 'TreatmentReport'
      if TreatmentReport.exists?(id: version.item_id)
        treatment_report_id = TreatmentReport.find(version.item_id).conservation_record.id
        link_to ConservationRecord.find(treatment_report_id).title.to_s, conservation_record_path(treatment_report_id)
      else
        # version.object.split('title: ').last.split('author: ').first.chomp
        'Record has been deleted'
      end
    when 'User'
      User.find(version.item_id).display_name
    when 'InHouseRepairRecord'
      if InHouseRepairRecord.exists?(id: version.item_id)
        in_house_repair_id = InHouseRepairRecord.find(version.item_id).conservation_record.id
        link_to InHouseRepairRecord.find(version.item_id).conservation_record.title, conservation_record_path(in_house_repair_id)
      else
        'Record has been deleted'
      end
    when 'ExternalRepairRecord'
      if ExternalRepairRecord.exists?(id: version.item_id)
        external_repair_id = ExternalRepairRecord.find(version.item_id).conservation_record.id
        link_to ExternalRepairRecord.find(version.item_id).conservation_record.title, conservation_record_path(external_repair_id)
      else
        'Record has been deleted'
      end
    when 'CostReturnReport'
      if CostReturnReport.exists?(id: version.item_id)
        cost_return_report_id = CostReturnReport.find(version.item_id).conservation_record.id
        link_to ConservationRecord.find(cost_return_report_id).title.to_s, conservation_record_path(cost_return_report_id)
      else
        # CostReturnReport.find(version.item_id).conservation_record.title
        'Record has been deleted'
      end
    end
  end

  def changeset_format(field, value); end
end
