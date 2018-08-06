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

require 'google/sql/property/base'

module Google
  module Sql
    module Data
      # A class to manage data for IpConfiguration for instance.
      class InstanceIpConfiguration
        include Comparable

        attr_reader :ipv4_enabled
        attr_reader :authorized_networks
        attr_reader :require_ssl

        def to_json(_arg = nil)
          {
            'ipv4Enabled' => ipv4_enabled,
            'authorizedNetworks' => authorized_networks,
            'requireSsl' => require_ssl
          }.reject { |_k, v| v.nil? }.to_json
        end

        def to_s
          {
            ipv4_enabled: ipv4_enabled,
            authorized_networks: ['[',
                                  (authorized_networks || []).map(&:to_json).join(', '),
                                  ']'].join(' '),
            require_ssl: require_ssl
          }.reject { |_k, v| v.nil? }.map { |k, v| "#{k}: #{v}" }.join(', ')
        end

        def ==(other)
          return false unless other.is_a? InstanceIpConfiguration
          compare_fields(other).each do |compare|
            next if compare[:self].nil? || compare[:other].nil?
            return false if compare[:self] != compare[:other]
          end
          true
        end

        def <=>(other)
          return false unless other.is_a? InstanceIpConfiguration
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
            { self: ipv4_enabled, other: other.ipv4_enabled },
            { self: authorized_networks, other: other.authorized_networks },
            { self: require_ssl, other: other.require_ssl }
          ]
        end
      end

      # Manages a InstanceIpConfiguration nested object
      # Data is coming from the GCP API
      class InstanceIpConfigurationApi < InstanceIpConfiguration
        def initialize(args)
          @ipv4_enabled = Google::Sql::Property::Boolean.api_munge(args['ipv4Enabled'])
          @authorized_networks = Google::Sql::Property::InstanceAuthorizedNetworksArray.api_munge(
            args['authorizedNetworks']
          )
          @require_ssl = Google::Sql::Property::Boolean.api_munge(args['requireSsl'])
        end
      end

      # Manages a InstanceIpConfiguration nested object
      # Data is coming from the Puppet manifest
      class InstanceIpConfigurationCatalog < InstanceIpConfiguration
        def initialize(args)
          @ipv4_enabled = Google::Sql::Property::Boolean.unsafe_munge(args['ipv4_enabled'])
          @authorized_networks =
            Google::Sql::Property::InstanceAuthorizedNetworksArray.unsafe_munge(
              args['authorized_networks']
            )
          @require_ssl = Google::Sql::Property::Boolean.unsafe_munge(args['require_ssl'])
        end
      end
    end

    module Property
      # A class to manage input to IpConfiguration for instance.
      class InstanceIpConfiguration < Google::Sql::Property::Base
        # Used for parsing Puppet catalog
        def unsafe_munge(value)
          self.class.unsafe_munge(value)
        end

        # Used for parsing Puppet catalog
        def self.unsafe_munge(value)
          return if value.nil?
          Data::InstanceIpConfigurationCatalog.new(value)
        end

        # Used for parsing GCP API responses
        def self.api_munge(value)
          return if value.nil?
          Data::InstanceIpConfigurationApi.new(value)
        end
      end
    end
  end
end
