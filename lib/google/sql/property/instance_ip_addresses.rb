# Copyright 2018 Google Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ----------------------------------------------------------------------------
#
#     ***     AUTO GENERATED CODE    ***    AUTO GENERATED CODE     ***
#
# ----------------------------------------------------------------------------
#
#     This file is automatically generated by Magic Modules and manual
#     changes will be clobbered when the file is regenerated.
#
#     Please read more about how to change this file in README.md and
#     CONTRIBUTING.md located at the root of this package.
#
# ----------------------------------------------------------------------------

require 'google/sql/property/array'
require 'google/sql/property/base'

module Google
  module Sql
    module Data
      # A class to manage data for IpAddresses for instance.
      class InstanceIpAddresses
        include Comparable

        attr_reader :ip_address
        attr_reader :time_to_retire
        attr_reader :type

        def to_json(_arg = nil)
          {
            'ipAddress' => ip_address,
            'timeToRetire' => time_to_retire,
            'type' => type
          }.reject { |_k, v| v.nil? }.to_json
        end

        def to_s
          {
            ip_address: ip_address,
            time_to_retire: time_to_retire,
            type: type
          }.reject { |_k, v| v.nil? }.map { |k, v| "#{k}: #{v}" }.join(', ')
        end

        def ==(other)
          return false unless other.is_a? InstanceIpAddresses
          compare_fields(other).each do |compare|
            next if compare[:self].nil? || compare[:other].nil?
            return false if compare[:self] != compare[:other]
          end
          true
        end

        def <=>(other)
          return false unless other.is_a? InstanceIpAddresses
          compare_fields(other).each do |compare|
            next if compare[:self].nil? || compare[:other].nil?
            result = compare[:self] <=> compare[:other]
            return result unless result.zero?
          end
          0
        end

        private

        def compare_fields(other)
          [
            { self: ip_address, other: other.ip_address },
            { self: time_to_retire, other: other.time_to_retire },
            { self: type, other: other.type }
          ]
        end
      end

      # Manages a InstanceIpAddresses nested object
      # Data is coming from the GCP API
      class InstanceIpAddressesApi < InstanceIpAddresses
        def initialize(args)
          @ip_address = Google::Sql::Property::String.api_munge(args['ipAddress'])
          @time_to_retire = Google::Sql::Property::Time.api_munge(args['timeToRetire'])
          @type = Google::Sql::Property::Enum.api_munge(args['type'])
        end
      end

      # Manages a InstanceIpAddresses nested object
      # Data is coming from the Puppet manifest
      class InstanceIpAddressesCatalog < InstanceIpAddresses
        def initialize(args)
          @ip_address = Google::Sql::Property::String.unsafe_munge(args['ip_address'])
          @time_to_retire = Google::Sql::Property::Time.unsafe_munge(args['time_to_retire'])
          @type = Google::Sql::Property::Enum.unsafe_munge(args['type'])
        end
      end
    end

    module Property
      # A class to manage input to IpAddresses for instance.
      class InstanceIpAddresses < Google::Sql::Property::Base
        # Used for parsing Puppet catalog
        def unsafe_munge(value)
          self.class.unsafe_munge(value)
        end

        # Used for parsing Puppet catalog
        def self.unsafe_munge(value)
          return if value.nil?
          Data::InstanceIpAddressesCatalog.new(value)
        end

        # Used for parsing GCP API responses
        def self.api_munge(value)
          return if value.nil?
          Data::InstanceIpAddressesApi.new(value)
        end
      end

      # A Puppet property that holds an integer
      class InstanceIpAddressesArray < Google::Sql::Property::Array
        # Used for parsing Puppet catalog
        def unsafe_munge(value)
          self.class.unsafe_munge(value)
        end

        # Used for parsing Puppet catalog
        def self.unsafe_munge(value)
          return if value.nil?
          return InstanceIpAddresses.unsafe_munge(value) \
            unless value.is_a?(::Array)
          value.map { |v| InstanceIpAddresses.unsafe_munge(v) }
        end

        # Used for parsing GCP API responses
        def self.api_munge(value)
          return if value.nil?
          return InstanceIpAddresses.api_munge(value) \
            unless value.is_a?(::Array)
          value.map { |v| InstanceIpAddresses.api_munge(v) }
        end
      end
    end
  end
end
