# frozen_string_literal: true

# Takes the login logic out of our navigation bar and puts it in a helper method
module NavigationHelper
  def navigation_links(user)
    return 'navigation/logged_out_navigation' if user.blank?

    'navigation/logged_in_navigation'
  end

  def nav_links_for_user
    links = []
    links << { title: 'Conservation Records', path: conservation_records_path } if can?(:read, ConservationRecord)
    links << { title: 'Vocabularies', path: controlled_vocabularies_path } if can?(:read, ControlledVocabulary)
    links << { title: 'Users', path: users_path } if can?(:manage, User)
    links << { title: 'Activity', path: activity_index_path } if can?(:manage, Activity)
    links << { title: 'Reports', path: reports_path } if can?(:manage, Report)
    links << { title: 'Staff Codes', path: staff_codes_path } if can?(:read, StaffCode)
    links
  end
end
