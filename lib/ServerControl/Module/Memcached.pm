#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package ServerControl::Module::Memcached;

use strict;
use warnings;

our $VERSION = '0.94';

use ServerControl::Module;
use ServerControl::Commons::Process;

use base qw(ServerControl::Module);

__PACKAGE__->Implements( qw(ServerControl::Module::PidFile) );

__PACKAGE__->Parameter(
   help  => { isa => 'bool', call => sub { __PACKAGE__->help; } },
);

sub help {
   my ($class) = @_;

   print __PACKAGE__ . " " . $ServerControl::Module::Memcached::VERSION . "\n";

   printf "  %-30s%s\n", "--name=", "Instance Name";
   printf "  %-30s%s\n", "--path=", "The path where the instance should be created";
   printf "  %-30s%s\n", "--user=", "Memcache User";
   print "\n";
   printf "  %-30s%s\n", "--create", "Create the instance";
   printf "  %-30s%s\n", "--start", "Start the instance";
   printf "  %-30s%s\n", "--stop", "Stop the instance";

}

sub start {
   my ($class) = @_;

   my $pid_dir          = ServerControl::FsLayout->get_directory("Runtime", "pid");
   my ($name, $path)    = ($class->get_name, $class->get_path);
   my $user             = ServerControl::Args->get->{'user'};
   my $memcache_user    = ServerControl::Args->get->{'user'}?"-u " . ServerControl::Args->get->{'user'} : "";

   my $exec_file   = ServerControl::FsLayout->get_file("Exec", "memcached");
   my $conf_file   = ServerControl::FsLayout->get_file("Configuration", "conf");

   chomp(my @params = grep { ! /^#/ && ! /^$/ && ! /^\s+#/} eval { local(@ARGV) = ($conf_file); <>; });

   spawn("$path/$exec_file $memcache_user " . join(" ", @params));

}

1;
