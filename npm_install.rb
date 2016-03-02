require_relative 'lib/package_installer'

package_installer = PackageInstaller.new
if ARGV.length == 1
  if ARGV[0].include? '@'
    package_installer.install_particular_package(
      ARGV[0].split('@').first, ARGV[0].split('@').last
    )
  else
    package_installer.install_latest_package(ARGV[0])
  end
else
  puts "Wrong number of arguments. Expected 1."
end
