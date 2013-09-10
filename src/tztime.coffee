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
define = ((root, module) ->
  if typeof root.define is 'function' and root.define.amd
    root.define
  else
    if typeof module is 'object' and module.exports
      (factory) -> module.exports = factory()
    else
      (factory) -> root.TzTime = factory()
) this, module


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
    # One non-standard form is added:
    #
    #     new TzTime(dateString, format)
    #
    # The non-standard form will parse teh `dateString` using supplied `format`
    # string which is compatible with `strptime` formatting.
    #
    # Unlike the JavaScript Date constructor, calling TzTime without the `new`
    # keyword has the same behavior as calling it with it.
    #
    constructor: (yr, mo, dy, hr=0, mi=0, se=0, ms=0) ->

      ## Because of the way native Date constructor works, we must resort to
      ## argument-counting.
      switch arguments.length
        when 0
          instance = new Date()
        when 1
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
      get: () -> @__timezone__
      set: (v) ->
        ## Note that the exceptions thrown here are not in the tests. This is
        ## bacause Chai does not support exception assertions when we are using
        ## accessors.
        v = parseInt v
        if isNaN v
          throw new TypeError "Time zone offset must be an integer."
        if -720 > v > 720
          throw new TypeError "Time zone offset out of bounds."
        diff = @__timezone__ + v
        @setMinutes @getMinutes() + diff
        @__timezone__ = v
        v

    # #### `#year`
    #
    # Full integer year. The value is an integer.
    #
    property 'year',
      get: () -> @getFullYear()
      set: (v) -> @setFullYear v

    # #### `#month`
    #
    # Month. The value is 0-index where 0 is January.
    #
    property 'month',
      get: () -> @getMonth()
      set: (v) -> @setMonth v

    # #### `#date`
    #
    # Date. The value is an integer between 1 and 31.
    #
    property 'date',
      get: () -> @getDate()
      set: (v) -> @setDate v

    # #### `#hour`
    #
    # Hour in 24-hour format. The value is an integer between 0 and 23.
    #
    property 'hour',
      get: () -> @getHours()
      set: (v) -> @setHours v

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
      -@timezone

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
      @timezone = -v

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
        'setFullYear'
        'setMonth'
        'setDate'
        'setHours'
        'setMinutes'
        'setSeconds'
        'setMilliseconds'
        'setTime'
      ]

      for method in methods
        proto[method] = ((method) ->
          ## Create a closure for `method` so it doesn't get overrun by
          ## iteration.
          () ->
            Date.prototype[method].apply this, arguments
            this
        ) method
    ) TzTime.prototype
