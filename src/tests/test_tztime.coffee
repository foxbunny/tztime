root = this

if require?
  chai = require 'chai'
  TzTime = require '../tztime'

assert = chai.assert
equal = assert.equal

assertTime = (d, yr, mo, dy, hr, mi, se, ms) ->
  equal d.getFullYear(), yr, "Year of #{d} are not correct" if yr
  equal d.getMonth(), mo, "Month of #{d} are not correct" if mo
  equal d.getDate(), dy, "Date of #{d} are not correct" if dy
  equal d.getHours(), hr, "Hours of #{d} are not correct" if hr
  equal d.getMinutes(), mi, "Minutes of #{d} are not correct" if mi
  equal d.getSeconds(), se, "Seconds of #{d} are not correct" if se
  equal d.getMilliseconds(), ms, "Milliseconds of #{d} are not correct" if mi

assertEqualDate = (a, b) ->
  equal a.getFullYear(), b.getFullYear()
  equal a.getMonth(), b.getMonth()
  equal a.getDate(), b.getDate()
  equal a.getHours(), b.getHours()
  equal a.getMinutes(), b.getMinutes()
  equal a.getSeconds(), b.getSeconds()
  equal a.getMilliseconds(), b.getMilliseconds()

describe 'TzTime', () ->

  describe 'constructor', () ->
    it 'should be identical to Date constructor', () ->
      d1 = new TzTime 2013, 8, 1
      d2 = new Date 2013, 8, 1
      equal d1.getTime(), d2.getTime()

    it 'should have a constructor of TzTime', () ->
      d = new TzTime 2013, 8, 1
      equal d.constructor, TzTime

    it 'should be an instance of TzTime', () ->
      d = new TzTime 2013, 8, 1
      assert.ok d instanceof TzTime

    it 'should be usable withough the new keyword', () ->
      d = TzTime 2013, 8, 1
      equal typeof d, 'object'
      equal d.constructor, TzTime
      assert.ok d instanceof TzTime

      d1 = new TzTime 2013, 8, 1
      equal d.getTime(), d1.getTime()

    it 'should accept the timezone as last argument', () ->
      d = TzTime 2013, 8, 1, 12, 45, 39, 0, 360
      equal d.timezone, 360

    it 'should set correct time when time zone is passed', () ->
      d1 = TzTime 2013, 0, 1, 12, 30, 0, 0, 60
      d2 = TzTime 2013, 0, 1, 12, 30, 0, 0, 360
      d3 = TzTime 2013, 0, 1, 12, 30, 0, 0, 720
      d4 = TzTime 2013, 0, 1, 12, 30, 0, 0, -120
      assertTime d1, 2013, 0, 1, 12, 30, 0, 0
      assertTime d2, 2013, 0, 1, 12, 30, 0, 0
      assertTime d3, 2013, 0, 1, 12, 30, 0, 0
      assertTime d4, 2013, 0, 1, 12, 30, 0, 0

    it 'should create a new instance if passed Date or TzTime obj', () ->
      d1 = new Date 2013, 8, 1
      d2 = TzTime 2013, 8, 1
      d3 = TzTime d1
      d4 = TzTime d2
      assert.notEqual d1, d2
      assert.notEqual d1, d3
      assert.notEqual d1, d4
      assert.notEqual d2, d3
      assert.notEqual d2, d4
      assert.notEqual d3, d4
      assertEqualDate d1, d2
      assertEqualDate d2, d3
      assertEqualDate d3, d4

    it 'should retain timezone when passed TzTime instance', () ->
      d = TzTime 2013, 8, 1
      d.timezone = -240
      d1 = TzTime d
      equal d1.timezone, -240

    it 'should behave as TzTime.parse() if passed two strings', () ->
      d = TzTime '2013-03-03', '%Y-%m-%d'
      equal d.year, 2013
      equal d.month, 2
      equal d.date, 3

    it 'should take unix epoch and timezone', () ->
      d = TzTime 2013, 8, 1, 12, 34, 20, 220, 240
      uepoch = d.getTime()
      d1 = TzTime uepoch, -120
      equal d1.year, 2013
      equal d1.month, 8
      equal d1.date, 1
      equal d1.hours, 6
      equal d1.minutes, 34
      equal d1.seconds, 20
      equal d1.milliseconds, 220
      equal d1.timezone, -120

  describe '#timezone', () ->
    it 'is a number', () ->
      d = TzTime 2013, 8, 1, 8, 20
      equal typeof d.timezone, 'number'

    it 'should be opposite of #getTimezoneOffset()', () ->
      d = TzTime 2013, 8, 1, 8, 20
      equal d.getTimezoneOffset() + d.timezone, 0

    it 'can be set by assigning', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d.timezone = 12
      equal d.getTimezoneOffset() + d.timezone, 0
      equal d.getTimezoneOffset(), -12

    it 'should not shift the time when set', () ->
      offset = -120
      d = TzTime 2013, 8, 1, 8, 20, 0, 0, offset
      d.timezone = 0
      h1 = d.getHours()
      uh1 = d.getUTCHours()
      d.timezone = 60
      h2 = d.getHours()
      uh2 = d.getUTCHours()
      equal h1, h2
      assert.notEqual uh1, uh2

    it 'should give same UTC and local time when set to 0', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d.timezone = 0
      equal d.getHours(), d.getUTCHours()

    it 'should generally work correctly', () ->
      pzone = TzTime.platformZone
      pzhours = pzone / 60
      d = TzTime 2013, 8, 1, 8, 20  ## 8:20am in pzone

      utch1 = d.getUTCHours()
      loch1 = d.getHours()

      equal utch1, loch1 - pzhours

      d.timezone = pzone + 120  ## + 2 hours

      utch2 = d.getUTCHours()
      loch2 = d.getHours()

      equal loch2, loch1  ## local time remains the same
      equal utch2, utch1 - 2  ## UTC has been shifted -2 hr

    it 'will convert floats to integers', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d.timezone = 120.4
      equal d.timezone, 120

    it 'can be set using -= and += operators', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d.timezone = 0
      d.timezone += 12
      equal d.timezone, 12

    it 'should be UTC time if set to 0', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d.timezone = 0
      d.setHours 8
      equal d.getUTCHours(), 8
      equal d.getHours(), 8

  describe '#getTimezoneOffset()', () ->
    it 'should return the opposite of time zone offset', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d.timezone = 12
      equal d.getTimezoneOffset(), -12

  describe '#setTimezoneOffset()', () ->
    it 'should set the timezone using opposite of offset', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d.timezone = 0
      d.setTimezoneOffset 12
      equal d.timezone, -12

  describe '#setFullYear()', () ->
    it 'should set the year and return instance', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d1 = d.setFullYear 2020
      equal d1, d
      equal d.getFullYear(), 2020

    it 'should set mont and date if passed', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d.setFullYear 2015, 2, 12
      equal d.getFullYear(), 2015
      equal d.getMonth(), 2
      equal d.getDate(), 12

  describe '#setMonth()', () ->
    it 'should set month and return instance', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d1 = d.setMonth 9
      equal d.getMonth(), 9
      equal d1, d

    it 'should set both month and date if passed both', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d.setMonth 9, 12
      equal d.getMonth(), 9
      equal d.getDate(), 12

  describe '#setDate()', () ->
    it 'should set the date and return instance', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d1 = d.setDate 2
      equal d.getDate(), 2
      equal d1, d

  describe '#setHours()', () ->
    it 'should set hours and return instance', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d1 = d.setHours 2
      equal d.getHours(), 2
      equal d1, d

    it 'should set minutes, seconds, and milliseconds if given', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.setHours 2, 2, 2, 2
      equal d.getHours(), 2
      equal d.getMinutes(), 2
      equal d.getSeconds(), 2
      equal d.getMilliseconds(), 2

  describe '#setMinutes()', () ->
    it 'should set minutes and return instance', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d1 = d.setMinutes 2
      equal d.getMinutes(), 2
      equal d1, d

    it 'should set seconds and milliseconds if given', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.setMinutes 2, 2, 2
      equal d.getMinutes(), 2
      equal d.getSeconds(), 2
      equal d.getMilliseconds(), 2

  describe '#setSeconds()', () ->
    it 'should set seconds and return instance', () ->
      d = TzTime 2013, 8, 1, 8, 20
      d1 = d.setSeconds 2
      equal d.getSeconds(), 2
      equal d1, d

    it 'should set milliseconds if given', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.setSeconds 2, 2
      equal d.getSeconds(), 2
      equal d.getMilliseconds(), 2

  describe '#setMilliseconds()', () ->
    it 'should set milliseconds and return instance', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d1 = d.setMilliseconds 2
      equal d.getMilliseconds(), 2
      equal d1, d

  describe '#getHours()', () ->
    it 'should give time in instance timezone', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      equal d.getHours(), 8
      d.timezone += 120
      equal d.getHours(), 8
      d.timezone -= 300
      equal d.getHours(), 8

  describe '#year', () ->
    it 'should set year', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.year = 2020
      equal d.getFullYear(), 2020

    it 'should return year', () ->
      d = TzTime 2013, 8, 1, 8, 20
      equal d.year, 2013

    it 'can be used with -= and += operators', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.year -= 2
      y1 = d.year
      d.year += 4
      y2 = d.year
      equal y1, 2011
      equal y2, 2015

  describe '#month', () ->
    it 'should set month', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.month = 9
      equal d.getMonth(), 9

    it 'should return month', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      equal d.month, 8

    it 'can be used with -= and += operators', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.month -= 2
      m1 = d.month
      d.month += 4
      m2 = d.month
      equal m1, 6
      equal m2, 10

    it 'should adjust the year when incremented or decremented', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.month -= 12
      y1 = d.year
      d.month += 24
      y2 = d.year
      equal y1, 2012
      equal y2, 2014

  describe '#date', () ->
    it 'should set the date', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.date = 20
      equal d.getDate(), 20

    it 'should return the date', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      equal d.date, 1

    it 'can be used with -= and += operators', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.date += 12
      d1 = d.date
      d.date -= 4
      d2 = d.date
      equal d1, 13
      equal d2, 9

    it 'should cross month boundaries when setting', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.date += 31
      m1 = d.month
      d.date -= 62
      m2 = d.month
      equal m1, 9
      equal m2, 7

    it 'should cross year boundaries when setting', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.date += 365
      y1 = d.year
      d.date -= 2 * 365
      y2 = d.year
      equal y1, 2014
      equal y2, 2012

  describe '#day', () ->
    it 'should return the day of week', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500  ## Sunday
      equal d.day, 0

  describe '#hours', () ->
    it 'should set the hour', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.hours = 2
      equal d.getHours(), 2

    it 'should return hour', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      equal d.hours, 8

    it 'can be used with -= and += operators', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.hours -= 4
      h1 = d.hours
      d.hours += 12
      h2 = d.hours
      equal h1, 4
      equal h2, 16

    it 'should cross date boundaries', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.hours += 20
      equal d.date, 2

    it 'should cross month boundaries', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.hours += 24 * 31
      equal d.month, 9

    it 'should cross year boundaries', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.hours += 24 * 365
      equal d.year, 2014

  describe '#minutes', () ->
    it 'should set minute', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.minutes = 21
      equal d.getMinutes(), 21

    it 'should return minute', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      equal d.minutes, 20

    it 'can be used with -= and += operators', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.minutes -= 15
      m1 = d.minutes
      d.minutes += 20
      m2 = d.minutes
      equal m1, 5
      equal m2, 25

    it 'should cross hour boundary', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.minutes += 50
      equal d.hours, 9

    it 'should cross date boundary', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.minutes += 60 * 24
      equal d.date, 2

    it 'should cross month boundary', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.minutes += 60 * 24 * 31
      equal d.month, 9

    it 'should cross year boundary', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.minutes += 60 * 24 * 365
      equal d.year, 2014

  describe '#seconds', () ->
    it 'should set seconds', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds = 21
      equal d.getSeconds(), 21

    it 'should return seconds', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      equal d.seconds, 1

    it 'can be used with -= and += operators', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds += 20
      s1 = d.seconds
      d.seconds -= 5
      s2 = d.seconds
      equal s1, 21
      equal s2, 16

    it 'should cross minutes boundary', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds += 60
      equal d.minutes, 21

    it 'should cross hours boundary', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds += 60 * 60
      equal d.hours, 9

    it 'should cross date boundary', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds += 60 * 60 * 24
      equal d.date, 2

    it 'should cross month boundary', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds += 60 * 60 * 24 * 31
      equal d.month, 9

    it 'should cross year boundary', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds += 60 * 60 * 24 * 365
      equal d.year, 2014

  describe '#milliseconds', () ->
    it 'should return milliseconds', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      equal d.milliseconds, 500

    it 'should set milliseconds', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.milliseconds = 430
      equal d.milliseconds, 430

    it 'can be used with -= and += operators', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.milliseconds += 10
      equal d.milliseconds, 510
      d.milliseconds -= 20
      equal d.milliseconds, 490

    it 'should cross second boundary', () ->
      d = TzTime 2013, 8, 1, 8, 20, 1, 500
      d.milliseconds += 500
      equal d.seconds, 2

  describe '#utcYear', () ->
    it 'should return the UTC year', () ->
      d = TzTime 2013, 0, 1, 0, 0, 0, 0, 60
      equal d.year, 2013
      equal d.utcYear, 2012

    it 'should set the UTC year', () ->
      d = TzTime 2013, 0, 1, 0, 0, 0, 0, 60
      d.utcYear = 2013
      equal d.year, 2014

  describe '#utcMonth', () ->
    it 'should return the UTC month', () ->
      d = TzTime 2013, 1, 1, 0, 0, 0, 0, 60
      equal d.month, 1
      equal d.utcMonth, 0

    it 'should set the UTC month', () ->
      d = TzTime 2013, 1, 1, 0, 0, 0, 0, 60
      d.utcMonth = 1
      equal d.month, 2

  describe '#utcDate', () ->
    it 'should return the UTC date', () ->
      d = TzTime 2013, 1, 2, 0, 0, 0, 0, 60
      equal d.date, 2
      equal d.utcDate, 1

    it 'should set the UTC date', () ->
      d = TzTime 2013, 1, 2, 0, 0, 0, 0, 60
      d.utcDate = 2
      equal d.date, 3

  describe '#utcDay', () ->
    it 'should return the UTC day of week', () ->
      d = TzTime 2013, 1, 2, 0, 0, 0, 0, 60
      equal d.day, 6
      equal d.utcDay, 5

  describe '#utcHours', () ->
    it 'should return the UTC hours', () ->
      d = TzTime 2013, 1, 2, 1, 0, 0, 0, 60
      equal d.hours, 1
      equal d.utcHours, 0

    it 'should set the UTC hours', () ->
      d = TzTime 2013, 1, 2, 1, 0, 0, 0, 60
      d.utcHours = 1
      equal d.hours, 2

  describe '#utcMinutes', () ->
    it 'should return the UTC minutes', () ->
      d = TzTime 2013, 1, 2, 1, 35, 0, 0, 30
      equal d.minutes, 35
      equal d.utcMinutes, 5

    it 'should set the UTC minutes', () ->
      d = TzTime 2013, 1, 2, 1, 35, 0, 0, 30
      d.utcMinutes = 15
      equal d.minutes, 45

  describe '#utcSeconds', () ->
    it 'should return the UTC seconds', () ->
      ## And yes, the UTC seconds are not differnt from normal seconds but we
      ## still need to make sure the accessor works.
      d = TzTime 2013, 1, 2, 1, 35, 7, 0, 30
      equal d.seconds, 7
      equal d.utcSeconds, 7

    it 'should set the UTC seconds', () ->
      d = TzTime 2013, 1, 2, 1, 35, 7, 0, 30
      d.utcSeconds = 12
      equal d.seconds, 12

  describe '#utcMilliseconds', () ->
    it 'should return the UTC milliseconds', () ->
      ## Again, just making sure the accessors work
      d = TzTime 2013, 1, 2, 1, 35, 7, 224, 30
      equal d.milliseconds, 224
      equal d.utcMilliseconds, 224

    it 'shoul set the UTC milliseconds', () ->
      d = TzTime 2013, 1, 2, 1, 35, 7, 224, 30
      d.utcMilliseconds = 433
      equal d.milliseconds, 433

  describe '#resetTime', () ->
    it 'should reset the time', () ->
      d = TzTime 2013, 8, 1, 12, 45, 13, 300
      equal d.hours, 12
      equal d.minutes, 45
      equal d.seconds, 13
      equal d.milliseconds, 300
      d.resetTime()
      equal d.hours, 0
      equal d.minutes, 0
      equal d.seconds, 0
      equal d.milliseconds, 0

    it 'shouold return instance', () ->
      d = TzTime 2013, 8, 1, 12, 45, 13, 300
      r = d.resetTime()
      equal r, d

