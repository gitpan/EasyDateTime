#!/usr/bin/perl -w
use strict;
use Test::More tests => 8;
use lib '..';
use EasyDateTime;

my $dt=EasyDateTime->new('1983-03-07 01:02:03',8);
$dt->year(2000);
is($dt->str,'2000-03-07 01:02:03','test: $dt->year($param)');
$dt->month(7);
is($dt->str,'2000-07-07 01:02:03','test: $dt->month($param)');
$dt->day(8);
is($dt->str,'2000-07-08 01:02:03','test: $dt->day($param)');
$dt->hour(4);
is($dt->str,'2000-07-08 04:02:03','test: $dt->hour($param)');
$dt->min(5);
is($dt->str,'2000-07-08 04:05:03','test: $dt->min($param)');
$dt->sec(6);
is($dt->str,'2000-07-08 04:05:06','test: $dt->sec($param)');
$dt->timezone(0);
is($dt->str,'2000-07-07 20:05:06','test: $dt->timezone($param)');
$dt->set({year=>1983,month=>3,day=>7,hour=>1,min=>2,sec=>3});
is($dt->str,'1983-03-07 01:02:03','test: $dt->set({})');

