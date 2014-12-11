module Putenv
  class Provider < Thor

    desc 'list', DESC_PROVIDER_LIST
    def list
      puts 'list [NOT YET IMPLEMENTED]'
    end

    desc 'install PATH', DESC_PROVIDER_INSTALL
    def install(path)
      puts "install #{path} [NOT YET IMPLEMENTED]"
    end

    desc 'update [PROVIDER]', DESC_PROVIDER_UPDATE
    def update(plugin='')
      puts "update #{plugin} [NOT YET IMPLEMENTED]"
    end

    desc 'remove PROVIDER', DESC_PROVIDER_REMOVE
    def remove(plugin)
      puts "remove #{plugin} [NOT YET IMPLEMENTED]"
    end

    desc 'init', DESC_PROVIDER_INIT
    def init
      puts 'init [NOT YET IMPLEMENTED]'
    end

  end
end