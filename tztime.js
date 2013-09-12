// Generated by CoffeeScript 1.6.3
/*
@author Your Name <email@example.com>
@license LICENSE
*/

var define;

define = (function(root) {
  if (typeof root.define === 'function' && root.define.amd) {
    return root.define;
  } else {
    if (typeof module === 'object' && module.exports) {
      return function(factory) {
        return module.exports = factory();
      };
    } else {
      return function(factory) {
        return root.TzTime = factory();
      };
    }
  }
})(this);

define(function(require) {
  var TzTime;
  TzTime = (function() {
    var D, property, staticProperty;

    property = function(name, descriptor) {
      return Object.defineProperty(TzTime.prototype, name, descriptor);
    };

    staticProperty = function(name, descriptor) {
      return Object.defineProperty(TzTime, name, descriptor);
    };

    function TzTime(yr, mo, dy, hr, mi, se, ms, tz) {
      var instance, t;
      if (hr == null) {
        hr = 0;
      }
      if (mi == null) {
        mi = 0;
      }
      if (se == null) {
        se = 0;
      }
      if (ms == null) {
        ms = 0;
      }
      if (tz == null) {
        tz = null;
      }
      switch (arguments.length) {
        case 0:
          instance = new Date();
          break;
        case 1:
          if (yr instanceof TzTime) {
            instance = new Date(yr.getTime());
            instance.__timezone__ = yr.timezone;
          } else if (yr instanceof Date) {
            instance = new Date(yr.getTime());
          } else {
            instance = new Date(yr);
          }
          break;
        case 2:
          throw new Error("Not implemented yet");
          break;
        case 8:
          t = Date.UTC(yr, mo, dy, hr, mi, se, ms);
          t -= tz * 60 * 1000;
          instance = new Date(t);
          instance.__timezone__ = tz;
          break;
        default:
          instance = new Date(yr, mo, dy, hr, mi, se, ms);
      }
      instance.__timezone__ || (instance.__timezone__ = -instance.getTimezoneOffset());
      instance.constructor = TzTime;
      instance.__proto__ = TzTime.prototype;
      return instance;
    }

    D = function() {};

    D.prototype = Date.prototype;

    TzTime.prototype = new D();

    property('timezone', {
      get: function() {
        return -this.getTimezoneOffset();
      },
      set: function(v) {
        return this.setTimezoneOffset(-v);
      }
    });

    property('year', {
      get: function() {
        return this.getFullYear();
      },
      set: function(v) {
        return this.setFullYear(v);
      }
    });

    property('month', {
      get: function() {
        return this.getMonth();
      },
      set: function(v) {
        return this.setMonth(v);
      }
    });

    property('date', {
      get: function() {
        return this.getDate();
      },
      set: function(v) {
        return this.setDate(v);
      }
    });

    property('hours', {
      get: function() {
        return this.getHours();
      },
      set: function(v) {
        return this.setHours(v);
      }
    });

    property('minutes', {
      get: function() {
        return this.getMinutes();
      },
      set: function(v) {
        return this.setMinutes(v);
      }
    });

    property('seconds', {
      get: function() {
        return this.getSeconds();
      },
      set: function(v) {
        return this.setSeconds(v);
      }
    });

    TzTime.prototype.getTimezoneOffset = function() {
      return -this.__timezone__;
    };

    TzTime.prototype.setTimezoneOffset = function(v) {
      var delta;
      v = parseInt(v);
      if (isNaN(v)) {
        throw new TypeError("Time zone offset must be an integer.");
      }
      if ((-720 > v && v > 720)) {
        throw new TypeError("Time zone offset out of bounds.");
      }
      v = -v;
      delta = v - this.__timezone__;
      this.__timezone__ = v;
      this.setUTCMinutes(this.getUTCMinutes() - delta);
      return this;
    };

    (function(proto) {
      var method, methods, _i, _len, _results;
      methods = ['FullYear', 'Month', 'Date', 'Hours'];
      _results = [];
      for (_i = 0, _len = methods.length; _i < _len; _i++) {
        method = methods[_i];
        proto['set' + method] = (function(method) {
          return function() {
            var delta, utcmins;
            Date.prototype['setUTC' + method].apply(this, arguments);
            utcmins = Date.prototype.getUTCMinutes.call(this);
            delta = utcmins - this.__timezone__;
            Date.prototype.setUTCMinutes.call(this, delta);
            return this;
          };
        })(method);
        _results.push(proto['get' + method] = (function(method) {
          return function() {
            var d;
            d = new Date(this.getTime());
            d.setUTCMinutes(d.getUTCMinutes() + this.__timezone__);
            return d['getUTC' + method]();
          };
        })(method));
      }
      return _results;
    })(TzTime.prototype);

    (function(proto) {
      var method, methods, _i, _len, _results;
      methods = ['Minutes', 'Seconds', 'Milliseconds'];
      _results = [];
      for (_i = 0, _len = methods.length; _i < _len; _i++) {
        method = methods[_i];
        _results.push(proto['set' + method] = (function(method) {
          return function() {
            Date.prototype['setUTC' + method].apply(this, arguments);
            return this;
          };
        })(method));
      }
      return _results;
    })(TzTime.prototype);

    staticProperty('platformZone', {
      get: function() {
        return -(new Date().getTimezoneOffset());
      },
      set: function() {}
    });

    return TzTime;

  })();
  TzTime.utils = {
    repeat: function(s, count) {
      return new Array(count + 1).join(s);
    },
    reverse: function(s) {
      return s.split('').reverse().join('');
    },
    pad: function(i, digits, tail) {
      var h, t, _ref;
      if (digits == null) {
        digits = 3;
      }
      if (tail == null) {
        tail = false;
      }
      if (tail === false) {
        return (TzTime.utils.repeat('0', digits) + i).slice(-digits);
      } else {
        _ref = i.toString().split('.'), h = _ref[0], t = _ref[1];
        if (tail === 0) {
          return TzTime.utils.pad(h, digits, false);
        } else {
          t || (t = '0');
          h = TzTime.utils.pad(h, digits, false);
          t = TzTime.utils.pad(TzTime.utils.reverse(t), tail, false);
          t = TzTime.utils.reverse(t);
          return [h, t].join('.');
        }
      }
    },
    cycle: function(i, max, zeroIndex) {
      if (zeroIndex == null) {
        zeroIndex = false;
      }
      return i % max || (zeroIndex ? 0 : max);
    },
    hour24: function(h, pm) {
      if (pm == null) {
        pm = false;
      }
      h += (pm ? 12 : 0);
      if (h === 12) {
        return 0;
      }
      if (h === 24) {
        return 12;
      }
      return h;
    }
  };
  return TzTime;
});
