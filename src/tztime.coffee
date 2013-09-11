###
@author Your Name <email@example.com>
@license LICENSE
###

# # TzTime
#
# This is a drop-in replacement for JavaScript's native Date constructor which
# adds many useful and arguably saner API enhancements, and makes it
# time-zone-aware.
#
# ::TOC::
#

## UMD WRAPPER ##
define = ((root) ->
  if typeof root.define is 'function' and root.define.amd
    root.define
  else
    if typeof module is 'object' and module.exports
      (factory) -> module.exports = factory()
    else
      (factory) -> root.TzTime = factory()
) this


define (require) ->

  # ## `TzTime`
  #
  # Crates a JavaScript Date object with enhanced API and time zone awareness.
  #
  # Most of the native Date's API is retained. However, some time-zone-related
  # methods like `#getTimezoneOffset()` have been modified to support time zone
  # manipulation.
  #
  # In general, you can assume that an undocumented method that exists in
  # native Date global works as expected.
  #
  class TzTime

    ## Wrapper to make defining accessors easier
    property  = (name, descriptor) ->
      Object.defineProperty TzTime.prototype, name, descriptor

    # ### Constructor
    #
    #     new TzTime();
    #     new TzTime(value);
    #     new TzTime(dateString);
    #     new TzTime(year, month, day [, hour, minute, second, millisecond]);
    #
    # All constructor arguments are compliant with the standard JavaScript Date
    # constructor arguments. Please refer to [Date
    # documentation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date)
    # for more information.
    #
    # There are a few non-standard forms added.
    #
    # One is the same as the longest standard form, with the additon of time
    # zone offset as last argument.
    #
    #     new TimeZone(year, month, day, hour, minute, second, millsecond, tz);
    #
    # The last argument is an integer offset from UTC in minutes (positive
    # towards East, negative towards West).
    #
    # Unlike the JavaScript Date constructor, calling TzTime without the `new`
    # keyword has the same behavior as calling it with it.
    #
    constructor: (yr, mo, dy, hr=0, mi=0, se=0, ms=0, tz=null) ->

      ## Because of the way native Date constructor works, we must resort to
      ## argument-counting.
      switch arguments.length
        when 0
          instance = new Date()
        when 1
          if yr instanceof TzTime
            instance = new Date yr.getTime()
            tz = yr.timezone
          else if yr instanceof Date
            instance = new Date yr.getTime()
          else
            instance = new Date yr
        when 2
          throw new Error "Not implemented yet"
        else
          instance = new Date yr, mo, dy, hr, mi, se, ms

      # ### `#__timezone__` (private property)
      #
      # This property is a private property that stores the currently set
      # timezone offset. This property is used to calcualte the correct UTC
      # time. Please do not override this property.
      #
      # To set the time zone use either `#timezone` attribute, or
      # `#setTimezoneOffset()` method.
      #
      instance.__timezone__ = -instance.getTimezoneOffset()

      ## Reset the constructor and prototype chain
      instance.constructor = TzTime
      instance.__proto__ = TzTime.prototype

      instance.timezone = tz if tz?

      return instance

    # TzTime constructor inherits from the native Date prototype.
    #
    D = () ->
    D.prototype = Date.prototype
    TzTime.prototype = new D()

    # ### Attributes
    #
    # The TzTime prototype provides a number of methods that can be used to
    # manipulate the objects with greater ease than with native Date methods.
    # This is particularly true when incrementing or decrementing values. For
    # example:
    #
    #     var d = new TzTime();
    #     d.setHours(d.getHours() + 20);
    #     d.hour += 12;
    #
    # Most of the attributes are accessors that call methods to set or get the
    # values.
    #

    # #### `#timezone`
    #
    # The time zone offset in integer minutes from UTC.
    #
    # Unlike the native `#getTimezoneOffset()` method, these values are
    # calculated as positive integers from UTC towards East, and negative
    # towards West, as is usual for time zones.
    #
    # The `#getTimezoneOffset()` method retains the native behavior of giving
    # the offset in reverse, if you need to rely on such behavior.
    #
    property 'timezone',
      get: () -> -@getTimezoneOffset()
      set: (v) -> @setTimezoneOffset -v

    # #### `#year`
    #
    # Full integer year in instance's time zone. The value is an integer.
    #
    property 'year',
      get: () -> @getFullYear()
      set: (v) -> @setFullYear v

    # #### `#month`
    #
    # Month in instance's time zone. The value is 0-index where 0 is January.
    #
    property 'month',
      get: () -> @getMonth()
      set: (v) -> @setMonth v

    # #### `#date`
    #
    # Date in instance's time zone. The value is an integer between 1 and 31.
    #
    property 'date',
      get: () -> @getDate()
      set: (v) -> @setDate v

    # #### `#hours`
    #
    # Hours in 24-hour format in instance's time zone. The value is an integer
    # between 0 and 23.
    #
    property 'hours',
      get: () -> @getHours()
      set: (v) -> @setHours v

    # #### `#minutes`
    #
    # Minutes in instace's time zone. The value is an integer between 0 and 59.
    #
    property 'minutes',
      get: () -> @getMinutes()
      set: (v) -> @setMinutes v

    # #### `#seconds`
    #
    # Seconds in instance's time zome. The value is an integer between 0 and
    # 59.
    #
    property 'seconds',
      get: () -> @getSeconds()
      set: (v) -> @setSeconds v

    # ### Methods
    #
    # The methods of the TzTime prototype are specifically designed to address
    # either time-zone-awareness issues, or simply provide a somewhat better
    # API over those of the native Date objects. Methods that are not listed
    # here, but are present in the native Date object, behave the same way as
    # in the native Date object.
    #
    # One of the primary differences between the native methods and the ones
    # implemented in TzTime is the fact that setters all return the instance.
    # This is not the case with the native implementation.
    #
    # The `UTC*` methods behave slightly differently under the hood because of
    # TzTime's time-zone-awareness, but should provide the same API and
    # expected behavior.
    #

    # #### `#getTimezoneOffset()`
    #
    # This method is different from the native implementation. It returns the
    # actual time zone set on the TzTime instance instead of the local time
    # zone of the platform. Like the native implementation, it returns the
    # opposite of the actual UTC offset in integer minutes.
    #
    getTimezoneOffset: () ->
      -@__timezone__

    # #### `#setTimezoneOffset(v)`
    #
    # Sets the time zone using the reverse offset. This is a counterpart of
    # `#getTimezoneOffset()` that is missing in the native implementation. It
    # is here for the sake of compatibility with `#getTimezoneOffset()` but you
    # are generally recommended to use the `#timezone` attribute instead.
    #
    # `v` should be a reverse offset from UTC in integer minutes.
    #
    setTimezoneOffset: (v) ->
      ## Note that the exceptions thrown here are not in the tests. This is
      ## bacause Chai does not support exception assertions when we are using
      ## accessors.
      v = parseInt v
      if isNaN v
        throw new TypeError "Time zone offset must be an integer."
      if -720 > v > 720
        throw new TypeError "Time zone offset out of bounds."
      @__timezone__ = -v

    # #### `#getFullYear()`
    #
    # Returns the full integer year with century in the instance's time zone.
    #
    # #### `#getMonth()`
    #
    # Returns the 0-indexed integer month. 0 is January. The return value is in
    # the instance's time zone.
    #
    # #### `#getDate()`
    #
    # Returns the integer date (1-31) in the instance's time zone.
    #
    # #### `#getHours()`
    #
    # Returns the 24-hour format hour (0-23) in the instance's time zone.
    #
    # #### `#getMinutes()`
    #
    # Returns the minutes (0-59) in the instance's time zone.
    #
    # #### `#getSeconds()`
    #
    # Returns the seconds (0-59) in the instance's time zone.
    #
    # #### `#getMilliseconds()`
    #
    # Returns the milliseconds (0-999) in the instance's time zone.
    #
    # #### `#setFullYear(year [, month, date])`
    #
    # Sets the year, and optionally month and date. The arguments are the same
    # as for the native Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # #### `#setMonth(month [, date])`
    #
    # Sets the month, and optionally date. The arguments are the same as for
    # the native Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # #### `#setDate(date)`
    #
    # Sets the date. The argument is the same as for the native Date
    # prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # #### `#setHours(hours [, minutes, seconds, milliseconds])`
    #
    # Sets the hours, and optionally minutes, seconds and milliseconds if
    # specified. The argumetns are the same as for the native Date prototype's
    # method.
    #
    # The return value of this method is the TzTime object.
    #
    # #### `#setMinutes(minutes [, seconds, milliseconds])`
    #
    # Set the minutes and optionally seconds and milliseconds. The arguments
    # are the same as for the native Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # #### `#setSeconds(seconds [, milliseconds])
    #
    # Set the seconds, and optionally milliseconds. The arguments are the same
    # as for the native Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # #### `#setMilliseconds(milliseconds)`
    #
    # Sets the milliseconds. The argument is the same as for the native Date
    # prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    ((proto) ->
      methods = [
        'FullYear'
        'Month'
        'Date'
        'Hours'
        'Minutes'
        'Seconds'
        'Milliseconds'
      ]

      for method in methods
        ## Create setters
        if method isnt 'Hours'
          proto['set' + method] = ((method) ->
            () ->
              Date.prototype['setUTC' + method].apply this, arguments
              this
          ) method

        ## Crate getters
        proto['get' + method] = ((method) ->
          ## Create a closure for `method` so it doesn't get overrun by
          ## iteration.
          () ->
            ## Clone the `this` using plain Date object
            d = new Date this.getTime()
            ## Adjust for timezone difference
            d.setUTCMinutes d.getUTCMinutes() + @__timezone__
            ## Return the adjusted value
            d['getUTC' + method]()
        ) method
    ) TzTime.prototype

    setHours: () ->
      ## Set using UTC version of the method
      Date::setUTCHours.apply this, arguments
      ## Adjust for the timezone difference
      utcmins = Date.prototype.getUTCMinutes.call this
      delta = utcmins - @__timezone__
      Date.prototype.setUTCMinutes.call this, delta
      this

  # ### `TzTime.utils`
  #
  # Utility functions for micro-formatting.
  #
  # The `TzTime.utils` contains a few utility methods that are used to perform
  # formatting and calculation tasks, mainly used by `strptime` and `strftime`
  # functions.
  #
  TzTime.utils =

    # ### `TzTime.utils.repeat(s, count)`
    #
    # Repeat string `s` `count` times.
    #
    repeat: (s, count) ->
      new Array(count + 1).join s

    # ### `TzTime.utils.reverse(s)`
    #
    # Reverses a string.
    #
    reverse: (s) ->
      s.split('').reverse().join('')

    # ### `TzTime.utils.pad(i, [digits, tail])`
    #
    # Zero-pads a number `i`.
    #
    # `digits` argument specifies the total number of digits. If omitted, it will
    # default to 3 for no particular reason. :)
    #
    # If `tail` argument is specified, the number will be considered a float, and
    # will zero-padded from the tail as well. The `tail` should be the number of
    # fractional digits after the dot.
    #
    # Tail is `false` by default. If you pass it a 0, it will floor the number
    # instead of not tailing, by removing the fractional part.
    #
    # Example:
    #
    #     datetime.utils.pad(12, 4);
    #     // returns '0012'
    #
    #     datetime.utils.pad(2.3, 5);
    #     // 002.3
    #
    #     datetime.utils.pad(2.3, 5, 0);
    #     // 00002
    #
    #     datetime.utils.pad(2.3, 2, 2);
    #     // 02.30
    #
    pad: (i, digits=3, tail=false) ->
      if tail is false
        (TzTime.utils.repeat('0', digits) + i).slice -digits
      else
        [h, t] = i.toString().split('.')
        if tail is 0
          TzTime.utils.pad h, digits, false
        else
          t or= '0'
          h = TzTime.utils.pad h, digits, false
          t = TzTime.utils.pad TzTime.utils.reverse(t), tail, false
          t = TzTime.utils.reverse t
          [h, t].join('.')

    # ### `TzTime.utils.cycle(i, max, [zeroIndex])`
    #
    # Keeps the number `i` within the `max` range. The range starts at 0 if
    # `zeroIndex` is `true` or 1 if `zeroIndex` is `false` (default).
    #
    # Example:
    #
    #     TzTime.utils.cycle(4, 12);
    #     // Returns 4
    #
    #     TzTime.utils.cycle(13, 12);
    #     // Returns 1
    #
    #     TzTime.utils.cycle(13, 12, true);
    #     // Returns 1
    #
    #     TzTime.utils.cycle(12, 12, true);
    #     // Returns 0
    #
    #     TzTime.utils.cycle(12, 12, false);
    #     // Returns 12
    #
    cycle: (i, max, zeroIndex=false) ->
      i % max or if zeroIndex then 0 else max

    # ### `TzTime.utils.hour24(h, [pm])`
    #
    # Converts the `h` hour into 24-hour format. The `pm` is `true` if the hour
    # is PM. The `pm` argument defaults to `false`.
    #
    hour24: (h, pm=false) ->
      h += (if pm then 12 else 0)
      return 0 if h is 12
      return 12 if h is 24
      h

  TzTime
