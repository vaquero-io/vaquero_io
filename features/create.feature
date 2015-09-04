Feature: Create virtual machines via specified provider

  As an Infracoder developing the vaquero command line tool
  I want to test the ability of the tool to reference gems created as provider plugins
  In order to maintain the ability of the tool to support custom providers

  Scenario: Request help with create command

    When I get general help for "vaquero_io help create"
    Then the exit status should be 0
    And the output should contain "Usage:"
    And the output should contain "vaquero_io create ENV {-r ROLE {-n NODE#..#}}"

  Scenario: vaquero_io_provider_template provides the default response

    When I run `vaquero_io create ENV`
    Then the exit status should be 0
    And the output should contain "create command"
