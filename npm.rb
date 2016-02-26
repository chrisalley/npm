require 'open-uri'
require 'json'

def tidy_version_number(version)
  version = version.gsub(/[\^\~\<\>\=]/, '')
  version.gsub(/\s.+/, '')
end

def install_latest_package(name)
  puts "Getting metadata for the latest version of #{name}..."
  json_string = ''
  open("http://registry.npmjs.org/#{name}/latest") do |f|
    f.each_line do |line|
      json_string << line
    end
  end
  json = JSON(json_string)
  if json["version"]
    install_particular_package(name, json["version"])
  else
    puts "Version not found in #{name}'s metadata."
  end
end

def install_particular_package(name, version)
  version = tidy_version_number(version)
  puts "Getting metadata for #{name} #{version}..."
  json_string = ''
  open("http://registry.npmjs.org/#{name}/#{version}") do |f|
    f.each_line do |line|
      json_string << line
    end
  end
  json = JSON(json_string)
  if version != ''
    if json["dependencies"]
      install_dependencies_then_package(name, version, json["dependencies"])
    else
      install_package(name, version)
    end
  else
    puts "Version not specified."
  end
end

def install_dependencies_then_package(name, version, dependencies)
  version = tidy_version_number(version)
  dependencies.each do |dep_name, dep_version|
    dep_version = tidy_version_number(dep_version)
    puts "Getting metadata for dependency #{dep_name} #{dep_version}..."
    json_string = ''
    open("http://registry.npmjs.org/#{dep_name}/#{dep_version}") do |f|
      f.each_line do |line|
        json_string << line
      end
    end
    json = JSON(json_string)
    if json["dependencies"]
      install_dependencies_then_package(dep_name, dep_version, json["dependencies"])
    end
  end
  install_package(name, version)
end

def install_package(name, version)
  puts "Installing #{name} #{version} globally..."
  `npm install -g #{name}@#{version}`
end

if ARGV.length == 2 || ARGV.length == 3
  argument_number = 0
  install = false
  package_name = ''
  package_version = ''
  ARGV.each do |argument|
    argument_number = argument_number + 1
    case argument_number
    when 1
      install = true if argument == 'install'
    when 2
      package_name = argument
      if install && ARGV.length == 2
        install_latest_package(package_name)
      end
    when 3
      package_version = argument
      if install && ARGV.length == 3
        install_particular_package(package_name, package_version)
      end
    end
  end
else
  puts "Wrong number of arguments. Expected 2 or 3."
end
