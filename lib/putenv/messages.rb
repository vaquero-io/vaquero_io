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

  DESC_HEALTH = 'Health check of all platform files and list all nodes for ENVIRONMENT'
  HEALTHY = 'Success: Platform definition files exist and parameters match type requirements'

  # Error messages
  NO_PROVIDER_FILE = 'Missing or invalid Providerfile'
  NO_PROVIDER = 'Must specify a valid, installed provider plugin for platform definition'
  PLUGINS_CURRENT = ' provider already at current version'
  PLATFORM_EXISTS = 'Platform files already exist at this location'

  MISSING_PLATFORM = 'Missing or invalid platform definitions file:'

  FAIL_PROVIDER = 'Incorrect Provider'
  WARN_PROVIDER_VERSION = 'Warning: Version difference between Provider plugin and platform definition'
  FAIL_EMPTY_ENVIRONMENTS = 'Empty environments definition'
  FAIL_EMPTY_NODENAME = 'Emptry nodename convention'
  FAIL_REQUIRED_FILES = 'No references to required file:'
end
# rubocop:enable LineLength
