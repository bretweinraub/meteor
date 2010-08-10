/////////////////////////////////////////////////////////////////////////////////////
// Then Modified by:
//      Ed Moss
//
// Modified and enhanced by: 
//      Nathaniel Brown - http://nshb.net
//      Email: nshb@inimit.com
//
// Created by: 
//      Simon Willison - http://simon.incutio.com
//
// License:
//      GNU Lesser General Public License version 2.1 or above.
//      http://www.gnu.org/licenses/lgpl.html
//
// Bugs:
//      Please submit bug reports to http://dev.toolbocks.com
//
/////////////////////////////////////////////////////////////////////////////////////


// Dates such as 2/29/2005 to rollover to 3/1/2005
var configAutoRollOver = true;

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

// Functions

function dateBocksKeyListener(event) {
  
  var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
  
	if (keyCode == 13 || keyCode == 10) {
		return false;
  }
}

function windowProperties(param_properties){
  var oRegex = new RegExp('');
  oRegex.compile( "(?:^|,)([^=]+)=(\\d+|yes|no|auto)", 'gim' );
  
  var oProperties = new Object();
  var oPropertiesMatch;
  
  while( ( oPropertiesMatch = oRegex.exec( param_properties ) ) != null )  {
    var sValue = oPropertiesMatch[2];
  
    if ( sValue == ( 'yes' || '1' ) ) {
    	oProperties[ oPropertiesMatch[1] ] = true;
    } else if ( (! isNaN( sValue ) && sValue != 0) || ('auto' == sValue ) ) {
    	oProperties[ oPropertiesMatch[1] ] = sValue;
    }
	}
	
	return oProperties;
}

function windowOpenCenter(window_url, window_name, window_properties){
  try {
    var oProperties = windowProperties(window_properties);
    
    //if( !oProperties['autocenter'] || oProperties['fullscreen'] ) {
    //  return window.open(window_url, window_name, window_properties);
    //}
    
    w = parseInt(oProperties['width']);
    h = parseInt(oProperties['height']);
    w = w > 0 ? w : 640;
    h = h > 0 ? h : 480;
    
    if (screen) {
      t = (screen.height - h) / 2;
      l = (screen.width - w) / 2;
    } else {
      t = 250;
      l = 250;
    }
    
    window_properties = (w>0?",width="+w:"") + (h>0?",height="+h:"") + (t>0?",top="+t:"") + (l>0?",left="+l:"") + "," + window_properties.replace(/,(width=\s*\d+\s*|height=\s*\d+\s*|top=\s*\d+\s*||left=\s*\d+\s*)/gi, "");
    return window.open(window_url, window_name, window_properties);
  } catch( e ) {};
}

// add indexOf function to Array type
// finds the index of the first occurence of item in the array, or -1 if not found
Array.prototype.indexOf = function(item) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == item) {
            return i;
        }
    }
    return -1;
};

// add filter function to Array type
// returns an array of items judged true by the passed in test function
Array.prototype.filter = function(test) {
    var matches = [];
    for (var i = 0; i < this.length; i++) {
        if (test(this[i])) {
            matches[matches.length] = this[i];
        }
    }
    return matches;
};

// add right function to String type
// returns the rightmost x characters
String.prototype.right = function( intLength ) {
   if (intLength >= this.length)
      return this;
   else
      return this.substr( this.length - intLength, intLength );
};

// add trim function to String type
// trims leading and trailing whitespace
String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };

// arrays for month and weekday names
var monthNames = "January February March April May June July August September October November December".split(" ");
var weekdayNames = "Sunday Monday Tuesday Wednesday Thursday Friday Saturday".split(" ");

/* Takes a string, returns the index of the month matching that string, throws
   an error if 0 or more than 1 matches
*/
function parseMonth(month) {
    var matches = monthNames.filter(function(item) { 
        return new RegExp("^" + month, "i").test(item);
    });
    if (matches.length == 0) {
        throw new Error("Invalid month string");
    }
    if (matches.length < 1) {
        throw new Error("Ambiguous month");
    }
    return monthNames.indexOf(matches[0]);
}

