# toFormat formatting tests

if require?
  chai = require 'chai'
  TzTime = require '../tztime'

assert = chai.assert
equal = assert.equal

d = new TzTime(2013, 8, 1, 18, 7, 8, 200)
d1 = new TzTime(2013, 8, 1, 8, 7, 8, 200)

describe 'TzTime', () ->
  describe 'tpFormat()', () ->
    it 'should return the short week day name', () ->
      equal d.toFormat('%a'), 'Sun'

    it 'should return the long week day name', () ->
      equal d.toFormat('%A'), 'Sunday'

    it 'should return the short month name', () ->
      equal d.toFormat('%b'), 'Sep'

    it 'should return the long month name', () ->
      equal d.toFormat('%B'), 'September'

    it 'should return the zero-padded date', () ->
      equal d.toFormat('%d'), '01'

    it 'should return the non-padded date', () ->
      equal d.toFormat('%D'), '1'

    it 'should return zero-padded seconds with fraction', () ->
      equal d.toFormat('%f'), '08.20'

    it 'should return zero-padded hours in 24-hour format', () ->
      equal d.toFormat('%H'), '18'

    it 'should return non-padded hours in 12-hour format', () ->
      equal d.toFormat('%i'), '6'

    it 'should return zero-padded hours in 12-hour format', () ->
      equal d.toFormat('%I'), '06'

    it 'should return zer-padded day of year', () ->
      equal d.toFormat('%j'), '244'

    it 'should return zero-padded numeric month', () ->
      equal d.toFormat('%m'), '09'

    it 'should return zero-padded minutes', () ->
      equal d.toFormat('%M'), '07'

    it 'should return non-padded month', () ->
      equal d.toFormat('%n'), '9'

    it 'should return non-padded minutes', () ->
      equal d.toFormat('%N'), '7'

    it 'should return PM', () ->
      equal d.toFormat('%p'), 'p.m.'

    it 'should return AM', () ->
      d.setHours 9
      equal d.toFormat('%p'), 'a.m.'
      d.setHours 18

    it 'should return non-padded seconds', () ->
      equal d.toFormat('%s'), '8'

    it 'should return padded seconds', () ->
      equal d.toFormat('%S'), '08'

    it 'should return miliseconds', () ->
      equal d.toFormat('%r'), '200'

    it 'should return numeric weed day', () ->
      equal d.toFormat('%w'), '0'

    it 'should return year without century', () ->
      equal d.toFormat('%y'), '13'

    it 'should return full year', () ->
      equal d.toFormat('%Y'), '2013'

    it 'should return timezone', () ->
      # We must mock the timezone method
      originalTz = d.timezone
      d.timezone = 120
      equal d.toFormat('%z'), '+0200'
      d.timezone = -360
      equal d.toFormat('%z'), '-0600'
      d.timezone = originalTz

    it 'should return literal percent', () ->
      equal d.toFormat('%%'), '%'

    it 'should retain non-formatting character', () ->
      f = d.toFormat('The year is %Y, around %i %p on %B %D')
      equal f, "The year is 2013, around 6 p.m. on September 1"

