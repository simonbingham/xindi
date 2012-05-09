component extends="mxunit.framework.TestCase"
{
	// ------------------------ TESTS ------------------------ // 
	function testGetUserByCredentialsReturnsUserForCorrectCredentials()
	{
		var $LoginUser = mock( "model.beans.User" );
		$LoginUser.getUsername().returns( "aliaspooryorik" );
		$LoginUser.getPassword().returns( "1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB" );
		
		UserResult = CUT.getUserByCredentials( $LoginUser );
		
		assertEquals( false, IsNull( UserResult ) );
		assertEquals( "foo@bar.moo", UserResult.getEmail() );
	}

	function testGetUserByCredentialsReturnsNullForInCorrectCredentials()
	{
		var $LoginUser = mock( "model.beans.User" );
		$LoginUser.getUsername().returns( "aliaspooryorik" );
		$LoginUser.getPassword().returns( "1111111111111111111111111111111111111111111111111111111111111111" );		
		UserResult = CUT.getUserByCredentials( $LoginUser );
		
		assertEquals( true, IsNull( UserResult ) );
	}

	// ------------------------ IMPLICIT ------------------------ // 
	/**
	* this will run before every single test in this test case
	*/
	function setUp()
	{
		CUT = new model.services.UserService(); 
		
	}
	/**
	* this will run after every single test in this test case
	*/
	function tearDown()
	{
	}
	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests()
	{
		var q = new Query();
		q.setSQL( "
			insert into Users (
				user_firstname, user_lastname, user_email, user_username, user_password
			) 
			values (
				'John', 'Whish', 'foo@bar.moo', 'aliaspooryorik', '1492D0A411AD79F0D1897DB928AA05612023D222D7E4D6B802C68C6F750E0BDB'
			)
		" );
		q.execute();
	}
	/**
	* this will run once after all tests have been run
	*/
	function afterTests()
	{
		var q = new Query();
		q.setSQL( "delete from Users where user_username = 'aliaspooryorik'");
		q.execute();
	}
 
	
}