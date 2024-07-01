# frozen_string_literal: true

require 'rails_helper'
require 'capistrano/all'

RSpec.describe 'deploy:confirmation', type: :task do
  before :each do
    allow_any_instance_of(Capistrano::Configuration).to receive(:fetch) do |_instance, key, default = nil|
      {
        rails_env: 'test',
        stage: 'production',
        branch: 'main'
      }[key] || default
    end

    allow_any_instance_of(Object).to receive(:abort) do |*args|
      raise "Abort called with arguments: #{args.inspect}"
    end
  end

  def setup_deployment_confirmation(return_value:)
    allow_any_instance_of(Capistrano::Configuration)
      .to receive(:ask)
      .with(:value, 'Sure you want to continue deploying `main` on PRODUCTION? (Y or Yes)')
      .and_return(return_value)

    allow_any_instance_of(Capistrano::Configuration)
      .to receive(:fetch)
      .with(:value)
      .and_return(return_value)
  end

  context 'when user confirms deployment' do
    it 'does not output "deploy cancelled" message' do
      setup_deployment_confirmation(return_value: 'Y')

      expect do
        Rake::Task['deploy:confirmation'].invoke
      end.to_not output.to_stderr
    end
  end

  context 'when user does not confirm deployment' do
    it 'outputs "deploy cancelled" message and calls exit_gracefully' do
      setup_deployment_confirmation(return_value: 'potato')

      expect do
        Rake::Task['deploy:confirmation'].invoke
      end.to raise_error(RuntimeError, /Abort called with arguments:/)
        .and output(/\nNo confirmation - deploy cancelled!\n/).to_stdout
    end
  end
end
