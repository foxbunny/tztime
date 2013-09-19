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
  DAY_MS = 86400000

  # ## `TzTime` constructor
  #
  # Crates a JavaScript Date object with enhanced API and time zone awareness.
  #
  # Most of the native Date's API is retained. However, some time-zone-related
  # methods like `#getTimezoneOffset()` have been modified to support time zone
  # manipulation.
  #
  # During development, we have decided to not inherit from the Date prototype
  # directly. Therefore, TzTime provides a subset of methods that Date
  # prototype offers. Deprecated or seldom used methods have been omitted.
  #
  # While some of the methods are simple wrappers around native methods, others
  # may provide altered behavior. For example, all setters will return the
  # object for chaining instaed of a numeric value. Most getters, on the other
  # hand, should work as expected.
  #
  class TzTime

    ## Wrapper to make defining accessors easier
    property  = (name, descriptor) ->
      Object.defineProperty TzTime.prototype, name, descriptor

    ## Wrapper to make defining static accessors easier
    staticProperty  = (name, descriptor) ->
      Object.defineProperty TzTime, name, descriptor

    ## Create a method on `TzTime.prototype` that wraps the native method
    wrap = (name) ->
      TzTime.prototype[name] = () ->
        @__datetime__[name] arguments...

    ## Crate a method on `TzTime.prototype` that wraps the native method and
    ## returns the instance.
    wrapReturn = (name) ->
      TzTime.prototype[name] = () ->
        @__datetime__[name] arguments...
        this

    ## All setter and getter methods without the `set` and `get` parts.
    METHODS = [
      'FullYear'
      'Month'
      'Date'
      'Day'
      'Hours'
      'Minutes'
      'Seconds'
      'Milliseconds'
    ]

    TZ_AWARE_METHODS = [
      'FullYear'
      'Month'
      'Date'
      'Day'
      'Hours'
      'Minutes'
    ]

    NON_TZ_AWARE_GETTERS = [
      'Seconds'
      'Milliseconds'
    ]

    NON_TZ_AWARE_SETTERS = [
      'Minutes',
      'Seconds',
      'Milliseconds'
    ]

    # ### Syntax
    #
    # The Date-compatible syntax is as follows:
    #
    #     [new] TzTime();
    #     [new] TzTime(value);
    #     [new] TzTime(dateString);
    #     [new] TzTime(year, month, day [, hour, minute, second, millisecond]);
    #
    # All constructor arguments are compliant with the standard JavaScript Date
    # constructor arguments. Please refer to [Date
    # documentation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date)
    # for more information.
    #
    # There are a few non-compatible syntaxes that were added to take advantage
    # of features unique to TzTime:
    #
    #     [new] TimeZone(year, month, day, hour, minute, second, millsecond, tz);
    #     [new] TimeZone(dateObject);
    #     [new] TimeZone(tzTimeObject);
    #     [new] TimeZone(str, format); // same as TzTime.parse()
    #     [new] TimeZone(str, tz); // same as TzTime.parse()
    #     [new] TimeZone(str, format, tz); // same as TzTime.parse()
    #     [new] TimeZone(value, tz);
    #
    # The `tz` argument is a time zone UTC offset in integer minutes (postive
    # towards East, and negative towards West).
    #
    # The `dateObject` and `tzTimeObject` are Date and TzTime objects
    # respectively. Constructor will return a completely new instance of those
    # objects and, in case of TzTime objects, also retain the time zone offset.
    #
    # The `str` is a string representation of a date and/or time.
    #
    # The `format` argument is a formatting string compatible with
    # `TzTime.parse()` method.
    #
    # In the last non-standard form, the `value` is the number of milliseconds
    # since 1 January, 1970 UTC, or 'Unix epoch' (same as the form with a
    # single numeric argument).
    #
    # Unlike the JavaScript Date constructor, calling TzTime without the `new`
    # keyword has the same behavior as calling it with it.
    #
    constructor: (yr, mo, dy, hr=0, mi=0, se=0, ms=0, tz=null) ->

      if not (this instanceof TzTime)
        return new TzTime arguments...

      ## Because of the way native Date constructor works, we must resort to
      ## argument-counting.
      switch arguments.length
        when 0
          instance = new Date()
        when 1
          if yr instanceof TzTime
            instance = new Date yr.getTime()
            @__tz__ = yr.timezone
          else if yr instanceof Date
            instance = new Date yr.getTime()
          else
            instance = new Date yr
        when 2
          if typeof yr is 'string'
            return TzTime.parse yr, mo
          instance = new Date yr
          @__tz__ = mo
        when 3
          if typeof yr is 'string'
            return TzTime.parse yr, mo, dy
          instance = new Date yr, mo, dy
        when 8
          ## When time zone is passed as an argument, first create the the unix
          ## epoch using other arguments as if they were UTC, then shift the
          ## unix epoch by the time zone offset in milliseconds.
          t = Date.UTC yr, mo, dy, hr, mi, se, ms
          t -= tz * 60 * 1000
          instance = new Date t
          @__tz__ = tz
        else
          instance = new Date yr, mo, dy, hr, mi, se, ms

      # ## Private properties
      #
      # There are a few private properties that are used in most TzTime
      # methods. Since JavaScript does not have truly private properties, it is
      # just a convention not to touch these properties. They are documented
      # here since it may sometimes be useful to access them for
      # troubleshooting. Otherwise, you shouldn't expect the API stability
      # and/or usefulness of using these properties directly.
      #

      # ### `#__tz__`
      #
      # Stores the currently set timezone offset. This property is used to
      # calcualte the correct UTC time. Please do not override this property.
      #
      # To set the time zone use either `#timezone` attribute, or
      # `#setTimezoneOffset()` method.
      #
      @__tz__ = -instance.getTimezoneOffset() if not @__tz__?

      # ### `#__datetime__`
      #
      # This is a reference to the underlaying Date object that is queried to
      # return all values necessary for TzTime object to function.
      #
      @__datetime__ = instance

      @constructor = TzTime

    # ## Attributes
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

    # ### `#timezone`
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
    # The semantic of setting the time zone is changing just the time zone
    # without changing the local _time_. When setting the timezone, the local
    # time of the instance remains the same, while the UTC time of the instance
    # is shifted.
    #
    property 'timezone',
      get: () -> -@getTimezoneOffset()
      set: (v) -> @setTimezoneOffset -v

    # ### `#year`
    #
    # Full integer year in instance's time zone. The value is an integer.
    #
    property 'year',
      get: () -> @getFullYear()
      set: (v) -> @setFullYear v

    # ### `#month`
    #
    # Month in instance's time zone. The value is an integer between 0 and 11
    # where 0 is January.
    #
    # Setting values outside the rage will adjust other attributes accordingly.
    #
    property 'month',
      get: () -> @getMonth()
      set: (v) -> @setMonth v

    # ### `#date`
    #
    # Date in instance's time zone. The value is an integer between 1 and 31.
    #
    # Setting values outside the rage will adjust other attributes accordingly.
    #
    property 'date',
      get: () -> @getDate()
      set: (v) -> @setDate v

    # ### `#day`
    #
    # Day of week in instance's time zone. The value is an integer between 0
    # and 6 where 0 is Sunday and 6 is Saturday.
    #
    # This is a read-only attribute.
    #
    property 'day',
      get: () -> @getDay()
      set: () -> throw new TypeError "Cannot assign to day"

    # ### `#hours`
    #
    # Hours in 24-hour format in instance's time zone. The value is an integer
    # between 0 and 23.
    #
    # Setting values outside the rage will adjust other attributes accordingly.
    #
    property 'hours',
      get: () -> @getHours()
      set: (v) -> @setHours v

    # ### `#minutes`
    #
    # Minutes in instace's time zone. The value is an integer between 0 and 59.
    #
    # Setting values outside the rage will adjust other attributes accordingly.
    #
    property 'minutes',
      get: () -> @getMinutes()
      set: (v) -> @setMinutes v

    # ### `#seconds`
    #
    # Seconds in instance's time zome. The value is an integer between 0 and
    # 59.
    #
    # Setting values outside the rage will adjust other attributes accordingly.
    #
    property 'seconds',
      get: () -> @getSeconds()
      set: (v) -> @setSeconds v

    # ### `#milliseconds`
    #
    # Milliseconds in instance's time zone. The value is an integer between 0
    # and 999.
    #
    # Setting values outside the rage will adjust other attributes accordingly.
    #
    property 'milliseconds',
      get: () -> @getMilliseconds()
      set: (v) -> @setMilliseconds v

    # ### `#dayOfYear`
    #
    # Number of days since January 1st. The value is an integer between 0 and
    # 365 (366 for leap years).
    #
    # Setting values outside the range will adjust other attributes
    # accordingly.
    #
    property 'dayOfYear',
      get: () -> @getDayOfYear()
      set: (v) -> @setDayOfYear v

    # ### `#utcYear`
    #
    # The full year with century in UTC time zone. The value is an integer.
    #
    property 'utcYear',
      get: () -> @getUTCFullYear()
      set: (v) -> @setUTCFullYear v

    # ### `#utcMonth`
    #
    # Month in UTC time zone. The value is an integer between 0 and 11 where 0
    # is January.
    #
    # Setting values outside the rage will adjust other attributes accordingly.
    #
    property 'utcMonth',
      get: () -> @getUTCMonth()
      set: (v) -> @setUTCMonth v

    # ### `#utcDate`
    #
    # Date in UTC time zone. The value is an integer between 1 and 31.
    #
    # Setting values outside the rage will adjust other attributes accordingly.
    #
    property 'utcDate',
      get: () -> @getUTCDate()
      set: (v) -> @setUTCDate v

    # ### `#utcDay`
    #
    # Day of week in UTC time zone. The value is an integer between 0 and 6
    # where 0 is Sunday, and 6 is Saturday.
    #
    # This is a read-only attribute.
    #
    property 'utcDay',
      get: () -> @getUTCDay()
      set: () -> throw new TypeError "Cannot assign to utcDay"

    # ### `#utcHours`
    #
    # Hours in UTC time zone. The value is an integer between 0 and 23.
    #
    # Setting values outside the rage will adjust other attributes accordingly.
    #
    property 'utcHours',
      get: () -> @getUTCHours()
      set: (v) -> @setUTCHours v

    # ### `#utcMinutes`
    #
    # Minutes in UTC time zone. The value is an integer between 0 and 59.
    #
    # Setting values outside the rage will adjust other attributes accordingly.
    #
    property 'utcMinutes',
      get: () -> @getUTCMinutes()
      set: (v) -> @setUTCMinutes v

    # ### `#utcSeconds`
    #
    # Seconds in UTC time zone. The value is an integer between 0 and 59.
    #
    # Setting values outside the rage will adjust other attributes accordingly.
    #
    property 'utcSeconds',
      get: () -> @getUTCSeconds()
      set: (v) -> @setUTCSeconds v

    # ### `#utcMilliseconds`
    #
    # Milliseconds in UTC time zone. The value is an integer between 0 and 999.
    #
    # Setting values outside the rage will adjust other attributes accordingly.
    #
    property 'utcMilliseconds',
      get: () -> @getUTCMilliseconds()
      set: (v) -> @setUTCMilliseconds v

    # ## Methods
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

    # ### `#getTimezoneOffset()`
    #
    # This method is different from the native implementation. It returns the
    # actual time zone set on the TzTime instance instead of the local time
    # zone of the platform. Like the native implementation, it returns the
    # opposite of the actual UTC offset in integer minutes.
    #
    getTimezoneOffset: () ->
      -@__tz__

    # ### `#setTimezoneOffset(v)`
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
      v = -v
      delta = v - @__tz__
      @__tz__ = v
      @setUTCMinutes @getUTCMinutes() - delta
      this

    # ### `#getFullYear()`
    #
    # Returns the full integer year with century in the instance's time zone.
    #
    # ### `#getMonth()`
    #
    # Returns the 0-indexed integer month. 0 is January. The return value is in
    # the instance's time zone.
    #
    # ### `#getDate()`
    #
    # Returns the integer date (1-31) in the instance's time zone.
    #
    # ### `#getDay()`
    #
    # Returns the integer day of week (0-6) in instace's time zone. 0 is
    # Sunday, and 6 is Saturday.
    #
    # ### `#getHours()`
    #
    # Returns the 24-hour format hour (0-23) in the instance's time zone.
    #
    # ### `#getMinutes()`
    #
    # Returns the minutes (0-59) in the instance's time zone.
    #
    # ### `#getSeconds()`
    #
    # Returns the seconds (0-59) in the instance's time zone.
    #
    # ### `#getMilliseconds()`
    #
    # Returns the milliseconds (0-999) in the instance's time zone.
    #
    # ### `#setFullYear(year [, month, date])`
    #
    # Sets the year, and optionally month and date. The arguments are the same
    # as for the native Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#setMonth(month [, date])`
    #
    # Sets the month, and optionally date. The arguments are the same as for
    # the native Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#setDate(date)`
    #
    # Sets the date. The argument is the same as for the native Date
    # prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#setHours(hours [, minutes, seconds, milliseconds])`
    #
    # Sets the hours, and optionally minutes, seconds and milliseconds if
    # specified. The argumetns are the same as for the native Date prototype's
    # method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#setMinutes(minutes [, seconds, milliseconds])`
    #
    # Set the minutes and optionally seconds and milliseconds. The arguments
    # are the same as for the native Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#setSeconds(seconds [, milliseconds])`
    #
    # Set the seconds, and optionally milliseconds. The arguments are the same
    # as for the native Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#setMilliseconds(milliseconds)`
    #
    # Sets the milliseconds. The argument is the same as for the native Date
    # prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#getUTCFullYear()`
    #
    # Returns the full integer year with century in UTC.
    #
    # ### `#getUTCMonth()`
    #
    # Returns the 0-indexed integer month. 0 is January. The return value is in
    # UTC.
    #
    # ### `#getUTCDate()`
    #
    # Returns the integer date (1-31) in UTC.
    #
    # ### `#getUTCDay()`
    #
    # Returns the integer day of week (0-6) in instace's time zone. 0 is
    # Sunday, and 6 is Saturday. Return value is in UTC.
    #
    # ### `#getUTCHours()`
    #
    # Returns the 24-hour format hour (0-23) in UTC.
    #
    # ### `#getUTCMinutes()`
    #
    # Returns the minutes (0-59) in UTC.
    #
    # ### `#getUTCSeconds()`
    #
    # Returns the seconds (0-59) in UTC.
    #
    # ### `#getUTCMilliseconds()`
    #
    # Returns the milliseconds (0-999) in UTC.
    #
    # ### `#setUTCFullYear(year [, month, date])`
    #
    # Sets the year, and optionally month and date in UTC. The arguments are
    # the same as for the native Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#setUTCMonth(month [, date])`
    #
    # Sets the month, and optionally date in UTC. The arguments are the same as
    # for the native Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#setUTCDate(date)`
    #
    # Sets the date in UTC. The argument is the same as for the native Date
    # prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#setUTCHours(hours [, minutes, seconds, milliseconds])`
    #
    # Sets the hours, and optionally minutes, seconds and milliseconds if
    # specified in UTC. The argumetns are the same as for the native Date
    # prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#setUTCMinutes(minutes [, seconds, milliseconds])`
    #
    # Set the minutes and optionally seconds and milliseconds in UTC. The
    # arguments are the same as for the native Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#setUTCSeconds(seconds [, milliseconds])`
    #
    # Set the seconds, and optionally milliseconds in UTC. The arguments are
    # the same as for the native Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#setUTCMilliseconds(milliseconds)`
    #
    # Sets the milliseconds in UTC. The argument is the same as for the native
    # Date prototype's method.
    #
    # The return value of this method is the TzTime object.
    #
    # ### `#toDateString()`
    #
    # Returns the date portion as human-readable string.
    #
    # ### `#toISOString()`
    #
    # Returns the date and time in ISO 8601 extended format.
    #
    # ### `#toJSON()`
    #
    # Same as `#toISOString`.
    #
    # ### `#toLocaleDateString()`
    #
    # Returns the date portion in locale-specific format.
    #
    # ### `#toLocaleString()`
    #
    # Returns the date and time in local-specific format.
    #
    # ### `#toLocaleTimeString()`
    #
    # Returns the time portion in locale-specific format.
    #
    # ### `#toString()`
    #
    # Returns the string representation of the date and time object. Note that
    # this string usually includes a time zone. However, the time zone has
    # nothing to do with the timezone associated with the instance (it is
    # always in the local time zone of the platform).
    #
    # ### `#toTimeString()`
    #
    # Returns the time portion of the string returned by `#toString()`. Note
    # that the time zone returned by this method has nothing to do with the
    # timezone associated with the instance (it is always in the local time
    # zone of the platform).
    #
    # ### `#toUTCString()`
    #
    # Returns a human-friendly representation of the date and time in GMT.
    #
    # ### `#valueOf()`
    #
    # Returns the base value of the instance in milliseconds since Unix epoch.
    # (Essentially the same as `#getTime()`).
    #
    # ### `#getTime()`
    #
    # Returns the number of milliseconds since Unix epoch.
    #
    # ### `#setTime(milliseconds)`
    #
    # Sets the number of milliseconds since Unix epoch.
    #
    wrap m for m in [
      'toDateString'
      'toISOString'
      'toJSON'
      'toLocaleDateString'
      'toLocaleString'
      'toLocaleTimeString'
      'toString'
      'toTimeString'
      'toUTCString'
      'valueOf'
      'getTime'
    ]

    wrapReturn 'setTime'
    wrapReturn 'setUTC' + m for m in METHODS if m isnt 'Day'
    wrapReturn 'set' + m for m in NON_TZ_AWARE_SETTERS
    wrap 'getUTC' + m for m in METHODS
    wrap 'get' + m for m in NON_TZ_AWARE_GETTERS

    ((proto) ->
      for method in TZ_AWARE_METHODS
        ## Create setters
        proto['set' + method] = ((method) ->
          () ->
            this['setUTC' + method] arguments...
            ## Adjust for the timezone difference
            time = @getTime()
            delta = time - @timezone * 60 * 1000
            @setTime delta
            ## Return the instance
            this
        ) method if not (method in ['Day', 'Minutes'])

        ## Create getters
        proto['get' + method] = ((method) ->
          ## Create a closure for `method` so it doesn't get overrun by
          ## iteration.
          () ->
            ## Create a clone of the instance using Date constructor and time
            ## shifted by the time zone offset, then use the UTC getter to
            ## return the value.
            d = new Date @getTime() + @timezone * 60 * 1000
            d['getUTC' + method]()
        ) method

      return
    ) TzTime.prototype

    # ### `#getDayOfYear()`
    #
    # Returns the number of days since January 1st.
    #
    getDayOfYear: () ->
      t = TzTime this.year, 0, 1
      diff = this.getTime() - t.getTime()
      Math.round(diff / DAY_MS) + 1

    # ### `#setDayOfYear(days)`
    #
    # Sets the date by setting the number of days since January 1st. The
    # argument is an ingteger from 0 to 365 (or 366 in leap years).
    #
    # Setting values outside the range will adjust other attributes
    # accordingly.
    #
    setDayOfYear: (d) ->
      this.month = 0
      this.date = d

    # ### `#toSource()`
    #
    # Returns the source code representation.
    #
    toSource: () ->
      "(new TzTime(#{this.getTime()}, #{this.timezone}))"

    # ### `#toFormat([format])`
    #
    # Formats date and time using `format` formatting string. The formatting
    # uses strftime-compatible syntax with follwing tokens:
    #
    #  + %a - Short week day name (e.g. 'Sun', 'Mon'...)
    #  + %A - Long week day name (e.g., 'Sunday', 'Monday'...)
    #  + %b - Short month name (e.g., 'Jan', 'Feb'...)
    #  + %B - Full month name (e.g., 'January', 'February'...)
    #  + %c - Locale-formatted date and time (platform-dependent)
    #  + %d - Zero-padded date (e.g, 02, 31...)
    #  + %D - Non-zero-padded date (e.g., 2, 31...)
    #  + %f - Zero-padded decimal seconds (e.g., 04.23, 23.50)
    #  + %F - Zero-padded decimal seconds with 3-digit fraction (e.g., 04.233)
    #  + %H - Zero-padded hour in 24-hour format (e.g., 8, 13, 0...)
    #  + %i - Non-zero-padded hour in 12-hour format (e.g., 8, 1, 12...)
    #  + %I - Zero-padded hour in 12-hour format (e.g., 08, 01, 12...)
    #  + %j - Zero-padded day of year (e.g., 002, 145, 364...)
    #  + %m - Zero-padded month (e.g., 01, 02...)
    #  + %M - Zero-padded minutes (e.g., 01, 12, 59...)
    #  + %n - Non-zero-padded month (e.g., 1, 2...)
    #  + %N - Non-zero-padded minutes (e.g., 1, 12, 59)
    #  + %p - AM/PM (a.m. and p.m.)
    #  + %s - Non-zero-padded seconds (e.g., 1, 2, 50...)
    #  + %S - Zero-padded seconds (e.g., 01, 02, 50...)
    #  + %r - Milliseconds (e.g., 1, 24, 500...)
    #  + %w - Numeric week day where 0 is Sunday (e.g., 0, 1...)
    #  + %y - Zero-padded year without the century part (e.g., 01, 13, 99...)
    #  + %Y - Full year (e.g., 2001, 2013, 2099...)
    #  + %z - Timezone in +HHMM or -HHMM format (e.g., +0200, -0530)
    #  + %x - Locale-formatted date (platform dependent)
    #  + %X - Locale-formatted time (platform dependent)
    #  + %% - Literal percent character %
    #
    # Because of the formatting token usage, you may safely mix non-date strings
    # in the formatting string. For example:
    #
    #     var t = new TzTime();
    #     t.toFormat('On %b %d at %i:%M %p');
    #
    # If `format` string is omitted, `TzTime.DEFAULT_FORMAT` setting is used.
    #
    toFormat: (format=TzTime.DEFAULT_FORMAT) ->
      for token of TzTime.FORMAT_TOKENS
        r = new RegExp token, 'g'
        format = format.replace r, () =>
          TzTime.FORMAT_TOKENS[token].call this
      format

    # ### `#strftime([format])`
    #
    # Alias for `#toFormat()` method.
    #
    TzTime::strftime = TzTime::toFormat

    # ### `#resetTime()`
    #
    # Resets the time portion of the object to 0:00:00.000.
    #
    resetTime: () ->
      this.hours = this.minutes = this.seconds = this.milliseconds = 0
      this

    # ### `#equals(t)`
    #
    # Whether object represents the same time as `t`. `t` can be a `TzTime` or
    # a `Date` object.
    #
    equals: (t) ->
      t >= this and t <= this

    # ### `#isAfter(t)`
    #
    # Whether object is after `t`. `t` can be either anohter `TzTime` or a
    # `Date` object.
    #
    # Note that if `t` is equal to this object, it is considered to not be
    # after it.
    #
    isAfter: (t) ->
      t < this

    # ### `#isBefore(t)`
    #
    # Whether object is before `t`. `t` can be either another `TzTime` or a
    # `Date` object.
    #
    # Note that if `t` is equal to this object, it is considered to not be
    # before it.
    #
    isBefore: (t) ->
      t > this

    # ### `#isBetween(t1, t2)`
    #
    # Whther object is between `t1` and `t2`. `t1` and `t2` can be either
    # `TzTime` or `Date` objects.
    #
    # Note that if `t1` or `t2` is equal to this object, this object is not
    # considered to be between `t1` and `t2`.
    #
    # The order of `t1` and `t2` does not matter.
    #
    isBetween: (t1, t2) ->
      t1 > this > t2 or t1 < this < t2

    # ### `#dateEquals(t)`
    #
    # Whether this object represents the same date as `t`. `t` can be either
    # `TzTime` or `Date` object.
    #
    dateEquals: (t) ->
      copy = new TzTime this
      t = new TzTime t
      copy.resetTime()
      t.resetTime()
      t >= copy and t <= copy

    # ### `#isDateAfter(t)`
    #
    # Whether this object is after `t` by date. `t` can be either another
    # `TzTime` or `Date` object.
    #
    isDateAfter: (t) ->
      copy = new TzTime this
      t = new TzTime t
      copy.resetTime()
      t.resetTime()
      copy > t

    # ### `#isDateBefore(t)`
    #
    # Whether this object is before `t` by date. `t` can be either another
    # `TzTime` or `Date` object.
    #
    isDateBefore: (t) ->
      copy = new TzTime this
      t = new TzTime t
      copy.resetTime()
      t.resetTime()
      copy < t

    # ### `#isDateBetween(t1, t2)`
    #
    # Whether this object is between `t1` and `t2` by date. The two arguments
    # can either be `TzTime` or `Date` objects.
    #
    # Note that if `t1` or `t2` equals this object, this object is not
    # considered to be between them.
    #
    # The order of `t1` and `t2` does not matter.
    #
    isDateBetween: (t1, t2) ->
      copy = new TzTime this
      t1 = new TzTime t1
      t2 = new TzTime t2
      copy.resetTime()
      t1.resetTime()
      t2.resetTime()
      t1 < copy < t2 or t1 > copy > t2

    # ### `#delta(t)`
    #
    # Calculates the difference between this instance and `t`, another `TzTime`
    # objects or a `Date` object and returns a delta object. The delta object
    # has the following structure:
    #
    #     d.delta // relative difference
    #     d.milliseconds // difference in milliseconds (same as delta)
    #     d.seconds // difference rounded to seconds with no decimals
    #     d.minutes // difference rounded to minutes with no decimals
    #     d.hours // difference rounded to hours with no decimals
    #     d.days // difference rounded to days with no decimals
    #     d.composite // composite difference
    #
    # Relative difference means the difference between this object and `t`
    # relative to this object. This can be a negative or positive number in
    # milliseconds. All other values (including the `milliseconds` key) are
    # absolute, which means they are always positive.
    #
    # The composite difference is an array containing the total difference
    # broken down into days, hours, minutes, seconds, and milliseconds.
    #
    delta: (t) ->
      delta = t - this  # absolute delta in ms
      absD = Math.abs delta

      ## As a side note, the `~` operator is a bitwise NOT operator. It's an
      ## unary operator, which floors a number if chained twice. Not sure where
      ## I picked it up, but it seems to work fine.
      ##
      ## Here in the code below we use it to get the fraction part of float
      ## numbers by subtracting the number from the double-bitwise-negated
      ## version of the same number: x - ~~x

      days = absD / 1000 / 60 / 60 / 24  # diff in days, not rounded
      hrs = (days - ~~days) * 24 # fraction part of days in hours, not rounded
      mins = (hrs - ~~hrs) * 60 # fraction part of hours in minutes, not rounded
      secs = (mins - ~~mins) * 60 # fraction part of mins in seconds, not rounded
      msecs = (secs - ~~secs) * 1000 # fraction part of secs in milliseconds

      delta: delta
      milliseconds: absD
      seconds: Math.ceil absD / 1000
      minutes: Math.ceil absD / 1000 / 60
      hours: Math.ceil absD / 1000 / 60 / 60
      days: Math.ceil days
      composite: [~~days, ~~hrs, ~~mins, ~~secs, msecs]


    # ## Static properties
    #

    # ### `TzTime.platformZone`
    #
    # Gets the time zone offset of the platform. This is a read-only attribute.
    #
    staticProperty 'platformZone',
      get: () -> -(new Date().getTimezoneOffset())
      set: () -> throw new TypeError "Cannot assign to platformZone"

    # ## Static methods
    #

    # ### `TzTime.reorder(d, d1 [, d2...])`
    #
    # Reorders the `TzTime` or `Date` objects from earliest to latest. The
    # return value is an array.
    #
    TzTime.reorder = (d...) ->
      d.sort (d1, d2) -> d1 - d2
      d

    # ### `TzTime.parse(s, [format, tz])`
    #
    # Parse a string `s` and return a `Date` object. The `format` string is
    # used to specify the format in which `s` date is represented.
    #
    # The `tz` argument is a time zone offset to use as an override for the
    # time zone found in the string (if any). If it is 0 or `true`, UTC is used
    # instead of an offset. If it is undefined or `null`, no time zone
    # override is performed.
    #
    # A subset of `#toFormat()` tokens is used in parsing.
    #
    #  + %b - Short month name (e.g., 'Jan', 'Feb'...)
    #  + %B - Full month name (e.g., 'January', 'February'...)
    #  + %d - Zero-padded date (e.g, 02, 31...)
    #  + %D - Non-zero-padded date (e.g., 2, 31...)
    #  + %f - Zero-padded decimal seconds (e.g., 04.23, 23.50)
    #  + %F - Zero-padded decimal seconds with 3-digit fraction (e.g., 04.233)
    #  + %H - Zero-padded hour in 24-hour format (e.g., 8, 13, 0...)
    #  + %i - Non-zero-padded hour in 12-hour format (e.g., 8, 1, 12...)
    #  + %I - Zero-padded hour in 12-hour format (e.g., 08, 01, 12...)
    #  + %m - Zero-padded month (e.g., 01, 02...)
    #  + %M - Zero-padded minutes (e.g., 01, 12, 59...)
    #  + %n - Non-zero-padded month (e.g., 1, 2...)
    #  + %N - Non-zero-padded minutes (e.g., 1, 12, 59)
    #  + %p - AM/PM (a.m. and p.m.)
    #  + %s - Non-zero-padded seconds (e.g., 1, 2, 50...)
    #  + %S - Zero-padded seconds (e.g., 01, 02, 50...)
    #  + %r - Milliseconds (e.g., 1, 24, 500...)
    #  + %y - Zero-padded year without the century part (e.g., 01, 13, 99...)
    #  + %Y - Full year (e.g., 2001, 2013, 2099...)
    #  + %z - Time zone in +HHMM or -HHMM format or 'Z' (e.g., +1000, -0200)
    #
    # The `%z` token behaves slightly differently when parsing date and time
    # strings. In addition to formats that strftime outputs, it also supports
    # 'Z', which allows parsing of ISO timestamps.
    #
    # If `format` string is omitted, it will default to
    # `TzTime.DEFAULT_FORMAT`.
    #
    TzTime.parse = (s, format, tz) ->
      if typeof format isnt 'string'
        tz = format
        format = TzTime.DEFAULT_FORMAT
      if not format?
        format = TzTime.DEFAULT_FORMAT
      if not utc?
        utc = null

      ## Escape all regexp special characters
      rxp = format.replace /\\/, '\\\\'
      for schr in TzTime.REGEXP_CHARS
        rxp = rxp.replace new RegExp('\\' + schr, 'g'), "\\#{schr}"

      ## Build the regexp for matching parse tokens
      parseTokens = (key for key of TzTime.PARSE_RECIPES)
      parseTokenRe = new RegExp "(#{parseTokens.join '|'})", "g"

      ## Interpolate the format tokens and obtain converter functions
      converters = []
      rxp = rxp.replace parseTokenRe, (m, token) ->
        # Get the token regexp and parser function
        {re, fn} = TzTime.PARSE_RECIPES[token]()
        converters.push fn
        "(#{re})"

      rxp = new RegExp "^#{rxp}$", "i"

      ## Perform the match against the compiled parse regexp
      matches = s.match rxp

      ## We consider the parse failed if nothing matched
      return null if not matches

      ## Remove the first item from the matches, since we're not interested in it
      matches.shift()

      ## Prepare the meta object
      meta =
        year: 0
        month: 0
        date: 0
        hour: 0
        minute: 0
        second: 0
        millisecond: 0
        timeAdjust: null
        timezone: TzTime.platformZone

      ## Iterate parser functions and apply the function to each match
      for fn, idx in converters
        fn matches[idx], meta

      if meta.timeAdjust in [true, false]
        meta.hour = TzTime.utils.hour24(meta.hour, meta.timeAdjust)

      if tz is true
        meta.timezone = 0
      if typeof tz is 'number'
        meta.timezone = tz

      ## Create the `TzTime` object using meta data
      new TzTime meta.year,
        meta.month,
        meta.date,
        meta.hour,
        meta.minute,
        meta.second,
        meta.millisecond
        meta.timezone

    # ### `TzTime.strptime(s, [format])`
    #
    # Alias for `TzTime.parse()` method.
    #
    TzTime.strptime = TzTime.parse

    # ### `TzTime.fromJSON`
    #
    # Parses the string using the `TzTime.JSON_FORMAT` format string.
    #
    # Because `JSON.parse` returns a string when parsing a valid JSON
    # timestamp, we need to convert the string to a date by parsing the string.
    # `TzTime.fromJSON()` is a shortcut for performing this task by using a
    # prset format string and wrapping `TzTime.parse()`
    #
    TzTime.fromJSON = (s) ->
      TzTime.parse s, TzTime.JSON_FORMAT

  # ## Settings
  #

  # ### `TzTime.DAY_MS`
  #
  # Number of milliseconds in a day
  #
  TzTime.DAY_MS = DAY_MS = 86400000

  # ### `TzTime.REGEXP_CHARS`
  #
  # Array of regexp characters that should be escaped in a format string when
  # parsing dates and times.
  #
  TzTime.REGEXP_CHARS = '^$[]().{}+*?|'.split ''

  # ### `TzTime.MONTHS`
  #
  # Month names
  #
  TzTime.MONTHS = [
    'January'
    'February'
    'March'
    'April'
    'May'
    'June'
    'July'
    'August'
    'September'
    'October'
    'November'
    'December'
  ]

  # ### `TzTime.MNTH`
  #
  # Short month names (three-letter abbreviations).
  #
  TzTime.MNTH = [
    'Jan'
    'Feb'
    'Mar'
    'Apr'
    'May'
    'Jun'
    'Jul'
    'Aug'
    'Sep'
    'Oct'
    'Nov'
    'Dec'
  ]

  # ### `TzTime.DAYS`
  #
  # Week day names, starting with Sunday.
  #
  TzTime.DAYS = [
    'Sunday'
    'Monday'
    'Tuesday'
    'Wednesday'
    'Thursday'
    'Friday'
    'Saturday'
  ]

  # ### `TzTime.DY`
  #
  # Abbreviated week day names.
  #
  TzTime.DY = [
    'Sun'
    'Mon'
    'Tue'
    'Wed'
    'Thu'
    'Fri'
    'Sat'
  ]

  # ### `TzTime.AM`
  #
  # Ante-meridiem shorthand
  #
  TzTime.AM = 'a.m.'

  # ### `TzTime.PM`
  #
  # Post-meridiem shorthand
  #
  TzTime.PM = 'p.m.'


  # ### `TzTime.WEEK_START`
  #
  # Day the week starts on. 0 is Sunday, 1 is Monday, and so on.
  #
  TzTime.WEEK_START = 0

  # ### `TzTime.FORMAT_TOKENS`
  #
  # Definitions of formatting tokens used by the `#strftime()` method. All
  # format functions are applied to a `Date` object so the `Date` methods can
  # be called on `this`.
  #
  TzTime.FORMAT_TOKENS =
    ## Shorthand day-of-week name
    '%a': () -> TzTime.DY[@day]

    ## Full day-of-week name
    '%A': () -> TzTime.DAYS[@day]

    ## Shorthand three-letter month name
    '%b': () -> TzTime.MNTH[@month]

    ## Full month name
    '%B': () -> TzTime.MONTHS[@month]

    ## Locale-formatted date and time (dependent on browser/platform/device),
    ## here added for compatibility reasons.
    '%c': () -> @toLocaleString()

    ## Zero-padded date (day of month)
    '%d': () -> TzTime.utils.pad @date, 2

    ## * Non-zero-padded date (day of month)
    '%D': () -> "#{@date}"

    ## Zero-padded seconds with decimal part
    '%f': () ->
      fs = Math.round((@seconds + @milliseconds / 1000) * 100) / 100
      TzTime.utils.pad fs, 2, 2

    ## Zero-padded seconds with 3-digit decimal part.
    '%F': () ->
      fs = @seconds + @milliseconds / 1000
      TzTime.utils.pad fs, 2, 3

    ## Zero-padded hour in 24-hour format
    '%H': () -> TzTime.utils.pad @hours, 2

    ## * Non-zero-padded hour in 12-hour format
    '%i': () -> TzTime.utils.cycle @hours, 12

    ## Zero-padded hour in 12-hour format
    '%I': () -> TzTime.utils.pad TzTime.utils.cycle(@hours, 12), 2

    ## Zero-padded day of year
    '%j': () ->
      firstOfYear = new TzTime @year, 0, 1
      TzTime.utils.pad Math.ceil((this - firstOfYear) / TzTime.DAY_MS), 3

    ## Zero-padded numeric month
    '%m': () -> TzTime.utils.pad @month + 1, 2

    ## Zero-padded minutes
    '%M': () -> TzTime.utils.pad @minutes, 2

    ## * Non-zero-padded numeric month
    '%n': () -> "#{@month + 1}"

    ## * Non-zero-padded minutes
    '%N': () -> "#{@minutes}"

    ## am/pm
    '%p': () ->
      ((h) ->
        if 0 <= h < 12 then TzTime.AM else TzTime.PM
      ) @hours

    ## Non-zero-padded seconds
    '%s': () -> "#{@seconds}"

    ## Zero-padded seconds
    '%S': () -> TzTime.utils.pad @seconds, 2

    ## Milliseconds
    '%r': () -> "#{@milliseconds}"

    ## Numeric day of week (0 == Sunday)
    '%w': () -> "#{@day}"

    ## Last two digits of the year
    '%y': () -> "#{@year}"[-2..]

    ## Full year
    '%Y': () -> "#{@year}"

    ## Locale-formatted date (without time)
    '%x': () -> @toLocaleDateString()

    ## Locale-formatted time
    '%X': () -> @toLocaleTimeString()

    ## Timezone in +HHMM or -HHMM format
    '%z': () ->
      pfx = if @timezone >= 0 then '+' else '-'
      tz = Math.abs @timezone
      "#{pfx}#{TzTime.utils.pad ~~(tz / 60), 2}#{TzTime.utils.pad tz % 60, 2}"

    ## Literal percent character
    '%%': () -> '%'

    ## Unsupported
    '%U': () -> ''
    '%Z': () -> ''

  # ### `TzTime.PARSE_RECIPES`
  #
  # Functions for parsing the date.
  #
  # Each parser recipe corresponds to a format token. The recipe will return a
  # piece of regexp that will match the token within the string, and a function
  # that will convert the match.
  #
  # The converter function will take the matched string, and a meta object. The
  # meta object is later used as source of information for building the final
  # `Date` object.
  #
  TzTime.PARSE_RECIPES =
    '%b': () ->
      re: "#{TzTime.MNTH.join '|'}"
      fn: (s, meta) ->
        mlc = (mo.toLowerCase() for mo in TzTime.MNTH)
        meta.month = mlc.indexOf s.toLowerCase()
    '%B': () ->
      re: "#{TzTime.MONTHS.join '|'}"
      fn: (s, meta) ->
        mlc = (mo.toLowerCase() for mo in TzTime.MONTHS)
        meta.month = mlc.indexOf s.toLowerCase()
    '%d': () ->
      re: '[0-2][0-9]|3[01]'
      fn: (s, meta) ->
        meta.date = parseInt s, 10
    '%D': () ->
      re: '3[01]|[12]?\\d'
      fn: (s, meta) ->
        meta.date = parseInt s, 10
    '%f': () ->
      re: '[0-5]\\d\\.\\d{2}'
      fn: (s, meta) ->
        s = parseFloat s
        meta.second = ~~s
        meta.millisecond = Math.round((s - ~~s) * 1000)
    '%F': () ->
      re: '[0-5]\\d\\.\\d{3}'
      fn: (s, meta) ->
        s = parseFloat s
        meta.second = ~~s
        meta.millisecond = Math.round((s - ~~s) * 1000)
    '%H': () ->
      re: '[0-1]\\d|2[0-3]'
      fn: (s, meta) ->
        meta.hour = parseInt s, 10
    '%i': () ->
      re: '1[0-2]|\\d'
      fn: (s, meta) ->
        if meta.timeAdjust is null
          meta.timeAdjust = false
        meta.hour = parseInt s, 10
    '%I': () ->
      re: '0\\d|1[0-2]'
      fn: (s, meta) ->
        if meta.timeAdjust is null
          meta.timeAdjust = false
        meta.hour = parseInt s, 10
    '%m': () ->
      re: '0\\d|1[0-2]'
      fn: (s, meta) ->
        meta.month = parseInt(s, 10) - 1
    '%M': () ->
      re: '[0-5]\\d'
      fn: (s, meta) ->
        meta.minute = parseInt s, 10
    '%n': () ->
      re: '1[0-2]|\\d'
      fn: (s, meta) ->
        meta.month = parseInt(s, 10) - 1
    '%N': () ->
      re: '[1-5]?\\d'
      fn: (s, meta) ->
        meta.minute = parseInt s, 10
    '%p': () ->
      re: "#{TzTime.PM.replace(/\./g, '\\.')}|#{TzTime.AM.replace(/\./g, '\\.')}"
      fn: (s, meta) ->
        meta.timeAdjust = TzTime.PM.toLowerCase() is s.toLowerCase()
    '%s': () ->
      re: '[1-5]?\\d'
      fn: (s, meta) ->
        meta.second = parseInt s, 10
    '%S': () ->
      re: '[0-5]\\d'
      fn: (s, meta) ->
        meta.second = parseInt s, 10
    '%r': () ->
      re: '\\d{1,3}'
      fn: (s, meta) ->
        meta.millisecond = parseInt s, 10
    '%y': () ->
      re: '\\d{2}'
      fn: (s, meta) ->
        c = (new Date()).getFullYear().toString()[..1]  # century
        meta.year = parseInt c + s, 10
    '%Y': () ->
      re: '\\d{4}'
      fn: (s, meta) ->
        meta.year = parseInt s, 10
    '%z': () ->
      re: '[+-](?:1[01]|0\\d)[0-5]\\d|Z'
      fn: (s, meta) ->
        if s is 'Z'
          meta.timezone = 0
        else
          mult = if s[0] is '-' then 1 else -1
          h = parseInt s[1..2], 10
          m = parseInt s[3..4], 10
          meta.timezone = - mult * (h * 60) + m

  # ### `TzTime.DEFAULT_FORMAT`
  #
  # The default format string for formatting and parsing functions. Default is
  # '%Y-%m-%dT%H:%M:%S' (short ISO format without time zone).
  #
  TzTime.DEFAULT_FORMAT = '%Y-%m-%dT%H:%M:%S'

  # ### `TzTime.JSON_FORMAT`
  #
  # This formatting string is used to parse the date using the
  # `TzTime.fromJSON()` method. Default value is '%Y-%m-%dT%H:%M:%F%z' (full
  # ISO exended format).
  #
  TzTime.JSON_FORMAT = '%Y-%m-%dT%H:%M:%F%z'

  # ## `TzTime.utils`
  #
  # Utility functions for micro-formatting.
  #
  # The `TzTime.utils` contains a few utility methods that are used to perform
  # formatting and calculation tasks, mainly used by `strptime` and `strftime`
  # functions.
  #
  TzTime.utils =

    # ### `#repeat(s, count)`
    #
    # Repeat string `s` `count` times.
    #
    repeat: (s, count) ->
      new Array(count + 1).join s

    # ### `#reverse(s)`
    #
    # Reverses a string.
    #
    reverse: (s) ->
      s.split('').reverse().join('')

    # ### `#pad(i, [digits, tail])`
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

    # ### `#cycle(i, max, [zeroIndex])`
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

    # ### `#hour24(h, [pm])`
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
