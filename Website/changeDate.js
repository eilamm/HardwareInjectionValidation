function changeDate(date) {
      if (date === "current") {
            var folder = date.concat("/", ', date, ');
      } else {
            var folder = date.concat("/", date);
      }
      var plot_c = folder.concat("_c.png");
      var plot_d = folder.concat("_d.png");
      document.getElementById("plot_c").src = plot_c;
      document.getElementById("plot_d").src = plot_d;
      };