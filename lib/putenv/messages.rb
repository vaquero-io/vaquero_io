# string constants for interactive messages
# rubocop:disable LineLength
module Putenv
  # command descriptions
  DESC_VERSION = 'Display gem version'

  DESC_PLUGIN = 'Manage Provider plugin modules'
  DESC_PLUGIN_LIST = 'List installed Provider plugins'
  DESC_PLUGIN_INSTALL = 'Install Provider plugin from LOCATION'
  DESC_PLUGIN_UPDATE = 'Update installed Provider plugins'
  DESC_PLUGIN_REMOVE = 'Remove installed Provider plugin'
  DESC_PLUGIN_INIT = 'Create new Providerfile template for custom provider development'

  DESC_NEW = 'Create new platform definition files based on specified Provider'
  MSG_NEW_SUCCESS = 'Platform definition files successfully created'

  # Error messages
  NO_PROVIDER_FILE = 'Missing or invalid Providerfile'
  NO_PROVIDER = 'Must specify a valid, installed provider plugin for platform definition'
  PLUGINS_CURRENT = ' provider already at current version'
  PLATFORM_EXISTS = 'Platform files already exist at this location'
end
# rubocop:enable LineLength
