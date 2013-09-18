# # Parser tests

if require?
  chai = require 'chai'
  TzTime = require '../tztime'

if not GLOBAL?
  root = this
else
  root = GLOBAL

assert = chai.assert
equal = equal

describe 'TzTime.parse', () ->
  it 'should return null when input is bogus', () ->
    d = TzTime.parse 'bogus input', '%Y-%m-%d'
    equal d, null

  it 'should parse full month name', () ->
    for month, idx in TzTime.MONTHS
      d = TzTime.parse "#{month} 1 2013", '%B %D %Y'
      equal d.getMonth(), idx

  it 'should parse full month case insensitively', () ->
    for month, idx in TzTime.MONTHS
      d = TzTime.parse "#{month.toLowerCase()} 1 2013", '%B %D %Y'
      equal d.getMonth(), idx

  it 'should parse short month name', () ->
    for month, idx in TzTime.MNTH
      d = TzTime.parse "#{month} 1 2013", '%b %D %Y'
      equal d.getMonth(), idx

  it 'should parse short month names case insensitively', () ->
    for month, idx in TzTime.MNTH
      d = TzTime.parse "#{month.toLowerCase()} 1 2013", '%b %D %Y'
      equal d.getMonth(), idx

  it 'should parse decimal seconds', () ->
    d = TzTime.parse '2013-12-01 12:00:01.12', '%Y-%m-%d %H:%M:%f'
    equal d.year, 2013, 'year must match'
    equal d.month, 11, 'month must match'
    equal d.date, 1, 'date must match'
    equal d.hours, 12, 'hours must match'
    equal d.minutes, 0, 'minutes must match'
    equal d.seconds, 1, 'seconds must match'
    equal d.milliseconds, 120, 'milliseconds must match'

  it 'should parse decimal seconds with 3-digit fraction', () ->
    d = TzTime.parse '2013-12-01T12:00:01.221', '%Y-%m-%dT%H:%M:%F'
    equal d.year, 2013, 'year must match'
    equal d.month, 11, 'month must match'
    equal d.date, 1, 'date must match'
    equal d.hours, 12, 'hours must match'
    equal d.minutes, 0, 'minutes must match'
    equal d.seconds, 1, 'seconds must match'
    equal d.milliseconds, 221, 'milliseconds must match'

  it 'should parse json timestamp correctly', () ->
    d = TzTime.parse '2013-12-01T12:00:01.221Z', '%Y-%m-%dT%H:%M:%F%z'
    equal d.timezone, 0, 'timezone must be in UTC'
    equal d.year, 2013, 'year must match'
    equal d.month, 11, 'month must match'
    equal d.date, 1, 'date must match'
    equal d.hours, 12, 'hours must match'
    equal d.minutes, 0, 'minutes must match'
    equal d.seconds, 1, 'seconds must match'
    equal d.milliseconds, 221, 'milliseconds must match'

  it 'should parse AM/PM correctly', () ->
    d = TzTime.parse '2013-12-01 12:00 p.m.', '%Y-%m-%d %i:%M %p'
    equal d.year, 2013, 'year must match'
    equal d.month, 11, 'month must match'
    equal d.date, 1, 'date must match'
    equal d.hours, 12, 'hours must match'
    equal d.minutes, 0, 'minutes must match'

    d = TzTime.parse '2013-12-01 12:00 a.m.', '%Y-%m-%d %i:%M %p'
    equal d.year, 2013, 'year must match'
    equal d.month, 11, 'month must match'
    equal d.date, 1, 'date must match'
    equal d.hours, 0, 'hours must match'
    equal d.minutes, 0, 'minutes must match'
