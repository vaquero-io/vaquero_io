Feature: Display information about the platform

  As an Infracoder developing the vaquero command line tool
  I want to display formatted information about the platform
  In order to assist the user in managing provision automation

  Scenario: Request help with show command

    When I get general help for "vaquero_io help show"
    Then the exit status should be 0
    And the output should contain "Usage:"
    And the output should contain "aquero_io show [INFRA|ENV|{all}]"

  Scenario: Show platform details with no other arguments

    Given a file named "platform.yml" with:
    """
    platform:
      product: demo
      provider: vaquero_io_provider_template
      plugin_version: 2.0.0

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
          cmserver: chef.domain.com
          cmrunlist:
            - org-base
            - app-#
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
        timezone: 085
        datacenter: 'nonprod.domain.com'
        imagefolder: 'org/app/templates'
        destfolder: 'org/app/dev'
        datastore: 'org-nonprod'
        domain: dev.domain.com
        dnsips:
          - 10.1.1.15
          - 10.1.1.16

      defaultprod: &defaultprod
        <<: *defaultnonprod
        datacenter: 'prod.domain.com'
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
        cpu: 1
        ram: 1024
        image: 'org-centos-rev00002'
        disk:
          mount: 'opt'
          capacity: 8192

      defaultdb: &defaultdb
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
    When I run `vaquero_io show`
    Then the output should contain "infrastructure: vcenter, network, compute"
    And the output should contain "role                    DEV          INT          QA          PROD"
    And the output should contain "cui                      2            2            2            8"
    And the output should contain "adminui                  2            2            2            4"
    And the output should contain "api                      2            2            2           12"
    And the output should contain "db                       2            2            2            2"
    And the output should contain "TOTAL                    8            8            8           26"
    When I run `vaquero_io show infra`
    Then the output should contain "role                   infra         DEV          INT          QA          PROD"
    Then the output should contain "cui"
    Then the output should contain "                      vcenter        dev          int          qa          prod"
    Then the output should contain "                      network      devweb       devweb        qaweb       prodweb"
    Then the output should contain "                      compute       tiny         tiny         tiny        medium"
    Then the output should contain "adminui"
    Then the output should contain "api"
    Then the output should contain "db"
    Then the output should contain "                      compute      smalldb      smalldb      smalldb     mediumdb"
    When I run `vaquero_io show infra vcenter`
    Then the output should contain:
    """
    defaultnonprod:
      timezone: 085
      datacenter: nonprod.domain.com
      imagefolder: org/app/templates
      destfolder: org/app/dev
      datastore: org-nonprod
      domain: dev.domain.com
      dnsips: &1
      - 10.1.1.15
      - 10.1.1.16
    defaultprod:
      timezone: 085
      datacenter: prod.domain.com
      imagefolder: org/app/templates
      destfolder: org/app/undefined
      datastore: org-prod
      domain: domain.com
      dnsips: &2
      - 10.200.1.15
      - 10.200.1.16
    dev:
      timezone: 085
      datacenter: nonprod.domain.com
      imagefolder: org/app/templates
      destfolder: org/app/dev
      datastore: org-nonprod
      domain: dev.domain.com
      dnsips: *1
    int:
      timezone: 085
      datacenter: nonprod.domain.com
      imagefolder: org/app/templates
      destfolder: org/app/int
      datastore: org-nonprod
      domain: dev.domain.com
      dnsips: *1
    qa:
      timezone: 085
      datacenter: nonprod.domain.com
      imagefolder: org/app/templates
      destfolder: org/app/qa
      datastore: org-nonprod
      domain: dev.domain.com
      dnsips: *1
    prod:
      timezone: 085
      datacenter: prod.domain.com
      imagefolder: org/app/templates
      destfolder: org/app/prod
      datastore: org-prod
      domain: domain.com
      dnsips: *2
    """
    When I run `vaquero_io show env prod`
    Then the output should contain:
    """
    cui:
      vcenter: &1
        timezone: 085
        datacenter: prod.domain.com
        imagefolder: org/app/templates
        destfolder: org/app/prod
        datastore: org-prod
        domain: domain.com
        dnsips:
        - 10.200.1.15
        - 10.200.1.16
      network: &2
        vlanid: PROD_WEB_NET
        gateway: 10.101.128.1
        netmask: 19
      compute: &3
        cpu: 1
        ram: 4096
        image: org-centos-rev00002
        disk:
          mount: opt
          capacity: 8192
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
      cmserver: chef.domain.com
      cmrunlist:
      - org-base
      - app-cui
      nodename: prodcui
    adminui:
      vcenter: *1
      network: *2
      compute: *3
      count: 4
      addresses:
      - 10.21.101.20
      - 10.21.101.21
      - 10.21.101.22
      - 10.21.101.23
      cmserver: chef.domain.com
      cmrunlist:
      - org-base
      - app-adminui
      nodename: prodadminui
    api:
      vcenter: *1
      network:
        vlanid: PROD_SVC_NET
        gateway: 10.102.128.1
        netmask: 19
      compute: *3
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
      cmserver: chef.domain.com
      cmrunlist:
      - org-base
      - app-api
      nodename: prodapi
    db:
      vcenter: *1
      network:
        vlanid: PROD_DB_NET
        gateway: 10.108.128.1
        netmask: 19
      compute:
        cpu: 4
        ram: 12288
        image: org-centos-rev00002
        disk:
          mount: opt
          capacity: 81920
      addresses:
      - 10.28.108.10
      - 10.28.108.11
      count: 2
      cmserver: chef.domain.com
      cmrunlist:
      - org-base
      - app-db
      nodename: proddb
    """

  Scenario: Show with invalid commands

    Given a file named "platform.yml" with:
    """
    platform:
      product: demo
      provider: vaquero_io_provider_template
      plugin_version: 2.0.0

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
          cmserver: chef.domain.com
          cmrunlist:
            - org-base
            - app-#
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
        timezone: 085
        datacenter: 'nonprod.domain.com'
        imagefolder: 'org/app/templates'
        destfolder: 'org/app/dev'
        datastore: 'org-nonprod'
        domain: dev.domain.com
        dnsips:
          - 10.1.1.15
          - 10.1.1.16

      defaultprod: &defaultprod
        <<: *defaultnonprod
        datacenter: 'prod.domain.com'
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
        cpu: 1
        ram: 1024
        image: 'org-centos-rev00002'
        disk:
          mount: 'opt'
          capacity: 8192

      defaultdb: &defaultdb
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
    When I run `vaquero_io show env`
    Then the exit status should be 1
    And the output should contain "environment not found"
    When I run `vaquero_io show infra RANDOM`
    Then the exit status should be 1
    And the output should contain "RANDOM infrastructure not found"