#!/opt/puppetlabs/puppet/bin/ruby
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

# Allow resetting Cloud SQL password for existing users
#
# Command line arguments: JSON object from STDIN with the following fields:
#
# - name: The user that will have its password reset (default: root)
# - host: Host ACL for user (default: '%' [all hosts])
# - password: Password to set the user to
# - instance: Name of the SQL instance to manipulate users on
# - project: The project that hosts the Cloud SQL instance
# - credential: Path to a service account credentials file

SQL_ADM_SCOPES = [
  'https://www.googleapis.com/auth/sqlservice.admin'
].freeze

require 'puppet'

# We want to re-use code already written for the GCP modules
Puppet.initialize_settings

# Puppet apply does special stuff to load library code stored in modules
# but that magic is available in Bolt so we emulate it here.  We look in
# the local user's .puppetlabs directory or if running at "root" we look
# in the directory where Puppet pluginsyncs to.
libdir = if Puppet.run_mode.user?
           Dir["#{Puppet.settings[:codedir]}/modules/*/lib"]
         else
           File.path("#{Puppet.settings[:vardir]}/lib").to_a
         end
libdir << File.expand_path("#{File.dirname(__FILE__)}/../lib")
libdir.each { |l| $LOAD_PATH.unshift(l) unless $LOAD_PATH.include?(l) }

require 'google/auth/gauth_credential'
require 'google/sql/api/gsql_user'

# Validates user input
def validate(params, arg_id, default = nil)
  arg = arg_id.id2name
  raise "Missing parameter '#{arg}' from stdin" \
    if default.nil? && !params.key?(arg)
  params.key?(arg) ? params[arg] : default
end

# Parses and validates user input
params = {}
begin
  Timeout.timeout(3) do
    params = JSON.parse(STDIN.read)
  end
rescue Timeout::Error
  puts({ status: 'failure', error: 'Cannot read JSON from stdin' }.to_json)
  exit 1
end

name = validate(params, :name, 'root')
host = validate(params, :host, '%')
password = validate(params, :password)
instance = validate(params, :instance)
project = validate(params, :project)
credential = validate(params, :credential)

cred = Google::Auth::GAuthCredential \
       .serviceaccount_for_function(credential, SQL_ADM_SCOPES)
sql_user = Google::Sql::Api::User.new(name, instance, project, cred)

begin
  sql_user.passwd(host, password)
  puts({ status: 'success' }.to_json)
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e }.to_json)
  exit 1
end
