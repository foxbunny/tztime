// Generated by CoffeeScript 1.6.3
var TzTime, assert, assertEqualDate, assertTime, chai, equal, root;

root = this;

if (typeof require !== "undefined" && require !== null) {
  chai = require('chai');
  TzTime = require('../tztime');
}

assert = chai.assert;

equal = assert.equal;

assertTime = function(d, yr, mo, dy, hr, mi, se, ms) {
  if (yr) {
    equal(d.getFullYear(), yr, "Year of " + d + " are not correct");
  }
  if (mo) {
    equal(d.getMonth(), mo, "Month of " + d + " are not correct");
  }
  if (dy) {
    equal(d.getDate(), dy, "Date of " + d + " are not correct");
  }
  if (hr) {
    equal(d.getHours(), hr, "Hours of " + d + " are not correct");
  }
  if (mi) {
    equal(d.getMinutes(), mi, "Minutes of " + d + " are not correct");
  }
  if (se) {
    equal(d.getSeconds(), se, "Seconds of " + d + " are not correct");
  }
  if (mi) {
    return equal(d.getMilliseconds(), ms, "Milliseconds of " + d + " are not correct");
  }
};

assertEqualDate = function(a, b) {
  equal(a.getFullYear(), b.getFullYear());
  equal(a.getMonth(), b.getMonth());
  equal(a.getDate(), b.getDate());
  equal(a.getHours(), b.getHours());
  equal(a.getMinutes(), b.getMinutes());
  equal(a.getSeconds(), b.getSeconds());
  return equal(a.getMilliseconds(), b.getMilliseconds());
};

