# strftime formatting tests

if require?
  chai = require 'chai'
  datetime = require '../datetime'

assert = chai.assert
equal = assert.equal

d = new TzTime(2013, 8, 1, 18, 7, 8, 200)
d1 = new TzTime(2013, 8, 1, 8, 7, 8, 200)

describe 'datetime.format', () ->
  describe 'strftime()', () ->
    it 'should return the short week day name', () ->
      equal d.strftime('%a'), 'Sun'

    it 'should return the long week day name', () ->
      equal d.strftime('%A'), 'Sunday'

    it 'should return the short month name', () ->
      equal d.strftime('%b'), 'Sep'

    it 'should return the long month name', () ->
      equal d.strftime('%B'), 'September'

    it 'should return the zero-padded date', () ->
      equal d.strftime('%d'), '01'

    it 'should return the non-padded date', () ->
      equal d.strftime('%D'), '1'

    it 'should return zero-padded seconds with fraction', () ->
      equal d.strftime('%f'), '08.20'

    it 'should return zero-padded hours in 24-hour format', () ->
      equal d.strftime('%H'), '18'

    it 'should return non-padded hours in 12-hour format', () ->
      equal d.strftime('%i'), '6'

    it 'should return zero-padded hours in 12-hour format', () ->
      equal d.strftime('%I'), '06'

    it 'should return zer-padded day of year', () ->
      equal d.strftime('%j'), '244'

    it 'should return zero-padded numeric month', () ->
      equal d.strftime('%m'), '09'

    it 'should return zero-padded minutes', () ->
      equal d.strftime('%M'), '07'

    it 'should return non-padded month', () ->
      equal d.strftime('%n'), '9'

    it 'should return non-padded minutes', () ->
      equal d.strftime('%N'), '7'

    it 'should return PM', () ->
      equal d.strftime('%p'), 'p.m.'

    it 'should return AM', () ->
      d.setHours 9
      equal d.strftime('%p'), 'a.m.'
      d.setHours 18

    it 'should return non-padded seconds', () ->
      equal d.strftime('%s'), '8'

    it 'should return padded seconds', () ->
      equal d.strftime('%S'), '08'

    it 'should return miliseconds', () ->
      equal d.strftime('%r'), '200'

    it 'should return numeric weed day', () ->
      equal d.strftime('%w'), '0'

    it 'should return year without century', () ->
      equal d.strftime('%y'), '13'

    it 'should return full year', () ->
      equal d.strftime('%Y'), '2013'

    it 'should return timezone', () ->
      # We must mock the timezone method
      originalTz = d.timezone
      d.timezone = 120
      equal d.strftime('%z'), '+0200'
      d.timezone = -360
      equal d.strftime('%z'), '-0600'
      d.timezone = originalTz

    it 'should return literal percent', () ->
      equal d.strftime('%%'), '%'

    it 'should retain non-formatting character', () ->
      f = d.strftime('The year is %Y, around %i %p on %B %D')
      equal f, "The year is 2013, around 6 p.m. on September 1"

