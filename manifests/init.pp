# == Class: st2
#
#  Base class for st2 module. Used as top-level to set parameters via Hiera
#  This class does not need to be called directly
#
# === Parameters
#
#  [*version*]              - Version of StackStorm to install
#  [*revision*]             - Revision of StackStorm to install
#  [*autoupdate*]           - Automatically update to latest stable. (default: false)
#  [*mistral_git_branch*]   - Tagged branch of Mistral to download/install
#  [*repo_env*]             - Specify the environment of package repo (production, staging)
#  [*conf_file*]            - The path where st2 config is stored
#  [*use_ssl*]              - Enable/Disable SSL for all st2 APIs
#  [*ssl_key*]              - The path to SSL key for all st2 APIs
#  [*ssl_cert*]             - The path to SSL cert for all st2 APIs
#  [*st2web_ssl_dir*]       - Directory where st2web will look for its SSL info.
#                             (default: /etc/ssl/st2)
#  [*st2web_ssl_cert*]      - Path to the file where the StackStorm SSL cert will
#                             be generated. (default: /etc/ssl/st2/st2.crt)
#  [*st2web_ssl_key*]       - Path to the file where the StackStorm SSL key will
#                             be generated. (default: /etc/ssl/st2/st2.key)
#  [*api_url*]              - URL where the StackStorm API lives (default: undef)
#  [*api_logging_file*]     - Path to st2 API logging file (default: /etc/st2api/logging.conf)
#  [*auth*]                 - Toggle to enable/disable auth (Default: false)
#  [*auth_url*]             - URL where the StackStorm Auth lives (default: undef)
#  [*flow_url*]             - URL Path where StackStorm Flow lives (default: undef)
#  [*cli_base_url*]         - CLI config - Base URL lives
#  [*cli_api_version*]      - CLI config - API Version
#  [*cli_debug*]            - CLI config - Enable/Disable Debug
#  [*cli_cache_token*]      - CLI config - True to cache auth token until expries
#  [*cli_username*]         - CLI config - Auth Username
#  [*cli_password*]         - CLI config - Auth Password
#  [*cli_api_url*]          - CLI config - API URL
#  [*cli_auth_url*]         - CLI config - Auth URL
#  [*global_env*]           - Globally set the environment variables for ST2 API/Auth
#                             Overwritten by local config or CLI arguments.
#  [*workers*]              - Set the number of actionrunner processes to start
#  [*packs*]                - Hash of st2 packages to be installed
#  [*index_url*]            - Url to the StackStorm Exchange index file. (default undef)
#  [*syslog*]               - Routes all log messages to syslog
#  [*syslog_host*]          - Syslog host. Default: localhost
#  [*syslog_protocol*]      - Syslog protocol. Default: udp
#  [*syslog_port*]          - Syslog port. Default: 514
#  [*syslog_facility*]      - Syslog facility. Default: local7
#  [*ssh_key_location*]     - Location on filesystem of Admin SSH key for remote runner
#  [*db_host*]              - Hostname to talk to st2 db
#  [*db_port*]              - Port for db server for st2 to talk to
#  [*db_bind_ips*]          - Array of bind IP addresses for MongoDB to listen on
#  [*db_name*]              - Name of db to connect to (default: 'st2')
#  [*db_username*]          - Username to connect to db with (default: 'stackstorm')
#  [*db_password*]          - Password for 'admin' and 'stackstorm' users in MongDB.
#                             If 'undef' then use $cli_password
#  [*mongodb_version*]      - Version of MongoDB to install. If not provided it
#                             will be auto-calcuated based on $version
#                             (default: undef)
#  [*mongodb_manage_repo*]  - Set this to false when you have your own repositories
#                             for MongoDB (default: true)
#  [*mongodb_auth*]         - Boolean determining of auth should be enabled for
#                             MongoDB. Note: On new versions of Puppet (4.0+)
#                             you'll need to disable this setting.
#                             (default: true)
#  [*nginx_manage_repo*]    - Set this to false when you have your own repositories for nginx
#                             (default: true)
#  [*chatops_adapter*]      - Adapter package(s) to be installed with npm. List of hashes.
#  [*chatops_adapter_conf*] - Configuration parameters for Hubot adapter (hash)
#  [*chatops_hubot_log_level*]              - Logging level for hubot (string)
#  [*chatops_hubot_express_port*]           - Port that hubot operates on (integer or string)
#  [*chatops_tls_cert_reject_unauthorized*] - Should hubot validate SSL certs
#                                             Set to 1 when using self signed certs
#  [*chatops_hubot_name*]                   - Name of the bot in chat. Should be
#                                             properly quoted if it has special characters,
#                                             example: '"MyBot!"'
#  [*chatops_hubot_alias*]                  - Character to trigger the bot at the
#                                             beginning of a message. Must be properly
#                                             quoted of it's a special character,
#                                             example: "'!'"
#  [*chatops_api_key*]                      - API key generated by `st2 apikey create`
#                                             that hubot will use to post data back
#                                             to StackStorm.
#                                             (default: undef)
#  [*chatops_st2_hostname*]                 - Hostname of the StackStorm instance
#                                             that chatops will connect to for
#                                             API and Auth. If unspecified it will
#                                             use the default in /opt/stackstorm/chatops/st2chatops.env
#                                             (default: undef)
#  [*chatops_st2_web_url*]                  - Public URL of StackStorm instance.
#                                             used by chatops to offer links to
#                                             execution details in a chat.
#                                             If unspecified it will use the
#                                             default in /opt/stackstorm/chatops/st2chatops.env
#                                             (default: undef)
#  [*nodejs_version*]       - Version of NodeJS to install. If not provided it
#                             will be auto-calcuated based on $version
#                             (default: undef)
#  [*nodejs_manage_repo*]   - Set this to false when you have your own repositories
#                             for NodeJS (default: true)
#
#  Variables can be set in Hiera and take advantage of automatic data bindings:
#
#  Example:
#    st2::version: 0.6.0
#
class st2(
  $version                  = 'latest',
  $autoupdate               = false,
  $mistral_git_branch       = 'st2-1.2.0',
  $repo_base                = $::st2::params::repo_base,
  $repo_env                 = $::st2::params::repo_env,
  $conf_dir                 = $::st2::params::conf_dir,
  $conf_file                = "${::st2::params::conf_dir}/st2.conf",
  $use_ssl                  = false,
  $ssl_cert                 = '/etc/ssl/cert.crt',
  $ssl_key                  = '/etc/ssl/cert.key',
  $st2web_ssl_dir           = '/etc/ssl/st2',
  $st2web_ssl_cert          = '/etc/ssl/st2/st2.crt',
  $st2web_ssl_key           = '/etc/ssl/st2/st2.key',
  $api_url                  = undef,
  $api_logging_file         = '/etc/st2api/logging.conf',
  $auth                     = true,
  $auth_url                 = undef,
  $auth_mode                = 'standalone',
  $auth_logging_file        = '/etc/st2auth/logging.conf',
  $flow_url                 = undef,
  $cli_base_url             = 'http://127.0.0.1',
  $cli_api_version          = 'v1',
  $cli_debug                = false,
  $cli_cache_token          = true,
  $cli_silence_ssl_warnings = false,
  $cli_username             = 'st2admin',
  $cli_password             = 'Ch@ngeMe',
  $cli_api_url              = 'http://127.0.0.1:9101',
  $cli_auth_url             = 'http://127.0.0.1:9100',
  $global_env               = false,
  $workers                  = 8,
  $packs                    = {},
  $index_url                = undef,
  $mistral_api_url          = undef,
  $mistral_api_port         = '8989',
  $mistral_api_service      = false,
  $syslog                   = false,
  $syslog_host              = 'localhost',
  $syslog_protocol          = 'udp',
  $syslog_port              = 514,
  $syslog_facility          = 'local7',
  $ssh_key_location         = '/home/stanley/.ssh/st2_stanley_key',
  $db_host                  = '127.0.0.1',
  $db_port                  = $::st2::params::mongodb_port,
  $db_bind_ips              = $::st2::params::mongodb_bind_ips,
  $db_name                  = $::st2::params::mongodb_st2_db,
  $db_username              = $::st2::params::mongodb_st2_username,
  $db_password              = undef,
  $mongodb_version          = undef,
  $mongodb_manage_repo      = true,
  $mongodb_auth             = true,
  $ng_init                  = true,
  $datastore_keys_dir       = $::st2::params::datstore_keys_dir,
  $datastore_key_path       = "${::st2::params::datstore_keys_dir}/datastore_key.json",
  $nginx_manage_repo        = true,
  $chatops_adapter          = $::st2::params::chatops_adapter,
  $chatops_adapter_conf     = $::st2::params::chatops_adapter_conf,
  $chatops_hubot_log_level              = $::st2::params::hubot_log_level,
  $chatops_hubot_express_port           = $::st2::params::hubot_express_port,
  $chatops_tls_cert_reject_unauthorized = $::st2::params::tls_cert_reject_unauthorized,
  $chatops_hubot_name                   = $::st2::params::hubot_name,
  $chatops_hubot_alias                  = $::st2::params::hubot_alias,
  $chatops_api_key                      = undef,
  $chatops_st2_hostname                 = '127.0.0.1',
  $chatops_st2_web_url                  = undef,
  $nodejs_version           = undef,
  $nodejs_manage_repo       = true,
) inherits st2::params {

  ########################################
  ## Control commands
  exec {'/usr/bin/st2ctl reload --register-all':
    tag         => 'st2::reload',
    refreshonly => true,
  }

  exec {'/usr/bin/st2ctl reload --register-configs':
    tag         => 'st2::register-configs',
    refreshonly => true,
  }
}
