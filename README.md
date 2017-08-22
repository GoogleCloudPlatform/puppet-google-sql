# Google Cloud SQL Puppet Module

#### Table of Contents

1. [Module Description - What the module does and why it is useful](
    #module-description)
2. [Setup - The basics of getting started with Google Cloud SQL](#setup)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](
   #reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Module Description

This Puppet module manages the resource of Google Cloud SQL.
You can manage its resources using standard Puppet DSL and the module will,
under the hood, ensure the state described will be reflected in the Google
Cloud Platform resources.

## Setup

To install this module on your Puppet Master (or Puppet Client/Agent), use the
Puppet module installer:

    puppet module install google-gsql

Optionally you can install support to _all_ Google Cloud Platform products at
once by installing our "bundle" [`google-cloud`][bundle-forge] module:

    puppet module install google-cloud

## Usage

### Credentials

All Google Cloud Platform modules use an unified authentication mechanism,
provided by the [`google-gauth`][] module. Don't worry, it is automatically
installed when you install this module.

```puppet
gauth_credential { 'mycred':
  path     => $cred_path, # e.g. '/home/nelsonjr/my_account.json'
  provider => serviceaccount,
  scopes   => [
    'https://www.googleapis.com/auth/sqlservice.admin',
  ],
}
```

Please refer to the [`google-gauth`][] module for further requirements, i.e.
required gems.

### Examples

#### `gsql_instance`

```puppet
gsql_instance { "sql-test-${sql_instance_suffix}":
  ensure           => present,
  database_version => 'MYSQL_5_7',
  settings         => {
    ip_configuration => {
      authorized_networks => [
        # The ACL below is for example only. (do NOT use in production as-is)
        {
          name  => 'google dns server',
          value => '8.8.8.8/32'
        },
      ],
    },
    tier             => 'db-n1-standard-1'
  },
  region           => 'us-central1',
  project          => 'google.com:graphite-playground',
  credential       => 'mycred',
}

```

#### `gsql_database`

```puppet
# Tip: Remember to define gsql_instance to match the 'instance' property.
gsql_database { 'webstore':
  ensure     => present,
  charset    => 'utf8',
  instance   => "sql-test-${sql_instance_suffix}",
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

```

#### `gsql_user`

```puppet
# Tip: Remember to define gsql_instance to match the 'instance' property.
gsql_user { 'john.doe':
  ensure     => present,
  password   => 'secret-password',
  host       => '10.1.2.3',
  instance   => "sql-test-${sql_instance_suffix}",
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

```

#### `gsql_ssl_cert`

```puppet
# Tip: Remember to define gsql_instance to match the 'instance' property.
gsql_ssl_cert { 'server-certificate':
  cert_serial_number => '729335786',
  common_name        => 'CN=www.mydb.com,O=Acme',
  sha1_fingerprint   => '8fc295bf77a002db5182e04d92c48258cbc1117a',
  instance           => "sql-test-${sql_instance_suffix}",
  project            => 'google.com:graphite-playground',
  credential         => 'mycred',
}

```

#### `gsql_flag`

```puppet
gsql_flag { 'group_concat_max_len':
  min_value  => 4,
  max_value  => 4294967295,
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

```

#### `gsql_tier`

```puppet
gsql_tier { 'D0':
  ram        => 134217728, # we'll confirm that tier has enough RAM for us
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

```


### Classes

#### Public classes

* [`gsql_instance`][]:
    Represents a Cloud SQL instance. Cloud SQL instances are SQL databases
    hosted in Google's cloud. The Instances resource provides methods for
    common configuration and management tasks.
* [`gsql_database`][]:
    Represents a SQL database inside the Cloud SQL instance, hosted in
    Google's cloud.
* [`gsql_user`][]:
    The Users resource represents a database user in a Cloud SQL instance.
* [`gsql_ssl_cert`][]:
    Represents an SSL certificate created for a Cloud SQL instance. To use
    the
    SSL certificate you must have the SSL Client Certificate and the
    associated SSL Client Key. The Client Key can be downloaded only when
    the
    SSL certificate is created with the insert method.
* [`gsql_flag`][]:
    Represents a flag that can be configured for a Cloud SQL instance.
* [`gsql_tier`][]:
    The Tiers resource represents a service configuration that can be used
    to
    define a Cloud SQL instance. Each tier has an associated RAM, maximum
    storage, and list of regions in which the tier can be used. Available
    tiers vary depending on whether you use PostgreSQL, MySQL Second
    Generation, or MySQL First Generation instances.

### About output only properties

Some fields are output-only. It means you cannot set them because they are
provided by the Google Cloud Platform. Yet they are still useful to ensure the
value the API is assigning (or has assigned in the past) is still the value you
expect.

For example in a DNS the name servers are assigned by the Google Cloud DNS
service. Checking these values once created is useful to make sure your upstream
and/or root DNS masters are in sync.  Or if you decide to use the object ID,
e.g. the VM unique ID, for billing purposes. If the VM gets deleted and
recreated it will have a different ID, despite the name being the same. If that
detail is important to you you can verify that the ID of the object did not
change by asserting it in the manifest.

### Parameters

#### `gsql_instance`

Represents a Cloud SQL instance. Cloud SQL instances are SQL databases
hosted in Google's cloud. The Instances resource provides methods for
common configuration and management tasks.


#### Example

```puppet
gsql_instance { "sql-test-${sql_instance_suffix}":
  ensure           => present,
  database_version => 'MYSQL_5_7',
  settings         => {
    ip_configuration => {
      authorized_networks => [
        # The ACL below is for example only. (do NOT use in production as-is)
        {
          name  => 'google dns server',
          value => '8.8.8.8/32'
        },
      ],
    },
    tier             => 'db-n1-standard-1'
  },
  region           => 'us-central1',
  project          => 'google.com:graphite-playground',
  credential       => 'mycred',
}

```

#### Reference

```puppet
gsql_instance { 'id-of-resource':
  backend_type          => 'FIRST_GEN', 'SECOND_GEN' or 'EXTERNAL',
  connection_name       => string,
  database_version      => 'MYSQL_5_5', 'MYSQL_5_6' or 'MYSQL_5_7',
  failover_replica      => {
    available => boolean,
    name      => string,
  },
  instance_type         => 'CLOUD_SQL_INSTANCE', 'ON_PREMISES_INSTANCE' or 'READ_REPLICA_INSTANCE',
  ip_addresses          => [
    {
      ip_address     => string,
      time_to_retire => time,
      type           => 'PRIMARY' or 'OUTGOING',
    },
    ...
  ],
  ipv6_address          => string,
  master_instance_name  => string,
  max_disk_size         => integer,
  name                  => string,
  region                => string,
  replica_configuration => {
    failover_target               => boolean,
    mysql_replica_configuration   => {
      ca_certificate            => string,
      client_certificate        => string,
      client_key                => string,
      connect_retry_interval    => integer,
      dump_file_path            => string,
      master_heartbeat_period   => integer,
      password                  => string,
      ssl_cipher                => string,
      username                  => string,
      verify_server_certificate => boolean,
    },
    replica_names                 => [
      string,
      ...
    ],
    service_account_email_address => string,
  },
  settings              => {
    ip_configuration => {
      authorized_networks => [
        {
          expiration_time => time,
          name            => string,
          value           => string,
        },
        ...
      ],
      ipv4_enabled        => boolean,
      require_ssl         => boolean,
    },
    tier             => string,
  },
  project               => string,
  credential            => reference to gauth_credential,
}
```

##### `backend_type`

  * FIRST_GEN: First Generation instance. MySQL only.
  * SECOND_GEN: Second Generation instance or PostgreSQL instance.
  * EXTERNAL: A database server that is not managed by Google.

##### `connection_name`

  Connection name of the Cloud SQL instance used in connection strings.

##### `database_version`

  The database engine type and version. For First Generation instances,
  can be MYSQL_5_5, or MYSQL_5_6. For Second Generation instances, can
  be MYSQL_5_6 or MYSQL_5_7. Defaults to MYSQL_5_6.
  The databaseVersion property can not be changed after instance
  creation.

##### `failover_replica`

  The name and status of the failover replica. This property is
  applicable only to Second Generation instances.

##### failover_replica/available
Output only.  The availability status of the failover replica. A false status
  indicates that the failover replica is out of sync. The master
  can only failover to the falover replica when the status is true.

##### failover_replica/name
  The name of the failover replica. If specified at instance
  creation, a failover replica is created for the instance. The name
  doesn't include the project ID. This property is applicable only
  to Second Generation instances.

##### `instance_type`

  The instance type. This can be one of the following.
  * CLOUD_SQL_INSTANCE: A Cloud SQL instance that is not replicating
  from a master.
  * ON_PREMISES_INSTANCE: An instance running on the customer's
  premises.
  * READ_REPLICA_INSTANCE: A Cloud SQL instance configured as a
  read-replica.

##### `ipv6_address`

  The IPv6 address assigned to the instance. This property is applicable
  only to First Generation instances.

##### `master_instance_name`

  The name of the instance which will act as master in the replication
  setup.

##### `max_disk_size`

  The maximum disk size of the instance in bytes.

##### `name`

Required.  Name of the Cloud SQL instance. This does not include the project
  ID.

##### `region`

  The geographical region. Defaults to us-central or us-central1
  depending on the instance type (First Generation or Second
  Generation/PostgreSQL).

##### `replica_configuration`

  Configuration specific to failover replicas and read replicas.

##### replica_configuration/failover_target
  Specifies if the replica is the failover target. If the field is
  set to true the replica will be designated as a failover replica.
  In case the master instance fails, the replica instance will be
  promoted as the new master instance.
  Only one replica can be specified as failover target, and the
  replica has to be in different zone with the master instance.

##### replica_configuration/mysql_replica_configuration
  MySQL specific configuration when replicating from a MySQL
  on-premises master. Replication configuration information such as
  the username, password, certificates, and keys are not stored in
  the instance metadata.  The configuration information is used
  only to set up the replication connection and is stored by MySQL
  in a file named master.info in the data directory.

##### replica_configuration/mysql_replica_configuration/ca_certificate
  PEM representation of the trusted CA's x509 certificate.

##### replica_configuration/mysql_replica_configuration/client_certificate
  PEM representation of the slave's x509 certificate

##### replica_configuration/mysql_replica_configuration/client_key
  PEM representation of the slave's private key. The
  corresponsing public key is encoded in the client's asf asd
  certificate.

##### replica_configuration/mysql_replica_configuration/connect_retry_interval
  Seconds to wait between connect retries. MySQL's default is 60
  seconds.

##### replica_configuration/mysql_replica_configuration/dump_file_path
  Path to a SQL dump file in Google Cloud Storage from which the
  slave instance is to be created. The URI is in the form
  gs://bucketName/fileName. Compressed gzip files (.gz) are
  also supported. Dumps should have the binlog co-ordinates from
  which replication should begin. This can be accomplished by
  setting --master-data to 1 when using mysqldump.

##### replica_configuration/mysql_replica_configuration/master_heartbeat_period
  Interval in milliseconds between replication heartbeats.

##### replica_configuration/mysql_replica_configuration/password
  The password for the replication connection.

##### replica_configuration/mysql_replica_configuration/ssl_cipher
  A list of permissible ciphers to use for SSL encryption.

##### replica_configuration/mysql_replica_configuration/username
  The username for the replication connection.

##### replica_configuration/mysql_replica_configuration/verify_server_certificate
  Whether or not to check the master's Common Name value in the
  certificate that it sends during the SSL handshake.

##### replica_configuration/replica_names
  The replicas of the instance.

##### replica_configuration/service_account_email_address
  The service account email address assigned to the instance. This
  property is applicable only to Second Generation instances.

##### `settings`

  The user settings.

##### settings/ip_configuration
  The settings for IP Management. This allows to enable or disable
  the instance IP and manage which external networks can connect to
  the instance. The IPv4 address cannot be disabled for Second
  Generation instances.

##### settings/ip_configuration/ipv4_enabled
  Whether the instance should be assigned an IP address or not.

##### settings/ip_configuration/authorized_networks
  The list of external networks that are allowed to connect to
  the instance using the IP. In CIDR notation, also known as
  'slash' notation (e.g. 192.168.100.0/24).

##### settings/ip_configuration/authorized_networks[]/expiration_time
  The time when this access control entry expires in RFC
  3339 format, for example 2012-11-15T16:19:00.094Z.

##### settings/ip_configuration/authorized_networks[]/name
  An optional label to identify this entry.

##### settings/ip_configuration/authorized_networks[]/value
  The whitelisted value for the access control list. For
  example, to grant access to a client from an external IP
  (IPv4 or IPv6) address or subnet, use that address or
  subnet here.

##### settings/ip_configuration/require_ssl
  Whether the mysqld should default to 'REQUIRE X509' for
  users connecting over IP.

##### settings/tier
  The tier or machine type for this instance, for
  example db-n1-standard-1. For MySQL instances, this field
  determines whether the instance is Second Generation (recommended)
  or First Generation.


##### Output-only properties

* `ip_addresses`: Output only.
  The assigned IP addresses for the instance.

##### ip_addresses[]/ip_address
  The IP address assigned.

##### ip_addresses[]/time_to_retire
  The due time for this IP to be retired in RFC 3339 format, for
  example 2012-11-15T16:19:00.094Z. This field is only available
  when the IP is scheduled to be retired.

##### ip_addresses[]/type
  The type of this IP address. A PRIMARY address is an address
  that can accept incoming connections. An OUTGOING address is the
  source address of connections originating from the instance, if
  supported.

#### `gsql_database`

Represents a SQL database inside the Cloud SQL instance, hosted in
Google's cloud.


#### Example

```puppet
# Tip: Remember to define gsql_instance to match the 'instance' property.
gsql_database { 'webstore':
  ensure     => present,
  charset    => 'utf8',
  instance   => "sql-test-${sql_instance_suffix}",
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

```

#### Reference

```puppet
gsql_database { 'id-of-resource':
  charset    => string,
  collation  => string,
  instance   => reference to gsql_instance,
  name       => string,
  project    => string,
  credential => reference to gauth_credential,
}
```

##### `charset`

  The MySQL charset value.

##### `collation`

  The MySQL collation value.

##### `name`

  The name of the database in the Cloud SQL instance.
  This does not include the project ID or instance name.

##### `instance`

Required.  A reference to Instance resource


#### `gsql_user`

The Users resource represents a database user in a Cloud SQL instance.


#### Example

```puppet
# Tip: Remember to define gsql_instance to match the 'instance' property.
gsql_user { 'john.doe':
  ensure     => present,
  password   => 'secret-password',
  host       => '10.1.2.3',
  instance   => "sql-test-${sql_instance_suffix}",
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

```

#### Reference

```puppet
gsql_user { 'id-of-resource':
  host       => string,
  instance   => reference to gsql_instance,
  name       => string,
  password   => string,
  project    => string,
  credential => reference to gauth_credential,
}
```

##### `host`

Required.  The host name from which the user can connect. For insert operations,
  host defaults to an empty string. For update operations, host is
  specified as part of the request URL. The host name cannot be updated
  after insertion.

##### `name`

Required.  The name of the user in the Cloud SQL instance.

##### `instance`

Required.  A reference to Instance resource

##### `password`

  The password for the user.


#### `gsql_ssl_cert`

Represents an SSL certificate created for a Cloud SQL instance. To use the
SSL certificate you must have the SSL Client Certificate and the
associated SSL Client Key. The Client Key can be downloaded only when the
SSL certificate is created with the insert method.


#### Example

```puppet
# Tip: Remember to define gsql_instance to match the 'instance' property.
gsql_ssl_cert { 'server-certificate':
  cert_serial_number => '729335786',
  common_name        => 'CN=www.mydb.com,O=Acme',
  sha1_fingerprint   => '8fc295bf77a002db5182e04d92c48258cbc1117a',
  instance           => "sql-test-${sql_instance_suffix}",
  project            => 'google.com:graphite-playground',
  credential         => 'mycred',
}

```

#### Reference

```puppet
gsql_ssl_cert { 'id-of-resource':
  cert               => string,
  cert_serial_number => string,
  common_name        => string,
  create_time        => time,
  expiration_time    => time,
  instance           => reference to gsql_instance,
  sha1_fingerprint   => string,
  project            => string,
  credential         => reference to gauth_credential,
}
```

##### `cert`

  PEM representation of the X.509 certificate.

##### `cert_serial_number`

  Serial number, as extracted from the certificate.

##### `common_name`

  User supplied name. Constrained to [a-zA-Z.-_ ]+.

##### `create_time`

  The time when the certificate was created in RFC 3339 format, for
  example 2012-11-15T16:19:00.094Z.

##### `expiration_time`

  The time when the certificate expires in RFC 3339 format, for example
  2012-11-15T16:19:00.094Z.

##### `instance`

Required.  A reference to Instance resource

##### `sha1_fingerprint`

Required.  The SHA-1 of the certificate.


#### `gsql_flag`

Represents a flag that can be configured for a Cloud SQL instance.

#### Example

```puppet
gsql_flag { 'group_concat_max_len':
  min_value  => 4,
  max_value  => 4294967295,
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

```

#### Reference

```puppet
gsql_flag { 'id-of-resource':
  allowed_string_values => [
    string,
    ...
  ],
  applies_to            => [
    string,
    ...
  ],
  max_value             => integer,
  min_value             => integer,
  name                  => string,
  requires_restart      => boolean,
  type                  => string,
  project               => string,
  credential            => reference to gauth_credential,
}
```

##### `name`

  This is the name of the flag. Flag names always use underscores, not
  hyphens, e.g. max_allowed_packet


##### Output-only properties

* `allowed_string_values`: Output only.
  For STRING flags, List of strings that the value can be set to.

* `applies_to`: Output only.
  The database versions this flag is supported for.

* `max_value`: Output only.
  For INTEGER flags, the maximum allowed value.

* `min_value`: Output only.
  For INTEGER flags, the minimum allowed value.

* `requires_restart`: Output only.
  Indicates whether changing this flag will trigger a database restart.
  Only applicable to Second Generation instances.

* `type`: Output only.
  The type of the flag. Flags are typed to being BOOLEAN, STRING,
  INTEGER or NONE. NONE is used for flags which do not take a value,
  such as skip_grant_tables.

#### `gsql_tier`

The Tiers resource represents a service configuration that can be used to
define a Cloud SQL instance. Each tier has an associated RAM, maximum
storage, and list of regions in which the tier can be used. Available
tiers vary depending on whether you use PostgreSQL, MySQL Second
Generation, or MySQL First Generation instances.


#### Example

```puppet
gsql_tier { 'D0':
  ram        => 134217728, # we'll confirm that tier has enough RAM for us
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

```

#### Reference

```puppet
gsql_tier { 'id-of-resource':
  disk_quota => integer,
  ram        => integer,
  region     => [
    string,
    ...
  ],
  tier       => string,
  project    => string,
  credential => reference to gauth_credential,
}
```

##### `tier`

Required.  An identifier for the service tier or machine type, for example,
  db-n1-standard-1. For related information.


##### Output-only properties

* `disk_quota`: Output only.
  The maximum disk size of this tier in bytes.

* `ram`: Output only.
  The maximum RAM usage of this tier in bytes.

* `region`: Output only.
  The applicable regions for this tier.


## Limitations

This module has been tested on:

* RedHat 6, 7
* CentOS 6, 7
* Debian 7, 8
* Ubuntu 12.04, 14.04, 16.04, 16.10
* SLES 11-sp4, 12-sp2
* openSUSE 13
* Windows Server 2008 R2, 2012 R2, 2012 R2 Core, 2016 R2, 2016 R2 Core

Testing on other platforms has been minimal and cannot be guaranteed.

## Development

### Automatically Generated Files

Some files in this package are automatically generated by puppet-codegen.

We use a code compiler to produce this module in order to avoid repetitive tasks
and improve code quality. This means all Google Cloud Platform Puppet modules
use the same underlying authentication, logic, test generation, style checks,
etc.

Note: Currently `puppet-codegen` is not yet generally available, but it will
be made open source soon. Stay tuned. Please learn more about the way to change
autogenerated files by reading the [CONTRIBUTING.md][] file.

### Contributing

Contributions to this library are always welcome and highly encouraged.

See [CONTRIBUTING.md][] for more information on how to get
started.

### Running tests

This project contains tests for [rspec][], [rspec-puppet][] and [rubocop][] to
verify functionality. For detailed information on using these tools, please see
their respective documentation.

#### Testing quickstart: Ruby > 2.0.0

```
gem install bundler
bundle install
bundle exec rspec
bundle exec rubocop
```

#### Debugging Tests

In case you need to debug tests in this module you can set the following
variables to increase verbose output:

Variable                | Side Effect
------------------------|---------------------------------------------------
`PUPPET_HTTP_VERBOSE=1` | Prints network access information by Puppet provier.
`PUPPET_HTTP_DEBUG=1`   | Prints the payload of network calls being made.
`GOOGLE_HTTP_VERBOSE=1` | Prints debug related to the network calls being made.
`GOOGLE_HTTP_DEBUG=1`   | Prints the payload of network calls being made.

During test runs (using [rspec][]) you can also set:

Variable                | Side Effect
------------------------|---------------------------------------------------
`RSPEC_DEBUG=1`         | Prints debug related to the tests being run.
`RSPEC_HTTP_VERBOSE=1`  | Prints network expectations and access.

[CONTRIBUTING.md]: CONTRIBUTING.md
[bundle-forge]: https://forge.puppet.com/google/cloud
[`google-gauth`]: https://github.com/GoogleCloudPlatform/puppet-google-auth
[rspec]: http://rspec.info/
[rspec-puppet]: http://rspec-puppet.com/
[rubocop]: https://rubocop.readthedocs.io/en/latest/
[`gsql_instance`]: #gsql_instance
[`gsql_database`]: #gsql_database
[`gsql_user`]: #gsql_user
[`gsql_ssl_cert`]: #gsql_ssl_cert
[`gsql_flag`]: #gsql_flag
[`gsql_tier`]: #gsql_tier
