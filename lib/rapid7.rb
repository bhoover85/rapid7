require 'rapid7/version'
require 'benchmark'
require 'parse_response'
require 'calculate_times'

module Rapid7
  time = Benchmark.realtime { 
    file = "./lib/data/scan-times.json"
    response = ParseResponse.new(file)

    if response.hash.nil?
      puts "There was a problem retrieving/parsing #{file}"
      exit
    else
      CalculateTimes.new(file, response.hash)
    end
  }

  puts "Script execution time: #{time.round(1)} seconds"
end
