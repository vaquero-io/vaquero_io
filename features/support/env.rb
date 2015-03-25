require 'aruba/cucumber'
require 'aruba/in_process'
require 'vaquero/runner'
require 'coveralls'

ENV['PATH'] = "/lib#{File::PATH_SEPARATOR}#{ENV['PATH']}"

Coveralls.wear!

Aruba::InProcess.main_class = Vaquero::Runner
Aruba.process = Aruba::InProcess
