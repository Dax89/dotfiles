#! /bin/env ruby
# rubocop: disable Style/WordArray

require 'json'

INTEL_CPU  = ['coretemp-isa-0000', 'Package id 0', 'temp1_input'].freeze
AMD_CPU    = ['k10temp-pci-00c3', 'Tctl', 'temp1_input'].freeze
CATEGORIES = [INTEL_CPU, AMD_CPU].freeze

sensors = JSON.parse `sensors -j`
value = '???'

CATEGORIES.each do |category|
  obj = sensors

  category.each do |cpuprop|
    if obj[cpuprop].nil?
      obj = nil
      break
    else
      obj = obj[cpuprop]
    end
  end

  value = obj.to_i unless obj.nil?
end

puts "#{value}°C"

# rubocop: enable Style/WordArray
