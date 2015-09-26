Feature: New platform definition files for specified provider

  As an Infracoder developing the vaquero command line tool
  I want to test the ability to create platform definition template files for a provider
  In order to assist the user in creating and maintaining definition files for product platforms

  Scenario: Request help with init command

    When I get general help for "vaquero_io help init"
    Then the exit status should be 0
    And the output should contain "Usage:"
    And the output should contain "init PLATFORM"

  Scenario: Attempt to initialize a platform template without specifying a provider or default

    When I run `vaquero_io init PLATFORM`
    Then the exit status should be 1
    And the output should contain "Cannot load the Provider Gem specified"

  Scenario: Attempt to initialize a platform template with an invalid provider

    When I run `vaquero_io init PLATFORM --provider=RANDOM`
    Then the exit status should be 1
    And the output should contain "Cannot load the Provider Gem specified"

  Scenario: Attempt to initialize a platform template with an invalid default provider

    Given a file named ".vaquero_io/.env" with:
    """
    # Environment variables used by vaquero_io
    #
    # Provider
    export VAQUEROIO_DEFAULT_PROVIDER = 'RANDOM'
    # Logging
    export VAQUEROIO_OVERWRITE_LOGS = false

    # export VAQUEROIO_REMOTE_LOGGER = 'papertrail'
    # export VAQUEROIO_PAPERTRAIL_URL = '<your-url>'
    # export VAQUEROIO_PAPERTRAIL_PORT = '<your-port>'

    # export VAQUEROIO_REMOTE_LOGGER = 'loggly'
    # export VAQUEROIO_LOGGLY_URL = '<your-url>'
    """
    When I run `vaquero_io init PLATFORM`
    Then the exit status should be 1
    And the output should contain "Cannot load the Provider Gem specified"

  Scenario: Create new platform definition file specifying a valid provider

    # Gemfile includes this provider testing gem
    When I run `vaquero_io init PLATFORM --provider=vaquero_io_provider_template`
    Then the exit status should be 0
    And the output should contain "Platform definition files successfully created"
    And the following files should exist:
      |platform.yml|
      |infrastructure/vcenter.yml|
      |infrastructure/compute.yml|
      |infrastructure/network.yml|
    And the file "platform.yml" should contain:
    """
    platform:
      product: PLATFORM
      provider: vaquero_io_provider_template
      plugin_version: 2.0.1

      environments:
        -

      nodename:
        - environment
        - role

      infrastructure:
        - vcenter
        - network
        - compute

      profiles:

        defaultprofile: &defaultprofile
          vcenter:
          network:
          compute:
          count:
          cmserver:
          cmrunlist:
            -
          addresses:
            -

      roles:

        example:
          <<: *defaultprofile
    """
    And the file "infrastructure/vcenter.yml" should contain:
    """
    vcenter:

      default: &default
        timezone:
        datacenter:
        imagefolder:
        destfolder:
        datastore:
        domain:
        dnsips:
            -

      dev:
        <<: *default
    """
    And the file "infrastructure/compute.yml" should contain:
    """
    compute:

      default: &default
        windows:
        ram:
        cpu:
        image:
        disk:
          mount:
          capacity:

      dev:
        <<: *default
    """
    And the file "infrastructure/network.yml" should contain:
    """
    network:

      default: &default
        vlanid:
        gateway:
        netmask:

      dev:
        <<: *default
    """

  Scenario: Create new platform definition file with no specified provider but a valid default

    # Gemfile includes this provider testing gem
    Given a file named ".vaquero_io/.env" with:
    """
    # Environment variables used by vaquero_io
    #
    # Provider
    export VAQUEROIO_DEFAULT_PROVIDER = 'vaquero_io_provider_template'
    # Logging
    export VAQUEROIO_OVERWRITE_LOGS = false

    # export VAQUEROIO_REMOTE_LOGGER = 'papertrail'
    # export VAQUEROIO_PAPERTRAIL_URL = '<your-url>'
    # export VAQUEROIO_PAPERTRAIL_PORT = '<your-port>'

    # export VAQUEROIO_REMOTE_LOGGER = 'loggly'
    # export VAQUEROIO_LOGGLY_URL = '<your-url>'
    """
    When I run `vaquero_io init PLATFORM`
    Then the exit status should be 0
    And the output should contain "Platform definition files successfully created"
    And the following files should exist:
      |platform.yml|
      |infrastructure/vcenter.yml|
      |infrastructure/compute.yml|
      |infrastructure/network.yml|