require 'open-uri'
require 'json'

class PackageInstaller
  def initialize
    @installed_packages = []
    @discovered_dependencies = []
  end

  def tidy_version_number(version)
    version = version.gsub(/[\^\~\<\>\=]/, '')
    version.gsub(/\s.+/, '')
  end

  def install_latest_package(name)
    puts "Getting metadata for the latest version of #{name}..."
    json_string = ''
    begin
      open("http://registry.npmjs.org/#{name}/latest") do |f|
        f.each_line do |line|
          json_string << line
        end
      end
    rescue
      puts "Could not get metadata for the latest version of #{name}."
    end
    unless json_string == ''
      json = JSON(json_string)
      if json["version"]
        self.install_particular_package(name, json["version"])
      else
        puts "Version not found in #{name}'s metadata."
      end
    end
  end

  def install_particular_package(name, version)
    version = tidy_version_number(version)
    puts "Getting metadata for #{name} #{version}..."
    json_string = ''
    begin
      open("http://registry.npmjs.org/#{name}/#{version}") do |f|
        f.each_line do |line|
          json_string << line
        end
      end
    rescue
      puts "Could not get metadata for #{name} #{version}."
    end
    unless json_string == ''
      json = JSON(json_string)
      if version != ''
        if json["dependencies"]
          self.install_dependencies_then_package(name, version,
            json["dependencies"])
        else
          self.install_package(name, version)
        end
      else
        puts "Version not specified."
      end
    end
  end

  def package_already_installed?(name, version)
    @installed_packages.each do |installed_name, installed_version|
      return true if name == installed_name && version == installed_version
    end
    false
  end

  def dependency_already_discovered?(name, version)
    @discovered_dependencies.each do |dependency_name, dependency_version|
      return true if name == dependency_name && version == dependency_version
    end
    false
  end

  def install_dependencies_then_package(name, version, dependencies)
    version = tidy_version_number(version)
    puts "Installing dependencies for #{name} #{version}..."
    dependencies.each do |dep_name, dep_version|
      dep_version = tidy_version_number(dep_version)
      unless self.dependency_already_discovered?(dep_name, dep_version)
        @discovered_dependencies << [dep_name, dep_version]

        unless self.package_already_installed?(dep_name, dep_version)
          puts "Getting metadata for dependency #{dep_name} #{dep_version}..."
          json_string = ''
          begin
            open("http://registry.npmjs.org/#{dep_name}/#{dep_version}") do |f|
              f.each_line do |line|
                json_string << line
              end
            end
          rescue
            puts "Could not get metadata for dependency #{dep_name} " +
              "#{dep_version}."
          end
          unless json_string == ''
            json = JSON(json_string)
            if json["dependencies"]
              self.install_dependencies_then_package(dep_name, dep_version,
                json["dependencies"])
            end
          end
        end
      end
    end
    self.install_package(name, version)
  end

  def install_package(name, version)
    puts "Installing #{name} #{version} globally..."
    `npm install -g #{name}@#{version}`
    @installed_packages << [name, version]
  end
end