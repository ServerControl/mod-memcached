#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package ServerControl::Module::Memcached;

use strict;
use warnings;

our $VERSION = '0.90';

use ServerControl::Module;
use ServerControl::Commons::Process;

use base qw(ServerControl::Module);

__PACKAGE__->Implements( qw(ServerControl::Module::PidFile) );

__PACKAGE__->Parameter(
   help  => { isa => 'bool', call => sub { __PACKAGE__->help; } },
);

__PACKAGE__->Directories(
   bin      => { chmod => 0755, user => 'root', group => 'root' },
   conf     => { chmod => 0700, user => 'root', group => 'root' },
   run      => { chmod => 0755, user =>  'root', group => 'root' },
);

__PACKAGE__->Files(
   'bin/memcached-' . __PACKAGE__->get_name  => { link => ServerControl::Schema->get('memcached') },
);

sub help {
   my ($class) = @_;

   print __PACKAGE__ . " " . $ServerControl::Module::Memcached::VERSION . "\n";

   printf "  %-30s%s\n", "--name=", "Instance Name";
   printf "  %-30s%s\n", "--path=", "The path where the instance should be created";
   print "\n";
   printf "  %-30s%s\n", "--user=", "Apache User";
   printf "  %-30s%s\n", "--ip=", "Listen IP";
   printf "  %-30s%s\n", "--port=", "Listen Port";
   print "\n";
   printf "  %-30s%s\n", "--try-large-memory", "Try to use large memory.";
   printf "  %-30s%s\n", "--threads=", "Number of threads";
   printf "  %-30s%s\n", "--backlog=", "Set backlog queue limit";
   printf "  %-30s%s\n", "--max-memory-for-items=", "Max memory to use for items in megabytes.";
   print "\n";
   printf "  %-30s%s\n", "--create", "Create the instance";
   printf "  %-30s%s\n", "--start", "Start the instance";
   printf "  %-30s%s\n", "--stop", "Stop the instance";

}

sub start {
   my ($class) = @_;

   my ($name, $path)    = ($class->get_name, $class->get_path);
   my $port             = ServerControl::Args->get->{'port'};
   my $ip               = ServerControl::Args->get->{'ip'};
   my $user             = ServerControl::Args->get->{'user'};
   my $max_mem_for_item = ServerControl::Args->get->{'max-memory-for-items'}?"-m " . ServerControl::Args->get->{'max-memory-for-items'} : "";
   my $pid_file         = "$path/run/$name.pid";
   my $large_memory     = ServerControl::Args->get->{'try-large-memory'}?"-L":"";
   my $threads          = ServerControl::Args->get->{'threads'}?"-t " . ServerControl::Args->get->{'threads'} : "";
   my $backlog          = ServerControl::Args->get->{'backlog'}?"-b " . ServerControl::Args->get->{'backlog'} : "";

   spawn("$path/bin/memcached-$name -d -p $port -l $ip $max_mem_for_item -P $pid_file $large_memory $threads -b $backlog");
}


1;
