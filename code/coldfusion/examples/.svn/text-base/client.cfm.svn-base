<cfsilent>
<!---
Description:
============
	client testpage

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
</cfsilent>

<cfoutput>
<html>
<head>
	<title>ColdFusion - OAuth Test Client</title>
	<link rel="stylesheet" type="text/css" href="oauth.css">
</head>
<body>
<cfinclude template="common.cfm">
<cfinclude template="navimenu.cfm">

<form action="#CGI.SCRIPT_NAME#" method="POST">

<!--- create dao --->
<cfset oReqDataStore = CreateObject("component", "oauth.oauthtest").init(sDataSource, true)>

<!--- create server --->
<cfset oReqServer = CreateObject("component", "oauth.oauthserver").init(oReqDataStore)>

<!--- register signature methods --->
<cfset oReqSigMethodSHA = CreateObject("component", "oauth.oauthsignaturemethod_hmac_sha1")>
<cfset oReqSigMethodPLAIN = CreateObject("component", "oauth.oauthsignaturemethod_plaintext")>
<cfset oUtil = CreateObject("component", "oauth.oauthutil").init()>
<cfset oReqServer.addSignatureMethod(oReqSigMethodSHA)>
<cfset oReqServer.addSignatureMethod(oReqSigMethodPLAIN)>

<cfset stRequest = StructNew()>
<cfset stRequest["KEY"] = "default_key">
<cfset stRequest["SECRET"] = "default_secret">
<cfset stRequest["TOKEN"] = "">
<cfset stRequest["TOKEN_SECRET"] = "default_token_secret">
<cfset stRequest["ENDPOINT"] = "">
<cfset stRequest["ACTION"] = "">
<cfset stRequest["DUMP"] = "">

<cfset StructAppend(stRequest, FORM, "True")>
<cfset StructAppend(stRequest, URL, "True")>

<cfset sClientKey = stRequest["KEY"]>
<cfset sClientSecret = stRequest["SECRET"]>
<cfset sClientToken = stRequest["TOKEN"]>
<cfset sClientTokenSecret = stRequest["TOKEN_SECRET"]>
<cfset sEndpoint = stRequest["ENDPOINT"]>
<cfset sAction = stRequest["ACTION"]>
<cfset sDump = stRequest["DUMP"]>

<cfset oTestConsumer = CreateObject("component", "oauth.oauthconsumer").init(sKey = sClientKey, sSecret = sClientSecret)>
<cfset oEmptyToken = CreateObject("component", "oauth.oauthtoken").createEmptyToken()>
<cfset oTestToken = CreateObject("component", "oauth.oauthtoken").createEmptyToken()>

<cfif NOT Len(sClientToken) IS 0>
	<cfset oTestToken = CreateObject("component", "oauth.oauthtoken").init(sKey = sClientToken, sSecret = sClientTokenSecret)>
</cfif>

<cfif Compare(LCase(sAction), "request_token") IS 0>
	<cfset oReq = CreateObject("component", "oauth.oauthrequest").fromConsumerAndToken(
		oConsumer = oTestConsumer,
		oToken = oEmptyToken,
		sHttpMethod = "GET",
		sHttpURL = sEndpoint )>
	<cfset oReq.signRequest(
		oSignatureMethod = oReqSigMethodSHA,
		oConsumer = oTestConsumer,
		oToken = oEmptyToken)>

	<cfif NOT Len(sDump) IS 0>
		<cfheader name="Content-type" value="text/plain">
		request_url : #oReq.getString()#<br>
		<cfdump var="#oReq.getParameters()#">
	<cfelse>
		<cflocation url="#oReq.getString()#">
	</cfif>

<cfelseif Compare(LCase(sAction), "authorize") IS 0>
	<cfset sCallbackURL = sBaseURL & CGI.SCRIPT_NAME & "?" &
		"key=" & sClientKey &
		"&" & "secret=" & sClientSecret &
		"&" & "token=" & sClientToken &
		"&" & "token_secret=" & sClientTokenSecret &
		"&" & "endpoint=" & oUtil.encodePercent(sEndpoint)>
	<cfset sAuthURL = sEndpoint & "?oauth_token=" & sClientToken & "&" & "oauth_callback=" & oUtil.encodePercent(sCallbackURL)>
	<cfif NOT Len(sDump) IS 0>
		<cfheader name="Content-type" value="text/plain">
		auth_url : #sAuthURL#<br>
	<cfelse>
		<cflocation url="#sAuthURL#">
	</cfif>

<cfelseif Compare(LCase(sAction), "access_token") IS 0>
	<cfset oReq = CreateObject("component", "oauth.oauthrequest").fromConsumerAndToken(
		oConsumer = oTestConsumer,
		oToken = oTestToken,
		sHttpMethod = "GET",
		sHttpURL = sEndpoint )>
	<cfset oReq.signRequest(
		oSignatureMethod = oReqSigMethodSHA,
		oConsumer = oTestConsumer,
		oToken = oTestToken)>

	<cfif NOT Len(sDump) IS 0>
		<cfheader name="Content-type" value="text/plain">
		request_url : #oReq.getString()#<br>
		<cfdump var="#oReq.getParameters()#">
	<cfelse>
		<cflocation url="#oReq.getString()#">
	</cfif>

