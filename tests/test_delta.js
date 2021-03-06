// Generated by CoffeeScript 1.6.3
var TzTime, assert, chai, equal, hasProp, isok, notOk, root;

if (typeof require !== "undefined" && require !== null) {
  chai = require('chai');
  TzTime = require('../tztime');
}

if (typeof GLOBAL === "undefined" || GLOBAL === null) {
  root = this;
} else {
  root = GLOBAL;
}

assert = chai.assert;

isok = assert.ok;

notOk = assert.notOk;

equal = assert.equal;

hasProp = function(obj, prop, msg) {
  return isok(obj.hasOwnProperty(prop), msg);
};

describe('TzTime', function() {
  describe('#delta', function() {
    it('should return an object with required properties', function() {
      var d1, d2, delta;
      d1 = d2 = new TzTime();
      delta = d1.delta(d2);
      hasProp(delta, 'delta', 'missing `delta`');
      hasProp(delta, 'milliseconds', 'missing `milliseconds`');
      hasProp(delta, 'seconds', 'missing `seconds`');
      hasProp(delta, 'minutes', 'missing `minutes`');
      hasProp(delta, 'hours', 'missing `hours`');
      return hasProp(delta, 'composite', 'missing `composite`');
    });
    it('should return 0 if dates are equal', function() {
      var d1, d2, delta;
      d1 = d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.delta, 0);
    });
    it('should return difference in milliseconds', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 10);
      delta = d1.delta(d2);
      return equal(delta.delta, 10);
    });
    it('can return negative delta if d2 is before d1', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 12, 0, 0, 10);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.delta, -10);
    });
    it('returns absolute delta in milliseconds', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 12, 0, 0, 10);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.milliseconds, 10);
    });
    it('returns absolute delta in seconds', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 12, 0, 2, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.seconds, 2);
    });
    it('rounds delta in seconds up', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 12, 0, 2, 1);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.seconds, 3);
    });
    it('should express seconds in milliseconds as well', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 12, 0, 2, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.milliseconds, 2 * 1000);
    });
    it('returns absolute delta in minutes', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 12, 2, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.minutes, 2);
    });
    it('rounds delta in minutes up', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 12, 2, 0, 1);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.minutes, 3);
    });
    it('should express minutes in seconds as well', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 12, 2, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.seconds, 2 * 60);
    });
    it('should express minutes in milliseconds as well', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 12, 2, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.milliseconds, 2 * 60 * 1000);
    });
    it('returns absolute delta in hours', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 13, 0, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.hours, 1);
    });
    it('rounds delta in hours up', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 13, 0, 0, 1);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.hours, 2);
    });
    it('should express hours in minutes as well', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 13, 0, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.minutes, 60);
    });
    it('should express hours in seconds as well', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 13, 0, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.seconds, 60 * 60);
    });
    it('should express hours in milliseconds as well', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 1, 13, 0, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.milliseconds, 60 * 60 * 1000);
    });
    it('returns absolute delta in days', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 3, 12, 0, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.days, 2);
    });
    it('rounds delta in days up', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 3, 12, 0, 0, 1);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.days, 3);
    });
    it('should express days in hours as well', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 3, 12, 0, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.hours, 2 * 24);
    });
    it('should express days in minutes as well', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 3, 12, 0, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.minutes, 2 * 24 * 60);
    });
    it('should express days in seconds as well', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 3, 12, 0, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.seconds, 2 * 24 * 60 * 60);
    });
    it('should express days in milliseconds as well', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 3, 12, 0, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      return equal(delta.milliseconds, 2 * 24 * 60 * 60 * 1000);
    });
    it('should give a composite delta', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 3, 12, 0, 0, 0);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      equal(delta.composite[0], 2);
      equal(delta.composite[1], 0);
      equal(delta.composite[2], 0);
      equal(delta.composite[3], 0);
      return equal(delta.composite[4], 0);
    });
    return it('should give a composite delta with all values', function() {
      var d1, d2, delta;
      d1 = new TzTime(2013, 8, 3, 13, 1, 1, 1);
      d2 = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      delta = d1.delta(d2);
      equal(delta.composite[0], 2, 'days');
      equal(delta.composite[1], 1, 'hours');
      equal(delta.composite[2], 1, 'minutes');
      return equal(delta.composite[3], 1, 'seconds');
    });
  });
  describe('TzTime.reorder', function() {
    return it('should return ordered dates', function() {
      var d1, d2, d3, sorted;
      d1 = new TzTime(2013, 8, 1);
      d2 = new TzTime(2013, 8, 2);
      d3 = new TzTime(2013, 8, 3);
      sorted = TzTime.reorder(d3, d1, d2);
      equal(d1, sorted[0]);
      equal(d2, sorted[1]);
      return equal(d3, sorted[2]);
    });
  });
  describe('#equals', function() {
    it('should return true if objects represent same time', function() {
      var d1, d2;
      d1 = new TzTime(2013, 8, 3, 13, 1, 1, 1);
      d2 = new TzTime(2013, 8, 3, 13, 1, 1, 1);
      assert.notEqual(d1, d2);
      isok(d1.equals(d2));
      return isok(d2.equals(d1));
    });
    return it('should return false if dates represent different time', function() {
      var d1, d2;
      d1 = new TzTime(2013, 8, 3, 13, 1, 1, 1);
      d2 = new TzTime(2013, 8, 3, 13, 1, 1, 2);
      assert.notEqual(d1, d2);
      notOk(d1.equals(d2));
      return notOk(d2.equals(d1));
    });
  });
  describe('#isBefore', function() {
    it('should basically work :)', function() {
      var neu, old;
      old = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      neu = new TzTime(2013, 8, 1, 12, 1, 0, 0);
      isok(old.isBefore(neu));
      return notOk(neu.isBefore(old));
    });
    return it('should return false when dates are equal', function() {
      var neu, old;
      old = neu = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      notOk(old.isBefore(neu));
      return notOk(neu.isBefore(old));
    });
  });
  describe('#isAfter', function() {
    it('should basically work... again', function() {
      var neu, old;
      old = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      neu = new TzTime(2013, 8, 1, 12, 1, 0, 0);
      notOk(old.isAfter(old));
      return isok(neu.isAfter(old));
    });
    return it('should return false if dates are equal', function() {
      var neu, old;
      old = neu = new TzTime(2013, 8, 1, 12, 0, 0, 0);
      notOk(old.isAfter(neu));
      return notOk(neu.isAfter(old));
    });
  });
  describe('#isBetwen', function() {
    it('should return true when date is between two dates', function() {
      var d1, d2, d3;
      d1 = new TzTime(2013, 8, 1);
      d2 = new TzTime(2013, 8, 2);
      d3 = new TzTime(2013, 8, 3);
      return isok(d2.isBetween(d1, d3));
    });
    it("should't care about order of the two extremes", function() {
      var d1, d2, d3;
      d1 = new TzTime(2013, 8, 1);
      d2 = new TzTime(2013, 8, 2);
      d3 = new TzTime(2013, 8, 3);
      return isok(d2.isBetween(d3, d1));
    });
    it("should return false if middle date matches an extereme", function() {
      var d1, d2, d3;
      d1 = new TzTime(2013, 8, 1);
      d2 = d3 = new TzTime(2013, 8, 2);
      return notOk(d2.isBetween(d1, d3));
    });
    return it("should return false if date is outside extremes", function() {
      var d1, d2, d3;
      d1 = new TzTime(2013, 8, 1);
      d2 = new TzTime(2013, 8, 2);
      d3 = new TzTime(2013, 8, 3);
      return notOk(d1.isBetween(d2, d3));
    });
  });
  describe('#dateEquals', function() {
    it('should return true if dates equal', function() {
      var d1, d2;
      d1 = new TzTime(2013, 8, 3, 13, 1, 1, 1);
      d2 = new TzTime(2013, 8, 3, 14, 1, 1, 1);
      isok(d1.dateEquals(d2));
      return isok(d2.dateEquals(d1));
    });
    return it('should return false if dates are not equal', function() {
      var d1, d2;
      d1 = new TzTime(2013, 8, 3, 13, 1, 1, 1);
      d2 = new TzTime(2013, 8, 2, 13, 1, 1, 1);
      notOk(d1.dateEquals(d2));
      return notOk(d2.dateEquals(d1));
    });
  });
  describe('#isDateBefore', function() {
    it('should return false if only times differ', function() {
      var neu, old;
      old = new TzTime(2013, 8, 1, 5);
      neu = new TzTime(2013, 8, 1, 12);
      notOk(old.isDateBefore(neu));
      return notOk(neu.isDateBefore(old));
    });
    it('should return false if if date is after', function() {
      var neu, old;
      old = new TzTime(2013, 8, 1);
      neu = new TzTime(2013, 8, 2);
      return notOk(neu.isDateBefore(old));
    });
    return it('should return true if date is before', function() {
      var neu, old;
      old = new TzTime(2013, 8, 1);
      neu = new TzTime(2013, 8, 2);
      return isok(old.isDateBefore(neu));
    });
  });
  describe('#isDateAfter', function() {
    it('should return false if only times differ', function() {
      var neu, old;
      old = new TzTime(2013, 8, 1, 5);
      neu = new TzTime(2013, 8, 1, 12);
      notOk(neu.isDateAfter(old));
      return notOk(old.isDateAfter(neu));
    });
    it('should return false if date is before', function() {
      var neu, old;
      old = new TzTime(2013, 8, 1);
      neu = new TzTime(2013, 8, 2);
      return notOk(old.isDateAfter(neu));
    });
    return it('should return true if date is after', function() {
      var neu, old;
      old = new TzTime(2013, 8, 1);
      neu = new TzTime(2013, 8, 2);
      return isok(neu.isDateAfter(old));
    });
  });
  return describe('#isDateBetween', function() {
    it('should return false if only times differ', function() {
      var d1, d2, d3;
      d1 = new TzTime(2013, 8, 1, 5);
      d2 = new TzTime(2013, 8, 1, 12);
      d3 = new TzTime(2013, 8, 1, 18);
      notOk(d2.isDateBetween(d1, d3));
      return notOk(d2.isDateBetween(d3, d1));
    });
    it('should return true if between by date', function() {
      var d1, d2, d3;
      d1 = new TzTime(2013, 8, 1);
      d2 = new TzTime(2013, 8, 2);
      d3 = new TzTime(2013, 8, 3);
      return isok(d2.isBetween(d1, d3));
    });
    it('should not care about the order of arguments', function() {
      var d1, d2, d3;
      d1 = new TzTime(2013, 8, 1);
      d2 = new TzTime(2013, 8, 2);
      d3 = new TzTime(2013, 8, 3);
      return isok(d2.isBetween(d3, d1));
    });
    it('should return false if one of the extreme is same time', function() {
      var d1, d2, d3;
      d1 = new TzTime(2013, 8, 1);
      d2 = d3 = new TzTime(2013, 8, 2);
      return notOk(d2.isBetween(d3, d1));
    });
    return it('should return false if outside the range', function() {
      var d1, d2, d3;
      d1 = new TzTime(2013, 8, 1);
      d2 = new TzTime(2013, 8, 2);
      d3 = new TzTime(2013, 8, 3);
      return notOk(d1.isBetween(d2, d3));
    });
  });
});
