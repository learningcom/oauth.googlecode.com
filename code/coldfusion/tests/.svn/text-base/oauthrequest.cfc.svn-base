<!---
Description:
============
	oauth.oauthrequest testcase

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
	name="oauth.oauthrequest testcase"
	extends="org.cfcunit.framework.TestCase"
	hint="oauth.oauthrequest testcase"
	output="false">

	<cffunction name="setUp" returntype="void" access="private" output="false" hint="test fixture">
		<cfset variables.oUtil = CreateObject("component", "oauth.oauthutil").init()>
		<cfset variables.sHttpMethod = "GET">
		<cfset variables.sHttpURL = "http://test.example.com">
		<cfset variables.stParameters = StructNew()>
		<cfset variables.stParameters["test_param1"] = 123>
		<cfset variables.stParameters["test_param2"] = "str">
		<cfset variables.sOAuthVersion = "1.0">
		<cfset variables.oRequest = CreateObject("component", "oauth.oauthrequest").init(
			sHttpMethod = variables.sHttpMethod,
			sHttpURL = variables.sHttpURL,
			stParameters = variables.stParameters,
			sOAuthVersion = variables.sOAuthVersion)>
		<cfset variables.sConsumerKey = "ckey">
		<cfset variables.sConsumerSecret = "csecret">
		<cfset variables.oConsumer = CreateObject("component", "oauth.oauthconsumer").init(
			sKey = variables.sConsumerKey, sSecret = variables.sConsumerSecret )/>
		<cfset variables.sTokenKey = "tkey">
		<cfset variables.sTokenSecret = "tsecret">
		<cfset variables.oToken = CreateObject("component", "oauth.oauthtoken").init(
			sKey = variables.sTokenKey, sSecret = variables.sTokenSecret)>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="testinit" returntype="void" access="public" output="false">
		<cfset var oTempRequest = CreateObject("component", "oauth.oauthrequest").init(
			sHttpMethod = variables.sHttpMethod,
			sHttpURL = variables.sHttpURL,
			stParameters = variables.stParameters,
			sOAuthVersion = variables.sOAuthVersion)>
		<cfset assertTrue(IsInstanceOf(oTempRequest, "oauth.oauthrequest"))>
	</cffunction>

	<cffunction name="testsetParameters" returntype="void" access="public" output="false">
		<cfset var stTempParameters = StructNew()>
		<cfset var aKeys = ArrayNew(1)>
		<cfset var aValues = ArrayNew(1)>
		<cfset var i = "">

		<cfset stTempParameters["test_param1"] = "test_one">
		<cfset stTempParameters["test_param2"] = "test_two">
		<cfset variables.oRequest.clearParameters()>
		<cfset variables.oRequest.setParameters(stParameters = stTempParameters)>
		<cfset aKeys = variables.oRequest.getParameterKeys()>
		<cfset aValues = variables.oRequest.getParameterValues()>

		<cfloop from="1" to="#ArrayLen(aKeys)#" index="i">
			<cfset AssertEqualsString(StructFind(stTempParameters, aKeys[i]), aValues[i])>
		</cfloop>
	</cffunction>

	<cffunction name="testtoHeader" returntype="void" access="public" output="false">
		<cfset var sTemp = variables.oUtil.encodePercent("oauth_version") & "=""" & variables.oUtil.encodePercent(variables.sOAuthVersion) & """"/>
		<cfset assertEqualsString(sTemp, variables.oRequest.toHeader())>
	</cffunction>

	<cffunction name="testgetString" returntype="void" access="public" output="false">
		<cfset var sReqTemp = variables.oRequest.getString()>
		<cfset var sTemp = 	variables.sHttpURL & "?" & variables.oUtil.encodePercent("oauth_version") & "=" & variables.oUtil.encodePercent(variables.sOAuthVersion) & "&"
							& variables.oUtil.encodePercent("test_param1") & "=" & variables.stParameters["test_param1"] & "&"
							& variables.oUtil.encodePercent("test_param2") & "=" & variables.stParameters["test_param2"]>
		<cfset assertEqualsString(sTemp, sReqTemp)>
	</cffunction>

	<cffunction name="testsetHttpURL" returntype="void" access="public" output="false">
		<cfset variables.oRequest.setHttpURL("http://new.example.com")>
		<cfset assertEqualsString("http://new.example.com", variables.oRequest.getHttpURL())>
	</cffunction>

	<cffunction name="testcreateEmptyRequest" returntype="void" access="public" output="false">
		<cfset var oTempRequest = CreateObject("component", "oauth.oauthrequest").init(
			sHttpMethod = "",
			sHttpURL = "")>
		<cfset assertTrue(oTempRequest.isEmpty())>
	</cffunction>

	<cffunction name="testgetParameter" returntype="void" access="public" output="false">
		<cfset assertEqualsNumber( 123, variables.oRequest.getParameter("test_param1") )>
		<cfset assertEqualsString("str", variables.oRequest.getParameter("test_param2"))>
	</cffunction>

	<cffunction name="testfromConsumerAndToken" returntype="void" access="public" output="false">
		<cfset var oTemp = variables.oRequest.fromConsumerAndToken(
			oConsumer = variables.oConsumer,
			oToken = variables.oToken,
			sHttpMethod = "GET",
			sHttpURL = "http://test.example.com")>
		<cfset assertFalse(oTemp.isEmpty())>
		<cfset assertEqualsString(variables.oToken.getKey(), oTemp.getParameter("oauth_token"))>
		<cfset assertEqualsString("GET", oTemp.getHttpMethod())>
		<cfset assertEqualsString("http://test.example.com", oTemp.getHttpURL())>
	</cffunction>

	<cffunction name="testgetNormalizedHttpMethod" returntype="void" access="public" output="false">
		<cfset variables.oRequest.setHttpMethod("post")>
		<cfset assertEqualsString("POST", variables.oRequest.getNormalizedHttpMethod())>
		<cfset variables.oRequest.setHttpMethod("pOsT")>
		<cfset assertEqualsString("POST", variables.oRequest.getNormalizedHttpMethod())>
	</cffunction>

	<cffunction name="testsetParameter" returntype="void" access="public" output="false">
		<cfset variables.oRequest.setParameter("new_parameter", "new_value")>
		<cfset assertEqualsString("new_value", variables.oRequest.getParameter("new_parameter"))>
	</cffunction>

	<cffunction name="testbuildSignature" returntype="void" access="public" output="true">
		<cfset var oTempSig = CreateObject("component", "oauth.oauthsignaturemethod_plaintext")>
		<cfset var sResult = oTempSig.buildSignature(variables.oRequest, variables.oConsumer, variables.oToken)>
		<cfset var sTemp = variables.sConsumerSecret & variables.oUtil.encodePercent("&") & variables.sTokenSecret>
		<cfset assertEqualsString(sTemp, sResult)>
		<cfset oTempSig = CreateObject("component", "oauth.oauthsignaturemethod_hmac_sha1")>
		<cfset sResult = oTempSig.buildSignature(variables.oRequest, variables.oConsumer, variables.oToken)>
		<cfset sTemp = "Y8E4YtXHc5Ca6bPptiZ+XYHfDxY=">
		<cfset assertEqualsString(sTemp, sResult)>
	</cffunction>

	<cffunction name="testtoPostData" returntype="void" access="public" output="false">
		<cfset var sReqTemp = variables.oRequest.toPostData()>
		<cfset var sTemp =	variables.oUtil.encodePercent("oauth_version") & "=" & variables.oUtil.encodePercent(variables.sOAuthVersion) & "&" &
							variables.oUtil.encodePercent("test_param1") & "=" & variables.oUtil.encodePercent(variables.stParameters["test_param1"]) & "&" &
							variables.oUtil.encodePercent("test_param2") & "=" & variables.oUtil.encodePercent(variables.stParameters["test_param2"])>
		<cfset assertEqualsString(sTemp,sReqTemp)>
	</cffunction>

	<cffunction name="testsetVersion" returntype="void" access="public" output="false">
		<cfset variables.oRequest.setVersion("1.2.3")>
		<cfset assertEqualsString("1.2.3", variables.oRequest.getVersion())>
	</cffunction>

	<cffunction name="testgetVersion" returntype="void" access="public" output="false">
		<cfset assertTrue(variables.sOAuthVersion, variables.oRequest.getVersion())>
	</cffunction>

	<cffunction name="testsignatureBaseString" returntype="void" access="public" output="false">
		<cfset var sResult = variables.sHttpMethod & "&" & variables.oUtil.encodePercent(variables.sHttpURL) & "&" &
								variables.oUtil.encodePercent("oauth_version=" & variables.sOAuthVersion & "&")  &
								variables.oUtil.encodePercent("test_param1=" & variables.stParameters["test_param1"] & "&")  &
								variables.oUtil.encodePercent("test_param2=" & variables.stParameters["test_param2"])>
		<cfset var sTemp = variables.oRequest.signatureBaseString()>
		<cfset assertEqualsString(sResult, sTemp, sTemp)>
	</cffunction>

	<cffunction name="testgetSignableParameters" returntype="void" access="public" output="false">
		<cfset var sTemp = variables.oRequest.getSignableParameters()>
		<cfset var sParams = "oauth_version=1.0&test_param1=123&test_param2=str">
		<cfset assertEqualsString(sParams, sTemp)>
	</cffunction>

	<cffunction name="testfromRequest" returntype="void" access="public" output="false">
		<cfset var oTemp = variables.oRequest.fromRequest(sHttpMethod="POST", sHttpURL="http://test.com")>
		<cfset assertFalse(oTemp.isEmpty())>
		<cfset assertEqualsString("POST", oTemp.getHttpMethod())>
		<cfset assertEqualsString("http://test.com", oTemp.getHttpURL())>
	</cffunction>

	<cffunction name="testgenerateNonce" returntype="void" access="public" output="false">
		<cfset var sTemp = variables.oRequest.generateNonce()>
		<cfset assertTrue(Len(sTemp) GT 0)>
	</cffunction>

	<cffunction name="testgetHttpMethod" returntype="void" access="public" output="false">
		<cfset assertEqualsString(variables.sHttpMethod, variables.oRequest.getHttpMethod())>
	</cffunction>

	<cffunction name="testgetHttpURL" returntype="void" access="public" output="false">
		<cfset assertEqualsString(variables.sHttpURL, variables.oRequest.getHttpURL())>
	</cffunction>

	<cffunction name="testgetNormalizedHttpURL" returntype="void" access="public" output="false">
		<cfset assertEqualsString(variables.sHttpURL, variables.oRequest.getNormalizedHttpURL())>
	</cffunction>

	<cffunction name="testsignRequest" returntype="void" access="public" output="false">
		<cfset var oTempSig = CreateObject("component", "oauth.oauthsignaturemethod_plaintext")>
		<cfset var sTemp = variables.sConsumerSecret & variables.oUtil.encodePercent("&") & variables.sTokenSecret>
		<cfset variables.oRequest.signRequest(oTempSig, variables.oConsumer, variables.oToken)>
		<cfset assertEqualsString(sTemp, variables.oRequest.getParameter("oauth_signature"))>

		<cfset oTempSig = CreateObject("component", "oauth.oauthsignaturemethod_hmac_sha1")>
		<cfset sTemp = "ml+HYq0MwAdWnwJ+MZwYQP/8xT0=">
		<cfset variables.oRequest.signRequest(oTempSig, variables.oConsumer, variables.oToken)>
		<cfset assertEqualsString(sTemp, variables.oRequest.getParameter("oauth_signature"))>
	</cffunction>

	<cffunction name="testtoURL" returntype="void" access="public" output="false">
		<cfset var sReqTemp = variables.oRequest.toURL()>
		<cfset var sTemp = 	variables.sHttpURL & "?"
					& variables.oUtil.encodePercent("oauth_version") & "="
					& variables.oUtil.encodePercent(variables.sOAuthVersion) & "&"
					& variables.oUtil.encodePercent("test_param1") & "="
					& variables.oUtil.encodePercent(variables.stParameters["test_param1"]) & "&"
					& variables.oUtil.encodePercent("test_param2") & "="
					& variables.oUtil.encodePercent(variables.stParameters["test_param2"])>

		<cfset assertEqualsString(sTemp, sReqTemp)>
	</cffunction>

	<cffunction name="testsetHttpMethod" returntype="void" access="public" output="false">
		<cfset variables.oRequest.setHttpMethod("POST")>
		<cfset assertEqualsString("POST", variables.oRequest.getHttpMethod())>
		<cfset variables.oRequest.setHttpMethod("GET")>
		<cfset assertEqualsString("GET", variables.oRequest.getHttpMethod())>
	</cffunction>

	<cffunction name="testgetParameters" returntype="void" access="public" output="false">
		<cfset var stTemp = variables.oRequest.getParameters()>
		<cfset var aKeys = variables.oRequest.getParameterKeys()>
		<cfset var aValues = variables.oRequest.getParameterValues()>
		<cfset var i = 0>

		<cfloop from="1" to="#ArrayLen(stTemp['paramKeys'])#" index="i">
			<cfset AssertEqualsString(stTemp['paramKeys'][i], aKeys[i])>
		</cfloop>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="tearDown" returntype="void" access="private" output="false"
		hint="Tears down the fixture, for example, close a network connection.">
	</cffunction>

</cfcomponent>