// Generated by CoffeeScript 1.6.3
var TzTime, assert, chai, d, d1, equal;

if (typeof require !== "undefined" && require !== null) {
  chai = require('chai');
  TzTime = require('../tztime');
}

assert = chai.assert;

equal = assert.equal;

d = new TzTime(2013, 8, 1, 18, 7, 8, 200);

d1 = new TzTime(2013, 8, 1, 8, 7, 8, 200);

describe('TzTime', function() {
  return describe('tpFormat()', function() {
    it('should return the short week day name', function() {
      return equal(d.toFormat('%a'), 'Sun');
    });
    it('should return the long week day name', function() {
      return equal(d.toFormat('%A'), 'Sunday');
    });
    it('should return the short month name', function() {
      return equal(d.toFormat('%b'), 'Sep');
    });
    it('should return the long month name', function() {
      return equal(d.toFormat('%B'), 'September');
    });
    it('should return the zero-padded date', function() {
      return equal(d.toFormat('%d'), '01');
    });
    it('should return the non-padded date', function() {
      return equal(d.toFormat('%D'), '1');
    });
    it('should return zero-padded seconds with fraction', function() {
      return equal(d.toFormat('%f'), '08.20');
    });
    it('should return zero-padded hours in 24-hour format', function() {
      return equal(d.toFormat('%H'), '18');
    });
    it('should return non-padded hours in 12-hour format', function() {
      return equal(d.toFormat('%i'), '6');
    });
    it('should return zero-padded hours in 12-hour format', function() {
      return equal(d.toFormat('%I'), '06');
    });
    it('should return zer-padded day of year', function() {
      return equal(d.toFormat('%j'), '244');
    });
    it('should return zero-padded numeric month', function() {
      return equal(d.toFormat('%m'), '09');
    });
    it('should return zero-padded minutes', function() {
      return equal(d.toFormat('%M'), '07');
    });
    it('should return non-padded month', function() {
      return equal(d.toFormat('%n'), '9');
    });
    it('should return non-padded minutes', function() {
      return equal(d.toFormat('%N'), '7');
    });
    it('should return PM', function() {
      return equal(d.toFormat('%p'), 'p.m.');
    });
    it('should return AM', function() {
      d.setHours(9);
      equal(d.toFormat('%p'), 'a.m.');
      return d.setHours(18);
    });
    it('should return non-padded seconds', function() {
      return equal(d.toFormat('%s'), '8');
    });
    it('should return padded seconds', function() {
      return equal(d.toFormat('%S'), '08');
    });
    it('should return miliseconds', function() {
      return equal(d.toFormat('%r'), '200');
    });
    it('should return numeric weed day', function() {
      return equal(d.toFormat('%w'), '0');
    });
    it('should return year without century', function() {
      return equal(d.toFormat('%y'), '13');
    });
    it('should return full year', function() {
      return equal(d.toFormat('%Y'), '2013');
    });
    it('should return timezone', function() {
      var originalTz;
      originalTz = d.timezone;
      d.timezone = 120;
      equal(d.toFormat('%z'), '+0200');
      d.timezone = -360;
      equal(d.toFormat('%z'), '-0600');
      return d.timezone = originalTz;
    });
    it('should return literal percent', function() {
      return equal(d.toFormat('%%'), '%');
    });
    return it('should retain non-formatting character', function() {
      var f;
      f = d.toFormat('The year is %Y, around %i %p on %B %D');
      return equal(f, "The year is 2013, around 6 p.m. on September 1");
    });
  });
});
