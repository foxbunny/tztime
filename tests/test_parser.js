// Generated by CoffeeScript 1.6.3
var TzTime, assert, chai, equal;

if (typeof require !== "undefined" && require !== null) {
  chai = require('chai');
  TzTime = require('../tztime');
}

assert = chai.assert;

equal = assert.equal;

describe('TzTime.parse', function() {
  it('should return null when input is bogus', function() {
    var d;
    d = TzTime.parse('bogus input', '%Y-%m-%d');
    return equal(d, null);
  });
  it('should parse full month name', function() {
    var d, idx, month, _i, _len, _ref, _results;
    _ref = TzTime.MONTHS;
    _results = [];
    for (idx = _i = 0, _len = _ref.length; _i < _len; idx = ++_i) {
      month = _ref[idx];
      d = TzTime.parse("" + month + " 1 2013", '%B %D %Y');
      _results.push(equal(d.getMonth(), idx));
    }
    return _results;
  });
  it('should parse full month case insensitively', function() {
    var d, idx, month, _i, _len, _ref, _results;
    _ref = TzTime.MONTHS;
    _results = [];
    for (idx = _i = 0, _len = _ref.length; _i < _len; idx = ++_i) {
      month = _ref[idx];
      d = TzTime.parse("" + (month.toLowerCase()) + " 1 2013", '%B %D %Y');
      _results.push(equal(d.getMonth(), idx));
    }
    return _results;
  });
  it('should parse short month name', function() {
    var d, idx, month, _i, _len, _ref, _results;
    _ref = TzTime.MNTH;
    _results = [];
    for (idx = _i = 0, _len = _ref.length; _i < _len; idx = ++_i) {
      month = _ref[idx];
      d = TzTime.parse("" + month + " 1 2013", '%b %D %Y');
      _results.push(equal(d.getMonth(), idx));
    }
    return _results;
  });
  it('should parse short month names case insensitively', function() {
    var d, idx, month, _i, _len, _ref, _results;
    _ref = TzTime.MNTH;
    _results = [];
    for (idx = _i = 0, _len = _ref.length; _i < _len; idx = ++_i) {
      month = _ref[idx];
      d = TzTime.parse("" + (month.toLowerCase()) + " 1 2013", '%b %D %Y');
      _results.push(equal(d.getMonth(), idx));
    }
    return _results;
  });
  it('should parse decimal seconds', function() {
    var d;
    d = TzTime.parse('2013-12-01 12:00:01.12', '%Y-%m-%d %H:%M:%f');
    equal(d.year, 2013, 'year must match');
    equal(d.month, 11, 'month must match');
    equal(d.date, 1, 'date must match');
    equal(d.hours, 12, 'hours must match');
    equal(d.minutes, 0, 'minutes must match');
    equal(d.seconds, 1, 'seconds must match');
    return equal(d.milliseconds, 120, 'milliseconds must match');
  });
  it('should parse decimal seconds with 3-digit fraction', function() {
    var d;
    d = TzTime.parse('2013-12-01T12:00:01.221', '%Y-%m-%dT%H:%M:%F');
    equal(d.year, 2013, 'year must match');
    equal(d.month, 11, 'month must match');
    equal(d.date, 1, 'date must match');
    equal(d.hours, 12, 'hours must match');
    equal(d.minutes, 0, 'minutes must match');
    equal(d.seconds, 1, 'seconds must match');
    return equal(d.milliseconds, 221, 'milliseconds must match');
  });
  it('should parse json timestamp correctly', function() {
    var d;
    d = TzTime.parse('2013-12-01T12:00:01.221Z', '%Y-%m-%dT%H:%M:%F%z');
    equal(d.timezone, 0, 'timezone must be in UTC');
    equal(d.year, 2013, 'year must match');
    equal(d.month, 11, 'month must match');
    equal(d.date, 1, 'date must match');
    equal(d.hours, 12, 'hours must match');
    equal(d.minutes, 0, 'minutes must match');
    equal(d.seconds, 1, 'seconds must match');
    return equal(d.milliseconds, 221, 'milliseconds must match');
  });
  return it('should parse AM/PM correctly', function() {
    var d;
    d = TzTime.parse('2013-12-01 12:00 p.m.', '%Y-%m-%d %i:%M %p');
    equal(d.year, 2013, 'year must match');
    equal(d.month, 11, 'month must match');
    equal(d.date, 1, 'date must match');
    equal(d.hours, 12, 'hours must match');
    equal(d.minutes, 0, 'minutes must match');
    d = TzTime.parse('2013-12-01 12:00 a.m.', '%Y-%m-%d %i:%M %p');
    equal(d.year, 2013, 'year must match');
    equal(d.month, 11, 'month must match');
    equal(d.date, 1, 'date must match');
    equal(d.hours, 0, 'hours must match');
    return equal(d.minutes, 0, 'minutes must match');
  });
});

describe('TzTime.fromJSON', function() {
  return it('should parse a JSON-generated string', function() {
    var d, d1, s, s1;
    d = TzTime(2013, 11, 1, 12, 45, 11, 233, 0);
    s = JSON.stringify(d);
    equal(s, '"2013-12-01T12:45:11.233Z"');
    s1 = JSON.parse(s);
    equal(s1, '2013-12-01T12:45:11.233Z');
    d1 = TzTime.fromJSON(s1);
    equal(d1.year, 2013);
    equal(d1.month, 11);
    equal(d1.date, 1);
    equal(d1.hours, 12);
    equal(d1.minutes, 45);
    equal(d1.seconds, 11);
    equal(d1.milliseconds, 233);
    equal(d1.timezone, 0);
    return equal(d1 - d, 0);
  });
});
