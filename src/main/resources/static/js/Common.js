/*
 * All methods for Validation of field values of the form
 *
 */

function checkTrim(txtString)
{
	txtString = LTrim(txtString);
	txtString = RTrim(txtString);
	return txtString;
}

//returns the string after deleting  the trailing spaces
function LTrim(txtString)
{
	ctr = 0;

	while( ctr < txtString.length && (txtString.substring(ctr,ctr+1) == " "))
	{
		ctr=ctr+1;
	}
	return txtString.substring(ctr);
}

// returns the string after deleting the leading spaces
function RTrim(txtString)
{
	ctr = txtString.length;
	while( ctr > 0  && (txtString.substring(ctr,ctr-1) == " "))
	{
		ctr = ctr - 1;
	}
	return txtString.substring(0,ctr);
}



//Validation for field which should not be empty
function isEmpty(fieldname,fieldvalue)
{

	var str=checkTrim(fieldvalue);

	if(str.length==0)
	{
		alert(fieldname + ' can not be empty ');
		return false;
	}
	return true;
}

//validation for field which accepts zero
function isEmp(fieldname,fieldvalue)
{

	var str = fieldvalue;

	if(str==0)
	{
		alert(fieldname + ' can not be zero');
		return false;
    }

	return true;
}





//Validation for field which should not be empty
function isFilled(fieldname,fieldvalue)
{

	var str=checkTrim(fieldvalue)
	alert(str);
	if(str.length==0)
	{
		//alert("check");
		return false;
	}
	return true;
}

//Validation for field which should not be empty
function isFilled(fieldvalue)
{

	var str=checkTrim(fieldvalue)
	//alert(str);
	if(str.length==0)
	{

		return false;
	}
	return true;
}

//Validation for field RADIO button

function isChecked(fieldname,fieldId)
{
	/*var str=checkTrim(fieldvalue)
	if(str=='Yes')
	{
		return true;
	}
	else
	return false;*/
	//var setHasChecked=false
	for ( i =0 ; i < fieldId.length; i++)
	{
        //alert(fieldId[i].checked);

		if(fieldId[i].checked ==true)
		{
	//alert("hello");
			return true;
		}
	}
  alert(fieldname + " must be selected ");
	return false;
}

function isChecked1(fieldname,fieldId)
{
	/*var str=checkTrim(fieldvalue)
	if(str=='Yes')
	{
		return true;
	}
	else
	return false;*/
	//var setHasChecked=false
	for ( i =0 ; i < fieldId.length; i++)
	{
        //alert(fieldId[i].checked);

		if(fieldId[i].checked ==true)
		{
	//alert("hello");
			return true;
		}
	}
  //alert(fieldname + " must be selected ");
	return false;
}

// Validation for field RADIO which is marked true or Yes

function isCheck(fieldname,fieldId)
{
	var str=checkTrim(fieldId)
//alert(str);
	if(str=='Yes')
	{
		//alert("inside"+str);
		return true;
	}
	else
	return false;

}

function isNoChecked(fieldname,fieldId)
{
	var str=checkTrim(fieldId)
//alert(str);
	if(str=='No')
	{
		//alert("inside"+str);
		return true;
	}
	else
	return false;

}




// Validation for field RADIO which is marked No

function isNoCheck(fieldname,fieldId)
{
	var str=checkTrim(fieldId.value)

	if (fieldId.checked == true)

	if(str=='No')
	{
		//alert(str);
		return true;
	}
	else
	return false;

}



//Validation for field which can allow floating point
function isValidNumber(fieldname , fieldvalue)
{
	var str = fieldvalue;
	i = 0;
	while(i < str.length)
	{
		if(!((str.charAt(i) >= "0") && (str.charAt(i) <= "9")||(str.charAt(i)==".")))
		{
			alert('Please enter valid number for '+ fieldname);
			return false;
		}
		i++;
	}
	return true;
}


//Validation for field which can allow Negative numbers
function isValidNum(fieldname , fieldvalue)
{
	var str = fieldvalue;
	i = 0;
	while(i < str.length)
	{
		if(!((str.charAt(i) >= "0") && (str.charAt(i) <= "9")||(str.charAt(i)==".")||(str.charAt(i)=="-")))
		{
			alert('Please enter valid number for '+ fieldname);
			return false;
		}
		i++;
	}
	return true;
}


//Validation for field which can allow floating point
function isValidInteger(fieldname , fieldvalue)
{
	var str = fieldvalue;
	i = 0;
	while(i < str.length)
	{
		if(!((str.charAt(i) >= "0") && (str.charAt(i) <= "9")))
		{
			alert('Please enter valid value for '+ fieldname +". This field can only accept integer values");
			return false;
		}
		i++;
	}
	return true;
}

