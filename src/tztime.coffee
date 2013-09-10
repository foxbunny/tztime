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
  class TzTime
    # TzTime constructor inherits from the native Date prototype.
    #
    TzTime.prototype = Date.prototype

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

      return instance

