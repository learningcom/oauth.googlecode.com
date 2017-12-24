<!---
Description:
============
	oauth.oauthsignaturemethod_plaintext testcase

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
	name="oauth.oauthsignaturemethod_plaintext testcase"
	extends="org.cfcunit.framework.TestCase"
	output="false"
	hint="oauth.oauthsignaturemethod_plaintext testcase">

	<cffunction name="setUp" returntype="void" access="private" output="false" hint="test fixture">
		<cfset variables.oUtil = CreateObject("component", "oauth.oauthutil").init()>
		<cfset variables.oSigMethod = CreateObject("component", "oauth.oauthsignaturemethod_plaintext")>
		<cfset variables.oRequest = CreateObject("component", "oauth.oauthrequest").init(
			sHttpMethod = "GET",
			sHttpURL = "")>
		<cfset variables.sConsumerKey = "ckey">
		<cfset variables.sConsumerSecret = "csecret">
		<cfset variables.oConsumer = CreateObject("component", "oauth.oauthconsumer").init(
			sKey = variables.sConsumerKey, sSecret = variables.sConsumerSecret)>
		<cfset variables.sTokenKey = "tkey">
		<cfset variables.sTokenSecret = "tsecret">
		<cfset variables.oToken = CreateObject("component", "oauth.oauthtoken").init(
			sKey = variables.sTokenKey, sSecret = variables.sTokenSecret)>
	</cffunction>

	<!--------------------------------------------------------------->


	<cffunction name="testbuildSignature" returntype="void" access="public" output="false">
		<cfset var sTempSig = variables.oSigMethod.buildSignature(
			oRequest = variables.oRequest,
			oConsumer = variables.oConsumer,
			oToken = variables.oToken)>
		<cfset var sTempSigExpected = variables.oUtil.encodePercent(variables.sConsumerSecret & "&" & variables.sTokenSecret)>
		<cfset assertEqualsString(sTempSigExpected, sTempSig)>
	</cffunction>

	<cffunction name="testgetName" returntype="void" access="public" output="false">
		<cfset assertEqualsString("PLAINTEXT", variables.oSigMethod.getName())>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="tearDown" returntype="void" access="private" output="false"
		hint="Tears down the fixture, for example, close a network connection.">
	</cffunction>

</cfcomponent>