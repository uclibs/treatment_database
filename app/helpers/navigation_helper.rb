# frozen_string_literal: true

# Takes the login logic out of our navigation bar and puts it in a helper method
module NavigationHelper
  AVAILABLE_LINKS = [
    { title: 'Conservation Records', path: :conservation_records_path, permission: [:read, ConservationRecord] },
    { title: 'Vocabularies', path: :controlled_vocabularies_path, permission: [:read, ControlledVocabulary] },
    { title: 'Users', path: :users_path, permission: [:manage, User] },
    { title: 'Activity', path: :activity_index_path, permission: [:read, PaperTrail::Version] },
    { title: 'Reports', path: :reports_path, permission: [:manage, Report] },
    { title: 'Staff Codes', path: :staff_codes_path, permission: [:read, StaffCode] }
  ].freeze

  def navigation_links(user)
    return 'navigation/logged_out_navigation' if user.blank?

    'navigation/logged_in_navigation'
  end

  def nav_links_for_user
    AVAILABLE_LINKS.each_with_object([]) do |link, links|
      links << { title: link[:title], path: send(link[:path]) } if can?(*link[:permission])
    end
  end
end
