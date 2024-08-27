
Install Required Packages


sudo apt update
sudo apt install postfix dovecot-core dovecot-auth dovecot-ldap libsasl2-modules-ldap



Configure Dovecot for LDAP Authentication

Edit /etc/dovecot/conf.d/10-auth.conf:

auth_mechanisms = plain login
!include auth-ldap.conf.ext



Create /etc/dovecot/conf.d/auth-ldap.conf.ext:


passdb {
  driver = ldap
  args = /etc/dovecot/dovecot-ldap.conf.ext
}

userdb {
  driver = ldap
  args = /etc/dovecot/dovecot-ldap.conf.ext
}



Create /etc/dovecot/dovecot-ldap.conf.ext:

ini
Code kopieren
hosts = ldap.example.com
dn = cn=admin,dc=example,dc=com
dnpass = password
ldap_version = 3
auth_bind = yes
base = ou=users,dc=example,dc=com
user_filter = (sAMAccountName=%u)
pass_filter = (sAMAccountName=%u)



Configure Postfix to Use Dovecot for Authentication


Edit /etc/postfix/main.cf:

smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes
smtpd_recipient_restrictions = permit_sasl_authenticated, reject_unauth_destination
smtpd_use_tls = yes
smtp_tls_security_level = may
smtpd_tls_security_level = may


Edit /etc/postfix/master.cf to include:

smtp      inet  n       -       n       -       -       smtpd
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_sasl_security_options=noanonymous
  -o smtpd_recipient_restrictions=permit_sasl_authenticated,reject
Set Permissions for Dovecot Authentication Socket

Edit /etc/dovecot/conf.d/10-master.conf:

service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
}


Restart Services

bash

sudo systemctl restart postfix
sudo systemctl restart dovecot

Summary
Installed postfix, dovecot-core, dovecot-auth, dovecot-ldap, and libsasl2-modules-ldap.
Configured Dovecot to use LDAP for authentication.
Configured Postfix to use Dovecot's authentication mechanism.
Ensured permissions are set correctly for the Dovecot authentication socket.
Restarted services to apply the configuration.
