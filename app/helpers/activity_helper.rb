# frozen_string_literal: true

module ActivityHelper
  def version_summarizer(version)
    display_name = 'Someone'
    if !version.whodunnit.nil?
      display_name = User.find(version.whodunnit).display_name
    end
    display_name + ' ' + event_to_summary(version.event) + ' the ' + item_type_to_summary(version.item_type) + ': ' + name_to_summary(version)
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
      'treatment record'
    when 'ExternalRepairRecord'
      'external repair record'
    when 'InHouseRepairRecord'
      'in house repair record'
    when 'User'
      'user'
    else
      'some item'
    end
  end

  def name_to_summary(version)
    type = version.item_type
    id = version.item_id

    if type == 'ConservationRecord'
      link_to ConservationRecord.find(id).title, conservation_record_path(id)
    elsif type == 'TreatmentReport'
      treatment_report_id = TreatmentReport.find(id).conservation_record.id
      link_to ConservationRecord.find(treatment_report_id).title + "'s treatment report", conservation_record_path(id)
    elsif type == "User"
      User.find(id).display_name
    end
  end

  def changeset_format(field, value)
    
  end
end
