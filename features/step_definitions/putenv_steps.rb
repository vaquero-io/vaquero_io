require 'fileutils'
# rubocop:disable LineLength, StringLiterals
When(/^I get general help for "([^"]*)"$/) do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} --help`)
  step %(I run `#{app_name}`)
end

Then(/^the banner should be present$/) do
  step %(the output should match /putenv commands:/)
end

Then(/^the following commands should be documented:$/) do |options|
  options.raw.each do |option|
    step %(the command "#{option[0]}" should be documented)
  end
end

Then(/^the command "([^"]*)" should be documented$/) do |options|
  options.split(',').map(&:strip).each do |option|
    step %(the output should match /\\s*#{Regexp.escape(option)}[\\s\\W]+\\w[\\s\\w][\\s\\w]+/)
  end
end

Then(/^the output should display the version$/) do
  step %(the output should match /\\d+\\.\\d+\\.\\d+/)
end

Then(/^I will clean up the test plugin "([^"]*)" when finished$/) do |plugin|
  puts plugin
  puts Dir.pwd
  FileUtils.remove_dir(plugin) if File.file?("#{plugin}/Providerfile.yml")
end

# Then(/^I will clean up the test plugin "([^"]*)" when finished$/) do |plugin|
#   FileUtils.remove_dir('lib/providers/putenv-plugin-test') if File.file?('lib/providers/putenv-plugin-test/Providerfile.yml')
# end

# Given(/^I have cleaned up the test plugin$/) do
#   FileUtils.remove_dir('lib/providers/putenv-plugin-test') if File.file?('lib/providers/putenv-plugin-test/Providerfile.yml')
# end

# rubocop:enable LineLength, StringLiterals
