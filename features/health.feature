Feature: Provider Health check

  As an Infracoder developing the vaquero command line tool
  I want to routinely test the syntactic health of the platform definition files against the plugin definition
  In order to support consistent maintenance of large and multi-environment platforms

  Scenario: Health check of a correctly defined platform

    Given a file named "platform.yml" with:
    """
    platform:
      product: test
      provider: vaquero-plugin-test
      plugin_version: 0.1.0.pre

      environments:
        - dev
        - prod

      #
      # environment    environment name from the key above
      # component      component name
      # instance       single leading zero 0..9, up to count of component pool
      # geo            first letter of geo key value
      # 'string'       any single quoted string, escape char not evaluated
      #

      nodename:
        - 'node'
        - instance

      # You can add any other custom attributes to the platform definition
      # by creating additional yml files with key values. The referenced
      # files are, by convention, assumed to have the following structure:
      #
      # tags:
      #
      #   tagset1: &tagset1
      #     key1: value
      #     key2: value
      #     ...
      #
      #   tagset2:
      #     <<: *tagset1
      #     key2: override value
      #
      #
      # Example: array of string
      #
      # references:
      #   path: 'infrastructure/'
      #   keyfiles:
      #     - tags
      #

      pools:

        defaultpool: &defaultpool
          file1: devweb
          file2: nonprodweb
          count: 2
          run_list:
            - 'role[loc_uswest]'
            - 'recipe[loc_uswest]'
          component_role: 'role[aw_#]'
          chef_server: https://manage.chef.io
          addresses:
            -

      components:

        api:
          <<: *defaultpool
          addresses:
            - 10.10.10.1
            - 10.10.10.2

        aui:
          <<: *defaultpool
          addresses:
            - 10.10.10.10
            - 10.10.10.20
    """
    Given a file named "required/file1.yml" with:
    """
    file1:
      #
      file1record1:
        any_alphanumeric: DEV_WEB_NET
        any_IP: 10.10.128.1
        any_integer: 19
        any_boolean: true

      file1record2:
        any_alphanumeric: PROD_WEB_NET
        any_IP: 10.10.20.1
        any_integer: 24
        any_boolean: false
    """
    Given a file named "required/file2.yml" with:
    """
    file2:
      #
      default: &default
        cpu: 1
        ram: 2048
        drive:
          mount: '/media/data'
          capacity: 8192
        image: 'centos_2015.xxx'

      nonprodweb:
        <<: *default

      prodweb:
        <<: *default
        ram: 4096
        drive:
          capacity: 28192

    """
    Given a file named "environments/dev.yml" with:
    """

    """
    Given a file named "environments/prod.yml" with:
    """

    """
    When I run `vaquero plugin install https://github.com/vaquero-io/vaquero-plugin-test.git`
    When I run `vaquero health -p vaquero-plugin-test`
    Then the exit status should be 0
    And the output should contain "Success:"
    And I will clean up the test plugin "lib/providers/vaquero-plugin-test" when finished

  Scenario: Health check of a incorrectly defined platform (stress each param in test platform.yml)

    # for required files: this test only omits. See later test for validation of provided entries
    # for run_lists: test empty array
    # for component_role: test mismatch regex

    Given a file named "platform.yml" with:
    """
    platform:
      product: test
      provider: vaquero-plugin-test
      plugin_version: 0.1.0.pre

      environments:
        -

      #
      # environment    environment name from the key above
      # component      component name
      # instance       single leading zero 0..9, up to count of component pool
      # geo            first letter of geo key value
      # 'string'       any single quoted string, escape char not evaluated
      #

      nodename:
        -

      # You can add any other custom attributes to the platform definition
      # by creating additional yml files with key values. The referenced
      # files are, by convention, assumed to have the following structure:
      #
      # tags:
      #
      #   tagset1: &tagset1
      #     key1: value
      #     key2: value
      #     ...
      #
      #   tagset2:
      #     <<: *tagset1
      #     key2: override value
      #
      #
      # Example: array of string
      #
      # references:
      #   path: 'infrastructure/'
      #   keyfiles:
      #     - tags
      #

      pools:

        defaultpool: &defaultpool
          count: 25
          run_list: 'string instead of array'
          component_role: 'role[aw_%]'
          chef_server: 10.10.10.1
          addresses:
            -

      components:

        api:
          <<: *defaultpool
          addresses:
            - 10.10.300.1
            - 10.10.10.2

        aui:
          <<: *defaultpool
          addresses:
            - 10.10.10.10
            - 10.10.10.20
    """
    Given a file named "required/file1.yml" with:
    """
    file1:
      #
      file1record1:
        any_alphanumeric: 0
        any_IP: 10.10.300.1
        any_integer: 30
        any_boolean: random

      file1record2:
        any_alphanumeric: PROD_WEB_NET
        any_IP: 10.10.20.1
        any_integer: 24
        any_boolean: false
    """
    Given a file named "required/file2.yml" with:
    """
    file2:
      #
      default: &default
        cpu: 100
        ram: 0
        drive:
          mount: 0
          capacity: 0
        image:

      nonprodweb:
        <<: *default

      prodweb:
        <<: *default
        ram: 4096
        drive:
          capacity: 28192

    """
    Given a file named "environments/dev.yml" with:
    """

    """
    Given a file named "environments/prod.yml" with:
    """

    """
    When I run `vaquero plugin install https://github.com/vaquero-io/vaquero-plugin-test.git`
    When I run `vaquero health -p vaquero-plugin-test`
    And the output should contain "Empty environments definition"
    And the output should contain "Empty nodename convention"
    And the output should contain "No references to required file:file1"
    And the output should contain "No references to required file:file2"
    And the output should contain "Validation error: api:count"
    And the output should contain "Validation error: api:run_list"
    And the output should contain "Validation error: api:component_role"
    And the output should contain "Validation error: api:chef_server"
    And the output should contain "Validation error: api:addresses"
    And the output should contain "Validation error: file1record1:any_alphanumeric"
    And the output should contain "Validation error: file1record1:any_IP"
    And the output should contain "Validation error: file1record1:any_integer"
    And the output should contain "Validation error: file1record1:any_boolean"
    And the output should contain "Validation error: default:cpu"
    And the output should contain "Validation error: default:ram"
    And the output should contain "Validation error: default:drive"
    And the output should contain "Validation error: default:image"
    And I will clean up the test plugin "lib/providers/vaquero-plugin-test" when finished
