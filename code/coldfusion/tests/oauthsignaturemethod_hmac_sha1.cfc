<!---
Description:
============
	oauth.oauthsignaturemethod_hmac_sha1 testcase

License:
============
Copyright 2008 CONTENS Software GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--->
<cfcomponent
	name="oauth.oauthsignaturemethod_hmac_sha1 testcase"
	extends="org.cfcunit.framework.TestCase"
	output="false"
	hint="oauth.oauthsignaturemethod_hmac_sha1 testcase">

	<cffunction name="setUp" returntype="void" access="private" output="false" hint="test fixture">
		<cfset variables.oSigMethod = CreateObject("component", "oauth.oauthsignaturemethod_hmac_sha1")>

		<cfset variables.sConsumerKey = "ckey">
		<cfset variables.sConsumerSecret = "csecret">
		<cfset variables.oConsumer = CreateObject("component", "oauth.oauthconsumer").init(
			sKey = variables.sConsumerKey,
			sSecret = variables.sConsumerSecret)>

		<cfset variables.sTokenKey = "tkey">
		<cfset variables.sTokenSecret = "tsecret">
		<cfset variables.oToken = CreateObject("component", "oauth.oauthtoken").init(
			sKey = variables.sTokenKey,
			sSecret = variables.sTokenSecret)>

		<cfset variables.oRequest = CreateObject("component", "oauth.oauthrequest").init(
			sHttpMethod = "GET",
			sHttpURL = "http://example.com")>
		<cfset variables.oRequest.signRequest(variables.oSigMethod, variables.oConsumer, variables.oToken)>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="testhmac_sha1" returntype="void" access="public" output="false">
		<cfset var sTemp = variables.oSigMethod.hmac_sha1(
			signKey = "csecret&tsecret",
			signMessage = "GET&http://test.example.com&oauth_version=1.0&test_param1=123&test_param2=str")>
		<cfset var sExpected = "40D0hePIGuTzR9QvXVoEhy545Sc=">

		<cfset assertEqualsString(sExpected, sTemp)>
	</cffunction>

	<cffunction name="testbuildSignature" returntype="void" access="public" output="false">
		<cfset var sTemp = "">
		<cfset var sReqTemp = "">

		<cfset sTemp = variables.oSigMethod.buildSignature(
			oRequest = variables.oRequest,
			oConsumer = variables.oConsumer,
			oToken = variables.oToken)>
		<cfset variables.oRequest.signRequest(variables.oSigMethod, variables.oConsumer, variables.oToken)>
		<cfset sReqTemp = variables.oRequest.getParameter("oauth_signature")>

		<cfset assertEqualsString(sTemp, sReqTemp)>
	</cffunction>

	<cffunction name="testgetName" returntype="void" access="public" output="false">
		<cfset assertEqualsString("HMAC-SHA1", variables.oSigMethod.getName())>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="tearDown" returntype="void" access="private" output="false"
		hint="Tears down the fixture, for example, close a network connection.">
	</cffunction>

</cfcomponent>