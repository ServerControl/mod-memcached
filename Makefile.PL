use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'ServerControl-Memcached',
   VERSION_FROM => 'lib/ServerControl/Module/Memcached.pm',
   PREREQ_PM => {'ServerControl' => '0.90'},
   LICENSE => 'bsd'
);

