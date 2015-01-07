# Gem default configuration settings
# rubocop:disable LineLength
module Putenv
  # plugin conventions
  PROVIDERFILE = 'Providerfile.yml'
  PATH_PROVIDERS = "#{File.dirname(__FILE__).chomp('putenv')}providers/"
  PATH_LIST_PLUGINS = %W(#{PATH_PROVIDERS + '**/*.yml'} #{PROVIDERFILE})
  TEMPLATE_PROVIDER = "templates/#{PROVIDERFILE}.tt"
  INSTALL_WORK_FOLDER = "#{Dir.pwd}/tmp-providers"
  INSTALL_WORK_PROVIDER = "#{INSTALL_WORK_FOLDER}/#{PROVIDERFILE}"
end
# rubocop:enable LineLength