</cfif>

<cfset oAccessToken = CreateObject("component", "oauth.oauthconsumer").init(sKey = "accesskey", sSecret = "accesssecret")>

<cfset sTempURL = sBaseURL & "/" & sRequestTokenURL>
<cfset sOptRequestURL = sTempURL>
<cfset oRReq = CreateObject("component", "oauth.oauthrequest").fromConsumerAndToken(
	oConsumer = oTestConsumer,
	oToken = oEmptyToken,
	sHttpMethod = "GET",
	sHttpURL = sTempURL)>
<cfset oRReq.signRequest(
	oSignatureMethod = oReqSigMethodSHA,
	oConsumer = oTestConsumer,
	oToken = oEmptyToken)>

<cfset sTempURL = sBaseURL & "/" & sAccessTokenURL>
<cfset sOptAccessURL = sTempURL>
<cfset oAReq = CreateObject("component", "oauth.oauthrequest").fromConsumerAndToken(
	oConsumer = oTestConsumer,
	oToken = oTestToken,
	sHttpMethod = "GET",
	sHttpURL = sTempURL)>
<cfset oAReq.signRequest(
	oSignatureMethod = oReqSigMethodSHA,
	oConsumer = oTestConsumer,
	oToken = oTestToken)>

<cfset sTempURL = sBaseURL & "/" & sEchoURL>
<!--- some dummy parameters with dummy values, using different characters to test encoding too --->
<cfset stDummyParams = StructNew()>
<cfset stDummyParams.dummy = "v_a^lue$">
<cfset stDummyParams.anotherdummy = "ß?other _%§value~">
<cfset oEReq = CreateObject("component", "oauth.oauthrequest").fromConsumerAndToken(
	oConsumer = oTestConsumer,
	oToken = oTestToken,
	sHttpMethod = "GET",
	sHttpURL = sTempURL,
	stParams = stDummyParams)>
<cfset oEReq.signRequest(
	oSignatureMethod = oReqSigMethodSHA,
	oConsumer = oTestConsumer,
	oToken = oTestToken)>
<cfset sAuthRequestURL = sBaseURL & "/" & "authorize.cfm">

<div style="text-align:left;">
<h1>OAuth Test Client</h1>
<h2>Instructions for Use</h2>
<p>This is a test client that will let you test your OAuth server code. Enter the appropriate information below to test.</p>

<table id="oauth">
<tr>
	<th colspan="2">Enter The Endpoint to Test</th>
</tr>
<tr>
	<td>endpoint:</td>
	<td>
		<select name="endpoint">
			<option value="#sRequestTokenURL#">#sRequestTokenURL#</option>
			<option value="#sAccessTokenURL#">#sAccessTokenURL#</option>
		</select>
	</td>
</tr>
<tr>
	<th colspan="2">Enter Your Consumer Key / Secret</th>
</tr>
<tr>
	<td>consumer key:</td>
	<td><input type="text" name="key" value="#sClientKey#"></input></td>
</tr>
<tr>
	<td>consumer secret:</td>
	<td><input type="text" name="secret" value="#sClientSecret#"></input></td>
</tr>
<tr>
	<td>dump request, don't redirect:</td>
	<td><input type="checkbox" name="dump_request" value="1" <cfif IsDefined('variables.sDump')>checked="checked"</cfif>></td>
</tr>
<tr>
	<td>make a token request (don't forget to copy down the values you get)</td>
	<td><input type="submit" name="action" value="request_token"></td>
</tr>

<tr>
	<th colspan="2">Enter Your Request Token / Secret</th>
</tr>
<tr>
	<td>token:</td>
	<td><input type="text" name="token" value="#sClientToken#"></input></td>
</tr>
<tr>
	<td>token secret: </td>
	<td><input type="text" name="token_secret" value="#sClientTokenSecret#"></input></td>
</tr>

<tr>
	<th colspan="2">Don't forget to update your endpoint to point at the auth or access token url</th>
</tr>
<tr>
	<td>try to authorize this token:</td>
	<td><input type="submit" name="action" value="authorize"></td>
</tr>
<tr>
	<td>try to get an access token:</td>
	<td><input type="submit" name="action" value="access_token"></td>
</tr>
</table>

<p>
	<h3>Supported signature methods :</h3>
	<cfloop collection="#oReqServer.getSupportedSignatureMethods()#" item="sItem">#sItem#<br></cfloop>
</p>
</div>
</form>

<cfdump var="#FORM#" label="FORM">
<cfdump var="#URL#" label="URL">
<cfdump var="#stRequest#" label="parameters after append">

</body>
</html>
</cfoutput>