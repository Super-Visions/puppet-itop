require 'puppet'
module Puppet::Parser::Functions
  newfunction(:file_exists, :type => :rvalue) do |args|
    if File.file?(args[0])
      return 1
    else
      return 0
    end
  end
end
