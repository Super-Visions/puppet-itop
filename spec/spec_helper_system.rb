require 'rspec-system/spec_helper'

RSpec.configure do |c|
  c.system_setup_block = proc do
    include RSpecSystem::Helpers
    # Insert some setup tasks here
    system_run('yum install -y ntp')
  end
end
