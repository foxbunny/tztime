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

