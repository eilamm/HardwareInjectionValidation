% Updates the webpages for hardware injection project (CSS and HTML for homepage and pulsar pages)
clear;
close all;
includePaths;
fprintf('Updating webpages...\n');
homepageHTML2();
homepageCSS();
for p = 0:14
	pulsarHTML2(p);
end

