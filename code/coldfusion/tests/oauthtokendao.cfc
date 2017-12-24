<!---
Description:
============
	oauth.oauthtokendao testcase

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
	name="oauth.oauthtokendao testcase"
	extends="org.cfcunit.framework.TestCase"
	output="false"
	hint="oauth.oauthtokendao testcase">

	<cffunction name="setUp" returntype="void" access="private" output="false" hint="test fixture">
		<cfset variables.sDataSource = "oauth">

		<cfset variables.oDataStore = CreateObject("component", "oauth.oauthdatastore").init(variables.sDataSource)>

		<cfset variables.oConsumerDAO = CreateObject("component", "oauth.oauthconsumerdao").init(variables.sDataSource)>
		<cfset variables.stData = StructNew()>
		<cfset variables.stData.consumername = "_testusername">
		<cfset variables.stData.consumerfullname = "test user name">
		<cfset variables.stData.consumeremail = "test@example.com">
		<cfset variables.stData.consumerkey = "CONSUMER_KEY_TEST">
		<cfset variables.stData.consumersecret = "CONSUMER_SECRET_TEST">
		<cfset variables.oConsumerDAO.create(variables.stData)>
		<cfset variables.iDeleteID = variables.oConsumerDAO.read(variables.stData.consumerkey).consumerID>

		<cfset variables.oTokenDAO = CreateObject("component", "oauth.oauthtokendao").init(variables.sDataSource)>
		<cfset variables.stTokenData.tokenkey = "tkey">
		<cfset variables.stTokenData.tokensecret = "tsecret">
		<cfset variables.stTokenData.tokentype = "REQUEST">

		<cfset variables.oToken = CreateObject("component", "oauth.oauthtoken").init(
			sKey = variables.stTokenData.tokenkey,
			sSecret = variables.stTokenData.tokensecret)>

		<cfset variables.stTokenData.consumerid = variables.iDeleteID>
		<cfset variables.stTokenData.nonce = variables.oDataStore.getTokenNonce(oToken = variables.oToken, sTokenType = variables.stTokenData.tokentype)>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="testread" returntype="void" access="public" output="false">
		<cfset variables.oTokenDAO.create(stCreateData = variables.stTokenData)>
		<cfset assertFalse(StructIsEmpty(variables.oTokenDAO.read(variables.stTokenData.tokenkey)))>
		<cfset variables.oTokenDAO.delete(sTokenKey = variables.stTokenData.tokenkey, sTokenType = variables.stTokenData.tokentype)>
		<cfset assertTrue(StructIsEmpty(variables.oTokenDAO.read(variables.stTokenData.tokenkey)))>
	</cffunction>

	<cffunction name="testcreate" returntype="void" access="public" output="false">
		<cfset variables.oTokenDAO.create(stCreateData = variables.stTokenData)>
		<cfset assertFalse(StructIsEmpty(variables.oTokenDAO.read(variables.stTokenData.tokenkey)))>
		<cfset variables.oTokenDAO.delete(sTokenKey = variables.stTokenData.tokenkey, sTokenType = variables.stTokenData.tokentype)>
		<cfset assertTrue(StructIsEmpty(variables.oTokenDAO.read(variables.stTokenData.tokenkey)))>
	</cffunction>

	<cffunction name="testinit" returntype="void" access="public" output="false">
		<cfset assertTrue(IsInstanceOf(variables.oTokenDAO, "oauth.oauthtokendao"))>
	</cffunction>

	<cffunction name="testlistAll" returntype="void" access="public" output="false">
		<cfset assertTrue(IsQuery(variables.oTokenDAO.listAll()))>
	</cffunction>

	<cffunction name="testdelete" returntype="void" access="public" output="false">
		<cfset variables.oTokenDAO.create(stCreateData = variables.stTokenData)>
		<cfset assertFalse(StructIsEmpty(variables.oTokenDAO.read(variables.stTokenData.tokenkey)))>
		<cfset variables.oTokenDAO.delete(sTokenKey = variables.stTokenData.tokenkey, sTokenType = variables.stTokenData.tokentype)>
		<cfset assertTrue(StructIsEmpty(variables.oTokenDAO.read(variables.stTokenData.tokenkey)))>
	</cffunction>

	<cffunction name="testgetTokenCount" returntype="void" access="public" output="false">
		<cfset assertTrue(IsNumeric(variables.oTokenDAO.getTokenCount()))>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="tearDown" returntype="void" access="private" output="false"
		hint="Tears down the fixture, for example, close a network connection.">
		<cfset variables.oConsumerDAO.delete(variables.iDeleteID)>
	</cffunction>

</cfcomponent>