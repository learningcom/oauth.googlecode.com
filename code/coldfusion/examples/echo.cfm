<cfsilent>
<!---
Description:
============
	analyze request

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
	<title>Echo</title>
</head>
<body>

<cfinclude template="common.cfm">

<!--- create dao --->
<cfset oReqDataStore = CreateObject("component", "oauth.oauthtest").init(sDataSource, true)>

<!--- create server --->
<cfset oReqServer = CreateObject("component", "oauth.oauthserver").init(oReqDataStore)>

<!--- register signature methods --->
<cfset oReqSigMethodSHA = CreateObject("component", "oauth.oauthsignaturemethod_hmac_sha1")>
<cfset oReqSigMethodPLAIN = CreateObject("component", "oauth.oauthsignaturemethod_plaintext")>
<cfset oReqServer.addSignatureMethod(oReqSigMethodSHA)>
<cfset oReqServer.addSignatureMethod(oReqSigMethodPLAIN)>

<!--- analyze request --->
<cfset oReq = CreateObject("component", "oauth.oauthrequest").fromRequest()>
<cfdump var="#oReq.getParameters()#">
<!--- <cfset oReqServer.verifyRequest(oReq)> --->
<cfset test = oReqServer.verifyRequest(oReq)>
<!--- <cfdump var="#test#"> --->
<cfset aEchoParams = ArrayNew(1)>

<cfset aParamKeys = oReq.getParameterKeys()>
<cfset aParamValues = oReq.getParameterValues()>

<cfloop from="1" to="#ArrayLen(aParamKeys)#" index="i">
	<cfif NOT Left(aParamKeys[i], 5) EQ "oauth">
		<cfset ArrayAppend(aEchoParams, aParamKeys[i] & "=" & aParamValues[i])>
	</cfif>
</cfloop>
<cfset ArraySort(aEchoParams, "textnocase", "asc")>

non-OAuth parameters:<br>#ArrayToList(aEchoParams, "&")#
</body>
</html>
</cfoutput>