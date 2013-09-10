root = this

if require?
  chai = require 'chai'
  TzTime = require '../tztime'

assert = chai.assert

describe 'TzTime', () ->

  describe 'constrcutor', () ->
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
      d1 = new TzTime 2013, 8, 1
      d2 = TzTime 2013, 8, 1
      assert.equal d1.getTime(), d2.getTime()

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

