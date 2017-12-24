<cfsilent>
<!--- 
Description:
============
	admin main

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

<html>
<head>
	<title>ColdFusion OAuth Test Server</title>
	<link rel="stylesheet" type="text/css" href="oauth.css">
</head>
<body>

<cfoutput>

<cfinclude template="common.cfm">
<cfinclude template="navimenu.cfm">

<cfset oTestDataStore = CreateObject("component", "oauth.oauthtest").init(sDataSource, false)>
<cfset oTestServer = CreateObject("component", "oauth.oauthserver").init(oTestDataStore)>

<cfset sTestConsumerKey = "CONSUMER_KEY">
<cfset sTestConsumerSecret = "CONSUMER_SECRET">
<cfset oTestConsumer = CreateObject("component", "oauth.oauthconsumer").init(sKey = sTestConsumerKey, sSecret = sTestConsumerSecret)>

<cfset sRTKey = "RequestTokenKey">
<cfset sRTSecret = "RequestTokenSecret">

<cfset oTempToken = CreateObject("component", "oauth.oauthtoken").init(sKey = sRTKey, sSecret = sRTSecret)>
<cfset oLookUpToken = oTestDataStore.lookUpToken(oConsumer = oTestConsumer, sTokenType = "request", oToken = oTempToken)>
<cfif oLookUpToken.isEmpty()>
	<cfset oTestRToken = oTestDataStore.newToken(oConsumer = oTestConsumer, sTokenType = "REQUEST", sKey = sRTKey, sSecret = sRTSecret)>
<cfelse>
	<cfset oTestRToken = oLookUpToken>
</cfif>

<cfset sATKey = "AccessTokenKey">
<cfset sATSecret = "AccessTokenSecret">

<cfset oTempToken = CreateObject("component", "oauth.oauthtoken").init(sKey = sATKey, sSecret = sATSecret)>
<cfset oLookUpToken = oTestDataStore.lookUpToken(oConsumer = oTestConsumer, sTokenType = "access", oToken = oTempToken)>
<cfif oLookUpToken.getKey() EQ "" AND oLookUpToken.getSecret() EQ "">
	<cfset oTestAToken = oTestDataStore.newToken(oConsumer = oTestConsumer, sTokenType = "ACCESS", sKey = sATKey, sSecret = sATSecret)>
<cfelse>
	<cfset oTestAToken = oLookUpToken>
</cfif>

<cfset oEmptyToken = CreateObject("component", "oauth.oauthtoken").createEmptyToken()>

<cfset oSigMethodSHA = CreateObject("component", "oauth.oauthsignaturemethod_hmac_sha1")>
<cfset oSigMethodPLAIN = CreateObject("component", "oauth.oauthsignaturemethod_plaintext")>
<cfset oTestServer.addSignatureMethod(oSigMethodSHA)>
<cfset oTestServer.addSignatureMethod(oSigMethodPLAIN)>

<cfset sTemp = sBaseURL & "/" & sRequestTokenURL>
<cfset oRequestReq = CreateObject("component", "oauth.oauthrequest").fromConsumerAndToken(
	oConsumer = oTestConsumer, 
	oToken = oEmptyToken, 
	sHttpMethod = "GET", 
	sHttpURL = sTemp )>

<cfset oRequestReq.signRequest(	oSignatureMethod = oSigMethodSHA, 
	oConsumer = oTestConsumer, 
	oToken = oEmptyToken)>

<cfset sTempURL = sBaseURL & "/" & sAccessTokenURL>

<cfset oAccessReq = CreateObject("component", "oauth.oauthrequest").fromConsumerAndToken(
	oConsumer = oTestConsumer, 
	oToken = oTestRToken, 
	sHttpMethod = "GET", 
	sHttpURL = sTempURL )>

<cfset oAccessReq.signRequest(
	oSignatureMethod = oSigMethodSHA, 
	oConsumer = oTestConsumer, 
	oToken = oEmptyToken)>

<!--- additional parameters --->										
<cfset sTempURL = sBaseURL & "/" & sEchoURL>
<cfset stEchoParams = StructNew()>
<cfset stEchoParams.method = "f o o b_a_r">
<cfset stEchoParams.warn_msg = "MiNd_the!%&gA+*p">
<cfset oEchoReq = CreateObject("component", "oauth.oauthrequest").fromConsumerAndToken(
	oConsumer = oTestConsumer, 
	oToken = oTestAToken, 
	sHttpMethod = "GET", 
	sHttpURL = sTempURL,										
	stParameters = stEchoParams)>
									
