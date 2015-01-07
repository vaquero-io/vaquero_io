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

  # Error messages
  NO_PROVIDER = 'Missing or invalid Providerfile'
  PLUGINS_CURRENT = ' provider already at current version'
end
# rubocop:enable LineLength
