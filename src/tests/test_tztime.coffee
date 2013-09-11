root = this

if require?
  chai = require 'chai'
  TzTime = require '../tztime'

assert = chai.assert

describe 'TzTime', () ->

  describe 'constructor', () ->
    it 'should be identical to Date constructor', () ->
      d1 = new TzTime 2013, 8, 1
      d2 = new Date 2013, 8, 1
      assert.equal d1.getTime(), d2.getTime()

    it 'should have a constructor of TzTime', () ->
      d = new TzTime 2013, 8, 1
      assert.equal d.constructor, TzTime

    it 'should be an instance of TzTime', () ->
      d = new TzTime 2013, 8, 1
      assert.ok d instanceof TzTime

    it 'should also be an instance of Date', () ->
      d = new TzTime 2013, 8, 1
      assert.ok d instanceof Date

    it 'should be usable withough the new keyword', () ->
      d = TzTime 2013, 8, 1
      assert.equal typeof d, 'object'
      assert.equal d.constructor, TzTime
      assert.ok d instanceof TzTime
      assert.ok d instanceof Date

      d1 = new TzTime 2013, 8, 1
      assert.equal d.getTime(), d1.getTime()

    it 'should accept the timezone as last argument', () ->
      d = new TzTime 2013, 8, 1, 12, 45, 39, 0, 360
      assert.equal d.timezone, 360

    it 'should create a new instance if passed Date or TzTime obj', () ->
      d1 = new Date 2013, 8, 1
      d2 = new TzTime 2013, 8, 1
      d3 = new TzTime d1
      d4 = new TzTime d2
      assert.notEqual d1, d2
      assert.notEqual d1, d3
      assert.notEqual d1, d4
      assert.notEqual d2, d3
      assert.notEqual d2, d4
      assert.notEqual d3, d4
      assert.equal d1.getTime(), d2.getTime()
      assert.equal d1.getTime(), d3.getTime()
      assert.equal d1.getTime(), d4.getTime()

  describe '#timezone', () ->
    it 'is a number', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      assert.equal typeof d.timezone, 'number'

    it 'should be opposite of #getTimezoneOffset()', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      assert.equal d.getTimezoneOffset() + d.timezone, 0

    it 'can be set by assigning', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d.timezone = 12
      assert.equal d.getTimezoneOffset() + d.timezone, 0
      assert.equal d.getTimezoneOffset(), -12

    it 'should shift the time when set', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d.timezone = 0
      h1 = d.getHours()
      d.timezone = 60
      h2 = d.getHours()
      assert.equal h1 + 1, h2

    it 'will convert floats to integers', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d.timezone = 120.4
      assert.equal d.timezone, 120

    it 'can be set using -= and += operators', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d.timezone = 0
      d.timezone += 12
      assert.equal d.timezone, 12

    it 'should be UTC time if set to 0', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d.timezone = 0
      d.setHours 8
      assert.equal d.getUTCHours(), 8
      assert.equal d.getHours(), 8

  describe '#getTimezoneOffset()', () ->
    it 'should return the opposite of time zone offset', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d.timezone = 12
      assert.equal d.getTimezoneOffset(), -12

  describe '#setTimezoneOffset()', () ->
    it 'should set the timezone using opposite of offset', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d.timezone = 0
      d.setTimezoneOffset 12
      assert.equal d.timezone, -12

  describe '#setFullYear()', () ->
    it 'should set the year and return instance', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d1 = d.setFullYear 2020
      assert.equal d1, d
      assert.equal d.getFullYear(), 2020

    it 'should set mont and date if passed', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d.setFullYear 2015, 2, 12
      assert.equal d.getFullYear(), 2015
      assert.equal d.getMonth(), 2
      assert.equal d.getDate(), 12

  describe '#setMonth()', () ->
    it 'should set month and return instance', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d1 = d.setMonth 9
      assert.equal d.getMonth(), 9
      assert.equal d1, d

    it 'should set both month and date if passed both', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d.setMonth 9, 12
      assert.equal d.getMonth(), 9
      assert.equal d.getDate(), 12

  describe '#setDate()', () ->
    it 'should set the date and return instance', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d1 = d.setDate 2
      assert.equal d.getDate(), 2
      assert.equal d1, d

  describe '#setHours()', () ->
    it 'should set hours and return instance', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d1 = d.setHours 2
      assert.equal d.getHours(), 2
      assert.equal d1, d

    it 'should set minutes, seconds, and milliseconds if given', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.setHours 2, 2, 2, 2
      assert.equal d.getHours(), 2
      assert.equal d.getMinutes(), 2
      assert.equal d.getSeconds(), 2
      assert.equal d.getMilliseconds(), 2

  describe '#setMinutes()', () ->
    it 'should set minutes and return instance', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d1 = d.setMinutes 2
      assert.equal d.getMinutes(), 2
      assert.equal d1, d

    it 'should set seconds and milliseconds if given', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.setMinutes 2, 2, 2
      assert.equal d.getMinutes(), 2
      assert.equal d.getSeconds(), 2
      assert.equal d.getMilliseconds(), 2

  describe '#setSeconds()', () ->
    it 'should set seconds and return instance', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      d1 = d.setSeconds 2
      assert.equal d.getSeconds(), 2
      assert.equal d1, d

    it 'should set milliseconds if given', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.setSeconds 2, 2
      assert.equal d.getSeconds(), 2
      assert.equal d.getMilliseconds(), 2

  describe '#setMilliseconds()', () ->
    it 'should set milliseconds and return instance', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d1 = d.setMilliseconds 2
      assert.equal d.getMilliseconds(), 2
      assert.equal d1, d

  describe '#getHours()', () ->
    it 'should give time in instance timezone', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      assert.equal d.getHours(), 8
      d.timezone += 120
      assert.equal d.getHours(), 10
      d.timezone -= 300
      assert.equal d.getHours(), 5

  describe '#year', () ->
    it 'should set year', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.year = 2020
      assert.equal d.getFullYear(), 2020

    it 'should return year', () ->
      d = new TzTime 2013, 8, 1, 8, 20
      assert.equal d.year, 2013

    it 'can be used with -= and += operators', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.year -= 2
      y1 = d.year
      d.year += 4
      y2 = d.year
      assert.equal y1, 2011
      assert.equal y2, 2015

  describe '#month', () ->
    it 'should set month', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.month = 9
      assert.equal d.getMonth(), 9

    it 'should return month', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      assert.equal d.month, 8

    it 'can be used with -= and += operators', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.month -= 2
      m1 = d.month
      d.month += 4
      m2 = d.month
      assert.equal m1, 6
      assert.equal m2, 10

    it 'should adjust the year when incremented or decremented', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.month -= 12
      y1 = d.year
      d.month += 24
      y2 = d.year
      assert.equal y1, 2012
      assert.equal y2, 2014

  describe '#date', () ->
    it 'should set the date', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.date = 20
      assert.equal d.getDate(), 20

    it 'should return the date', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      assert.equal d.date, 1

    it 'can be used with -= and += operators', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.date += 12
      d1 = d.date
      d.date -= 4
      d2 = d.date
      assert.equal d1, 13
      assert.equal d2, 9

    it 'should cross month boundaries when setting', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.date += 31
      m1 = d.month
      d.date -= 62
      m2 = d.month
      assert.equal m1, 9
      assert.equal m2, 7

    it 'should cross year boundaries when setting', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.date += 365
      y1 = d.year
      d.date -= 2 * 365
      y2 = d.year
      assert.equal y1, 2014
      assert.equal y2, 2012

  describe '#hours', () ->
    it 'should set the hour', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.hours = 2
      assert.equal d.getHours(), 2

    it 'should return hour', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      assert.equal d.hours, 8

    it 'can be used with -= and += operators', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.hours -= 4
      h1 = d.hours
      d.hours += 12
      h2 = d.hours
      assert.equal h1, 4
      assert.equal h2, 16

    it 'should cross date boundaries', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.hours += 20
      assert.equal d.date, 2

    it 'should cross month boundaries', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.hours += 24 * 31
      assert.equal d.month, 9

    it 'should cross year boundaries', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.hours += 24 * 365
      assert.equal d.year, 2014

  describe '#minutes', () ->
    it 'should set minute', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.minutes = 21
      assert.equal d.getMinutes(), 21

    it 'should return minute', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      assert.equal d.minutes, 20

    it 'can be used with -= and += operators', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.minutes -= 15
      m1 = d.minutes
      d.minutes += 20
      m2 = d.minutes
      assert.equal m1, 5
      assert.equal m2, 25

    it 'should cross hour boundary', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.minutes += 50
      assert.equal d.hours, 9

    it 'should cross date boundary', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.minutes += 60 * 24
      assert.equal d.date, 2

    it 'should cross month boundary', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.minutes += 60 * 24 * 31
      assert.equal d.month, 9

    it 'should cross year boundary', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.minutes += 60 * 24 * 365
      assert.equal d.year, 2014

  describe '#seconds', () ->
    it 'should set seconds', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds = 21
      assert.equal d.getSeconds(), 21

    it 'should return seconds', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      assert.equal d.seconds, 1

    it 'can be used with -= and += operators', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds += 20
      s1 = d.seconds
      d.seconds -= 5
      s2 = d.seconds
      assert.equal s1, 21
      assert.equal s2, 16

    it 'should cross minutes boundary', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds += 60
      assert.equal d.minutes, 21

    it 'should cross hours boundary', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds += 60 * 60
      assert.equal d.hours, 9

    it 'should cross date boundary', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds += 60 * 60 * 24
      assert.equal d.date, 2

    it 'should cross month boundary', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds += 60 * 60 * 24 * 31
      assert.equal d.month, 9

    it 'should cross year boundary', () ->
      d = new TzTime 2013, 8, 1, 8, 20, 1, 500
      d.seconds += 60 * 60 * 24 * 365
      assert.equal d.year, 2014

