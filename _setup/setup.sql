INSERT INTO pages ( page_id, page_uuid, page_left, page_right, page_title, page_navigationtitle, page_content, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated ) 
VALUES ( 1, 'home', 1, 2, 'Welcome to Xindi', 'Home', '<p><strong>You&#39;ve successfully installed Xindi!</strong></p><p>All the key elements are here, but you&#39;ll need to employ a designer to make this public facing site look good. The content management system on the other hand is very nice and <a href="./admin" target="_blank">you&#39;ll find it here</a> (the username and password are &#39;admin&#39;).</p><h2>Useful Resources</h2><ul><li><a href="https://github.com/simonbingham/xindi/wiki/2.-Frequently-Asked-Questions">Frequently asked Question</a></li><li><a href="https://github.com/simonbingham/xindi/issues">Issue tracker</a></li></ul><p>You can also email me at <a href="mailto:me@simonbingham.me.uk">me@simonbingham.me.uk</a> or tweet me at <a href="http://twitter.com/#!/simonbingham">@simonbingham</a>.</p><p>I would very much welcome contributions to Xindi. Please feel free to <a href="https://github.com/simonbingham/xindi">fork the project on GitHub</a>, amend the source code and submit a pull request.</p>', 'Welcome to Xindi', '', '', '2012-04-22 00:00:00', '2012-04-26 00:00:00' );

INSERT INTO users ( user_id, user_firstname, user_lastname, user_email, user_username, user_password, user_created, user_updated ) 
VALUES ( 1, 'Simon', 'Bingham', 'me@simonbingham.me.uk', 'admin', '1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB', '2012-04-22 08:39:07', '2012-04-22 08:39:09' );