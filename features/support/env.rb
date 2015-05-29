require 'aruba/cucumber'
require 'coveralls'

ENV['PATH'] = "/lib#{File::PATH_SEPARATOR}#{ENV['PATH']}"

Coveralls.wear!
