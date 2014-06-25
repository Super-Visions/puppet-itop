require 'puppet'
module Puppet::Parser::Functions
  newfunction(:file_exists, :type => :rvalue) do |args|
    if File.file?(args[0])
      return true
    else
      return false
    end
  end
end
