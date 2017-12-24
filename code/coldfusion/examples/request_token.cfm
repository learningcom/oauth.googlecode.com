<cfsilent>
<!---
Description:
============
	Request Token Endpoint

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
	<title>Request Token</title>
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
<cfdump var="#oReq.getParameters()#" label="#CGI.SCRIPT_NAME#">

<!--- retrieve request token --->
<cfset oReqToken = oReqServer.fetchRequestToken(oReq)>

server response : <br>
[#oReqToken.getString()#]<br>
key = #oReqToken.getKey()#, secret = #oReqToken.getSecret()#<br>
</body>
</html>
</cfoutput>