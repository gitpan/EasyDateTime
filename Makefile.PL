require 5.004;
use ExtUtils::MakeMaker;

WriteMakefile(
	'NAME'		=>	'EasyDateTime',
	'VERSION_FROM'	=>	'EasyDateTime.pm',
	dist		=>	{ COMPRESS => 'gzip -9f', SUFFIX => 'gz'}
	);
