#!/usr/bin/perl -w
use strict;
use Test::More tests => 18;
use Time::Local qw(timegm timelocal);
use lib '..';
use EasyDateTime;

my $localtimezone=int ((timegm(0,0,0,1,0,2000)-timelocal(0,0,0,1,0,2000))/3600);
is(EasyDateTime->localtimezone,$localtimezone,'test: localtimezone()');
my $dt=EasyDateTime->now();
my $time=CORE::time();
is($dt->time,$time,'test: now()');
is($dt->timezone,$localtimezone,'test: now()');

$dt=EasyDateTime->now(8);
$time=CORE::time();
is($dt->time,$time,'test: now()');
is($dt->timezone,8,'test: now($timezone)');

is(EasyDateTime->validate('F1983-03-07 01:02:03'),'','Not Accept: F1983/03/07T01:02:03');
is(EasyDateTime->validate('1983-03-07 01:02:03'),'1','Accept: 1983-03-07 01:02:03');
is(EasyDateTime->validate('1983-33-07 01:02:03'),'','Not Accept: 1983-33-07 01:02:03');

is(EasyDateTime->validate({year=>1983,month=>3,day=>7,hour=>1,min=>2,sec=>3,timezone=>8}),'1','Accept: {year=>1983,month=>3,day=>7,hour=>1,min=>2,sec=>3,timezone=>8}');
is(EasyDateTime->validate({year=>1983,month=>3,day=>7,hour=>1,min=>2,sec=>3,timezone=>'dsa'}),'','Not Accept: {year=>1983,month=>3,day=>7,hour=>1,min=>2,sec=>3,timezone=>\'dsa\'}');
is(EasyDateTime->validate({year=>1983,month=>3,day=>7,hour=>1,min=>2,sec=>3}),'1','Accept: {year=>1983,month=>3,day=>7,hour=>1,min=>2,sec=>3}');
is(EasyDateTime->validate({year=>1983,month=>3,day=>7}),'1','Accept: {year=>1983,month=>3,day=>7}');
is(EasyDateTime->validate({year=>1983,month=>3,day=>32}),'','Not Accept: {year=>1983,month=>3,day=>32}');
is(EasyDateTime->validate({year=>1983,month=>'fd',day=>7}),'','Not Accept: {year=>1983,month=>\'fd\',day=>7}');
is(EasyDateTime->validate({year=>1983,month=>2,day=>29}),'','Not Accept: {year=>1983,month=>2,day=>29}');
is(EasyDateTime->validate({hour=>1,min=>2,sec=>3}),'1','Accept: {hour=>1,min=>2,sec=>3}');
is(EasyDateTime->validate({hour=>1,min=>2,sec=>62}),'','Not Accept: {hour=>1,min=>2,sec=>62}');
is(EasyDateTime->validate({year=>1983,month=>2,day=>29,hour=>1}),'','Not Accept: {year=>1983,month=>2,day=>29,hour=>1}');
