# define: nginx::resource::mailhost
#
# Parameters:
#   [*ensure*]                    - Enables or disables the specified mailhost (present|absent)
#   [*listen_ip*]                 - Default IP Address for NGINX to listen with this server on. Defaults to all interfaces (*)
#   [*listen_port*]               - Default IP Port for NGINX to listen with this server on. Defaults to TCP 80
#   [*listen_options*]            - Extra options for listen directive like 'default' to catchall. Undef by default.
#   [*ipv6_enable*]               - BOOL value to enable/disable IPv6 support (false|true). Module will check to see if IPv6
#                                   support exists on your system before enabling.
#   [*ipv6_listen_ip*]            - Default IPv6 Address for NGINX to listen with this server on. Defaults to all interfaces (::)
#   [*ipv6_listen_port*]          - Default IPv6 Port for NGINX to listen with this server on. Defaults to TCP 80
#   [*ipv6_listen_options*]       - Extra options for listen directive like 'default' to catchall. Template will allways add ipv6only=on.
#                                   While issue jfryman/puppet-nginx#30 is discussed, default value is 'default'.
#   [*index_files*]               - Default index files for NGINX to read when traversing a directory
#   [*ssl*]                       - Indicates whether to setup SSL bindings for this mailhost.
#   [*ssl_cert*]                  - Pre-generated SSL Certificate file to reference for SSL Support. This is not generated by this module.
#   [*ssl_ciphers*]               - Override default SSL ciphers. Defaults to nginx::ssl_ciphers
#   [*ssl_client_cert*]           - Pre-generated SSL Certificate file to reference for client verify SSL Support.
#                                   This is not generated by this module.
#   [*ssl_crl*]                   - String: Specifies CRL path in file system
#   [*ssl_dhparam*]               - This directive specifies a file containing Diffie-Hellman key agreement protocol cryptographic
#                                   parameters, in PEM format, utilized for exchanging session keys between server and client.
#   [*ssl_ecdh_curve*]            - This directive specifies a curve for ECDHE ciphers.
#   [*ssl_key*]                   - Pre-generated SSL Key file to reference for SSL Support. This is not generated by this module.
#   [*ssl_password_file*]         - This directive specifies a file containing passphrases for secret keys.
#   [*ssl_port*]                  - Default IP Port for NGINX to listen with this SSL server on. Defaults to TCP 443
#   [*ssl_prefer_server_ciphers*] - Specifies that server ciphers should be preferred over client ciphers when using the SSLv3
#                                   and TLS protocols. Defaults to $nginx::ssl_prefer_server_ciphers.
#   [*ssl_protocols*]             - SSL protocols enabled. Defaults to nginx::ssl_protocols
#   [*ssl_session_cache*]         - Sets the type and size of the session cache.
#   [*ssl_session_ticket_key*]    - This directive specifies a file containing secret key used to encrypt and decrypt TLS session tickets.
#   [*ssl_session_tickets*]       - Whether to enable or disable session resumption through TLS session tickets.
#   [*ssl_session_timeout*]       - String: Specifies a time during which a client may reuse the session parameters stored in a cache.
#                                   Defaults to 5m.
#   [*ssl_trusted_cert*]          - String: Specifies a file with trusted CA certificates in the PEM format used to verify client
#                                   certificates and OCSP responses if ssl_stapling is enabled.
#   [*ssl_verify_depth*]          - Sets the verification depth in the client certificates chain.
#   [*starttls*]                  - Enable STARTTLS support: (on|off|only)
#   [*protocol*]                  - Mail protocol to use: (imap|pop3|smtp)
#   [*auth_http*]                 - With this directive you can set the URL to the external HTTP-like server for authorization.
#   [*xclient*]                   - Whether to use xclient for smtp (on|off)
#   [*imap_auth*]                 - Sets permitted methods of authentication for IMAP clients.
#   [*imap_capabilities*]         - Sets the IMAP protocol extensions list that is passed to the client in response to the CAPA command.
#   [*imap_client_buffer*]        - Sets the IMAP commands read buffer size.
#   [*pop3_auth*]                 - Sets permitted methods of authentication for POP3 clients.
#   [*pop3_capabilities*]         - Sets the POP3 protocol extensions list that is passed to the client in response to the CAPA command.
#   [*smtp_auth*]                 - Sets permitted methods of SASL authentication for SMTP clients.
#   [*smtp_capabilities*]         - Sets the SMTP protocol extensions list that is passed to the client in response to the EHLO command.
#   [*proxy_pass_error_message*]  - Indicates whether to pass the error message obtained during the authentication on the backend
#                                   to the client.
#   [*server_name*]               - List of mailhostnames for which this mailhost will respond. Default [$name].
#   [*raw_prepend*]               - A single string, or an array of strings to prepend to the server directive (after mailhost_cfg_prepend
#                                   directive). NOTE: YOU are responsible for a semicolon on each line that requires one.
#   [*raw_append*]                - A single string, or an array of strings to append to the server directive (after mailhost_cfg_append
#                                   directive). NOTE: YOU are responsible for a semicolon on each line that requires one.
#   [*mailhost_cfg_append*]       - It expects a hash with custom directives to put after everything else inside server
#   [*mailhost_cfg_prepend*]      - It expects a hash with custom directives to put before everything else inside server
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  nginx::resource::mailhost { 'domain1.example':
#    ensure      => present,
#    auth_http   => 'server2.example/cgi-bin/auth',
#    protocol    => 'smtp',
#    listen_port => 587,
#    ssl_port    => 465,
#    starttls    => 'only',
#    xclient     => 'off',
#    ssl         => true,
#    ssl_cert    => '/tmp/server.crt',
#    ssl_key     => '/tmp/server.pem',
#  }
#
define nginx::resource::mailhost (
  Stdlib::Port $listen_port,
  Enum['absent', 'present'] $ensure                                = 'present',
  Nginx::Listen::V4 $listen_ip                                     = '*',
  Optional[String[1]] $listen_options                              = undef,
  Boolean $ipv6_enable                                             = false,
  Nginx::Listen::V6 $ipv6_listen_ip                                = '::',
  Stdlib::Port $ipv6_listen_port                                   = 80,
  String $ipv6_listen_options                                      = 'default ipv6only=on',
  Boolean $ssl                                                     = false,
  Optional[String[1]] $ssl_cert                                    = undef,
  String $ssl_ciphers                                              = $nginx::ssl_ciphers,
  Optional[String[1]] $ssl_client_cert                             = undef,
  Optional[String[1]] $ssl_crl                                     = undef,
  Optional[String[1]] $ssl_dhparam                                 = $nginx::ssl_dhparam,
  Optional[String[1]] $ssl_ecdh_curve                              = undef,
  Optional[String[1]] $ssl_key                                     = undef,
  Optional[String[1]] $ssl_password_file                           = undef,
  Optional[Stdlib::Port] $ssl_port                                 = undef,
  Nginx::Toggle $ssl_prefer_server_ciphers                         = $nginx::ssl_prefer_server_ciphers,
  String $ssl_protocols                                            = $nginx::ssl_protocols,
  Optional[String[1]] $ssl_session_cache                           = undef,
  Optional[String[1]] $ssl_session_ticket_key                      = undef,
  Optional[Nginx::Toggle] $ssl_session_tickets                     = undef,
  Nginx::Time $ssl_session_timeout                                 = '5m',
  Optional[String[1]] $ssl_trusted_cert                            = undef,
  Optional[Integer] $ssl_verify_depth                              = undef,
  Enum['on', 'off', 'only'] $starttls                              = 'off',
  Optional[Enum['imap', 'pop3', 'smtp']] $protocol                 = undef,
  Optional[String[1]] $auth_http                                   = undef,
  Optional[String[1]] $auth_http_header                            = undef,
  Nginx::Toggle $xclient                                           = 'on',
  Optional[String[1]] $imap_auth                                   = undef,
  Optional[Array[String[1]]] $imap_capabilities                    = undef,
  Optional[String[2]] $imap_client_buffer                          = undef,
  Optional[String[1]] $pop3_auth                                   = undef,
  Optional[Array[String[1]]] $pop3_capabilities                    = undef,
  Optional[String[1]] $smtp_auth                                   = undef,
  Optional[Array[String[1]]] $smtp_capabilities                    = undef,
  Optional[Variant[Array[String[1]], String[1]]] $raw_prepend      = undef,
  Optional[Variant[Array[String[1]], String[1]]] $raw_append       = undef,
  Optional[Nginx::Directives] $mailhost_cfg_prepend                = undef,
  Optional[Nginx::Directives] $mailhost_cfg_append                 = undef,
  Nginx::Toggle $proxy_pass_error_message                          = 'off',
  Array[Stdlib::Host] $server_name                                 = [$name]
) {
  if ! defined(Class['nginx']) {
    fail('You must include the nginx base class before using any defined resources')
  }

  # Add IPv6 Logic Check - Nginx service will not start if ipv6 is enabled
  # and support does not exist for it in the kernel.
  if ($ipv6_enable and !$facts['networking']['ip6']) {
    warning('nginx: IPv6 support is not enabled or configured properly')
  }

  # Check to see if SSL Certificates are properly defined.
  if ($ssl or $starttls == 'on' or $starttls == 'only') {
    if ($ssl_cert == undef) or ($ssl_key == undef) {
      fail('nginx: SSL certificate/key (ssl_cert/ssl_cert) and/or SSL Private must be defined and exist on the target system(s)')
    }
  }

  $config_dir  = "${nginx::conf_dir}/conf.mail.d"
  $config_file = "${config_dir}/${name}.conf"

  concat { $config_file:
    ensure  => $ensure,
    owner   => 'root',
    group   => $nginx::root_group,
    mode    => $nginx::global_mode,
    notify  => Class['nginx::service'],
    require => File[$config_dir],
  }

  if $ssl_port == undef or $listen_port != $ssl_port {
    concat::fragment { "${name}-header":
      target  => $config_file,
      content => template('nginx/mailhost/mailhost.erb'),
      order   => '001',
    }
  }

  # Create SSL File Stubs if SSL is enabled
  if $ssl {
    concat::fragment { "${name}-ssl":
      target  => $config_file,
      content => template('nginx/mailhost/mailhost_ssl.erb'),
      order   => '700',
    }
  }
}
