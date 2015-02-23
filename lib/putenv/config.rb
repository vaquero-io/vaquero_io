# Gem default configuration settings
# rubocop:disable LineLength
module Putenv
  # plugin conventions
  PROVIDERFILE = 'Providerfile.yml'
  PROVIDERS_PATH = "#{File.dirname(__FILE__).chomp('putenv')}providers/"
  LIST_PLUGINS_PATH = "#{PROVIDERS_PATH + '**/Providerfile.yml'}"
  TEMPLATE_PROVIDER = "templates/#{PROVIDERFILE}.tt"
  TMP_INSTALL_FOLDER = "#{Dir.pwd}/tmp-providers"
  TMP_INSTALL_PROVIDER = "#{TMP_INSTALL_FOLDER}/#{PROVIDERFILE}"
  ENVIRONMENTFILE = 'environments/'

  # provider platform temmplates
  PLATFORMFILE = 'platform.yml'

  # system variables
  PUTENV_PROVIDER = 'PUTENV_PROVIDER'
end
# rubocop:enable LineLength
