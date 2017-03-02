function readableDate(id, date) {
	if (date === "current") {
	    var ans = "Most Recent Run";
  	} else {
        var parts = date.split(/.{2}/g);
        var m = parts[0];
        var d = parts[1];
        var y = parts[2];
        var mname = "";
        if (m === 1) {
        	mname = "Jan";
        }
        if (m === 2) {
        	mname = "Feb";
        }
        if (m === 3) {
        	mname = "Mar";
        }
        if (m === 4) {
        	mname = "Apr";
        }
        if (m === 5) {
        	mname = "May";
        }
        if (m === 6) {
        	mname = "Jun";
        }
        if (m === 7) {
        	mname = "Jul";
        }
        if (m === 8) {
        	mname = "Aug";
        }
        if (m === 9) {
        	mname = "Sept";
        }
        if (m === 10) {
        	mname = "Oct";
        }
        if (m === 11) {
        	mname = "Nov";
        }
        if (m === 12) {
        	mname = "Dec";
        }
        var ans = mname.concat(" ", d, ", ", y);
  	}
  	
  	document.getElementById(id).innerHTML = ans;
};