describe('TzTime', function() {
  describe('constructor', function() {
    it('should be identical to Date constructor', function() {
      var d1, d2;
      d1 = new TzTime(2013, 8, 1);
      d2 = new Date(2013, 8, 1);
      return equal(d1.getTime(), d2.getTime());
    });
    it('should have a constructor of TzTime', function() {
      var d;
      d = new TzTime(2013, 8, 1);
      return equal(d.constructor, TzTime);
    });
    it('should be an instance of TzTime', function() {
      var d;
      d = new TzTime(2013, 8, 1);
      return assert.ok(d instanceof TzTime);
    });
    it('should be usable withough the new keyword', function() {
      var d, d1;
      d = TzTime(2013, 8, 1);
      equal(typeof d, 'object');
      equal(d.constructor, TzTime);
      assert.ok(d instanceof TzTime);
      d1 = new TzTime(2013, 8, 1);
      return equal(d.getTime(), d1.getTime());
    });
    it('should accept the timezone as last argument', function() {
      var d;
      d = TzTime(2013, 8, 1, 12, 45, 39, 0, 360);
      return equal(d.timezone, 360);
    });
    it('should set correct time when time zone is passed', function() {
      var d1, d2, d3, d4;
      d1 = TzTime(2013, 0, 1, 12, 30, 0, 0, 60);
      d2 = TzTime(2013, 0, 1, 12, 30, 0, 0, 360);
      d3 = TzTime(2013, 0, 1, 12, 30, 0, 0, 720);
      d4 = TzTime(2013, 0, 1, 12, 30, 0, 0, -120);
      assertTime(d1, 2013, 0, 1, 12, 30, 0, 0);
      assertTime(d2, 2013, 0, 1, 12, 30, 0, 0);
      assertTime(d3, 2013, 0, 1, 12, 30, 0, 0);
      return assertTime(d4, 2013, 0, 1, 12, 30, 0, 0);
    });
    it('should create a new instance if passed Date or TzTime obj', function() {
      var d1, d2, d3, d4;
      d1 = new Date(2013, 8, 1);
      d2 = TzTime(2013, 8, 1);
      d3 = TzTime(d1);
      d4 = TzTime(d2);
      assert.notEqual(d1, d2);
      assert.notEqual(d1, d3);
      assert.notEqual(d1, d4);
      assert.notEqual(d2, d3);
      assert.notEqual(d2, d4);
      assert.notEqual(d3, d4);
      assertEqualDate(d1, d2);
      assertEqualDate(d2, d3);
      return assertEqualDate(d3, d4);
    });
    return it('should retain timezone when passed TzTime instance', function() {
      var d, d1;
      d = TzTime(2013, 8, 1);
      d.timezone = -240;
      d1 = TzTime(d);
      return equal(d1.timezone, -240);
    });
  });
  describe('#timezone', function() {
    it('is a number', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20);
      return equal(typeof d.timezone, 'number');
    });
    it('should be opposite of #getTimezoneOffset()', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20);
      return equal(d.getTimezoneOffset() + d.timezone, 0);
    });
    it('can be set by assigning', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20);
      d.timezone = 12;
      equal(d.getTimezoneOffset() + d.timezone, 0);
      return equal(d.getTimezoneOffset(), -12);
    });
    it('should not shift the time when set', function() {
      var d, h1, h2, offset, uh1, uh2;
      offset = -120;
      d = TzTime(2013, 8, 1, 8, 20, 0, 0, offset);
      d.timezone = 0;
      h1 = d.getHours();
      uh1 = d.getUTCHours();
      d.timezone = 60;
      h2 = d.getHours();
      uh2 = d.getUTCHours();
      equal(h1, h2);
      return assert.notEqual(uh1, uh2);
    });
    it('should give same UTC and local time when set to 0', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20);
      d.timezone = 0;
      return equal(d.getHours(), d.getUTCHours());
    });
    it('should generally work correctly', function() {
      var d, loch1, loch2, pzhours, pzone, utch1, utch2;
      pzone = TzTime.platformZone;
      pzhours = pzone / 60;
      d = TzTime(2013, 8, 1, 8, 20);
      utch1 = d.getUTCHours();
      loch1 = d.getHours();
      equal(utch1, loch1 - pzhours);
      d.timezone = pzone + 120;
      utch2 = d.getUTCHours();
      loch2 = d.getHours();
      equal(loch2, loch1);
      return equal(utch2, utch1 - 2);
    });
    it('will convert floats to integers', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20);
      d.timezone = 120.4;
      return equal(d.timezone, 120);
    });
    it('can be set using -= and += operators', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20);
      d.timezone = 0;
      d.timezone += 12;
      return equal(d.timezone, 12);
    });
    return it('should be UTC time if set to 0', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20);
      d.timezone = 0;
      d.setHours(8);
      equal(d.getUTCHours(), 8);
      return equal(d.getHours(), 8);
    });
  });
  describe('#getTimezoneOffset()', function() {
    return it('should return the opposite of time zone offset', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20);
      d.timezone = 12;
      return equal(d.getTimezoneOffset(), -12);
    });
  });
  describe('#setTimezoneOffset()', function() {
    return it('should set the timezone using opposite of offset', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20);
      d.timezone = 0;
      d.setTimezoneOffset(12);
      return equal(d.timezone, -12);
    });
  });
  describe('#setFullYear()', function() {
    it('should set the year and return instance', function() {
      var d, d1;
      d = TzTime(2013, 8, 1, 8, 20);
      d1 = d.setFullYear(2020);
      equal(d1, d);
      return equal(d.getFullYear(), 2020);
    });
    return it('should set mont and date if passed', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20);
      d.setFullYear(2015, 2, 12);
      equal(d.getFullYear(), 2015);
      equal(d.getMonth(), 2);
      return equal(d.getDate(), 12);
    });
  });
  describe('#setMonth()', function() {
    it('should set month and return instance', function() {
      var d, d1;
      d = TzTime(2013, 8, 1, 8, 20);
      d1 = d.setMonth(9);
      equal(d.getMonth(), 9);
      return equal(d1, d);
    });
    return it('should set both month and date if passed both', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20);
      d.setMonth(9, 12);
      equal(d.getMonth(), 9);
      return equal(d.getDate(), 12);
    });
  });
  describe('#setDate()', function() {
    return it('should set the date and return instance', function() {
      var d, d1;
      d = TzTime(2013, 8, 1, 8, 20);
      d1 = d.setDate(2);
      equal(d.getDate(), 2);
      return equal(d1, d);
    });
  });
  describe('#setHours()', function() {
    it('should set hours and return instance', function() {
      var d, d1;
      d = TzTime(2013, 8, 1, 8, 20);
      d1 = d.setHours(2);
      equal(d.getHours(), 2);
      return equal(d1, d);
    });
    return it('should set minutes, seconds, and milliseconds if given', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.setHours(2, 2, 2, 2);
      equal(d.getHours(), 2);
      equal(d.getMinutes(), 2);
      equal(d.getSeconds(), 2);
      return equal(d.getMilliseconds(), 2);
    });
  });
  describe('#setMinutes()', function() {
    it('should set minutes and return instance', function() {
      var d, d1;
      d = TzTime(2013, 8, 1, 8, 20);
      d1 = d.setMinutes(2);
      equal(d.getMinutes(), 2);
      return equal(d1, d);
    });
    return it('should set seconds and milliseconds if given', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.setMinutes(2, 2, 2);
      equal(d.getMinutes(), 2);
      equal(d.getSeconds(), 2);
      return equal(d.getMilliseconds(), 2);
    });
  });
  describe('#setSeconds()', function() {
    it('should set seconds and return instance', function() {
      var d, d1;
      d = TzTime(2013, 8, 1, 8, 20);
      d1 = d.setSeconds(2);
      equal(d.getSeconds(), 2);
      return equal(d1, d);
    });
    return it('should set milliseconds if given', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.setSeconds(2, 2);
      equal(d.getSeconds(), 2);
      return equal(d.getMilliseconds(), 2);
    });
  });
  describe('#setMilliseconds()', function() {
    return it('should set milliseconds and return instance', function() {
      var d, d1;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d1 = d.setMilliseconds(2);
      equal(d.getMilliseconds(), 2);
      return equal(d1, d);
    });
  });
  describe('#getHours()', function() {
    return it('should give time in instance timezone', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      equal(d.getHours(), 8);
      d.timezone += 120;
      equal(d.getHours(), 8);
      d.timezone -= 300;
      return equal(d.getHours(), 8);
    });
  });
  describe('#year', function() {
    it('should set year', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.year = 2020;
      return equal(d.getFullYear(), 2020);
    });
    it('should return year', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20);
      return equal(d.year, 2013);
    });
    return it('can be used with -= and += operators', function() {
      var d, y1, y2;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.year -= 2;
      y1 = d.year;
      d.year += 4;
      y2 = d.year;
      equal(y1, 2011);
      return equal(y2, 2015);
    });
  });
  describe('#month', function() {
    it('should set month', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.month = 9;
      return equal(d.getMonth(), 9);
    });
    it('should return month', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      return equal(d.month, 8);
    });
    it('can be used with -= and += operators', function() {
      var d, m1, m2;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.month -= 2;
      m1 = d.month;
      d.month += 4;
      m2 = d.month;
      equal(m1, 6);
      return equal(m2, 10);
    });
    return it('should adjust the year when incremented or decremented', function() {
      var d, y1, y2;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.month -= 12;
      y1 = d.year;
      d.month += 24;
      y2 = d.year;
      equal(y1, 2012);
      return equal(y2, 2014);
    });
  });
  describe('#date', function() {
    it('should set the date', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.date = 20;
      return equal(d.getDate(), 20);
    });
    it('should return the date', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      return equal(d.date, 1);
    });
    it('can be used with -= and += operators', function() {
      var d, d1, d2;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.date += 12;
      d1 = d.date;
      d.date -= 4;
      d2 = d.date;
      equal(d1, 13);
      return equal(d2, 9);
    });
    it('should cross month boundaries when setting', function() {
      var d, m1, m2;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.date += 31;
      m1 = d.month;
      d.date -= 62;
      m2 = d.month;
      equal(m1, 9);
      return equal(m2, 7);
    });
    return it('should cross year boundaries when setting', function() {
      var d, y1, y2;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.date += 365;
      y1 = d.year;
      d.date -= 2 * 365;
      y2 = d.year;
      equal(y1, 2014);
      return equal(y2, 2012);
    });
  });
  describe('#day', function() {
    return it('should return the day of week', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      return equal(d.day, 0);
    });
  });
  describe('#hours', function() {
    it('should set the hour', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.hours = 2;
      return equal(d.getHours(), 2);
    });
    it('should return hour', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      return equal(d.hours, 8);
    });
    it('can be used with -= and += operators', function() {
      var d, h1, h2;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.hours -= 4;
      h1 = d.hours;
      d.hours += 12;
      h2 = d.hours;
      equal(h1, 4);
      return equal(h2, 16);
    });
    it('should cross date boundaries', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.hours += 20;
      return equal(d.date, 2);
    });
    it('should cross month boundaries', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.hours += 24 * 31;
      return equal(d.month, 9);
    });
    return it('should cross year boundaries', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.hours += 24 * 365;
      return equal(d.year, 2014);
    });
  });
  describe('#minutes', function() {
    it('should set minute', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.minutes = 21;
      return equal(d.getMinutes(), 21);
    });
    it('should return minute', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      return equal(d.minutes, 20);
    });
    it('can be used with -= and += operators', function() {
      var d, m1, m2;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.minutes -= 15;
      m1 = d.minutes;
      d.minutes += 20;
      m2 = d.minutes;
      equal(m1, 5);
      return equal(m2, 25);
    });
    it('should cross hour boundary', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.minutes += 50;
      return equal(d.hours, 9);
    });
    it('should cross date boundary', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.minutes += 60 * 24;
      return equal(d.date, 2);
    });
    it('should cross month boundary', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.minutes += 60 * 24 * 31;
      return equal(d.month, 9);
    });
    return it('should cross year boundary', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.minutes += 60 * 24 * 365;
      return equal(d.year, 2014);
    });
  });
  describe('#seconds', function() {
    it('should set seconds', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.seconds = 21;
      return equal(d.getSeconds(), 21);
    });
    it('should return seconds', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      return equal(d.seconds, 1);
    });
    it('can be used with -= and += operators', function() {
      var d, s1, s2;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.seconds += 20;
      s1 = d.seconds;
      d.seconds -= 5;
      s2 = d.seconds;
      equal(s1, 21);
      return equal(s2, 16);
    });
    it('should cross minutes boundary', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.seconds += 60;
      return equal(d.minutes, 21);
    });
    it('should cross hours boundary', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.seconds += 60 * 60;
      return equal(d.hours, 9);
    });
    it('should cross date boundary', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.seconds += 60 * 60 * 24;
      return equal(d.date, 2);
    });
    it('should cross month boundary', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.seconds += 60 * 60 * 24 * 31;
      return equal(d.month, 9);
    });
    return it('should cross year boundary', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.seconds += 60 * 60 * 24 * 365;
      return equal(d.year, 2014);
    });
  });
  describe('#milliseconds', function() {
    it('should return milliseconds', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      return equal(d.milliseconds, 500);
    });
    it('should set milliseconds', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.milliseconds = 430;
      return equal(d.milliseconds, 430);
    });
    it('can be used with -= and += operators', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.milliseconds += 10;
      equal(d.milliseconds, 510);
      d.milliseconds -= 20;
      return equal(d.milliseconds, 490);
    });
    return it('should cross second boundary', function() {
      var d;
      d = TzTime(2013, 8, 1, 8, 20, 1, 500);
      d.milliseconds += 500;
      return equal(d.seconds, 2);
    });
  });
  describe('#utcYear', function() {
    it('should return the UTC year', function() {
      var d;
      d = TzTime(2013, 0, 1, 0, 0, 0, 0, 60);
      equal(d.year, 2013);
      return equal(d.utcYear, 2012);
    });
    return it('should set the UTC year', function() {
      var d;
      d = TzTime(2013, 0, 1, 0, 0, 0, 0, 60);
      d.utcYear = 2013;
      return equal(d.year, 2014);
    });
  });
  describe('#utcMonth', function() {
    it('should return the UTC month', function() {
      var d;
      d = TzTime(2013, 1, 1, 0, 0, 0, 0, 60);
      equal(d.month, 1);
      return equal(d.utcMonth, 0);
    });
    return it('should set the UTC month', function() {
      var d;
      d = TzTime(2013, 1, 1, 0, 0, 0, 0, 60);
      d.utcMonth = 1;
      return equal(d.month, 2);
    });
  });
  describe('#utcDate', function() {
    it('should return the UTC date', function() {
      var d;
      d = TzTime(2013, 1, 2, 0, 0, 0, 0, 60);
      equal(d.date, 2);
      return equal(d.utcDate, 1);
    });
    return it('should set the UTC date', function() {
      var d;
      d = TzTime(2013, 1, 2, 0, 0, 0, 0, 60);
      d.utcDate = 2;
      return equal(d.date, 3);
    });
  });
  describe('#utcDay', function() {
    return it('should return the UTC day of week', function() {
      var d;
      d = TzTime(2013, 1, 2, 0, 0, 0, 0, 60);
      equal(d.day, 6);
      return equal(d.utcDay, 5);
    });
  });
  describe('#utcHours', function() {
    it('should return the UTC hours', function() {
      var d;
      d = TzTime(2013, 1, 2, 1, 0, 0, 0, 60);
      equal(d.hours, 1);
      return equal(d.utcHours, 0);
    });
    return it('should set the UTC hours', function() {
      var d;
      d = TzTime(2013, 1, 2, 1, 0, 0, 0, 60);
      d.utcHours = 1;
      return equal(d.hours, 2);
    });
  });
  describe('#utcMinutes', function() {
    it('should return the UTC minutes', function() {
      var d;
      d = TzTime(2013, 1, 2, 1, 35, 0, 0, 30);
      equal(d.minutes, 35);
      return equal(d.utcMinutes, 5);
    });
    return it('should set the UTC minutes', function() {
      var d;
      d = TzTime(2013, 1, 2, 1, 35, 0, 0, 30);
      d.utcMinutes = 15;
      return equal(d.minutes, 45);
    });
  });
  describe('#utcSeconds', function() {
    it('should return the UTC seconds', function() {
      var d;
      d = TzTime(2013, 1, 2, 1, 35, 7, 0, 30);
      equal(d.seconds, 7);
      return equal(d.utcSeconds, 7);
    });
    return it('should set the UTC seconds', function() {
      var d;
      d = TzTime(2013, 1, 2, 1, 35, 7, 0, 30);
      d.utcSeconds = 12;
      return equal(d.seconds, 12);
    });
  });
  describe('#utcMilliseconds', function() {
    it('should return the UTC milliseconds', function() {
      var d;
      d = TzTime(2013, 1, 2, 1, 35, 7, 224, 30);
      equal(d.milliseconds, 224);
      return equal(d.utcMilliseconds, 224);
    });
    return it('shoul set the UTC milliseconds', function() {
      var d;
      d = TzTime(2013, 1, 2, 1, 35, 7, 224, 30);
      d.utcMilliseconds = 433;
      return equal(d.milliseconds, 433);
    });
  });
  return describe('#resetTime', function() {
    it('should reset the time', function() {
      var d;
      d = TzTime(2013, 8, 1, 12, 45, 13, 300);
      equal(d.hours, 12);
      equal(d.minutes, 45);
      equal(d.seconds, 13);
      equal(d.milliseconds, 300);
      d.resetTime();
      equal(d.hours, 0);
      equal(d.minutes, 0);
      equal(d.seconds, 0);
      return equal(d.milliseconds, 0);
    });
    return it('shouold return instance', function() {
      var d, r;
      d = TzTime(2013, 8, 1, 12, 45, 13, 300);
      r = d.resetTime();
      return equal(r, d);
    });
  });
});
