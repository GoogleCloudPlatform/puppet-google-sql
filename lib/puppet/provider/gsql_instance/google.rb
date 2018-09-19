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

require 'google/hash_utils'
require 'google/object_store'
require 'google/sql/network/delete'
require 'google/sql/network/get'
require 'google/sql/network/post'
require 'google/sql/network/put'
require 'google/sql/property/boolean'
require 'google/sql/property/enum'
require 'google/sql/property/instance_authorized_networks'
require 'google/sql/property/instance_failover_replica'
require 'google/sql/property/instance_ip_addresses'
require 'google/sql/property/instance_ip_configuration'
require 'google/sql/property/instance_mysql_replica_configuration'
require 'google/sql/property/instance_replica_configuration'
require 'google/sql/property/instance_settings'
require 'google/sql/property/integer'
require 'google/sql/property/string'
require 'google/sql/property/string_array'
require 'google/sql/property/time'
require 'puppet'

Puppet::Type.type(:gsql_instance).provide(:google) do
  mk_resource_methods

  def self.instances
    debug('instances')
    raise [
      '"puppet resource" is not supported at the moment:',
      'TODO(nelsonjr): https://goto.google.com/graphite-bugs-view?id=167'
    ].join(' ')
  end

  def self.prefetch(resources)
    debug('prefetch')
    resources.each do |name, resource|
      project = resource[:project]
      debug("prefetch #{name}") if project.nil?
      debug("prefetch #{name} @ #{project}") unless project.nil?
      fetch = fetch_resource(resource, self_link(resource), 'sql#instance')
      resource.provider = present(name, fetch) unless fetch.nil?
      Google::ObjectStore.instance.add(:gsql_instance, resource)
    end
  end

  def self.present(name, fetch)
    result = new({ title: name, ensure: :present }.merge(fetch_to_hash(fetch)))
    result.instance_variable_set(:@fetched, fetch)
    result
  end

  # rubocop:disable Metrics/MethodLength
  def self.fetch_to_hash(fetch)
    {
      backend_type: Google::Sql::Property::Enum.api_munge(fetch['backendType']),
      connection_name: Google::Sql::Property::String.api_munge(fetch['connectionName']),
      database_version: Google::Sql::Property::Enum.api_munge(fetch['databaseVersion']),
      failover_replica:
        Google::Sql::Property::InstanceFailoverReplica.api_munge(fetch['failoverReplica']),
      instance_type: Google::Sql::Property::Enum.api_munge(fetch['instanceType']),
      ip_addresses: Google::Sql::Property::InstanceIpAddressesArray.api_munge(fetch['ipAddresses']),
      ipv6_address: Google::Sql::Property::String.api_munge(fetch['ipv6Address']),
      master_instance_name: Google::Sql::Property::String.api_munge(fetch['masterInstanceName']),
      max_disk_size: Google::Sql::Property::Integer.api_munge(fetch['maxDiskSize']),
      name: Google::Sql::Property::String.api_munge(fetch['name']),
      region: Google::Sql::Property::String.api_munge(fetch['region']),
      replica_configuration: Google::Sql::Property::InstanceReplicaConfiguration.api_munge(
        fetch['replicaConfiguration']
      ),
      settings: Google::Sql::Property::InstanceSettings.api_munge(fetch['settings'])
    }.reject { |_, v| v.nil? }
  end
  # rubocop:enable Metrics/MethodLength

  def exists?
    debug("exists? #{@property_hash[:ensure] == :present}")
    @property_hash[:ensure] == :present
  end

  def create
    debug('create')
    @created = true
    create_req = Google::Sql::Network::Post.new(collection(@resource),
                                                fetch_auth(@resource),
                                                'application/json',
                                                resource_to_request)
    @fetched = wait_for_operation create_req.send, @resource
    @property_hash[:ensure] = :present
  end

  def destroy
    debug('destroy')
    @deleted = true
    delete_req = Google::Sql::Network::Delete.new(self_link(@resource),
                                                  fetch_auth(@resource))
    wait_for_operation delete_req.send, @resource
    @property_hash[:ensure] = :absent
  end

  def flush
    debug('flush')
    # return on !@dirty is for aiding testing (puppet already guarantees that)
    return if @created || @deleted || !@dirty
    update_req = Google::Sql::Network::Put.new(self_link(@resource),
                                               fetch_auth(@resource),
                                               'application/json',
                                               resource_to_request)
    @fetched = wait_for_operation update_req.send, @resource
  end

  def dirty(field, from, to)
    @dirty = {} if @dirty.nil?
    @dirty[field] = {
      from: from,
      to: to
    }
  end

  def exports
    {
      name: resource[:name]
    }
  end

  private

  # rubocop:disable Metrics/MethodLength
  def self.resource_to_hash(resource)
    {
      project: resource[:project],
      name: resource[:name],
      kind: 'sql#instance',
      backend_type: resource[:backend_type],
      connection_name: resource[:connection_name],
      database_version: resource[:database_version],
      failover_replica: resource[:failover_replica],
      instance_type: resource[:instance_type],
      ip_addresses: resource[:ip_addresses],
      ipv6_address: resource[:ipv6_address],
      master_instance_name: resource[:master_instance_name],
      max_disk_size: resource[:max_disk_size],
      region: resource[:region],
      replica_configuration: resource[:replica_configuration],
      settings: resource[:settings]
    }.reject { |_, v| v.nil? }
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def resource_to_request
    request = {
      kind: 'sql#instance',
      backendType: @resource[:backend_type],
      connectionName: @resource[:connection_name],
      databaseVersion: @resource[:database_version],
      failoverReplica: @resource[:failover_replica],
      instanceType: @resource[:instance_type],
      ipv6Address: @resource[:ipv6_address],
      masterInstanceName: @resource[:master_instance_name],
      maxDiskSize: @resource[:max_disk_size],
      name: @resource[:name],
      region: @resource[:region],
      replicaConfiguration: @resource[:replica_configuration],
      settings: @resource[:settings]
    }.reject { |_, v| v.nil? }

    unless @fetched.nil?
      # Convert to pure JSON
      request = JSON.parse(request.to_json)
      request['settings']['settingsVersion'] =
        @fetched['settings']['settingsVersion']
    end

    debug "request: #{request}" unless ENV['PUPPET_HTTP_DEBUG'].nil?
    request.to_json
  end
  # rubocop:enable Metrics/MethodLength

  def fetch_auth(resource)
    self.class.fetch_auth(resource)
  end

  def self.fetch_auth(resource)
    Puppet::Type.type(:gauth_credential).fetch(resource)
  end

  def debug(message)
    puts("DEBUG: #{message}") if ENV['PUPPET_HTTP_VERBOSE']
    super(message)
  end

  def self.collection(data)
    URI.join(
      'https://www.googleapis.com/sql/v1beta4/',
      expand_variables(
        'projects/{{project}}/instances',
        data
      )
    )
  end

  def collection(data)
    self.class.collection(data)
  end

  def self.self_link(data)
    URI.join(
      'https://www.googleapis.com/sql/v1beta4/',
      expand_variables(
        'projects/{{project}}/instances/{{name}}',
        data
      )
    )
  end

  def self_link(data)
    self.class.self_link(data)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def self.return_if_object(response, kind, allow_not_found = false)
    raise "Bad response: #{response}" \
      unless response.is_a?(Net::HTTPResponse)
    return if response.is_a?(Net::HTTPNoContent)
    return if response.is_a?(Net::HTTPNotFound) && allow_not_found
    # TODO(nelsonjr): Remove return of Net::HTTPForbidden from
    # return_if_object once Cloud SQL Bug http://b/62635365 is resolved.
    # Currently the API returns 403 for objects that do not exist, even
    # when the user has access to the project. This is being changed to
    # return 404 as it is supposed to be.  Once 404 is the correct
    # response the temporary workaround should be removed.
    return if response.is_a?(Net::HTTPForbidden) && allow_not_found
    result = JSON.parse(response.body)
    raise_if_errors result, %w[error errors], 'message'
    raise "Bad response: #{response}" unless response.is_a?(Net::HTTPOK)
    raise "Incorrect result: #{result['kind']} (expecting #{kind})" \
      unless result['kind'] == kind
    result
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def return_if_object(response, kind, allow_not_found = false)
    self.class.return_if_object(response, kind, allow_not_found)
  end

  def self.extract_variables(template)
    template.scan(/{{[^}]*}}/).map { |v| v.gsub(/{{([^}]*)}}/, '\1') }
            .map(&:to_sym)
  end

  def self.expand_variables(template, var_data, extra_data = {})
    data = if var_data.class <= Hash
             var_data.merge(extra_data)
           else
             resource_to_hash(var_data).merge(extra_data)
           end
    extract_variables(template).each do |v|
      unless data.key?(v)
        raise "Missing variable :#{v} in #{data} on #{caller.join("\n")}}"
      end
      template.gsub!(/{{#{v}}}/, CGI.escape(data[v].to_s))
    end
    template
  end

  def expand_variables(template, var_data, extra_data = {})
    self.class.expand_variables(template, var_data, extra_data)
  end

  def fetch_resource(resource, self_link, kind)
    self.class.fetch_resource(resource, self_link, kind)
  end

  def async_op_url(data, extra_data = {})
    URI.join(
      'https://www.googleapis.com/sql/v1beta4/',
      expand_variables(
        'projects/{{project}}/operations/{{op_id}}',
        data, extra_data
      )
    )
  end

  def wait_for_operation(response, resource)
    op_result = return_if_object(response, 'sql#operation')
    return if op_result.nil?
    status = ::Google::HashUtils.navigate(op_result, %w[status])
    fetch_resource(
      resource,
      URI.parse(::Google::HashUtils.navigate(wait_for_completion(status,
                                                                 op_result,
                                                                 resource),
                                             %w[targetLink])),
      'sql#instance'
    )
  end

  def wait_for_completion(status, op_result, resource)
    op_id = ::Google::HashUtils.navigate(op_result, %w[name])
    op_uri = async_op_url(resource, op_id: op_id)
    while status != 'DONE'
      debug("Waiting for completion of operation #{op_id}")
      raise_if_errors op_result, %w[error errors], 'message'
      sleep 1.0
      raise "Invalid result '#{status}' on gsql_instance." \
        unless %w[PENDING RUNNING DONE].include?(status)
      op_result = fetch_resource(resource, op_uri, 'sql#operation')
      status = ::Google::HashUtils.navigate(op_result, %w[status])
    end
    op_result
  end

  def raise_if_errors(response, err_path, msg_field)
    self.class.raise_if_errors(response, err_path, msg_field)
  end

  def self.fetch_resource(resource, self_link, kind)
    get_request = ::Google::Sql::Network::Get.new(
      self_link, fetch_auth(resource)
    )
    return_if_object get_request.send, kind, true
  end

  def self.raise_if_errors(response, err_path, msg_field)
    errors = ::Google::HashUtils.navigate(response, err_path)
    raise_error(errors, msg_field) unless errors.nil?
  end

  def self.raise_error(errors, msg_field)
    raise IOError, ['Operation failed:',
                    errors.map { |e| e[msg_field] }.join(', ')].join(' ')
  end
end
