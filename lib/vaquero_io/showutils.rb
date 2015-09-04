module VaqueroIo
  # mixin for formatting console output of show command
  module ShowUtils
    def show_all(pf)
      puts "\ninfrastructure: #{pf.platform['infrastructure'].join(', ')}\n\n"
      table border: false do
        show_all_header(pf)
        show_all_body(pf)
        show_all_footer(pf)
      end
    end

    def show_all_header(pf)
      row color: 'green' do
        column 'role', width: 18
        pf.platform['environments'].each do |environment|
          column environment.upcase, width: 12, align: 'center'
        end
      end
    end

    def show_all_body(pf)
      pf.platform['roles'].each do |role, _v|
        row color: 'white' do
          column role
          pf.environments.each do |environment, _ev|
            column pf.environments[environment][role]['count']
          end
        end
      end
    end

    def show_all_footer(pf)
      row color: 'green' do
        column 'TOTAL'
        pf.environments.each do |environment, _ev|
          totals = 0
          pf.environments[environment].each { |_k, v| totals += v['count'] }
          column(totals)
        end
      end
    end

    def show_infra(pf, infra = nil)
      if infra
        puts pf.infrastructure[infra].to_yaml
      else
        puts "\n"
        table border: false do
          show_infra_header(pf)
          show_infra_body(pf)
        end
      end
    end

    def show_infra_header(pf)
      row color: 'green' do
        column 'role', width: 18
        column 'infra', width: 12, align: 'center'
        pf.platform['environments'].each do |environment|
          column environment.upcase, width: 12, align: 'center'
        end
      end
    end

    def show_infra_body(pf)
      pf.platform['roles'].each do |role, _v|
        row color: 'white' do
          column role
        end
        show_infra_detail(pf, role)
      end
    end

    def show_infra_detail(pf, role)
      pf.infrastructure.each do |infra, _iv|
        row do
          column ''
          column infra, color: 'white'
          pf.environments.each do |environment, _ev|
            column pf.pre_env[environment][role][infra]
          end
        end
      end
    end

    def show_env(pf, env)
      puts "show #{env}"
      puts pf.environments[env].to_yaml
    end
  end
end
