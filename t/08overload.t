#!/usr/bin/perl -w
use strict;
use Test::More tests => 7;
use lib '..';
use EasyDateTime;

my $dt=EasyDateTime->new('1983-03-07 01:02:03',8);

my $dt2=$dt+3600;
is($dt2->str,'1983-03-07 02:02:03','test add overload');
$dt2=$dt+{year=>1,month=>1,day=>1,hour=>1,min=>1,sec=>1};
is($dt2->str,'1984-04-08 02:03:04','test add overload');

$dt2=$dt-3600;
is($dt2->str,'1983-03-07 00:02:03','test sub overload');
$dt2=$dt-{year=>1,month=>1,day=>1,hour=>1,min=>1,sec=>1};
is($dt2->str,'1982-02-06 00:01:02','test sub overload');
$dt2=EasyDateTime->new('1983-03-07 00:02:03',8);
is($dt-$dt2,3600,'test sub overload');

$dt2=$dt->clone;$dt2+=3600;
is($dt2->str,'1983-03-07 02:02:03','test add overload');
$dt2=$dt->clone;$dt2+={year=>1,month=>1,day=>1,hour=>1,min=>1,sec=>1};
is($dt2->str,'1984-04-08 02:03:04','test add overload');