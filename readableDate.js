function readableDate() {
	var datesobj = document.getElementsByClassName("date")[0];
	var dates = datesobj.getElementsByTagName("p");

	var i;
	var temp;
	for (i = 0; i < dates.length; i++) {
		date = dates[i].innerHTML;
		if (date === "current") {
		    temp = "Most Recent Run";
	  	} else {
	        var parts = date.match(/.{2}/g);
	        var m = parts[0];
	        var d = parts[1];
	        var y = parts[2];
	        var mname = "";
	        if (m === "01") {
	        	mname = "Jan";
	        }
	        if (m === "02") {
	        	mname = "Feb";
	        }
	        if (m === "03") {
	        	mname = "Mar";
	        }
	        if (m === "04") {
	        	mname = "Apr";
	        }
	        if (m === "05") {
	        	mname = "May";
	        }
	        if (m === "06") {
	        	mname = "Jun";
	        }
	        if (m === "07") {
	        	mname = "Jul";
	        }
	        if (m === "08") {
	        	mname = "Aug";
	        }
	        if (m === "09") {
	        	mname = "Sept";
	        }
	        if (m === "10") {
	        	mname = "Oct";
	        }
	        if (m === "11") {
	        	mname = "Nov";
	        }
	        if (m === "12") {
	        	mname = "Dec";
	        }
	        temp = mname.concat(" ", d, ", ", y);
	        console.log(temp);
	  	}
	  	dates[i].innerHTML = temp;
  	}
};