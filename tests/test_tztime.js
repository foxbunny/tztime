// Generated by CoffeeScript 1.6.3
var TzTime, assert, chai, root;

root = this;

if (typeof require !== "undefined" && require !== null) {
  chai = require('chai');
  TzTime = require('../tztime');
}

assert = chai.assert;

describe('TzTime', function() {
  describe('constrcutor', function() {
    it('should be identical to Date constructor', function() {
      var d1, d2;
      d1 = new TzTime(2013, 8, 1);
      d2 = new Date(2013, 8, 1);
      return assert.equal(d1.getTime(), d2.getTime());
    });
    it('should have a constructor of TzTime', function() {
      var d;
      d = new TzTime(2013, 8, 1);
      return assert.equal(d.constructor, TzTime);
    });
    it('should be an instance of TzTime', function() {
      var d;
      d = new TzTime(2013, 8, 1);
      return assert.ok(d instanceof TzTime);
    });
    it('should also be an instance of Date', function() {
      var d;
      d = new TzTime(2013, 8, 1);
      return assert.ok(d instanceof Date);
    });
    return it('should be usable withough the new keyword', function() {
      var d1, d2;
      d1 = new TzTime(2013, 8, 1);
      d2 = TzTime(2013, 8, 1);
      return assert.equal(d1.getTime(), d2.getTime());
    });
  });
  describe('#timezone', function() {
    it('is a number', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      return assert.equal(typeof d.timezone, 'number');
    });
    it('should be opposite of #getTimezoneOffset()', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      return assert.equal(d.getTimezoneOffset() + d.timezone, 0);
    });
    it('can be set by assigning', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.timezone = 12;
      assert.equal(d.getTimezoneOffset() + d.timezone, 0);
      return assert.equal(d.getTimezoneOffset(), -12);
    });
    it('should shift the time when set', function() {
      var d, h1, h2;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.timezone = 0;
      h1 = d.getHours();
      d.timezone = 60;
      h2 = d.getHours();
      return assert.equal(h1 + 1, h2);
    });
    it('will convert floats to integers', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.timezone = 120.4;
      return assert.equal(d.timezone, 120);
    });
    return it('can be set using -= and += operators', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.timezone = 0;
      d.timezone += 12;
      return assert.equal(d.timezone, 12);
    });
  });
  describe('#getTimezoneOffset()', function() {
    return it('should return the opposite of time zone offset', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.timezone = 12;
      return assert.equal(d.getTimezoneOffset(), -12);
    });
  });
  describe('#setTimezoneOffset()', function() {
    return it('should set the timezone using opposite of offset', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.timezone = 0;
      d.setTimezoneOffset(12);
      return assert.equal(d.timezone, -12);
    });
  });
  describe('#setFullYear()', function() {
    it('should set the year and return instance', function() {
      var d, d1;
      d = new TzTime(2013, 8, 1, 8, 20);
      d1 = d.setFullYear(2020);
      assert.equal(d1, d);
      return assert.equal(d.getFullYear(), 2020);
    });
    return it('should set mont and date if passed', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.setFullYear(2015, 2, 12);
      assert.equal(d.getFullYear(), 2015);
      assert.equal(d.getMonth(), 2);
      return assert.equal(d.getDate(), 12);
    });
  });
  describe('#year', function() {
    it('should set year', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.year = 2020;
      return assert.equal(d.getFullYear(), 2020);
    });
    it('should return year', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      return assert.equal(d.year, 2013);
    });
    return it('can be used with -= and += operators', function() {
      var d, y1, y2;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.year -= 2;
      y1 = d.year;
      d.year += 4;
      y2 = d.year;
      assert.equal(y1, 2011);
      return assert.equal(y2, 2015);
    });
  });
  describe('#setMonth()', function() {
    it('should set month and return instance', function() {
      var d, d1;
      d = new TzTime(2013, 8, 1, 8, 20);
      d1 = d.setMonth(9);
      assert.equal(d.getMonth(), 9);
      return assert.equal(d1, d);
    });
    return it('should set both month and date if passed both', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.setMonth(9, 12);
      assert.equal(d.getMonth(), 9);
      return assert.equal(d.getDate(), 12);
    });
  });
  return describe('#month', function() {
    it('should set month', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.month = 9;
      return assert.equal(d.getMonth(), 9);
    });
    it('should return month', function() {
      var d;
      d = new TzTime(2013, 8, 1, 8, 20);
      return assert.equal(d.month, 8);
    });
    it('can be used with -= and += operators', function() {
      var d, m1, m2;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.month -= 2;
      m1 = d.month;
      d.month += 4;
      m2 = d.month;
      assert.equal(m1, 6);
      return assert.equal(m2, 10);
    });
    return it('should adjust the year when incremented or decremented', function() {
      var d, y1, y2;
      d = new TzTime(2013, 8, 1, 8, 20);
      d.month -= 12;
      y1 = d.year;
      d.month += 24;
      y2 = d.year;
      assert.equal(y1, 2012);
      return assert.equal(y2, 2014);
    });
  });
});
