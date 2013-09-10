// Generated by CoffeeScript 1.6.3
/*
@author Your Name <email@example.com>
@license LICENSE
*/

var define;

define = (function(root, module) {
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
})(this, module);

define(function(require) {
  var TzTime;
  return TzTime = (function() {
    var D, property;

    property = function(name, descriptor) {
      return Object.defineProperty(TzTime.prototype, name, descriptor);
    };

    function TzTime(yr, mo, dy, hr, mi, se, ms) {
      var instance;
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
      switch (arguments.length) {
        case 0:
          instance = new Date();
          break;
        case 1:
          instance = new Date(yr);
          break;
        case 2:
          throw new Error("Not implemented yet");
          break;
        default:
          instance = new Date(yr, mo, dy, hr, mi, se, ms);
      }
      instance.__timezone__ = -instance.getTimezoneOffset();
      instance.constructor = TzTime;
      instance.__proto__ = TzTime.prototype;
      return instance;
    }

    D = function() {};

    D.prototype = Date.prototype;

    TzTime.prototype = new D();

    property('timezone', {
      get: function() {
        return this.__timezone__;
      },
      set: function(v) {
        var diff;
        v = parseInt(v);
        if (isNaN(v)) {
          throw new TypeError("Time zone offset must be an integer.");
        }
        if ((-720 > v && v > 720)) {
          throw new TypeError("Time zone offset out of bounds.");
        }
        diff = this.__timezone__ + v;
        this.setMinutes(this.getMinutes() + diff);
        this.__timezone__ = v;
        return v;
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

    TzTime.prototype.getTimezoneOffset = function() {
      return -this.timezone;
    };

    TzTime.prototype.setTimezoneOffset = function(v) {
      return this.timezone = -v;
    };

    TzTime.prototype.setFullYear = function() {
      Date.prototype.setFullYear.apply(this, arguments);
      return this;
    };

    TzTime.prototype.setMonth = function() {
      Date.prototype.setMonth.apply(this, arguments);
      return this;
    };

    TzTime.prototype.setDate = function() {
      Date.prototype.setDate.apply(this, arguments);
      return this;
    };

    return TzTime;

  })();
});