<cfset oEchoReq.setParameter("oauth_token_secret", sATSecret)>

	<div style="text-align:left;">
	<h1>OAuth Test Server</h1>
	<h2>Instructions for Use</h2>
	
	<p>	
	Test server with predefined (static) key and secret:
	<ul>
		<li>consumer secret = [#sTestConsumerSecret#]</li>
		<li>consumer key = [#sTestConsumerKey#]</li>
	</ul>
	</p>

	<table id="oauth">
	<tr>
		<td>
		<h3>Step 1 : Getting a Request Token :</h3>
		<ul>
			<li>
				request token endpoint : <a href="#sRequestTokenURL#"><code>#sRequestTokenURL#</code></a><br>
				*	parameters needed :<br>
				<ul>
					<li>oauth_version</li>
					<li>oauth_nonce</li>
					<li>oauth_timestamp</li>
					<li>oauth_consumer_key</li>
					<li>oauth_signature</li>
					<li>oauth_signature_method</li>
				</ul>			
			</li>
		</ul>
	
		<p>A successful request will return the following:<p/>
		<p>	
			<code>oauth_token=requestkey&amp;oauth_token_secret=requestsecret</code>
		</p>
		<p>
			current values:<br>
			<code>oauth_token=#sRTKey#&amp;oauth_token_secret=#sRTSecret#</code>
		</p>
		
		<p>An unsuccessful request will attempt to describe what went wrong.</p>
		
		<h4>Example :</h4>
		<a href="#oRequestReq.getString()#" target="_blank">#oRequestReq.getString()#</a>
		
		<br><br>
		Test output - signature string :<br>
		#oRequestReq.signatureBaseString()#
		</td>
	</tr>
	<tr>
		<td>
		<h3>Step 2 : Getting an Access Token :</h3>
		<p>The Request Token provided above is already authorized, you may use it to request an Access Token right away.</p>
	
		<ul>
			<li>access token endpoint : <a href="#sAccessTokenURL#"><code>#sAccessTokenURL#</code></a></li>
				*	parameters needed :<br>
				<ul>
					<li>oauth_version</li>
					<li>oauth_nonce</li>
					<li>oauth_timestamp</li>
					<li>oauth_consumer_key</li>
					<li>oauth_token</li>
					<li>oauth_signature</li>
					<li>oauth_signature_method</li>
				</ul>
		</ul>
	
		<p>A successful request will return the following:</p>
		<p>
			<code>oauth_token=accesskey&amp;oauth_token_secret=accesssecret</code>
		</p>
		<p>
			current values:<br>
			<code>oauth_token=#sATKey#&amp;oauth_token_secret=#sATSecret#</code>
		</p>
		
		<p>An unsuccessful request will attempt to describe what went wrong.</p>
	
		<h4>Example</h4>
		<a href="#oAccessReq.getString()#" target="_blank">#oAccessReq.getString()#</a>
	
		<br><br>
		Test output - signature string :<br>
		#oAccessReq.signatureBaseString()#
		</td>
	</tr>
	<tr>
		<td>
		<h3>Making Authenticated Calls</h3>
		
		<p>Using your Access Token you can make authenticated calls.</p>
	
		<ul>
		<li>api endpoint: <code><a href="#sEchoURL#">#sEchoURL#</a></code></li>
		</ul>
		<p>
			A successful request will echo the non-OAuth parameters sent to it, for example:
		</p>
		<p><code>method=foo&amp;bar=baz</code></p>
		<p>An unsuccessful request will attempt to describe what went wrong.</p>
	
		<h4>Example</h4>
		<a href="#oEchoReq.getString()#" target="_blank">#oEchoReq.getString()#</a>
		
		<br><br>
		Test output - signature string :<br>
		#oEchoReq.signatureBaseString()#
		</td>
	</tr>
	<tr>
		<td>
		<h3>Supported signature methods :</h3>
		<cfloop collection="#oTestServer.getSupportedSignatureMethods()#" item="sItem">#sItem#<br></cfloop> 
		</td>
	</tr>
	</table>
	</div>
</cfoutput>
</body>
</html>
