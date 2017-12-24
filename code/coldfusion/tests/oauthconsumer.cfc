<!---
Description:
============
	oauth.oauthconsumer testcase

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
	name="oauth.oauthconsumer testcase"
	extends="org.cfcunit.framework.TestCase"
	output="false"
	hint="oauth.oauthconsumer testcase">

	<cffunction name="setUp" returntype="void" access="private" output="false" hint="test fixture">
		<cfset variables.sKey = "test_key">
		<cfset variables.sSecret = "test_secret">
		<cfset variables.sCallbackURL = "http://test.example.com">
		<cfset variables.iConsumerID = 123456>
		<cfset variables.oConsumer = CreateObject("component", "oauth.oauthconsumer").init(
			sKey = variables.sKey,
			sSecret = variables.sSecret,
			sCallbackURL = variables.sCallbackURL,
			iConsumerID = variables.iConsumerID)>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="testsetKey" returntype="void" access="public" output="false">
		<cfset variables.oConsumer.setKey("key")>
		<cfset assertEqualsString("key", variables.oConsumer.getKey())>
	</cffunction>

	<cffunction name="testsetSecret" returntype="void" access="public" output="false">
		<cfset variables.oConsumer.setSecret("secret")>
		<cfset assertEqualsString("secret", variables.oConsumer.getSecret())>
	</cffunction>

	<cffunction name="testgetSecret" returntype="void" access="public" output="false">
		<cfset assertEqualsString(variables.sSecret, variables.oConsumer.getSecret())>
	</cffunction>

	<cffunction name="testgetKey" returntype="void" access="public" output="false">
		<cfset assertEqualsString(variables.sKey, variables.oConsumer.getKey())>
	</cffunction>

	<cffunction name="testgetConsumerID" returntype="void" access="public" output="false">
		<cfset assertEqualsNumber(variables.iConsumerID, variables.oConsumer.getConsumerID())>
	</cffunction>

	<cffunction name="testisEmpty" returntype="void" access="public" output="false">
		<cfset variables.oConsumer.setKey("")>
		<cfset variables.oConsumer.setSecret("")>
		<cfset assertTrue(variables.oConsumer.isEmpty())>
	</cffunction>

	<cffunction name="testsetConsumerID" returntype="void" access="public" output="false">
		<cfset variables.oConsumer.setConsumerID(123)>
		<cfset assertEqualsNumber(123, variables.oConsumer.getConsumerID())>
	</cffunction>

	<cffunction name="testgetCallbackURL" returntype="void" access="public" output="false">
		<cfset assertEqualsString(variables.sCallbackURL, variables.oConsumer.getCallbackURL())>
	</cffunction>

	<cffunction name="testcreateEmptyConsumer" returntype="void" access="public" output="false">
		<cfset var oEmptyConsumer = CreateObject("component", "oauth.oauthconsumer").init(sKey="",sSecret="")>
		<cfset assertTrue(oEmptyConsumer.isEmpty())>
	</cffunction>

	<cffunction name="testinit" returntype="void" access="public" output="false">
		<cfset var oConsumer = CreateObject("component", "oauth.oauthconsumer").init(sKey = variables.sKey, sSecret = variables.sSecret)>
		<cfset assertTrue(IsInstanceOf(oConsumer, "oauth.oauthconsumer"))>
	</cffunction>

	<cffunction name="testsetCallbackURL" returntype="void" access="public" output="false">
		<cfset variables.oConsumer.setCallbackURL("newurl")>
		<cfset assertEqualsString("newurl", variables.oConsumer.getCallbackURL())>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="tearDown" returntype="void" access="private" output="false"
		hint="Tears down the fixture, for example, close a network connection.">
		<cfset variables.sKey = "">
		<cfset variables.sSecret = "">
		<cfset variables.sCallbackURL = "">
		<cfset variables.iConsumerID = 0>
		<cfset variables.oConsumer = 0>
	</cffunction>

</cfcomponent>