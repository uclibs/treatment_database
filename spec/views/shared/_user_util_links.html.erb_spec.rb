# copied from ucrate.  THis will need to be adjusted to fit our application.
# Only some of this file was copied over.
# need to check devise default behaior if by default devise shows a change password option
# frozen_string_literal: true

require 'rails_helper'

# Skipping this because we don't have a _user_util_links.html.erb file.
# And we have not yet implemented Shibboleth.

# RSpec.describe '/_user_util_links.html.erb', type: :view do
#   let(:join_date) { 5.days.ago }
#   let(:can_create_file) { true }
#   let(:can_create_collection) { true }
#
#   before do
#     allow(view).to receive(:user_signed_in?).and_return(true)
#     allow(view).to receive(:current_user).and_return(stub_model(User, user_key: 'userX'))
#     allow(view).to receive(:can?).with(:create, GenericWork).and_return(can_create_file)
#     allow(view).to receive(:can?).with(:create_any, Collection).and_return(can_create_collection)
#     stub_current_ability(can_create: true)
#     stub_create_work_presenter(many_works: true)
#   end
#   context 'when the user is using shibboleth' do
#     before do
#       allow(view).to receive(:current_user).and_return(stub_model(User, user_key: 'userX', provider: 'shibboleth'))
#       render
#     end
#
#     it 'does not show the change password manu option' do
#       expect(rendered).not_to have_link 'Change password'
#     end
#   end
#
#   def stub_current_ability(can_create: true)
#     current_ability = instance_double('CurrentAbility')
#     allow(view).to receive(:current_ability).and_return(current_ability)
#     allow(current_ability).to receive(:can_create_any_work?).and_return(can_create)
#   end
#
#   def stub_create_work_presenter(many_works: true)
#     create_work_presenter = instance_double('CreateWorkPresenter')
#     allow(view).to receive(:create_work_presenter).and_return(create_work_presenter)
#     allow(create_work_presenter).to receive(:many?).and_return(many_works)
#   end
# end
