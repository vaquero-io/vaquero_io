require 'aruba/cucumber'
require 'aruba/in_process'
require 'vaquero_io/runner'
require 'coveralls'

ENV['PATH'] = "/lib#{File::PATH_SEPARATOR}#{ENV['PATH']}"

Coveralls.wear!

Aruba::InProcess.main_class = VaqueroIo::Runner
Aruba.process = Aruba::InProcess
