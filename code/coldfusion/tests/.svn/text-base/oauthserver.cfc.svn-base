<!---
Description:
============
	oauth.oauthserver testcase

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
	name="oauth.oauthserver testcase"
	extends="org.cfcunit.framework.TestCase"
	output="false"
	hint="oauth.oauthserver testcase">

	<cffunction name="setUp" returntype="void" access="private" output="false" hint="test fixture">
		<cfset variables.sDataSource = "oauth">

		<cfset variables.oConsumerDAO = CreateObject("component", "oauth.oauthconsumerdao").init(variables.sDataSource)>
		<cfset variables.stData = StructNew()>
		<cfset variables.stData.consumername = "_testusername">
		<cfset variables.stData.consumerfullname = "test user name">
		<cfset variables.stData.consumeremail = "test@example.com">
		<cfset variables.stData.consumerkey = "CONSUMER_KEY_TEST">
		<cfset variables.stData.consumersecret = "CONSUMER_SECRET_TEST">
		<cfset variables.oConsumerDAO.create(variables.stData)>
		<cfset variables.iDeleteID = variables.oConsumerDAO.read(variables.stData.consumerkey).consumerID>

		<cfset variables.oConsumer = CreateObject("component","oauth.oauthconsumer").init(
			sKey = variables.stData.consumerkey,
			sSecret = variables.stData.consumersecret)>

		<cfset variables.oSig = CreateObject("component","oauth.oauthsignaturemethod_hmac_sha1")>

		<cfset variables.sTokenKey = "tkey">
		<cfset variables.sTokenSecret = "tsecret">
		<cfset variables.oToken = CreateObject("component","oauth.oauthtoken").init(
			sKey = variables.sTokenKey,
			sSecret = variables.sTokenSecret)>

		<cfset variables.oDataStore = CreateObject("component", "oauth.oauthdatastore").init(variables.sDataSource)>
		<cfset variables.oServer = CreateObject("component", "oauth.oauthserver").init(oDataStore = variables.oDataStore)>
		<!--- add signature --->
		<cfset variables.oServer.addSignatureMethod(variables.oSig)>
		<cfset variables.sOAuthVersion = "1.0">
		<cfset variables.sHttpMethod = "GET">
		<cfset variables.sHttpURL = "http://example.com">
		<cfset variables.stParameters = StructNew()>
		<cfset variables.oRequest = CreateObject("component", "oauth.oauthrequest").init(
			sHttpMethod = variables.sHttpMethod,
			sHttpURL = variables.sHttpURL,
			stParameters = variables.stParameters,
			sOAuthVersion = variables.sOAuthVersion)>
		<cfset variables.oRequest.signRequest(oSignatureMethod = variables.oSig, oConsumer = variables.oConsumer, oToken = variables.oToken)>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="testfetchRequestToken" returntype="void" access="public" output="false">
		<cfset var oTestRToken = "">
		<cfset var oReqToken = CreateObject("component", "oauth.oauthtoken").init(
			sKey = variables.sTokenKey,
			sSecret = variables.sTokenSecret)>
		<cfset var oLookUpToken = variables.oDataStore.lookUpToken(
			oConsumer = variables.oConsumer,
			sTokenType = "request",
			oToken = oReqToken)>

		<cfset variables.oRequest.setParameter("oauth_consumer_key",variables.oConsumer.getKey())>
		<cfset variables.oRequest.setParameter("oauth_timestamp",getTickCount())>
		<cfset oReqToken = variables.oServer.fetchRequestToken(variables.oRequest)>
		<cfset assertTrue(IsInstanceOf(oReqToken, "oauth.oauthtoken"))>
		<cfif oLookUpToken.isEmpty()>
			<cfset oTestRToken = oDataStore.newToken(
				oConsumer = variables.oConsumer,
				sTokenType = "REQUEST",
				sKey = variables.sTokenKey,
				sSecret = variables.sTokenSecret)>
		<cfelse>
			<cfset oTestRToken = oLookUpToken>
		</cfif>
		<cfset assertTrue(IsInstanceOf(oReqToken, "oauth.oauthtoken") AND NOT oReqToken.isEmpty())>
	</cffunction>

	<cffunction name="testaddSignatureMethod" returntype="void" access="public" output="false">
		<cfset var oTempSignature = CreateObject("component", "oauth.oauthsignaturemethod_plaintext")>
		<cfset var stTemp = StructNew()>
		<cfset variables.oServer.addSignatureMethod(oTempSignature)>
		<cfset StructAppend(stTemp, variables.oServer.getSupportedSignatureMethods())>
		<cfset assertTrue(StructKeyExists(stTemp, oTempSignature.getName()))>
	</cffunction>

	<cffunction name="testinit" returntype="void" access="public" output="false">
		<cfset assertTrue(IsInstanceOf(variables.oServer,"oauth.oauthserver"))>
	</cffunction>

	<cffunction name="testfetchAccessToken" returntype="void" access="public" output="false">
		<cfset var oReqToken = "">
		<cfset var oAccToken = "">
		<cfset var oLookUpToken = "">

		<cfset oReqToken = CreateObject("component", "oauth.oauthtoken").init(
			sKey = variables.sTokenKey,
			sSecret = variables.sTokenSecret)>
		<cfset oLookUpToken = variables.oDataStore.lookUpToken(
			oConsumer = variables.oConsumer,
			sTokenType = "request",
			oToken = oReqToken)>
		<cfset variables.oRequest.setParameter("oauth_consumer_key",variables.oConsumer.getKey())>
		<cfset variables.oRequest.setParameter("oauth_timestamp",getTickCount())>
		<cfset oReqToken = variables.oServer.fetchRequestToken(variables.oRequest)>
		<cfset assertTrue(IsInstanceOf(oReqToken, "oauth.oauthtoken") AND NOT oReqToken.isEmpty())>
		<cfif oLookUpToken.isEmpty()>
			<cfset oReqToken = oDataStore.newToken(
				oConsumer = variables.oConsumer,
				sTokenType = "REQUEST",
				sKey = variables.sTokenKey,
				sSecret = variables.sTokenSecret)>
		<cfelse>
			<cfset oReqToken = oLookUpToken>
		</cfif>
		<cfset assertTrue(IsInstanceOf(oReqToken, "oauth.oauthtoken"))>
		<cfset variables.oRequest.setParameter("oauth_token",oReqToken.getKey())>
		<cfset variables.oRequest.setParameter("oauth_token_secret",oReqToken.getSecret())>
		<cfset oAccToken = variables.oServer.fetchAccessToken(variables.oRequest)>
		<cfset assertTrue(IsInstanceOf(oAccToken, "oauth.oauthtoken") AND NOT oAccToken.isEmpty())>
	</cffunction>

	<cffunction name="testverifyRequest" returntype="void" access="public" output="false">
		<cfset var oReqToken = "">
		<cfset var oAccToken = "">
		<cfset var oLookUpToken = "">

		<cfset oReqToken = CreateObject("component", "oauth.oauthtoken").init(
			sKey = variables.sTokenKey,
			sSecret = variables.sTokenSecret)>
		<cfset oLookUpToken = variables.oDataStore.lookUpToken(
			oConsumer = variables.oConsumer,
			sTokenType = "request",
			oToken = oReqToken)>

		<cfset variables.oRequest.setParameter("oauth_consumer_key",variables.oConsumer.getKey())>
		<cfset variables.oRequest.setParameter("oauth_timestamp",getTickCount())>
		<cfset oReqToken = variables.oServer.fetchRequestToken(variables.oRequest)>
		<cfset assertTrue(IsInstanceOf(oReqToken, "oauth.oauthtoken"))>
		<cfif oLookUpToken.isEmpty()>
			<cfset oReqToken = oDataStore.newToken(
				oConsumer = variables.oConsumer,
				sTokenType = "REQUEST",
				sKey = variables.sTokenKey,
				sSecret = variables.sTokenSecret)>
		<cfelse>
			<cfset oReqToken = oLookUpToken>
		</cfif>
		<cfset assertTrue(IsInstanceOf(oReqToken, "oauth.oauthtoken") AND NOT oReqToken.isEmpty())>
		<cfset variables.oRequest.setParameter("oauth_token", oReqToken.getKey())>
		<cfset variables.oRequest.setParameter("oauth_token_secret", oReqToken.getSecret())>
		<cfset oAccToken = variables.oServer.fetchAccessToken(variables.oRequest)>
		<cfset assertTrue(IsInstanceOf(oAccToken, "oauth.oauthtoken") AND NOT oAccToken.isEmpty())>
		<cfif oLookUpToken.isEmpty()>
			<cfset oAccToken = oDataStore.newToken(
				oConsumer = variables.oConsumer,
				sTokenType = "ACCESS",
				sKey = oReqToken.getKey(),
				sSecret = oReqToken.getSecret())>
		<cfelse>
			<cfset oAccToken = oLookUpToken>
		</cfif>
		<cfset variables.oRequest.setParameter("oauth_key", oAccToken.getKey())>
		<cfset variables.oRequest.setParameter("oauth_timestamp", getTickCount())>
		<cfset variables.oRequest.signRequest(variables.oSig, variables.oConsumer, oAccToken)>

		<cfset assertTrue(variables.oServer.verifyRequest(variables.oRequest))>
	</cffunction>

	<cffunction name="testgetSupportedSignatureMethods" returntype="void" access="public" output="false">
		<cfset assertTrue(IsStruct(variables.oServer.getSupportedSignatureMethods()))>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="tearDown" returntype="void" access="private" output="false"
		hint="Tears down the fixture, for example, close a network connection.">
			<cfset variables.oConsumerDAO.delete(variables.iDeleteID)>
	</cffunction>

</cfcomponent>