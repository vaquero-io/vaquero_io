puts ENV['LOAD_PATH']
# module VaqueroIo
#   module ProviderExtension
#     def template
#       puts 'in template called from included gem'
#     end
#   end
# end
#
# module VaqueroIo
#
#   class Provider
#
#     # include ProviderExtension
#     def initialize
#       extend VaqueroIo::ProviderExtension
#     end
#
#     def test
#       puts 'in test'
#     end
#   end
# end
#
# include VaqueroIo
#
# t = Provider.new
# t.test
# t.template