//Validation for field which can allow floating point
function isValidNumberFare(fieldname , fieldvalue)
{
	var str = fieldvalue;
	str=str.toLowerCase();
//alert(str);
	i = 0;
	while(i < str.length)
	{
		//alert(str.charAt(i));
		if(!(((str.charAt(i) >= "a") && (str.charAt(i) <= "z")) || ((str.charAt(i) >= "0") && (str.charAt(i) <= "9"))
		|| (str.charAt(i)=="$")|| (str.charAt(i)==":")|| (str.charAt(i)==' ')))
		{
			alert('Please enter valid text for '+ fieldname);

			return false;
		}
		i++;
	}
	return true
}

//Validation for field which can allow text
function isValidText(fieldname , fieldvalue)
{
	var str = fieldvalue;
	str=str.toLowerCase();

	i = 0;
	while(i < str.length)
	{
		if(!(((str.charAt(i) >= "a") && (str.charAt(i) <= "z")) || ((str.charAt(i) >= "0") && (str.charAt(i) <= "9"))
		|| (str.charAt(i)==" ") || (str.charAt(i) == "_") || (str.charAt(i) == "-") || (str.charAt(i) == "+")
		|| (str.charAt(i) == "/") || (str.charAt(i) == "(") || (str.charAt(i) == ")") || (str.charAt(i) == ".") || (str.charAt(i) == ",")))
		{
			alert('Please enter valid text for '+ fieldname);

			return false;
		}
		i++;
	}
	return true;
}

//This function supplies the Parameter value for a given parameter name
//from a given query string
// Eg: Query_String = telus/WebTelus/Login/TELUSHome/ProjectSelection/Project:LoadProject:session=8rxnuj41o1&rowNum=0
// 	getParameter (Query_String, rowNum) will return the value 0

function getParameter ( queryString, parameterName )
{
	// Add "=" to the parameter name (i.e. parameterName=value)
	var parameterName = parameterName + "=";

	if ( queryString.length > 0 )
	{
		// Find the beginning of the string
		begin = queryString.indexOf ( parameterName );

		// If the parameter name is not found, skip it, otherwise return the value
		if ( begin != -1 )
		{
			// Add the length (integer) to the beginning
			begin += parameterName.length;
			// Multiple parameters are separated by the "&" sign
			end = queryString.indexOf ( "&" , begin );
			if ( end == -1 )
			{
				end = queryString.length
			}
			// Return the string
			return unescape ( queryString.substring ( begin, end ) );
		}
		// Return "null" if no parameter has been found
		return "null";
	}
}


// The following is code that allows you to highlight the current
//in focus element in a form

var highlightcolor="FFFFD8"

var ns6 = document.getElementById && !document.all
var previous=''
var eventobj

//Regular expression to highlight only form elements
var intended=/INPUT|TEXTAREA|SELECT|OPTION/

//Function to check whether element clicked is form element
function checkel(which)
{
	if ( which.style && intended.test(which.tagName) ) {
		if (ns6 && eventobj.nodeType == 3)	//TEXT_NODE          = 3
			eventobj = eventobj.parentNode.parentNode
		return true
	}
	else
		return false
}

//Function to highlight form element
function highlight(e)
{
	eventobj = ns6 ? e.target : event.srcElement

	if (previous != '')
	{
		if (checkel(previous))
			previous.style.backgroundColor=''

		previous = eventobj

		if (checkel(eventobj))
			eventobj.style.backgroundColor=highlightcolor
	}
	else {
		if (checkel(eventobj))
			eventobj.style.backgroundColor=highlightcolor
		previous = eventobj
	}
}


//To use the above functions, in the forms onClick or onKeyUp event call the highlight(event) method


// function to check the dates are valid

