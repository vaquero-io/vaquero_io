Feature: Platform definition validate

  As an Infracoder developing the vaquero command line tool
  I want to routinely test the syntactic health of the platform definition files against the plugin definition
  In order to support consistent maintenance of large and multi-environment platforms

  Scenario: Request help with validate command

    When I get general help for "vaquero_io help validate"
    Then the exit status should be 0
    And the output should contain "Usage:"
    And the output should contain "vaquero_io validate"

  Scenario: Validation of a correctly defined platform

    Given a file named "platform.yml" with:
    """
    platform:
      product: demo
      provider: vaquero_io_provider_template
      plugin_version: 2.0.2

      environments:
        - dev
        - int
        - qa
        - prod

      nodename:
        - environment
        - role

      infrastructure:
        - vcenter
        - network
        - compute

      profiles:

        defaultwebprofile: &defaultwebprofile
          vcenter: dev
          network: devweb
          compute: tiny
          count: 2
          cmserver: 'http://chef.domain.com'
          cmrunlist:
            - 'role[org-base]'
            - 'role[app-#]'
          addresses:
            -

        defaultsvcprofile: &defaultsvcprofile
          <<: *defaultwebprofile
          network: devsvc

        defaultdbprofile: &defaultdbprofile
          <<: *defaultwebprofile
          network: devdb
          compute: smalldb

      roles:

        cui:
          <<: *defaultwebprofile

        adminui:
          <<: *defaultwebprofile

        api:
          <<: *defaultsvcprofile

        db:
          <<: *defaultdbprofile
    """
    Given a file named "infrastructure/vcenter.yml" with:
    """
    vcenter:

      defaultnonprod: &defaultnonprod
        timezone: 85
        datacenter: 'http://nonprod.domain.com'
        imagefolder: 'org/app/templates'
        destfolder: 'org/app/dev'
        datastore: 'org-nonprod'
        domain: dev.domain.com
        dnsips:
          - 10.1.1.15
          - 10.1.1.16

      defaultprod: &defaultprod
        <<: *defaultnonprod
        datacenter: 'http://prod.domain.com'
        destfolder: 'org/app/undefined'
        datastore: 'org-prod'
        domain: domain.com
        dnsips:
          - 10.200.1.15
          - 10.200.1.16

      dev:
        <<: *defaultnonprod

      int:
        <<: *defaultnonprod
        destfolder: 'org/app/int'

      qa:
        <<: *defaultnonprod
        destfolder: 'org/app/qa'

      prod:
        <<: *defaultprod
        destfolder: 'org/app/prod'
    """
    Given a file named "infrastructure/compute.yml" with:
    """
    compute:

      default: &default
        windows: false
        cpu: 1
        ram: 1024
        image: 'org-centos-rev00002'
        disk:
          mount: 'opt'
          capacity: 8192

      defaultdb: &defaultdb
        windows: false
        cpu: 4
        ram: 8192
        image: 'org-centos-rev00002'
        disk:
          mount: 'opt'
          capacity: 81920

      tiny:
        <<: *default

      small:
        <<: *default
        ram: 2048

      medium:
        <<: *default
        ram: 4096

      smalldb:
        <<: *defaultdb

      mediumdb:
        <<: *defaultdb
        ram: 12288
    """
    Given a file named "infrastructure/network.yml" with:
    """
    network:

      devweb:
        vlanid: DEV_WEB_NET
        gateway: 10.1.128.1
        netmask: 19

      devsvc:
        vlanid: DEV_SVC_NET
        gateway: 10.2.128.1
        netmask: 19

      devdb:
        vlanid: DEV_DB_NET
        gateway: 10.8.128.1
        netmask: 19

      qaweb:
        vlanid: QA_WEB_NET
        gateway: 10.21.128.1
        netmask: 19

      qasvc:
        vlanid: QA_SVC_NET
        gateway: 10.22.128.1
        netmask: 19

      qadb:
        vlanid: QA_DB_NET
        gateway: 10.28.128.1
        netmask: 19

      prodweb:
        vlanid: PROD_WEB_NET
        gateway: 10.101.128.1
        netmask: 19

      prodsvc:
        vlanid: PROD_SVC_NET
        gateway: 10.102.128.1
        netmask: 19

      proddb:
        vlanid: PROD_DB_NET
        gateway: 10.108.128.1
        netmask: 19
    """
    Given a file named "environments/dev.yml" with:
    """
    dev:

      cui:
        addresses:
          - 10.1.10.10
          - 10.1.10.11

      adminui:
        addresses:
          - 10.1.10.20
          - 10.1.10.21

      api:
        addresses:
          - 10.2.10.10
          - 10.2.10.11

      db:
        addresses:
          - 10.8.10.10
          - 10.8.10.11
    """
    Given a file named "environments/int.yml" with:
    """
    int:

      cui:
        vcenter: int
        addresses:
          - 10.1.20.10
          - 10.1.20.11

      adminui:
        vcenter: int
        addresses:
          - 10.1.20.20
          - 10.1.20.21

      api:
        vcenter: int
        addresses:
          - 10.2.20.10
          - 10.2.20.11

      db:
        vcenter: int
        addresses:
          - 10.8.20.10
          - 10.8.20.11
    """
    Given a file named "environments/qa.yml" with:
    """
    qa:

      cui:
        vcenter: qa
        network: qaweb
        addresses:
          - 10.21.10.10
          - 10.21.10.11

      adminui:
        vcenter: qa
        network: qaweb
        addresses:
          - 10.21.10.20
          - 10.21.10.21

      api:
        vcenter: qa
        network: qasvc
        addresses:
          - 10.22.10.10
          - 10.22.10.11

      db:
        vcenter: qa
        network: qadb
        addresses:
          - 10.28.10.10
          - 10.28.10.11
    """
    Given a file named "environments/prod.yml" with:
    """
    prod:

      cui:
        vcenter: prod
        network: prodweb
        compute: medium
        count: 8
        addresses:
          - 10.21.101.10
          - 10.21.101.11
          - 10.21.101.12
          - 10.21.101.13
          - 10.21.101.14
          - 10.21.101.15
          - 10.21.101.16
          - 10.21.101.17

      adminui:
        vcenter: prod
        network: prodweb
        compute: medium
        count: 4
        addresses:
          - 10.21.101.20
          - 10.21.101.21
          - 10.21.101.22
          - 10.21.101.23

      api:
        vcenter: prod
        network: prodsvc
        compute: medium
        count: 12
        addresses:
          - 10.22.102.10
          - 10.22.102.11
          - 10.22.102.12
          - 10.22.102.13
          - 10.22.102.14
          - 10.22.102.15
          - 10.22.102.16
          - 10.22.102.17
          - 10.22.102.18
          - 10.22.102.19
          - 10.22.102.20
          - 10.22.102.21

      db:
        vcenter: prod
        network: proddb
        compute: mediumdb
        addresses:
          - 10.28.108.10
          - 10.28.108.11
    """
    When I run `vaquero_io validate`
    Then the exit status should be 0
    And the output should contain "Platform definition validated successfully"