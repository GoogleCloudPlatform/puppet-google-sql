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

require 'google/object_store'
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

Puppet::Type.newtype(:gsql_instance) do
  @doc = <<-DOC
    Represents a Cloud SQL instance. Cloud SQL instances are SQL databases hosted in Google's
    cloud. The Instances resource provides methods for common configuration and management tasks.
  DOC

  autorequire(:gauth_credential) do
    credential = self[:credential]
    raise "#{ref}: required property 'credential' is missing" if credential.nil?
    [credential]
  end

  ensurable

  newparam :credential do
    desc <<-DESC
      A gauth_credential name to be used to authenticate with Google Cloud
      Platform.
    DESC
  end

  newparam(:project) do
    desc 'A Google Cloud Platform project to manage.'
  end

  newparam(:name, namevar: true) do
    # TODO(nelsona): Make this description to match the key of the object.
    desc 'The name of the Instance.'
  end

  newproperty(:backend_type, parent: Google::Sql::Property::Enum) do
    desc <<-DOC
      * FIRST_GEN: First Generation instance. MySQL only. * SECOND_GEN: Second Generation instance
      or PostgreSQL instance. * EXTERNAL: A database server that is not managed by Google.
    DOC
    newvalue(:FIRST_GEN)
    newvalue(:SECOND_GEN)
    newvalue(:EXTERNAL)
  end

  newproperty(:connection_name, parent: Google::Sql::Property::String) do
    desc 'Connection name of the Cloud SQL instance used in connection strings.'
  end

  newproperty(:database_version, parent: Google::Sql::Property::Enum) do
    desc <<-DOC
      The database engine type and version. For First Generation instances, can be MYSQL_5_5, or
      MYSQL_5_6. For Second Generation instances, can be MYSQL_5_6 or MYSQL_5_7. Defaults to
      MYSQL_5_6. PostgreSQL instances: POSTGRES_9_6 The databaseVersion property can not be changed
      after instance creation.
    DOC
    newvalue(:MYSQL_5_5)
    newvalue(:MYSQL_5_6)
    newvalue(:MYSQL_5_7)
    newvalue(:POSTGRES_9_6)
  end

  newproperty(:failover_replica, parent: Google::Sql::Property::InstanceFailoverReplica) do
    desc <<-DOC
      The name and status of the failover replica. This property is applicable only to Second
      Generation instances.
    DOC
  end

  newproperty(:instance_type, parent: Google::Sql::Property::Enum) do
    desc <<-DOC
      The instance type. This can be one of the following. * CLOUD_SQL_INSTANCE: A Cloud SQL
      instance that is not replicating  from a master. * ON_PREMISES_INSTANCE: An instance running
      on the customer's  premises. * READ_REPLICA_INSTANCE: A Cloud SQL instance configured as a
      read-replica.
    DOC
    newvalue(:CLOUD_SQL_INSTANCE)
    newvalue(:ON_PREMISES_INSTANCE)
    newvalue(:READ_REPLICA_INSTANCE)
  end

  newproperty(:ip_addresses, parent: Google::Sql::Property::InstanceIpAddressesArray) do
    desc 'The assigned IP addresses for the instance. (output only)'
  end

  newproperty(:ipv6_address, parent: Google::Sql::Property::String) do
    desc <<-DOC
      The IPv6 address assigned to the instance. This property is applicable only to First
      Generation instances.
    DOC
  end

  newproperty(:master_instance_name, parent: Google::Sql::Property::String) do
    desc 'The name of the instance which will act as master in the replication setup.'
  end

  newproperty(:max_disk_size, parent: Google::Sql::Property::Integer) do
    desc 'The maximum disk size of the instance in bytes.'
  end

  newproperty(:name, parent: Google::Sql::Property::String) do
    desc 'Name of the Cloud SQL instance. This does not include the project ID.'
  end

  newproperty(:region, parent: Google::Sql::Property::String) do
    desc <<-DOC
      The geographical region. Defaults to us-central or us-central1 depending on the instance type
      (First Generation or Second Generation/PostgreSQL).
    DOC
  end

  newproperty(:replica_configuration,
              parent: Google::Sql::Property::InstanceReplicaConfiguration) do
    desc 'Configuration specific to failover replicas and read replicas.'
  end

  newproperty(:settings, parent: Google::Sql::Property::InstanceSettings) do
    desc 'The user settings.'
  end

  # Returns all properties that a provider can export to other resources
  def exports
    provider.exports
  end
end