/* Same as parseMonth but for days of the week */
function parseWeekday(weekday) {
    var matches = weekdayNames.filter(function(item) {
        return new RegExp("^" + weekday, "i").test(item);
    });
    if (matches.length == 0) {
        throw new Error("Invalid day string");
    }
    if (matches.length < 1) {
        throw new Error("Ambiguous weekday");
    }
    return weekdayNames.indexOf(matches[0]);
}

function DateInRange( yyyy, mm, dd )
   {

   // if month out of range
   if ( mm < 0 || mm > 11 )
      throw new Error('Invalid month value.  Valid months values are 1 to 12');

   if (!configAutoRollOver) {
       // get last day in month
       var d = (11 == mm) ? new Date(yyyy + 1, 0, 0) : new Date(yyyy, mm + 1, 0);
    
       // if date out of range
       if ( dd < 1 || dd > d.getDate() )
          throw new Error('Invalid date value.  Valid date values for ' + monthNames[mm] + ' are 1 to ' + d.getDate().toString());
   }

   return true;

   }

function getDateObj(yyyy, mm, dd, hh, min, ss) {
    var obj = new Date();
    if (!hh) hh = 0;
    if (!min) min = 0;
    if (!ss) ss = 0;
    
    obj.setDate(1);
    obj.setYear(yyyy);
    obj.setMonth(mm);
    obj.setDate(dd);
    obj.setHours(hh);
    obj.setMinutes(min);
    obj.setSeconds(ss);
    
    return obj;
}

