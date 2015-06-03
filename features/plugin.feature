Feature: Provider plugin modules

  As an Infracoder developing the vaquero command line tool
  I want to test the accuracy of the Provider plugin interactions for the PLUGIN command
  In order to maintain the users ability to use and create provider plugins for custom infrastructure targets

  Scenario: Request help with PLUGIN commands

    When I get general help for "vaquero_io plugin"
    Then the exit status should be 0
    And the following commands should be documented:
      |help|
      |list|
      |init|
      |install|
      |update|
      |remove|

  Scenario: List installed Providers

    Given a file named "../../lib/providers/vaquero-test-a/Providerfile.yml" with:
    """
    provider:
      name: test-installed-a
      version: 0.0.0.a
    """
    Given a file named "../../lib/providers/vaquero-test-b/Providerfile.yml" with:
    """
    provider:
      name: test-installed-b
      version: 0.0.0.b
    """
    When I run `vaquero_io plugin list`
    Then the exit status should be 0
    And the output should contain "test-installed-a (0.0.0.a)"
    And the output should contain "test-installed-b (0.0.0.b)"
    And I will clean up the test plugin "lib/providers/vaquero-test-a" when finished
    And I will clean up the test plugin "lib/providers/vaquero-test-b" when finished

  Scenario: New Providerfile template

    When I run `vaquero_io plugin init`
    Then the exit status should be 0
    And the output should contain "create  Providerfile.yml"
    And the following files should exist:
      |Providerfile.yml|
    And the file "Providerfile.yml" should contain:
    """
    provider:
      # define the plugin name that can be used to select this provider from the command line or environmental variable
      name:
      version: 0.0.0
    """

    When I run `vaquero_io plugin init example`
    Then the exit status should be 0
    And the output should contain "called with arguments"

  Scenario: Install new Provider

    When I run `vaquero_io plugin install`
    Then the exit status should be 0
    And the output should contain "called with no arguments"

    When I run `vaquero_io plugin install https://github.com/vaquero-io/vaquero_io-plugin-test.git`
    Then the exit status should be 0
    And the output should contain "Successfully installed vaquero_io-plugin-test"
    And the following files should exist:
      |../../lib/providers/vaquero_io-plugin-test/Providerfile.yml|
      |../../lib/providers/vaquero_io-plugin-test/vaquero_io_plugin_test.rb|
    And the file "../../lib/providers/vaquero_io-plugin-test/Providerfile.yml" should contain:
    """
    provider:
      name: vaquero_io-plugin-test
      version: 0.1.1
      location: https://github.com/vaquero-io/vaquero_io-plugin-test.git
    """
    And I will clean up the test plugin "lib/providers/vaquero_io-plugin-test" when finished

    Given a file named "../../lib/providers/vaquero_io-plugin-test/Providerfile.yml" with:
    """
    provider:
      name: vaquero_io-plugin-test
      version: 0.1.1
      location: https://github.com/vaquero-io/vaquero_io-plugin-test.git
    """
    When I run `vaquero_io plugin install https://github.com/vaquero-io/vaquero_io-plugin-test.git`
    Then the exit status should be 0
    And the output should contain "vaquero_io-plugin-test already installed"
    And I will clean up the test plugin "lib/providers/vaquero_io-plugin-test" when finished

  Scenario: Update installed Provider(s)

    Given a file named "../../lib/providers/vaquero_io-plugin-test/Providerfile.yml" with:
    """
    provider:
      name: vaquero_io-plugin-test
      version: 0.1.1
      location: https://github.com/vaquero-io/vaquero_io-plugin-test.git
    """
    When I run `vaquero_io plugin update vaquero_io-plugin-test`
    Then the exit status should be 0
    And the output should contain "vaquero_io-plugin-test provider already at current version"
    And I will clean up the test plugin "lib/providers/vaquero_io-plugin-test" when finished

    Given a file named "../../lib/providers/vaquero_io-plugin-test/Providerfile.yml" with:
    """
    provider:
      name: vaquero_io-plugin-test
      version: 0.0.0
      location: https://github.com/vaquero-io/vaquero_io-plugin-test.git
    """
    When I run `vaquero_io plugin update vaquero_io-plugin-test`
    Then the exit status should be 0
    And the output should contain "Updated vaquero_io-plugin-test version 0.0.0 -> 0.1.1"
    And I will clean up the test plugin "lib/providers/vaquero_io-plugin-test" when finished

  Scenario: Remove Provider

    When I run `vaquero_io plugin remove`
    Then the exit status should be 0
    And the output should contain "called with no arguments"

    When I run `vaquero_io plugin remove vaquero_io-plugin-test`
    Then the exit status should be 1
    And the output should contain "Missing or invalid Providerfile"

    Given a file named "../../lib/providers/vaquero_io-plugin-test/Providerfile.yml" with:
    """
    provider:
      name: vaquero_io-plugin-test
      version: 0.1.1
      location: https://github.com/vaquero-io/vaquero_io-plugin-test.git
    """
    When I run `vaquero_io plugin remove vaquero_io-plugin-test`
    Then the exit status should be 0
    And the output should contain "vaquero_io-plugin-test removed"
    And I will clean up the test plugin "lib/providers/vaquero_io-plugin-test" when finished
