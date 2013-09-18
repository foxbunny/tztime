# # Test for datetime.dtdelta

if require?
  chai = require 'chai'
  TzTime = require '../tztime'

if not GLOBAL?
  root = this
else
  root = GLOBAL

assert = chai.assert
isok = assert.ok
notOk = assert.notOk
equal = assert.equal

hasProp = (obj, prop, msg) ->
  isok obj.hasOwnProperty(prop), msg

describe 'TzTime', () ->
  describe '#delta', () ->
    it 'should return an object with required properties', () ->
      d1 = d2 = new TzTime()
      delta = d1.delta d2
      hasProp delta, 'delta', 'missing `delta`'
      hasProp delta, 'milliseconds', 'missing `milliseconds`'
      hasProp delta, 'seconds', 'missing `seconds`'
      hasProp delta, 'minutes', 'missing `minutes`'
      hasProp delta, 'hours', 'missing `hours`'
      hasProp delta, 'composite', 'missing `composite`'

    it 'should return 0 if dates are equal', () ->
      d1 = d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.delta, 0

    it 'should return difference in milliseconds', () ->
      d1 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 10
      delta = d1.delta d2
      equal delta.delta, 10

    it 'can return negative delta if d2 is before d1', () ->
      d1 = new TzTime 2013, 8, 1, 12, 0, 0, 10
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.delta, -10

    it 'returns absolute delta in milliseconds', () ->
      d1 = new TzTime 2013, 8, 1, 12, 0, 0, 10
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.milliseconds, 10

    it 'returns absolute delta in seconds', () ->
      d1 = new TzTime 2013, 8, 1, 12, 0, 2, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.seconds, 2

    it 'rounds delta in seconds up', () ->
      d1 = new TzTime 2013, 8, 1, 12, 0, 2, 1
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.seconds, 3

    it 'should express seconds in milliseconds as well', () ->
      d1 = new TzTime 2013, 8, 1, 12, 0, 2, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.milliseconds, 2 * 1000

    it 'returns absolute delta in minutes', () ->
      d1 = new TzTime 2013, 8, 1, 12, 2, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.minutes, 2

    it 'rounds delta in minutes up', () ->
      d1 = new TzTime 2013, 8, 1, 12, 2, 0, 1
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.minutes, 3

    it 'should express minutes in seconds as well', () ->
      d1 = new TzTime 2013, 8, 1, 12, 2, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.seconds, 2 * 60

    it 'should express minutes in milliseconds as well', () ->
      d1 = new TzTime 2013, 8, 1, 12, 2, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.milliseconds, 2 * 60 * 1000

    it 'returns absolute delta in hours', () ->
      d1 = new TzTime 2013, 8, 1, 13, 0, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.hours, 1

    it 'rounds delta in hours up', () ->
      d1 = new TzTime 2013, 8, 1, 13, 0, 0, 1
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.hours, 2

    it 'should express hours in minutes as well', () ->
      d1 = new TzTime 2013, 8, 1, 13, 0, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.minutes, 60

    it 'should express hours in seconds as well', () ->
      d1 = new TzTime 2013, 8, 1, 13, 0, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.seconds, 60 * 60

    it 'should express hours in milliseconds as well', () ->
      d1 = new TzTime 2013, 8, 1, 13, 0, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.milliseconds, 60 * 60 * 1000

    it 'returns absolute delta in days', () ->
      d1 = new TzTime 2013, 8, 3, 12, 0, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.days, 2

    it 'rounds delta in days up', () ->
      d1 = new TzTime 2013, 8, 3, 12, 0, 0, 1
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.days, 3

    it 'should express days in hours as well', () ->
      d1 = new TzTime 2013, 8, 3, 12, 0, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.hours, 2 * 24

    it 'should express days in minutes as well', () ->
      d1 = new TzTime 2013, 8, 3, 12, 0, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.minutes, 2 * 24 * 60

    it 'should express days in seconds as well', () ->
      d1 = new TzTime 2013, 8, 3, 12, 0, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.seconds, 2 * 24 * 60 * 60

    it 'should express days in milliseconds as well', () ->
      d1 = new TzTime 2013, 8, 3, 12, 0, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.milliseconds, 2 * 24 * 60 * 60 * 1000

    it 'should give a composite delta', () ->
      d1 = new TzTime 2013, 8, 3, 12, 0, 0, 0
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.composite[0], 2  # days
      equal delta.composite[1], 0  # hours
      equal delta.composite[2], 0  # minutes
      equal delta.composite[3], 0  # seconds
      equal delta.composite[4], 0  # milliseconds

    it 'should give a composite delta with all values', () ->
      d1 = new TzTime 2013, 8, 3, 13, 1, 1, 1
      d2 = new TzTime 2013, 8, 1, 12, 0, 0, 0
      delta = d1.delta d2
      equal delta.composite[0], 2, 'days'
      equal delta.composite[1], 1, 'hours'
      equal delta.composite[2], 1, 'minutes'
      equal delta.composite[3], 1, 'seconds'
      # We do not compare milliseconds due to rounding errors

  describe 'TzTime.reorder', () ->
    it 'should return ordered dates', () ->
      d1 = new TzTime 2013, 8, 1
      d2 = new TzTime 2013, 8, 2
      d3 = new TzTime 2013, 8, 3
      sorted = TzTime.reorder d3, d1, d2
      equal d1, sorted[0]
      equal d2, sorted[1]
      equal d3, sorted[2]

  describe '#isBefore', () ->
    it 'should basically work :)', () ->
      old = new TzTime 2013, 8, 1, 12, 0, 0, 0
      neu = new TzTime 2013, 8, 1, 12, 1, 0, 0
      isok old.isBefore neu
      notOk neu.isBefore old

    it 'should return false when dates are equal', () ->
      old = neu = new TzTime 2013, 8, 1, 12, 0, 0, 0
      notOk old.isBefore neu
      notOk neu.isBefore old

  describe '#isAfter', () ->
    it 'should basically work... again', () ->
      old = new TzTime 2013, 8, 1, 12, 0, 0, 0
      neu = new TzTime 2013, 8, 1, 12, 1, 0, 0
      notOk old.isAfter old
      isok neu.isAfter old

    it 'should return false if dates are equal', () ->
      old = neu = new TzTime 2013, 8, 1, 12, 0, 0, 0
      notOk old.isAfter neu
      notOk neu.isAfter old

  describe '#isBetwen', () ->
    it 'should return true when date is between two dates', () ->
      d1 = new TzTime 2013, 8, 1
      d2 = new TzTime 2013, 8, 2
      d3 = new TzTime 2013, 8, 3
      isok d2.isBetween d1, d3

    it "should't care about order of the two extremes", () ->
      d1 = new TzTime 2013, 8, 1
      d2 = new TzTime 2013, 8, 2
      d3 = new TzTime 2013, 8, 3
      isok d2.isBetween d3, d1

    it "should return false if middle date matches an extereme", () ->
      d1 = new TzTime 2013, 8, 1
      d2 = d3 = new TzTime 2013, 8, 2
      notOk d2.isBetween d1, d3

    it "should return false if date is outside extremes", () ->
      d1 = new TzTime 2013, 8, 1
      d2 = new TzTime 2013, 8, 2
      d3 = new TzTime 2013, 8, 3
      notOk d1.isBetween d2, d3

  describe '#isDateBefore', () ->
    it 'should return false if only times differ', () ->
      old = new TzTime 2013, 8, 1, 5
      neu = new TzTime 2013, 8, 1, 12
      notOk old.isDateBefore neu
      notOk neu.isDateBefore old

    it 'should return false if if date is after', () ->
      old = new TzTime 2013, 8, 1
      neu = new TzTime 2013, 8, 2
      notOk neu.isDateBefore old

    it 'should return true if date is before', () ->
      old = new TzTime 2013, 8, 1
      neu = new TzTime 2013, 8, 2
      isok old.isDateBefore neu

  describe '#isDateAfter', () ->
    it 'should return false if only times differ', () ->
      old = new TzTime 2013, 8, 1, 5
      neu = new TzTime 2013, 8, 1, 12
      notOk neu.isDateAfter old
      notOk old.isDateAfter neu

    it 'should return false if date is before', () ->
      old = new TzTime 2013, 8, 1
      neu = new TzTime 2013, 8, 2
      notOk old.isDateAfter neu

    it 'should return true if date is after', () ->
      old = new TzTime 2013, 8, 1
      neu = new TzTime 2013, 8, 2
      isok neu.isDateAfter old

  describe '#isDateBetween', () ->
    it 'should return false if only times differ', () ->
      d1 = new TzTime 2013, 8, 1, 5
      d2 = new TzTime 2013, 8, 1, 12
      d3 = new TzTime 2013, 8, 1, 18
      notOk d2.isDateBetween d1, d3
      notOk d2.isDateBetween d3, d1

    it 'should return true if between by date', () ->
      d1 = new TzTime 2013, 8, 1
      d2 = new TzTime 2013, 8, 2
      d3 = new TzTime 2013, 8, 3
      isok d2.isBetween d1, d3

    it 'should not care about the order of arguments', () ->
      d1 = new TzTime 2013, 8, 1
      d2 = new TzTime 2013, 8, 2
      d3 = new TzTime 2013, 8, 3
      isok d2.isBetween d3, d1

    it 'should return false if one of the extreme is same time', () ->
      d1 = new TzTime 2013, 8, 1
      d2 = d3 = new TzTime 2013, 8, 2
      notOk d2.isBetween d3, d1

    it 'should return false if outside the range', () ->
      d1 = new TzTime 2013, 8, 1
      d2 = new TzTime 2013, 8, 2
      d3 = new TzTime 2013, 8, 3
      notOk d1.isBetween d2, d3


