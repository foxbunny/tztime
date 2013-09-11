root = this

if require?
  chai = require 'chai'
  TzTime = require '../tztime'

assert = chai.assert
{repeat, reverse, pad, cycle, hour24} = TzTime.utils

describe 'TzTime.utils', () ->

  describe '#repeat()', () ->
    it 'should repeat a string', () ->
      assert.equal repeat('#', 5), '#####'

    it 'should return an empty string if length is 0', () ->
      assert.equal repeat('#', 0), ''

    it 'should return empty string if string arg is empty', () ->
      assert.equal repeat('', 5), ''

  describe '#reverse()', () ->
    it 'should reverse a string', () ->
      assert.equal reverse('esrever'), 'reverse'

  describe '#pad()', () ->
    it 'should zero-pad a number', () ->
      assert.equal pad(12), '012'

    it 'should pad with number of digits specified', () ->
      assert.equal pad(12, 5), '00012'

    it 'should pad floats', () ->
      assert.equal pad(12.5, 5), '012.5'

    it 'should pad the decimal places if tail is specified', () ->
      assert.equal pad(12.5, 5, 2), '00012.50'

    it 'should simply omit decimals if tail is 0', () ->
      assert.equal pad(12.5, 5, 0), '00012'

    it 'should pad only the decimals if digits is 0', () ->
      assert.equal pad(12.5, 0, 2), '12.50'

    it 'should truncate', () ->
      assert.equal pad(12.5112, 1, 1), '2.5'

  describe '#cycle()', () ->
    it 'should wrap the number within a given range', () ->
      assert.equal cycle(18, 12), 6

    it 'should wrap with zero index if told to', () ->
      assert.equal cycle(24, 12), 12
      assert.equal cycle(24, 12, true), 0

  describe '#hour24', () ->
    it 'should convert 12-hour format hours to 24-hour format', () ->
      for i in [1..11]
        assert.equal hour24(i), i

      assert.equal hour24(12), 0, hour24(12)  # 12 am

      for i in [1..11]
        assert.equal hour24(i, true), i + 12

      assert.equal hour24(12, true), 12  # 12 pm