function checkdate(fieldvalue)
{

   var datefield = fieldvalue;
   if (chkdate(fieldvalue) == false)
   {
	//datefield.select();
	alert("Date is invalid.  Please try again.");
	//datefield.focus();
	return false;
   }
   else
	{
		return true;

	}
}
function chkdate(fieldvalue)
 {
    var strDatestyle = "US";
    var strDate;
    var strDateArray;
    var strDay;
    var strMonth;
    var strYear;
    var intday;
    var intMonth;
    var intYear;
    var booFound = false;
    var datefield = fieldvalue;
	var strSeparatorArray = new Array("-"," ","/",".");
	var intElementNr;
	var err = 0;
	var strMonthArray = new Array(12);
	strMonthArray[0] = "Jan";
	strMonthArray[1] = "Feb";
	strMonthArray[2] = "Mar";
	strMonthArray[3] = "Apr";
	strMonthArray[4] = "May";
	strMonthArray[5] = "Jun";
	strMonthArray[6] = "Jul";
	strMonthArray[7] = "Aug";
	strMonthArray[8] = "Sep";
	strMonthArray[9] = "Oct";
	strMonthArray[10] = "Nov";
	strMonthArray[11] = "Dec";
	strDate = datefield;

	if (strDate.length < 1)
	 {
		 return true;
	 }
	for (intElementNr = 0; intElementNr < strSeparatorArray.length; intElementNr++)
	{
	 if (strDate.indexOf(strSeparatorArray[intElementNr]) != -1)
	 {
		strDateArray = strDate.split(strSeparatorArray[intElementNr]);
		//alert("string_date array " + strDateArray);
		if (strDateArray.length != 3)
		 {

		   err = 1;
		   return false;
		 }
		else
		 {

			strYear = strDateArray[0];
			strMonth = strDateArray[1];
			strDay = strDateArray[2];

		}
		booFound = true;
	   }
	}
//alert("found=" + booFound);
	if (booFound == false)
	{

	 if (strDate.length>5)
	 {

		strDay = strDate.substr(0, 2);
		strMonth = strDate.substr(2, 2);
		strYear = strDate.substr(4);
   	 }
	}
	if (strYear.length == 2)
	{
	  //strYear = '20' + strYear;

	  return false;
	}

	intday = parseInt(strDay, 10);
	//alert("day"+intday);
	if (isNaN(intday)) {
	  err = 2;
      return false;
	}
	intMonth = parseInt(strMonth, 10);
	//alert("month" +intMonth);
	if (isNaN(intMonth))
	{
	  for (i = 0;i<12;i++)
	  {
  		if (strMonth.toUpperCase() == strMonthArray[i].toUpperCase())
		{
		  intMonth = i+1;
		  strMonth = strMonthArray[i];
		  i = 12;
   	  }

	}
//alert("after for loop");
if (isNaN(intMonth))
{
err = 3;
return false;
   }
}
intYear = parseInt(strYear, 10);
if (isNaN(intYear))
{
err = 4;

return false;
}
if (intMonth>12 || intMonth<1) {
err = 5;
return false;
}
if ((intMonth == 1 || intMonth == 3 || intMonth == 5 || intMonth == 7 || intMonth == 8 || intMonth == 10 || intMonth == 12) && (intday > 31 || intday < 1)) {
err = 6;
return false;
}
if ((intMonth == 4 || intMonth == 6 || intMonth == 9 || intMonth == 11) && (intday > 30 || intday < 1)) {
err = 7;
return false;
}
if (intMonth == 2) {
if (intday < 1) {
err = 8;
return false;
}
if (LeapYear(intYear) == true) {
if (intday > 29) {
err = 9;
return false;
}
}
else {
if (intday > 28) {
err = 10;
return false;
}
}
}

return true;
}

function LeapYear(intYear)
{
  if (intYear % 100 == 0)
    {
        if (intYear % 400 == 0)
        { return true; }
     }
else
{
if ((intYear % 4) == 0) { return true; }
}
return false;
}


//function to check let date is lesser than completion date
function validdate(fieldvalue1, fieldvalue2)
{

  var temp1 = new Array();
  temp1 = fieldvalue1.split('/');
  var year1 = temp1[0];
  var month1 = temp1[1];
  var day1 = temp1[2];

  var temp2 = new Array();
  temp2 = fieldvalue2.split('/');
  var year2 = temp2[0];
  var month2 = temp2[1];
  var day2 = temp2[2];

  if(year1 > year2)
  {
  	alert("Let date must be less than Completion date. Please enter a valid date");
  	return false;
  }

  if(year1 == year2)
  {
  	if(month1 > month2)
  	{
  	alert("Let date must be less than Completion date. Please enter a valid date");
  	return false;
      }

  	if((month1 == month2) && (day1 > day2))
  	{
  			alert("Let date must be less than Completion date. Please enter a valid date");
  			return false;
  	}

  }


return true;
}

// function to find the total of the fields and validate the fields.

function validatenum()
{
 	var total = 0;
	var argv = validatenum.arguments;
	  var argc = argv.length;
	  //alert("arguments" + argc);
	  for (var i = 0; i < argc; i++)
	  {

         total = parseInt(argv[i]-0) + (total-0);
         //alert("tot" + total);
         var temp = total + '';
         //alert("temp"+ temp);
	  }

    if(temp < 100 || temp > 100 )
 	{
 		alert(" The fields total sum must be equal to 100");

 		return false;
	}

	return true;
 }

