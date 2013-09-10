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



