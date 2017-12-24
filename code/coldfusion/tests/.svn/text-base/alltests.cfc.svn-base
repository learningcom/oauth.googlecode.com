<cfcomponent output="false" displayname="all tests" extends="org.cfcunit.Object">

	<cffunction name="suite" returntype="org.cfcunit.framework.Test" access="public">
		<cfset var testSuite = newObject("org.cfcunit.framework.TestSuite").init("Framework tests")>

		<cfset testSuite.addTestSuite(newObject("oauth_tests.encodingtest").init())>
		<cfset testSuite.addTestSuite(newObject("oauth_tests.oauthconsumer"))>
		<cfset testSuite.addTestSuite(newObject("oauth_tests.oauthconsumerdao"))>
		<cfset testSuite.addTestSuite(newObject("oauth_tests.oauthdatastore"))>
		<cfset testSuite.addTestSuite(newObject("oauth_tests.oauthrequest"))>
		<cfset testSuite.addTestSuite(newObject("oauth_tests.oauthserver"))>
		<cfset testSuite.addTestSuite(newObject("oauth_tests.oauthsignaturemethod_hmac_sha1"))>
		<cfset testSuite.addTestSuite(newObject("oauth_tests.oauthsignaturemethod_plaintext"))>
		<cfset testSuite.addTestSuite(newObject("oauth_tests.oauthtoken"))>
		<cfset testSuite.addTestSuite(newObject("oauth_tests.oauthtokendao"))>

		<cfreturn testSuite/>
	</cffunction>
</cfcomponent>