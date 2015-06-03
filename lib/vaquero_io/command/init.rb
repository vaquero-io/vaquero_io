# Copyright information in version.rb
#
require 'vaquero_io/command'
module VaqueroIo
  # included in Command module
  module Command
    # command
    class Init < VaqueroIo::Command::Base
      # Invoke the command.
      def call
        provider = VaqueroIo::Provider.new(options[:provider])
        puts "name: #{provider.name}"

        # if options[:create_gemfile]
        #
        # end
      end

      # private

      # create_platform_definition_files
      # update_gemfile
      # update_gitignore
    end
  end
end
# Copyright information in version.rb
#
# module VaqueroIo
#   class Init < Thor::Group
#     include Thor::Actions
#
#
#     def init
#       self.class.source_root(VaqueroIo.source_root.join('templates'))
#
#       puts options
#       # create_provider_yaml
#       # prepare_gitignore
#       # create_gemfile
#       # add_drivers
#       # display_bundle_message
#     end
#
# def create_gemfile
#   return unless modify_gemfile?
#   create_gemfile
#   add_gem_to_gemfile
# end
#
# def create_gemfile_if_missing
#   unless File.exist?('Gemfile')
#     create_file('Gemfile', %{source "https://rubygems.org"\n\n})
#   end
# end
#
# def add_gem_to_gemfile
#   if not_in_file?("Gemfile", %r{gem ('|")vaquero_io('|")})
#     append_to_file("Gemfile", %{gem "test-kitchen"\n})
#     @display_bundle_msg = true
#   end
# end
#
# def add_driver_to_gemfile(driver_gem)
#   if not_in_file?("Gemfile", %r{gem ('|")#{driver_gem}('|")})
#     append_to_file("Gemfile", %{gem "#{driver_gem}"\n})
#     @display_bundle_msg = true
#   end
# end
#
# def install_gem(driver_gem)
#   unbundlerize { Gem::GemRunner.new.run(["install", driver_gem]) }
# rescue Gem::SystemExitException => e
#   raise unless e.exit_code == 0
# end
#
# def modify_gemfile?
#   File.exist?('Gemfile') || options[:create_gemfile]
# end
