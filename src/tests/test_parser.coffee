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
    equal d.getSeconds(), 1
    equal d.getMilliseconds(), 120

