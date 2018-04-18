# Copyright 2017 Google Inc.
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
      # A class to manage data for authorized_networks for instance.
      class InstancAuthoriNetwork
        include Comparable

        attr_reader :expiration_time
        attr_reader :name
        attr_reader :value

        def to_json(_arg = nil)
          {
            'expirationTime' => expiration_time,
            'name' => name,
            'value' => value
          }.reject { |_k, v| v.nil? }.to_json
        end

        def to_s
          {
            expiration_time: expiration_time,
            name: name,
            value: value
          }.reject { |_k, v| v.nil? }.map { |k, v| "#{k}: #{v}" }.join(', ')
        end

        def ==(other)
          return false unless other.is_a? InstancAuthoriNetwork
          compare_fields(other).each do |compare|
            next if compare[:self].nil? || compare[:other].nil?
            return false if compare[:self] != compare[:other]
          end
          true
        end

        def <=>(other)
          return false unless other.is_a? InstancAuthoriNetwork
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
            { self: expiration_time, other: other.expiration_time },
            { self: name, other: other.name },
            { self: value, other: other.value }
          ]
        end
      end

      # Manages a InstancAuthoriNetwork nested object
      # Data is coming from the GCP API
      class InstancAuthoriNetworkApi < InstancAuthoriNetwork
        def initialize(args)
          @expiration_time =
            Google::Sql::Property::Time.api_munge(args['expirationTime'])
          @name = Google::Sql::Property::String.api_munge(args['name'])
          @value = Google::Sql::Property::String.api_munge(args['value'])
        end
      end

      # Manages a InstancAuthoriNetwork nested object
      # Data is coming from the Puppet manifest
      class InstancAuthoriNetworkCatalog < InstancAuthoriNetwork
        def initialize(args)
          @expiration_time =
            Google::Sql::Property::Time.unsafe_munge(args['expiration_time'])
          @name = Google::Sql::Property::String.unsafe_munge(args['name'])
          @value = Google::Sql::Property::String.unsafe_munge(args['value'])
        end
      end
    end

    module Property
      # A class to manage input to authorized_networks for instance.
      class InstancAuthoriNetwork < Google::Sql::Property::Base
        # Used for parsing Puppet catalog
        def unsafe_munge(value)
          self.class.unsafe_munge(value)
        end

        # Used for parsing Puppet catalog
        def self.unsafe_munge(value)
          return if value.nil?
          Data::InstancAuthoriNetworkCatalog.new(value)
        end

        # Used for parsing GCP API responses
        def self.api_munge(value)
          return if value.nil?
          Data::InstancAuthoriNetworkApi.new(value)
        end
      end

      # A Puppet property that holds an integer
      class InstancAuthoriNetworkArray < Google::Sql::Property::Array
        # Used for parsing Puppet catalog
        def unsafe_munge(value)
          self.class.unsafe_munge(value)
        end

        # Used for parsing Puppet catalog
        def self.unsafe_munge(value)
          return if value.nil?
          return InstancAuthoriNetwork.unsafe_munge(value) \
            unless value.is_a?(::Array)
          value.map { |v| InstancAuthoriNetwork.unsafe_munge(v) }
        end

        # Used for parsing GCP API responses
        def self.api_munge(value)
          return if value.nil?
          return InstancAuthoriNetwork.api_munge(value) \
            unless value.is_a?(::Array)
          value.map { |v| InstancAuthoriNetwork.api_munge(v) }
        end
      end
    end
  end
end
