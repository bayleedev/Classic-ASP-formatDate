<script language="javascript" runat="server">
/**
 *	Function: formatDate
 *
 *	Will help in formatting date's similar to PHP's Date Function.
 *	Does not have support for:
 *		- 'u' Microseconds - No JS support
 *		- 'e' Timezone identifier
 *		- 'I' Whether or not the date is in daylight saving time
 *
 *	@author Blaine Schmeisser <BlaineSch@gmail.com>
 *	@param string format The format you want the date to return as.
 *	@return string The formatted date string.
 *	@version v1.0
 *	@example http://www.BlaineSch.com/378/classic-asp-dates/
**/
function formatDate(format) {
	// Variables
	var format = new String(format),
		thisDate,
		formatLen = format.length,
		ret = '',
		dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
		monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
		tNum,
		tDays = [7,1,2,3,4,5,6],
		toMonday = [6,0,1,2,3,4,5],
		getS = function(fn_day) {
			/*
				Gets the "English ordinal suffix" for any number based on the last 2 digits.
			*/
			
			// Variables
			var fnll, fndl;

			// Get date
			if(fn_day) {
				fn_day = parseInt(fn_day);
			} else {
				fn_day = parseInt(new Date().getDate());	
			}

			// Convert to string
			fn_day = new String(fn_day);
			
			// Last Digit
			fnll = fn_day.substring(fn_day.length - 1, fn_day.length);
			// Last Two Digits
			fndl = fn_day.substring(fn_day.length - 2, fn_day.length);
			
			// Logic
			if(fndl >= 11 && fndl <= 13) {
				return "th";
			} else if(fnll == 1) {
				return "st";	
			} else if(fnll == 2) {
				return "nd";
			} else if(fnll == 3) {
				return "rd";	
			}
			return "th";
		},
		getW = function(fn_day) {
			// Variables
			var lastEndWeek, lastBegWeek, thisBegWeek, tNum;
			// December 28th is always the 52nd week
			lastEndWeek = new Date();
			lastEndWeek.setUTCFullYear(fn_day.getFullYear()-1);
			lastEndWeek.setUTCMonth(11);
			lastEndWeek.setUTCDate(28);
			lastEndWeek.setUTCHours(0);
			lastEndWeek.setUTCMinutes(0);
			lastEndWeek.setUTCSeconds(0);
			// ISO-8601 starts week on Monday - Get the first Monday before Dec 28th
			lastBegWeek = new Date();
			lastBegWeek.setUTCFullYear(lastEndWeek.getFullYear());
			lastBegWeek.setUTCMonth(11);
			lastBegWeek.setUTCDate(28-toMonday[lastEndWeek.getDay()]);
			lastBegWeek.setUTCHours(0);
			lastBegWeek.setUTCMinutes(0);
			lastBegWeek.setUTCSeconds(0);
			// Get the first Monday from the given date
			thisBegWeek = new Date();
			thisBegWeek.setUTCFullYear(fn_day.getFullYear());
			thisBegWeek.setUTCMonth(fn_day.getMonth());
			thisBegWeek.setUTCDate(fn_day.getDate()-toMonday[thisDate.getDay()]);
			thisBegWeek.setUTCHours(0);
			thisBegWeek.setUTCMinutes(0);
			thisBegWeek.setUTCSeconds(0);
			// Subtract the difference, divide by weeks
			tNum = Math.round((thisBegWeek.getTime() - lastBegWeek.getTime()) / 604800000);
			tNum = (tNum > 52)?tNum-52:tNum;
			tNum = (tNum == 0)?52:tNum;
			tNum = '0' + tNum;
			return tNum.substring(tNum.length-2);
		},
		exactLength = function(num, len) {
			/*
				Returns a number to be an exact length:
				exactLength(1,2) // 01
				exactLength(31,2) // 31
			*/
			var ret;
			for(var i = 0;i<len;i++) {
				ret += '0';
			}
			ret += num;
			return ret.substring(ret.length-len);
		},
		typeOfArg1 = (typeof arguments[1]);
		
	// Get the Date
	if(typeOfArg1 == 'date' || typeOfArg1 == 'number') {
		// Input date
		thisDate = new Date(new Date(arguments[1]));
	} else {
		// Today
		thisDate = new Date();	
	}

	// Loop format
	/*
		References:
			http://www.w3schools.com/jsref/jsref_obj_date.asp
			http://us2.php.net/manual/en/function.date.php
	*/
	for(var i = 0;i<formatLen;i++) {
		switch(format.substring(i, i+1)) {
			// Day (8 of 8)
				case 'd':
					// Day of the month, 2 digits with leading zeros
					ret += exactLength(new String(thisDate.getDate()), 2);
					break;
				case 'D':
					// A textual representation of a day, three letters
					ret += dayNames[thisDate.getDay()].substring(0, 3);
					break;
				case 'j':
					// Day of the month without leading zeros
					ret += thisDate.getDate();
					break;
				case 'l':
					// A full textual representation of the day of the week
					ret += dayNames[thisDate.getDay()];
					break;
				case 'N':
					// ISO-8601 numeric representation of the day of the week (added in PHP 5.1.0)
					ret += tDays[thisDate.getDay()];
					break;
				case 'S':
					// English ordinal suffix for the day of the month, 2 characters
					ret += getS(thisDate.getDate());
					break;
				case 'w':
					// Numeric representation of the day of the week
					ret += thisDate.getDay();
					break;
				case 'z':
					// The day of the year (starting from 0)
					ret += Math.floor((thisDate.getTime() - new Date(thisDate.getFullYear(), 0, 1).getTime()) / 86400000);
					break;
			// Week (1 of 1)
				case 'W':
					// ISO-8601 week number of year, weeks starting on Monday (added in PHP 4.1.0)
					ret += getW(thisDate);
					break;
			// Month (5 of 5)
				case 'F':
					// A full textual representation of a month, such as January or March
					ret += monthNames[thisDate.getMonth()];
					break;
				case 'm':
					// Numeric representation of a month, with leading zeros
					ret += exactLength((thisDate.getMonth() + 1), 2);
					break;
				case 'M':
					// A short textual representation of a month, three letters
					ret += monthNames[thisDate.getMonth()].substring(0,3);
					break;
				case 'n':
					// Numeric representation of a month, without leading zeros
					ret += (thisDate.getMonth() + 1);
					break;
				case 't':
					// Number of days in the given month
					ret += new Date(thisDate.getFullYear(), thisDate.getMonth() + 1, 0).getDate();
					break;
			// Year (4 of 4)
				case 'L':
					// Whether it's a leap year
					tNum = thisDate.getFullYear();
					ret += (tNum % 400 == 0 || (tNum % 100 != 0 && tNum % 4 == 0))?1:0;
					break;
				case 'o':
					// ISO-8601 year number. This has the same value as Y, except that if the ISO week number (W) belongs to the previous or next year, that year is used instead.
					var thisYear = thisDate.getFullYear();
					var weekIndex = parseInt(getW(thisDate));
					var thisMonth = thisDate.getMonth();
					if(thisMonth == 11 && weekIndex == 1) {
						thisYear++;
					} else if(thisMonth == 0 && weekIndex == 52) {
						thisYear--;	
					}
					ret += thisYear;
					break;
				case 'Y':
					// A full numeric representation of a year, 4 digits
					ret += thisDate.getFullYear();
					break;
				case 'y':
					// A two digit representation of a year
					ret += new String(thisDate.getFullYear()).substring(2);
					break;
			// Time (9 of 10) - Miscroseconds (u) is not supported in JavaScript
				case 'a':
					// Lowercase Ante meridiem and Post meridiem
					ret += (thisDate.getHours() >= 12)?'pm':'am';
					break;
				case 'A':
					// Uppercase Ante meridiem and Post meridiem
					ret += (thisDate.getHours() >= 12)?'PM':'AM';
					break;
				case 'B':
					// Swatch Internet time
					ret += exactLength(Math.floor((((thisDate.getUTCHours() + 1)%24) + thisDate.getUTCMinutes()/60 + thisDate.getUTCSeconds()/3600)*1000/24), 3);
					break;
				case 'g':
					// 12-hour format of an hour without leading zeros
					tNum = thisDate.getHours();
					tNum = (tNum >= 12)?tNum-12:tNum;
					ret += (tNum==0)?12:tNum;
					break;
				case 'G':
					// 24-hour format of an hour without leading zeros
					ret += thisDate.getHours();
					break;
				case 'h':
					// 12-hour format of an hour with leading zeros
					tNum = thisDate.getHours();
					tNum = ((tNum >= 12)?tNum-12:tNum);
					tNum = ((tNum==0)?12:tNum);
					ret += exactLength(((tNum==0)?12:tNum), 2);
					break;
				case 'H':
					// 24-hour format of an hour with leading zeros
					ret += exactLength(thisDate.getHours(), 2);
					break;
				case 'i':
					// Minutes with leading zeros
					ret += exactLength(thisDate.getMinutes(), 2);
					break;
				case 's':
					// Seconds, with leading zeros
					ret += exactLength(thisDate.getSeconds(), 2);
					break;
			// Timezones (4 of 6)
				case 'O':
					// Difference to Greenwich time (GMT) in hours
					var sign = '+';
					tNum = -1 * (thisDate.getTimezoneOffset()/60);
					if(tNum < 0) {
						sign = '-';
						tNum *= -1;
					}
					ret += sign + exactLength(tNum, 2) + '00';
					break;
				case 'P':
					// Difference to Greenwich time (GMT) with colon between hours and minutes
					var sign = '+';
					tNum = -1 * (thisDate.getTimezoneOffset()/60);
					if(tNum < 0) {
						sign = '-';
						tNum *= -1;
					}
					ret += sign + exactLength(tNum, 2) + ':00';
					break;
				case 'T':
					// Timezone abbreviation
					tNum = thisDate.toString();
					if(tNum.match(/GMT [\-\+0-9]{5}/)) {
						ret += tNum.match(/\([a-zA-Z ]+\)/)[0].replace(/[^A-Z]+/g, '');
					} else {
						ret += tNum.match(/([A-Z]{3,4}) [0-9]{4}$/)[1];
					}
					break;
				case 'Z':
					// Timezone offset in seconds. The offset for timezones west of UTC is always negative, and for those east of UTC is always positive.
					ret += thisDate.getTimezoneOffset() * -1 * 60;
			// Full date/time (3 of 3)
				case 'c':
					// ISO 8601 date
					ret += formatDate('Y-m-d\TH:i:sP', thisDate.getTime());
					break;
				case 'r':
					// RFC 2822 formatted date
					ret += formatDate('D, d M Y H:i:s O', thisDate.getTime());
					break;
				case 'U':
					// Seconds since the Unix Epoch (January 1 1970 00:00:00 GMT)
					ret += Math.round(thisDate.getTime()/1000);
			// Escaped
				case '\\':
					i++;
				default:
					ret += format.substring(i, i+1);
		}
	}
	return ret;
}
</script>