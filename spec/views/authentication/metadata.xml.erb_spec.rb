# frozen_string_literal: true

# # frozen_string_literal: true
#
# require 'rails_helper'
#
# RSpec.describe 'sessions/metadata', type: :view do
#   include SamlHelper
#   include Rails.application.routes.url_helpers
#
#   before do
#     assign(:metadata, OneLogin::RubySaml::Metadata.new.generate(saml_settings))
#     render template: 'sessions/metadata', formats: [:xml]
#   end
#
#   it 'renders XML content type' do
#     expect(rendered).to include("<?xml version='1.0'")
#   end
#
#   it 'contains SAML metadata elements' do
#     expect(rendered).to include('<md:EntityDescriptor')
#     expect(rendered).to include('<md:SPSSODescriptor')
#   end
#
#   it 'includes the correct entity ID' do
#     entity_id = saml_settings.sp_entity_id
#     expect(rendered).to match(/entityID=['"]#{Regexp.escape(entity_id)}['"]/)
#   end
# end
