<!---
Description:
============
	oauth.oauthdatastore testcase

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
	name="oauth.oauthdatastore testcase"
	extends="org.cfcunit.framework.TestCase"
	output="false"
	hint="oauth.oauthdatastore testcase">

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
		<cfset variables.oConsumer = CreateObject("component","oauth.oauthconsumer").init(
			sKey = variables.stData.consumerkey,
			sSecret = variables.stData.consumersecret )>
		<cfset variables.iConsumerIDToDelete = variables.oConsumerDAO.read(variables.stData.consumerkey).consumerID>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="testlookUpNonce" returntype="void" access="public" output="false">
		<cfset var oTemp = variables.oDataStore.newToken(variables.oConsumer, "REQUEST")>
		<cfset var sTempNonce = variables.oDataStore.getTokenNonce(oToken = oTemp, sTokenType = "REQUEST")>
		<cfset assertTrue(variables.oDataStore.lookUpNonce(
			oConsumer = variables.oConsumer,
			oToken = oTemp,
			sNonce = sTempNonce,
			timestamp = GetTickCount()) )>
		<cfset variables.oDataStore.deleteToken(sTokenKey = oTemp.getKey(), sTokenType = "REQUEST")>
		<cfset assertFalse(variables.oDataStore.lookUpNonce(
			oConsumer = variables.oConsumer,
			oToken = oTemp,
			sNonce = sTempNonce,
			timestamp = GetTickCount()) )>
	</cffunction>

	<cffunction name="testnewRequestToken" returntype="void" access="public" output="false">
		<cfset var oTemp = variables.oDataStore.newRequestToken(variables.oConsumer)>
		<cfset assertTrue(IsInstanceOf(oTemp, "oauth.oauthtoken"))>
	</cffunction>

	<cffunction name="testlookUpConsumer" returntype="void" access="public" output="false">
		<cfset var oTemp = Createobject("component", "oauth.oauthconsumer").init(
			sKey = variables.stData.consumerkey,
			sSecret = variables.stData.consumersecret)>
		<cfset var oResult = variables.oDataStore.lookupConsumer(variables.stData.consumerkey)>
		<cfset assertTrue(IsInstanceOf(oResult,"oauth.oauthconsumer"))>
		<cfset assertEqualsString(oTemp.getKey(), oResult.getKey())>
		<cfset assertEqualsString(oTemp.getSecret(), oResult.getSecret())>
	</cffunction>

	<cffunction name="testnewToken" returntype="void" access="public" output="false">
		<cfset var oTemp = variables.oDataStore.newToken(variables.oConsumer, "REQUEST")>
		<cfset assertTrue(IsInstanceOf(oTemp, "oauth.oauthtoken"))>
		<cfset variables.oDataStore.deleteToken(sTokenKey = oTemp.getKey(), sTokenType = "REQUEST")>
		<cfset oTemp = variables.oDataStore.newToken(variables.oConsumer, "ACCESS")>
		<cfset assertTrue(IsInstanceOf(oTemp, "oauth.oauthtoken"))>
		<cfset variables.oDataStore.deleteToken(sTokenKey = oTemp.getKey(), sTokenType = "ACCESS")>
	</cffunction>

	<cffunction name="testlookUpNonceValue" returntype="void" access="public" output="false">
		<cfset var oTemp = variables.oDataStore.newToken(variables.oConsumer, "REQUEST")>
		<cfset var sTempNonce = variables.oDataStore.getTokenNonce(oToken = oTemp, sTokenType = "REQUEST")>
		<cfset assertTrue(Len(variables.oDataStore.lookUpNonceValue(
			oToken = oTemp, sNonce = sTempNonce) )) GT 0>
		<cfset variables.oDataStore.deleteToken(sTokenKey = oTemp.getKey(), sTokenType = "REQUEST")>
		<cfset assertTrue(Len(variables.oDataStore.lookUpNonceValue(
			oToken = oTemp,	sNonce = sTempNonce) ) IS 0)>
	</cffunction>

	<cffunction name="testnewAccessToken" returntype="void" access="public" output="false">
		<cfset var oReqTemp = variables.oDataStore.newRequestToken(variables.oConsumer)>
		<cfset var oAccTemp = variables.oDataStore.newAccessToken(oToken = oReqTemp, oConsumer = variables.oConsumer)>
		<cfset assertTrue(IsInstanceOf(oAccTemp, "oauth.oauthtoken"))>
	</cffunction>

	<cffunction name="testlookUpConsumerID" returntype="void" access="public" output="false">
		<cfset var iTemp = variables.oDataStore.lookUpConsumerID(variables.stData.consumerkey)>
		<cfset assertEqualsNumber(iTemp, variables.iConsumerIDToDelete)>
	</cffunction>

	<cffunction name="testdeleteToken" returntype="void" access="public" output="false">
		<cfset var oTemp = variables.oDataStore.newToken(variables.oConsumer, "REQUEST")>
		<cfset assertTrue(IsInstanceOf(oTemp, "oauth.oauthtoken"))>
		<cfset variables.oDataStore.deleteToken(sTokenKey = oTemp.getKey(), sTokenType = "REQUEST")>
		<cfset assertTrue(variables.oDataStore.lookUpToken(sTokenType="REQUEST", oToken=oTemp).isEmpty())>
		<cfset oTemp = variables.oDataStore.newToken(variables.oConsumer, "ACCESS")>
		<cfset assertTrue(IsInstanceOf(oTemp, "oauth.oauthtoken"))>
		<cfset variables.oDataStore.deleteToken(sTokenKey = oTemp.getKey(), sTokenType = "ACCESS")>
		<cfset assertTrue(variables.oDataStore.lookUpToken(sTokenType="ACCESS",oToken = oTemp).isEmpty())>
	</cffunction>

	<cffunction name="testlookUpToken" returntype="void" access="public" output="false">
		<cfset var oTemp = variables.oDataStore.newToken(variables.oConsumer, "REQUEST")>
		<cfset var oResult = variables.oDataStore.lookUpToken(sTokenType="REQUEST",oToken = oTemp)>

		<cfset assertTrue(IsInstanceOf(oTemp, "oauth.oauthtoken"))>
		<cfset assertTrue(IsInstanceOf(oResult, "oauth.oauthtoken"))>
		<cfset assertFalse(variables.oDataStore.lookUpToken(sTokenType="REQUEST", oToken=oTemp).isEmpty())>
		<cfset variables.oDataStore.deleteToken(sTokenKey = oTemp.getKey(), sTokenType = "REQUEST")>
		<cfset assertTrue(variables.oDataStore.lookUpToken(sTokenType="REQUEST", oToken=oTemp).isEmpty())>

		<cfset oTemp = variables.oDataStore.newToken(variables.oConsumer, "ACCESS")>
		<cfset oResult = variables.oDataStore.lookUpToken(sTokenType="ACCESS",oToken=oTemp)>
		<cfset assertTrue(IsInstanceOf(oTemp, "oauth.oauthtoken"))>
		<cfset assertTrue(IsInstanceOf(oResult, "oauth.oauthtoken"))>
		<cfset assertFalse(variables.oDataStore.lookUpToken(sTokenType="ACCESS",oToken = oTemp).isEmpty())>
		<cfset variables.oDataStore.deleteToken(sTokenKey = oTemp.getKey(), sTokenType = "ACCESS")>
		<cfset assertTrue(variables.oDataStore.lookUpToken(sTokenType="ACCESS",oToken = oTemp).isEmpty())>
	</cffunction>

	<cffunction name="testinit" returntype="void" access="public" output="false">
		<cfset assertTrue(IsInstanceOf(variables.oDataStore, "oauth.oauthdatastore"))>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="tearDown" returntype="void" access="private" output="false"
		hint="Tears down the fixture, for example, close a network connection.">
		<cfset variables.oConsumerDAO.delete(variables.iConsumerIDToDelete)>
	</cffunction>

</cfcomponent>