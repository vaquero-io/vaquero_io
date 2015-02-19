# Basically a dummy placeholder for the provision method that
# plugins will override
module Putenv
  # comment
  class Platform
    # comment
    module Provision
      def provision(_env)
        puts 'success'
      end
    end
  end
end
