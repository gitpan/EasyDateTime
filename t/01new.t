#!/usr/bin/perl -w
use strict;
use Test::More tests => 15;
use lib '..';
use EasyDateTime;

my $dt;

$dt=EasyDateTime->new('1983-03-07 01:02:03');
is($dt->str,'1983-03-07 01:02:03','Accept:1983-03-07 01:02:03');
$dt=EasyDateTime->new("\r\n\t 1983-03-07 01:02:03 \r\n\t");
is($dt->str,'1983-03-07 01:02:03','Accept:\r\n\t 1983-03-07 01:02:03 \r\n\t');
$dt=EasyDateTime->new('1983-03-07  01:02:03');
is($dt->str,'1983-03-07 01:02:03','Accept:1983-03-07  01:02:03');
$dt=EasyDateTime->new('1983-03-07T01:02:03');
is($dt->str,'1983-03-07 01:02:03','Accept:1983-03-07T01:02:03');
$dt=EasyDateTime->new('1983/03/07 01:02:03');
is($dt->str,'1983-03-07 01:02:03','Accept:1983/03/07 01:02:03');
$dt=EasyDateTime->new('1983.03.07 01:02:03');
is($dt->str,'1983-03-07 01:02:03','Accept:1983.03.07 01:02:03');
$dt=EasyDateTime->new('1983-03-07 01.02.03');
is($dt->str,'1983-03-07 01:02:03','Accept:1983-03-07 01.02.03');
$dt=EasyDateTime->new('83-3-7 1:2:3');
is($dt->str,'1983-03-07 01:02:03','Accept:83-3-7 1:2:3');
$dt=EasyDateTime->new('04-3-7 1:2:3');
is($dt->str,'2004-03-07 01:02:03','Accept:04-3-7 1:2:3');
$dt=EasyDateTime->new('1983-03-07');
is($dt->str,'1983-03-07 00:00:00','Accept:1983-03-07');
$dt=EasyDateTime->new('01:02:03');
is($dt->str,'2000-01-01 01:02:03','Accept:01:02:03');

$dt=EasyDateTime->new({year=>1983,month=>3,day=>7,hour=>1,min=>2,sec=>3,timezone=>8});
is($dt->str,'1983-03-07 01:02:03','Accept:{year=>1983,month=>3,day=>7,hour=>1,min=>2,sec=>3,timezone=>8}');
is($dt->timezone,8,'Accept:{year=>1983,month=>3,day=>7,hour=>1,min=>2,sec=>3,timezone=>8}');

$dt=EasyDateTime->new({});
is($dt->str,'2000-01-01 00:00:00','Accept:{}');
is($dt->timezone,EasyDateTime->localtimezone,'Accept:{}');

