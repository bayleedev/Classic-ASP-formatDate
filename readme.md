# Classic ASP Format Date

Date support similar to PHP's [date()](http://us3.php.net/manual/en/function.date.php)

```vb
<!-- #include file="./formatDate.asp"-->
<%
Response.write(formatDate("Y-m-d H:i:s", CDate("02/25/2012 10:00:00")))
    ' 2012-02-25 10:00:00
Response.write(formatDate("l, F jS, Y", NOW()))
    ' Monday, February 27th, 2012
Response.write(formatDate("r"))
    ' Mon, 27 Feb 2012 13:53:21 -0600
%>
```

## Missing Support
* 'u' Microseconds - No JS support
* 'e' Timezone identifier
* 'I' Whether or not the date is in daylight saving time
