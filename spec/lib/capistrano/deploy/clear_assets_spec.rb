# frozen_string_literal: true

require 'rails_helper'
require 'capistrano/all'
require 'capistrano/setup'

RSpec.describe 'deploy tasks', type: :task do
  describe 'deploy:clear_assets' do
    include SSHKit::DSL
    before do
      Capistrano::Configuration.env.set(:release_path, Pathname.new('/var/www/myapp/releases/20200625'))
    end

    it 'executes the correct commands to remove assets' do
      Capistrano::Configuration.env.role(:web, ['example.com'])

      expect_any_instance_of(SSHKit::Backend::Netssh).to receive(:execute).with(:rm, '-rf', '/var/www/myapp/releases/20200625/public/assets/*')
      expect_any_instance_of(SSHKit::Backend::Netssh).to receive(:execute).with(:rm, '-rf', '/var/www/myapp/releases/20200625/public/build/*')

      Rake::Task['deploy:clear_assets'].invoke
    end
  end
end
