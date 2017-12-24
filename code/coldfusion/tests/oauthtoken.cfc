<!---
Description:
============
	oauth.oauthtoken testcase

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
	name="oauth.oauthtoken testcase"
	extends="org.cfcunit.framework.TestCase"
	output="false"
	hint="oauth.oauthtoken testcase">

	<cffunction name="setUp" returntype="void" access="private" output="false" hint="test fixture">
		<cfset variables.sTokenKey = "tkey">
		<cfset variables.sTokenSecret = "tsecret">
		<cfset variables.oToken = CreateObject("component", "oauth.oauthtoken").init(
			sKey = variables.sTokenKey, sSecret = variables.sTokenSecret)>
		<cfset variables.oUtil = CreateObject("component", "oauth.oauthutil").init()>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="testgetString" returntype="void" access="public" output="false">
		<cfset var sTemp = variables.oToken.getString()>
		<cfset var sExpected = 	"oauth_token=" & variables.oUtil.encodePercent(variables.sTokenKey) & "&" &
								"oauth_token_secret=" & variables.oUtil.encodePercent(variables.sTokenSecret)>
		<cfset assertEqualsString(sExpected, sTemp)>
	</cffunction>

	<cffunction name="testisEmpty" returntype="void" access="public" output="false">
		<cfset variables.oToken.setKey("")>
		<cfset variables.oToken.setSecret("")>
		<cfset assertTrue(variables.oToken.isEmpty())>
	</cffunction>

	<cffunction name="testinit" returntype="void" access="public" output="false">
		<cfset assertTrue(IsInstanceOf(variables.oToken, "oauth.oauthtoken"))>
	</cffunction>

	<cffunction name="testgetKey" returntype="void" access="public" output="false">
		<cfset assertEqualsString(variables.sTokenKey, variables.oToken.getKey())>
	</cffunction>

	<cffunction name="testsetKey" returntype="void" access="public" output="false">
		<cfset variables.oToken.setKey("newkey")>
		<cfset assertEqualsString("newkey", variables.oToken.getKey())>
	</cffunction>

	<cffunction name="testgetSecret" returntype="void" access="public" output="false">
		<cfset assertEqualsString(variables.sTokenSecret, variables.oToken.getSecret())>
	</cffunction>

	<cffunction name="testcreateEmptyToken" returntype="void" access="public" output="false">
		<cfset var oTemp = variables.oToken.createEmptyToken()>
		<cfset assertTrue(IsInstanceOf(oTemp, "oauth.oauthtoken"))>
		<cfset assertTrue(oTemp.isEmpty())>
	</cffunction>

	<cffunction name="testsetSecret" returntype="void" access="public" output="false">
		<cfset variables.oToken.setSecret("newsecret")>
		<cfset assertEqualsString("newsecret", variables.oToken.getSecret())>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="tearDown" returntype="void" access="private" output="false"
		hint="Tears down the fixture, for example, close a network connection.">
	</cffunction>

</cfcomponent>