// function to validate the lanes fields values in A, AH, H1,H2, H3 forms
function isChklane(fieldname, fieldvalue, value)
{
var str = fieldvalue;
var val = value;
//alert(str);
if(str > (eval(val)))
{
  alert(fieldname + ' value must be lesser than ' + val);
  return false;
}

  return true;

}


// function to validate the HOV lanes fields values in A, AH, H1,H2, H3 forms
function isChkHOVlane(fieldname, fieldvalue)
{
var str = fieldvalue;
//alert(str);
if(str > 2)
{
  alert(fieldname + ' value must not be greater than 2 ');
  return false;
}

  return true;

}


// function to validate the speed fields values in A, AH, H1,H2, H3 forms
function isChkspeed(fieldname, fieldvalue, value)
{
var str = fieldvalue;
var val = value;
//alert("string"+str);
//alert("value"+ val);
if(str > (eval(val)))
{
  alert(fieldname + ' value must not be greater than ' + val);
  return false;
}

  return true;

}

// function to validate the width lanes fields values in A, AH, H1,H2, H3 forms
function isChkwidlane(fieldname, fieldvalue)
{
var str = fieldvalue;
//alert(str);
if(str > 12)
{
  alert(fieldname + ' value must not be greater than 12 ');
  return false;
}

  return true;

}

// function to validate the shoulders fields values in A, AH, H1,H2, H3 forms
function isChkshoulder(fieldname, fieldvalue)
{
var str = fieldvalue;
//alert(str);
if(str > 6)
{
  alert(fieldname + ' value must not be greater than 6 ');
  return false;
}

  return true;

}


// function to validate the project length field in cover sheet
function isProjlength(fieldname, fieldvalue)
{
   var str = fieldvalue;
   //alert(str);
   if(str > 15)
   {
      alert(fieldname + ' value must not be greater than 15 ');
	  return false;
   }

  return true;

}


// function to validate the phone number field in cover sheet
function isPhone(fieldname, fieldvalue)
{
   var str = fieldvalue;

   var str1 = str.length;

   if(str1 >=11 || str1 <= 9)
   {
      alert(fieldname + ' value must be equal to 10 digits ');
	  return false;
   }

  return true;

}



// function to validate email address
function isvalidemail(fieldname, fieldvalue)
{
	// test if valid email address, must have @ and .
	var checkEmail = "@.";
	var checkStr = fieldvalue;

	var EmailValid = false;
	var EmailAt = false;
	var EmailPeriod = false;
	for (i = 0;  i < checkStr.length;  i++)
	{
	  ch = checkStr.charAt(i);
	  for (j = 0;  j < checkEmail.length;  j++)
	  {
	    if (ch == checkEmail.charAt(j) && ch == "@")
	      EmailAt = true;
	    if (ch == checkEmail.charAt(j) && ch == ".")
	      EmailPeriod = true;
		if (EmailAt && EmailPeriod)
			break;
		if (j == checkEmail.length)
			break;
	  }
		// if both the @ and . were in the string
	  if (EmailAt && EmailPeriod)
	  {
			EmailValid = true;
			break;
	  }
	}
	if (!EmailValid)
	{
	alert("The " + fieldname + " must contain an \"@\" and a \".\".");
	return (false);
	}

  return true;
}


function copyFromExistToProp(theForm)
{
	//The purpose of this function is to copy stuff from the before side
	//to the after side of a form. Instead of manually suppyling all the names
	//we are going to iterate over the form elements and get the value for all
	//fields with the sig exist_ and copy the values to prop_
	var exist = /exist/ig;

	for (i=0; i<theForm.elements.length; i++)
	{
		//Get form elements that have 'exist_" in it
		if (theForm.elements[i].name.search(exist) != -1)
		{
			var theName = theForm.elements[i].name;

			//Change the 'exist_' to 'prop'
			theName = theName.replace(exist, 'prop');
			//alert(theForm.elements[i].name+ ' Value: ' + theForm.elements[i].value);
			//alert(theName);

			//change the value of the corresponding 'prop' field
			theForm.elements[theName].value = theForm.elements[i].value;
			//alert( theName + ' Value: ' + theForm.elements[theName].value);
		}
	}
}

//validation for field which accepts null
function isContinue(fieldvalue)
{

	var str = fieldvalue;

	if(str =='')
	{
		alert("Some of the fields are not entered with data, hence data is not validated!!!");
		return false;
    }

	return true;
}

//Validation for field which should not be empty
function isEmpCheck(fieldname,fieldvalue)
{

	var str=checkTrim(fieldvalue);

	if(str.length==0)
	{
		//alert(fieldname + ' can not be empty ');
		return false;
	}
	return true;
}