Feature: Provider plugin gems

  As an Infracoder developing the vaquero command line tool
  I want to test the accuracy of the Provider gem interactions for the Provider command
  In order to maintain the users ability to use custom infrastructure targets

  Scenario: Request help with Provider commands

    When I get general help for "vaquero_io help provider"
    Then the exit status should be 0
    And the following commands should be documented:
      |list|
      |discover|

  Scenario: List installed Providers

    When I run `vaquero_io provider --list`
    Then the output should contain "vaquero_io"

  Scenario: Discover available Providers

    When I run `vaquero_io provider --discover`
    Then the output should contain "vaquero_io"

  Scenario: List default provider when no argument specified but defined in .env

    Given a file named ".vaquero_io/.env" with:
    """
    # Environment variables used by vaquero_io
    #
    # Provider
    export VAQUEROIO_DEFAULT_PROVIDER = 'RANDOM'
    export VAQEUROIO_DEFAULT_ENV =
    # Logging
    export VAQUEROIO_OVERWRITE_LOGS = false

    export VAQUEROIO_REMOTE_LOGGER = 'papertrail'
    export VAQUEROIO_PAPERTRAIL_URL = '<your-url>'
    export VAQUEROIO_PAPERTRAIL_PORT = '<your-port>'

    #export VAQUEROIO_REMOTE_LOGGER = 'loggly'
    #export VAQUEROIO_LOGGLY_URL = '<your-url>'
    """
    When I run `vaquero_io provider`
    Then the output should contain "RANDOM"

  Scenario: List default provider when no argument and not defined in .env

    Given a file named ".vaquero_io/.env" with:
    """
    # Environment variables used by vaquero_io
    #
    # Provider
    export VAQUEROIO_DEFAULT_PROVIDER =
    export VAQEUROIO_DEFAULT_ENV =
    # Logging
    export VAQUEROIO_OVERWRITE_LOGS = false

    export VAQUEROIO_REMOTE_LOGGER = 'papertrail'
    export VAQUEROIO_PAPERTRAIL_URL = '<your-url>'
    export VAQUEROIO_PAPERTRAIL_PORT = '<your-port>'

    #export VAQUEROIO_REMOTE_LOGGER = 'loggly'
    #export VAQUEROIO_LOGGLY_URL = '<your-url>'
    """
    When I run `vaquero_io provider`
    Then the output should contain "No default provider"