/* Array of objects, each has 're', a regular expression and 'handler', a 
   function for creating a date from something that matches the regular 
   expression. Handlers may throw errors if string is unparseable. 
*/
var dateParsePatterns = [
    // Today
    {   re: /^tod|now/i,
        handler: function() { 
            return new Date();
        } 
    },
    // Tomorrow
    {   re: /^tom/i,
        handler: function() {
            var d = new Date(); 
            d.setDate(d.getDate() + 1); 
            return d;
        }
    },
    // Yesterday
    {   re: /^yes/i,
        handler: function() {
            var d = new Date();
            d.setDate(d.getDate() - 1);
            return d;
        }
    },
    // 4th
    {   re: /^(\d{1,2})(st|nd|rd|th)?$/i, 
        handler: function(bits, calendarIfFormat) {

            var d = new Date();
            var yyyy = d.getFullYear();
            var dd = parseInt(bits[1], 10);
            var mm = d.getMonth();

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // 4th Jan
    {   re: /^(\d{1,2})(?:st|nd|rd|th)? (?:of\s)?(\w+)$/i, 
        handler: function(bits, calendarIfFormat) {

            var d = new Date();
            var yyyy = d.getFullYear();
            var dd = parseInt(bits[1], 10);
            var mm = parseMonth(bits[2]);

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // 4th Jan 2003
    {   re: /^(\d{1,2})(?:st|nd|rd|th)? (?:of )?(\w+),? (\d{4})$/i,
        handler: function(bits, calendarIfFormat) {
            var d = new Date();
            d.setDate(parseInt(bits[1], 10));
            d.setMonth(parseMonth(bits[2]));
            d.setYear(bits[3]);
            return d;
        }
    },
    // Jan 4th
    {   re: /^(\w+) (\d{1,2})(?:st|nd|rd|th)?$/i, 
        handler: function(bits, calendarIfFormat) {

            var d = new Date();
            var yyyy = d.getFullYear(); 
            var dd = parseInt(bits[2], 10);
            var mm = parseMonth(bits[1]);

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // Jan 4th 2003
    {   re: /^(\w+) (\d{1,2})(?:st|nd|rd|th)?,? (\d{4})$/i,
        handler: function(bits, calendarIfFormat) {

            var yyyy = parseInt(bits[3], 10); 
            var dd = parseInt(bits[2], 10);
            var mm = parseMonth(bits[1]);

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // Next Week, Last Week, Next Month, Last Month, Next Year, Last Year
    {   re: /((next|last)\s(week|month|year))/i,
        handler: function(bits, calendarIfFormat) {
            var objDate = new Date();
            
            var dd = objDate.getDate();
            var mm = objDate.getMonth();
            var yyyy = objDate.getFullYear();
            
            switch (bits[3]) {
              case 'week':
                var newDay = (bits[2] == 'next') ? (dd + 7) : (dd - 7);
                
                objDate.setDate(newDay);
                
                break;
              case 'month':
                var newMonth = (bits[2] == 'next') ? (mm + 1) : (mm - 1);
                
                objDate.setMonth(newMonth);
                
                break;
              case 'year':
                var newYear = (bits[2] == 'next') ? (yyyy + 1) : (yyyy - 1);
                
                objDate.setYear(newYear);
                
                break;
            }
            
            return objDate;
        }
    },
    // next Tuesday - this is suspect due to weird meaning of "next"
    {   re: /^next (\w+)$/i,
        handler: function(bits, calendarIfFormat) {

            var d = new Date();
            var day = d.getDay();
            var newDay = parseWeekday(bits[1]);
            var addDays = newDay - day;
            if (newDay <= day) {
                addDays += 7;
            }
            d.setDate(d.getDate() + addDays);
            return d;

        }
    },
    // last Tuesday
    {   re: /^last (\w+)$/i,
        handler: function(bits, calendarIfFormat) {

            var d = new Date();
            var wd = d.getDay();
            var nwd = parseWeekday(bits[1]);

            // determine the number of days to subtract to get last weekday
            var addDays = (-1 * (wd + 7 - nwd)) % 7;

            // above calculate 0 if weekdays are the same so we have to change this to 7
            if (0 == addDays)
               addDays = -7;
            
            // adjust date and return
            d.setDate(d.getDate() + addDays);
            return d;

        }
    },
    // mm/dd/yyyy or dd/mm/yyyy
    {   re: /(\d{1,2})\/(\d{1,2})\/(\d{4})/,
        handler: function(bits, calendarIfFormat) {
            // if config date type is set to another format, use that instead
            if (calendarIfFormat[1] == 'd') {
              var yyyy = parseInt(bits[3], 10);
              var dd = parseInt(bits[1], 10);
              var mm = parseInt(bits[2], 10) - 1;
            } else {
              var yyyy = parseInt(bits[3], 10);
              var dd = parseInt(bits[2], 10);
              var mm = parseInt(bits[1], 10) - 1;
            }

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // mm/dd/yy (American style) short year
    {   re: /(\d{1,2})\/(\d{1,2})\/(\d{1,2})/,
        handler: function(bits, calendarIfFormat) {

            var d = new Date();
            var yyyy = d.getFullYear() - (d.getFullYear() % 100) + parseInt(bits[3], 10);
            var dd = parseInt(bits[2], 10);
            var mm = parseInt(bits[1], 10) - 1;

            if ( DateInRange(yyyy, mm, dd) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // mm/dd (American style) omitted year
    {   re: /(\d{1,2})\/(\d{1,2})/,
        handler: function(bits, calendarIfFormat) {

            var d = new Date();
            var yyyy = d.getFullYear();
            var dd = parseInt(bits[2], 10);
            var mm = parseInt(bits[1], 10) - 1;

            if ( DateInRange(yyyy, mm, dd) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // mm-dd-yyyy :HH:MM:SS or dd-mm-yyyy :HH:MM:SS
    {   re: /(\d{1,2})-(\d{1,2})-(\d{4}) (\d{1,2}):(\d{1,2}):(\d{1,2})/,
        handler: function(bits, calendarIfFormat) {
            if (calendarIfFormat[1] == 'd') {
              // if the config is set to use a different schema, then use that instead
              var yyyy = parseInt(bits[3], 10);
              var dd = parseInt(bits[1], 10);
              var mm = parseInt(bits[2], 10) - 1;
            } else {
              var yyyy = parseInt(bits[3], 10);
              var dd = parseInt(bits[2], 10);
              var mm = parseInt(bits[1], 10) - 1;
            }
            var hh = parseInt(bits[4], 10);
            var min = parseInt(bits[5], 10);
            var ss = parseInt(bits[6], 10);

            if ( DateInRange( yyyy, mm, dd ) ) {
               return getDateObj(yyyy, mm, dd, hh, min, ss);
            }

        }
    },
    // mm-dd-yyyy or dd-mm-yyyy
    {   re: /(\d{1,2})-(\d{1,2})-(\d{4})/,
        handler: function(bits, calendarIfFormat) {
            if (calendarIfFormat[1] == 'd') {
              // if the config is set to use a different schema, then use that instead
              var yyyy = parseInt(bits[3], 10);
              var dd = parseInt(bits[1], 10);
              var mm = parseInt(bits[2], 10) - 1;
            } else {
              var yyyy = parseInt(bits[3], 10);
              var dd = parseInt(bits[2], 10);
              var mm = parseInt(bits[1], 10) - 1;
            }

            if ( DateInRange( yyyy, mm, dd ) ) {
               return getDateObj(yyyy, mm, dd);
            }

        }
    },
    // dd.mm.yyyy :HH:MM:SS
    {   re: /(\d{1,2})\.(\d{1,2})\.(\d{4}) (\d{1,2}):(\d{1,2}):(\d{1,2})/,
        handler: function(bits, calendarIfFormat) {
            var dd = parseInt(bits[1], 10);
            var mm = parseInt(bits[2], 10) - 1;
            var yyyy = parseInt(bits[3], 10);
            var hh = parseInt(bits[4], 10);
            var min = parseInt(bits[5], 10);
            var ss = parseInt(bits[6], 10);

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd, hh, min, ss);

        }
    },
    // dd.mm.yyyy
    {   re: /(\d{1,2})\.(\d{1,2})\.(\d{4})/,
        handler: function(bits, calendarIfFormat) {
            var dd = parseInt(bits[1], 10);
            var mm = parseInt(bits[2], 10) - 1;
            var yyyy = parseInt(bits[3], 10);

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // yyyy-mm-dd HH:MM:SS (ISO style)
    {   re: /(\d{4})-(\d{1,2})-(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})/,
        handler: function(bits, calendarIfFormat) {
            var yyyy = parseInt(bits[1], 10);
            var dd = parseInt(bits[3], 10);
            var mm = parseInt(bits[2], 10) - 1;
            var hh = parseInt(bits[4], 10);
            var min = parseInt(bits[5], 10);
            var ss = parseInt(bits[6], 10);

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd, hh, min, ss);

        }
    },
    // yyyy-mm-dd HH:MM:SS (ISO style)
    {   re: /(\d{4})-(\d{1,2})-(\d{1,2})/,
        handler: function(bits, calendarIfFormat) {
            var yyyy = parseInt(bits[1], 10);
            var dd = parseInt(bits[3], 10);
            var mm = parseInt(bits[2], 10) - 1;

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // yy-mm-dd (ISO style) short year
    {   re: /(\d{1,2})-(\d{1,2})-(\d{1,2})/,
        handler: function(bits, calendarIfFormat) {

            var d = new Date();
            var yyyy = d.getFullYear() - (d.getFullYear() % 100) + parseInt(bits[1], 10);
            var dd = parseInt(bits[3], 10);
            var mm = parseInt(bits[2], 10) - 1;

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // mm-dd (ISO style) omitted year
    {   re: /(\d{1,2})-(\d{1,2})/,
        handler: function(bits, calendarIfFormat) {

            var d = new Date();
            var yyyy = d.getFullYear();
            var dd = parseInt(bits[2], 10);
            var mm = parseInt(bits[1], 10) - 1;

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // mon, tue, wed, thr, fri, sat, sun
    {   re: /(^mon.*|^tue.*|^wed.*|^thu.*|^fri.*|^sat.*|^sun.*)/i,
        handler: function(bits, calendarIfFormat) {
            var d = new Date();
            var day = d.getDay();
            var newDay = parseWeekday(bits[1]);
            var addDays = newDay - day;
            if (newDay <= day) {
                addDays += 7;
            }
            d.setDate(d.getDate() + addDays);
            return d;
        }
    },
];


function parseDateString(s, calendarIfFormat) {
    for (var i = 0; i < dateParsePatterns.length; i++) {
        var re = dateParsePatterns[i].re;
        var handler = dateParsePatterns[i].handler;
        var bits = re.exec(s, calendarIfFormat);
        if (bits) {
            return handler(bits, calendarIfFormat);
        }
    }
    throw new Error("Invalid date string");
}


function magicDateOnlyOnSubmit(id, calendarIfFormat, event) {
    var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
    
    if (keyCode == 13 || keyCode == 10) {
  		magicDate(id, calendarIfFormat);
    }
}
    
function magicDate(id, calendarIfFormat) {

    var input = document.getElementById(id);
    var messagespan = input.id + 'Msg';

    try {
        var d = parseDateString(input.value, calendarIfFormat);
        
        var year = d.getFullYear();
        var day = (d.getDate() <= 9) ? '0' + d.getDate().toString() : d.getDate();
        var month = ((d.getMonth() + 1) <= 9) ? '0' + (d.getMonth() + 1) : (d.getMonth() + 1);
        var hours = (d.getHours() <= 9) ? '0' + d.getHours().toString() : d.getHours();
        var minutes = (d.getMinutes() <= 9) ? '0' + d.getMinutes().toString() : d.getMinutes();
        var seconds = (d.getSeconds() <= 9) ? '0' + d.getSeconds().toString() : d.getSeconds();

        if (calendarIfFormat) {
          date_value = calendarIfFormat.replace("%Y", year).replace("%m", month).replace("%d", day).replace("%H", hours).replace("%M", minutes).replace("%S", seconds);
        }
        else {
          date_value = year + '-' + month + '-' + day;
        }
        input.value = date_value;
        // Human readable date
        if (document.getElementById(messagespan)) document.getElementById(messagespan).innerHTML = d.toDateString();
        if (document.getElementById(messagespan)) document.getElementById(messagespan).className = 'normal';
    }
    catch (e) {
        input.className = 'fieldWithErrors';
        var message = e.message;
        // Fix for IE6 bug
        if (message.indexOf('is null or not an object') > -1) {
            message = 'Invalid date string';
        }
        if (document.getElementById(messagespan)) document.getElementById(messagespan).innerHTML = message;
        if (document.getElementById(messagespan)) document.getElementById(messagespan).className = 'error';
    }
    
}

/*
Compact Forms (for Prototype)
http://www.alistapart.com/articles/makingcompactformsmoreaccessible/
*/
// OverLabel = Class.create();
// OverLabel.prototype = {
//   label: null,
//   target: null,
// 
//   initialize: function(label) {
//     this.label = $(label);
//     this.target = $(this.label.htmlFor || this.label.getAttribute('for'));
//     this.label.addClassName('overlabel-apply');
//     this.hide_or_show(); // initialize the state
//     this.target.observe('focus', this.hide.bind(this));
//     this.target.observe('blur', this.hide_or_show.bind(this));
// 
//     this.label.observe('click', function() {
//       this.target.focus();
//     }.bind(this));
//   },
// 
//   hide_or_show: function() {
//     if (this.target.value) this.hide();
//     else this.show();
//   },
// 
//   hide: function() {
//     this.label.style.textIndent = '-2000px';
//   },
//   show: function() {
//     this.label.style.textIndent = '0px';
//   }
// }
// OverLabel.initialize_all = function() {
//   $$('label.overlabel').each(function(label) {
//     if (label.htmlFor || label.getAttribute('for')) new OverLabel(label);
//   });
// }
// 
// Event.observe(window, 'load', function() {
//   setTimeout(OverLabel.initialize_all, 50)
// });