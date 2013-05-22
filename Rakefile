# Rakefile
require 'rubygems'

require 'rspec-system/rake_task'

desc "Run puppet-lint."
task :lint do |t, args|
  begin
    require 'puppet-lint'
  rescue LoadError
    fail "Cannot load puppet-lint, please install gem : # gem install puppet-lint"
  end
  PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
  #PuppetLint.configuration.send("disable_80chars")
  PuppetLint.configuration.disable_80chars
  linter = PuppetLint.new
  files = File.join('./', "**", "*.pp")
  Dir.glob(files).each do |puppet_file|
    puts "Evaluating #{puppet_file}"
    linter.file = puppet_file
    linter.run
  end
end

desc "Check syntax."
task :syntax do |t, args|
  begin
    require 'puppet/face'
  rescue LoadError
    fail 'Cannot load puppet/face, are you sure you have Puppet 2.7?'
  end

  def validate_manifest(file)
    Puppet::Face[:parser, '0.0.1'].validate(file)
  rescue Puppet::Error => error
    puts error.message
  end

  files = File.join('./', "**", "*.pp")
  Dir.glob(files).each do|manifest|
    puts "Evaluating syntax for #{manifest}"
    validate_manifest manifest
 end
end

desc "Generate documentation"
task :doc do |t, args|
  puts "Generating puppet modules documentation"
  work_dir = File.dirname(__FILE__)
  sh %{puppet doc \
        --outputdir #{work_dir}/doc \
        --mode rdoc \
        --modulepath #{work_dir} \
        --manifestdir #{work_dir}/../puppet/manifests \
        --manifest #{work_dir}/../puppet/manifests/site.pp }
end
