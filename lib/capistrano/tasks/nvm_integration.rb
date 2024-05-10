# frozen_string_literal: true

module NVMIntegration
  def self.wrap_with_nvm(task_name)
    original_task = Rake::Task[task_name]
    actions = original_task.actions.dup # Save the original actions
    original_task.clear_actions # Clear existing actions

    redefine_task_with_nvm(original_task, actions)
  end

  def self.redefine_task_with_nvm(original_task, actions)
    Rake::Task.define_task(original_task) do
      on roles(:all) do
        within release_path do
          NVMIntegration.setup_and_execute_actions(actions)
        end
      end
    end
  end

  def self.setup_and_execute_actions(actions)
    actions.each do |action|
      NVMIntegration.setup_nvm_environment
      instance_exec(&action)
      NVMIntegration.cleanup_nvm_environment
    end
  end

  def self.setup_nvm_environment
    command = "source ~/.nvm/nvm.sh && nvm use $(cat #{release_path}/.nvmrc) && cd #{release_path} && RAILS_ENV=production"
    SSHKit.config.command_map.prefix[:rake].unshift(command)
  end

  def self.cleanup_nvm_environment
    SSHKit.config.command_map.prefix[:rake].shift
  end
end
