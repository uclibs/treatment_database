# frozen_string_literal: true

# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    def authenticate_admin
      send(:authenticate_user!)
    end

    load_and_authorize_resource
    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    # Raise an exception if the user is not permitted to access this resource
    def authorize_resource(resource)
      raise 'Erg!' unless show_action?(params[:action], resource)
    end

    # Hide links to actions if the user is not allowed to do them
    def show_action?(action, resource)
      can? action, resource
    end
  end
end
