# Copyright information in version.rb
#
# string constants for interactive messages
# rubocop:disable LineLength
module VaqueroIo
  # command descriptions
  DESC = {
    cmd_version:              'Print vaquero_io version information',
    cmd_init:                 'Create new platform definition files based on specified Provider',
    cmd_init_provider:        'Specify vaquero_io provider gem to generate platform files',
    cmd_init_create_gemfile:  'Create Gemfile with vaquero_io and provider dependencies',
    cmd_create:               'Provision and boot strap an ENV, COMPONENT, or NODE(s)',
    cmd_validate:             'Validate contents of platform desired state files',
    cmd_set:                  'Set the default ENV ',
    cmd_show:                 'Print current state information',
    cmd_show_test:            'Include serverspec test results',
    cmd_show_config_only:     'Show only running configuration',
    cmd_destroy:              'Destroy an ENV, COMPONENT, or NODE(s)',
    cmd_verify:               'Verify nodes using serverspec and provider-gem test'
  }
  # Warning error messages
  # Fatal error messages
  FERR = {
    fatal_no_provider:        'must specify a valid vaquero_io provider'
  }
  # ------------------------------------------
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

  DESC_BUILD = 'Provision vms in an environment definition'
  DESC_BUILD_ALL = 'Build everything for the named environment'
  DESC_BUILD_COMPONENT = 'Build all nodes for the specified component'
  DESC_BUILD_NODE = 'Build the single specified node'

  # Error messages
  NO_PROVIDER_FILE = 'Missing or invalid Providerfile'
  NO_PROVIDER = 'Must specify a valid, installed provider plugin for platform definition'
  PLUGINS_CURRENT = ' provider already at current version'
  PLATFORM_EXISTS = 'Platform files already exist at this location'

  MISSING_PLATFORM = 'Missing or invalid platform definitions file:'

  FAIL_PROVIDER = 'Incorrect Provider'
  WARN_PROVIDER_VERSION = 'Warning: Version difference between Provider plugin and platform definition'
  FAIL_EMPTY_ENVIRONMENTS = 'Empty environments definition'
  FAIL_EMPTY_NODENAME = 'Empty nodename convention'
  FAIL_REQUIRED_FILES = 'No references to required file:'
  FAIL_MISSING_ENV = 'Defined environment files not found:'
end
# rubocop:enable LineLength
