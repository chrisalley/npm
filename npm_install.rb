require_relative 'lib/package_installer'

package_installer = PackageInstaller.new
case ARGV.length
when 0
  package_installer.begin_installation('')
when 1
  package_installer.begin_installation(ARGV[0])
when 2
  if ARGV[0] == '-g'
    package_installer.install_packages_globally = true
    package_installer.begin_installation(ARGV[1])
  elsif ARGV[1] == '-g'
    package_installer.install_packages_globally = true
    package_installer.begin_installation(ARGV[0])
  else
    puts "One or more of your arguments is not supported."
  end
else
  puts "Wrong number of arguments. Maximum of 2."
end
