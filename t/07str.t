#!/usr/bin/perl -w
use strict;
use Test::More tests => 1;
use lib '..';
use EasyDateTime;

#===YEAR
#%yyyy       A full numeric representation of a year, 4 digits(2004)
#%yy         A two digit representation of a year(04)
#%is_leap    Whether it's a leap year(0 or 1)

#===MONTH
#%MM         Numeric representation of a month, with leading zeros (01..12)
#%M          Numeric representation of a month, without leading zeros (1..12)
#%MN         A full textual representation of a month (January through December)
#%MA         A short textual representation of a month, three letters (Jan through Dec)
#%DM         Number of days in the given month (28..31)

#===DAY
#%dd         Day of the month, 2 digits with leading zeros (01..31)
#%d          Day of the month without leading zeros (1..31)
#%yday       The day of the year (starting from 0,sunday=0)
#%wday       Numeric representation of the day of the week(start from 0)
#%dn         A full textual representation of the day of the week (Sunday through Saturday)
#%da         A textual representation of a day, three letters (Mon through Sun)

#===HOUR
#%h12        12-hour format of an hour without leading zeros (1..12)
#%h          24-hour format of an hour without leading zeros (0..23)
#%hh12       12-hour format of an hour with leading zeros (01..12)
#%hh         24-hour format of an hour with leading zeros (00..23)
#%ap         a Lowercase Ante meridiem and Post meridiem  (am or pm)
#%AP         Uppercase Ante meridiem and Post meridiem (AM or PM)

#===MINUTE
#%mm         Minutes with leading zeros (00..59)
#%m          Minutes without leading zeros (0..59)

#===SECOND
#%ss         Seconds, with leading zeros (00..59)
#%s          Seconds, without leading zeros (0..59)

#===TIMEZONE
#%tz         Difference to Greenwich time (GMT) in hours
#%ts         Timezone offset in seconds
#%lt         Timezone setting of this machine
#%tn1        A textual representation of the timezone (GMT+02:00)
#%tn2        A textual representation of the timezone (+0200)
#%tn3        A textual representation of the timezone (+02:00)

#===FULL DATETIME
#%date       string like '2004-08-06'
#%time       string like '03:02:01'
#%iso1861    string like '2004-02-12T15:19:21+00:00' 
#%rfc2822    string like 'Thu, 21 Dec 2000 16:01:07 +0200'
#%datetime   string like '2004-08-06 03:02:01'

#%%          %

my $dt=EasyDateTime->new('1983-03-07 01:02:03',8);

my $str1=$dt->str('%yyyy-%yy-%is_leap-%MM-%M-%MN-%MA-%DM-%dd-%d-%yday-%wday-%dn-%da-%h12-%h-%hh12-%hh-%ap-%AP-%mm-%m-%ss-%s-%tz-%ts-%lt-%tn1-%tn2-%tn3-%date-%time-%iso1861-%rfc2822-%datetime-%%END');
my $str2='1983-83-0-03-3-March-Mar-31-07-7-65-1-Monday-Mon-1-1-01-01-am-AM-02-2-03-3-8-28800-8-GMT+08:00-+0800-+08:00-1983-03-07-01:02:03- 1983-03-07T01:02:03+08:00-Mon, 07 Mar 1983 01:02:03 +0800-1983-03-07 01:02:03-%END';

is($str1,$str2,'test: str()');




