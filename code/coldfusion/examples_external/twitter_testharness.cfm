<cfparam name="form.consumerkey" default="">
<cfparam name="form.consumerkeysecret" default="">
<cfparam name="form.commethod" default="get">

<cfset sConsumerKey = form.consumerkey> <!---  the consumer key you got from twitter when registering you app  --->
<cfset sConsumerSecret = form.consumerkeysecret> <!--- the consumer secret you got from twitter --->
<cfset sTokenEndpoint = "https://api.twitter.com/oauth/request_token"> <!--- Request Token URL --->
<cfset sAccessTokenEndpoint = "http://api.twitter.com/oauth/access_token"> <!--- Access Token URL --->
<cfset sAuthorizationEndpoint = "https://api.twitter.com/oauth/authorize"> <!--- Authorize URL --->
<cfset sCallbackURL = "www.somesite.com/mashup/authorize.cfm"> <!--- where twitter will redirect to after the user enters their details --->
<cfset sRequestToken = ""> <!--- returned after an access token call --->
<cfset sRequestTokenSecret = ""> <!--- returned after an access token call --->
<cfset sAccessToken = ""> <!--- returned after an access token call --->
<cfset sAccessTokenSecret = ""> <!--- returned after an access token call --->
<cfset sAuthURL = "">

<cfif isdefined("form.requesttoken") and form.consumerkey neq "">
	<cfset sConsumerKey = form.consumerkey> <!--- the consumer key you got from twitter when registering you app  --->
	<cfset sConsumerSecret = form.consumersecret> <!--- the consumer secret you got from twitter --->
	<cfset oReqSigMethodSHA = CreateObject("component", "oauth.oauthsignaturemethod_hmac_sha1")>
	<cfset oToken = CreateObject("component", "oauth.oauthtoken").createEmptyToken()>
	<cfset oConsumer = CreateObject("component", "oauth.oauthconsumer").init(sKey = sConsumerKey, sSecret = sConsumerSecret)>

	<cfset oReq = CreateObject("component", "oauth.oauthrequest").fromConsumerAndToken(
		oConsumer = oConsumer,
		oToken = oToken,
		sHttpMethod = form.commethod,
		sHttpURL = sTokenEndpoint)>
	<cfset oReq.signRequest(
		oSignatureMethod = oReqSigMethodSHA,
		oConsumer = oConsumer,
		oToken = oToken)>

	<cfif form.commethod eq "get">
		<cfhttp url="#oREQ.getString()#" method="get" result="tokenResponse"/>
	<cfelse>
		<cfhttp url="#sTokenEndpoint#" method="post" result="tokenResponse">
			<cfhttpparam type="header" name="Authorization" value="#oREQ.toHeader()#">
		</cfhttp>
	</cfif>
	
	<cfif findNoCase("oauth_token",tokenresponse.filecontent)>
		<cfset sRequestToken = listlast(listfirst(tokenResponse.filecontent,"&"),"=")>
		<cfset sRequestTokenSecret = listlast(listgetat(tokenResponse.filecontent,2,"&"),"=")>
	<cfelse>
	 <cfdump var="#tokenresponse.filecontent#">
	 <cfabort>
	</cfif>
</cfif>
<cfif isDefined("form.authorize") and form.requesttoken neq "">
	<cfset sConsumerKey = form.consumerkey> <!--- the consumer key you got from twitter when registering you app  --->
	<cfset sConsumerSecret = form.consumersecret> <!--- the consumer secret you got from twitter --->
	<cfset sRequestToken = form.requesttoken> <!--- returned after an access token call --->
	<cfset sRequestTokenSecret = form.requesttokensecret> <!--- returned after an access token call --->
	<cfset sCallbackURL = sCallbackURL & "?" &
		"key=" & sConsumerKey &
		"&" & "secret=" & sConsumerSecret &
		"&" & "token=" & sRequestToken &
		"&" & "token_secret=" & sRequestTokenSecret &
		"&" & "endpoint=" & URLEncodedFormat(sAuthorizationEndpoint)>

	<cfset sAuthURL = sAuthorizationEndpoint & "?oauth_token=" & sRequestToken & "&" & "oauth_callback=" & URLEncodedFormat(sCallbackURL) >

</cfif>
<cfif isdefined("form.accesstoken") and form.oauthpin neq "">
	<cfset sConsumerKey = form.consumerkey> <!--- the consumer key you got from twitter when registering you app  --->
	<cfset sConsumerSecret = form.consumersecret> <!--- the consumer secret you got from twitter --->
	<cfset sRequestToken = form.requesttoken> <!--- returned after an access token call --->
	<cfset sRequestTokenSecret = form.requesttokensecret> <!--- returned after an access token call --->
	<cfset oReqSigMethodSHA = CreateObject("component", "oauth.oauthsignaturemethod_hmac_sha1")>
	<cfset oToken = CreateObject("component", "oauth.oauthtoken").init(sKey= sRequestToken,sSecret=sRequestTokenSecret)>
	<cfset oConsumer = CreateObject("component", "oauth.oauthconsumer").init(sKey = sConsumerKey, sSecret = sConsumerSecret)>

	<cfset Parameters = structNew()>
	<cfset parameters.oauth_verifier = form.oauthpin>
	<cfset oReq = CreateObject("component", "oauth.oauthrequest").fromConsumerAndToken(
		oConsumer = oConsumer,
		oToken = oToken,
		sHttpMethod = form.commethod,
		sHttpURL = sAccessTokenEndpoint,
		stparameters= Parameters )>
	<cfset oReq.signRequest(
		oSignatureMethod = oReqSigMethodSHA,
		oConsumer = oConsumer,
		oToken = oToken)>
	
	<cfhttp url="#oREQ.getString()#" method="get" result="tokenResponse"/>
	
	<cfif findNoCase("oauth_token",tokenresponse.filecontent)>
		<cfset sAccessToken = listlast(listfirst(tokenResponse.filecontent,"&"),"=")>
		<cfset sAccessTokenSecret = listlast(listgetAt(tokenResponse.filecontent,2,"&"),"=")>
	</cfif>

</cfif>
<cfoutput>
<html>
<head>
	<title>Twitter oAuth Test Harness</title>

<script>
	var enableAccessTokenButton = function enableAccessTokenButton(t){
		if(t.value.length > 0){
			document.getElementById('accessToken').disabled=false;
		}else{
			document.getElementById('accessToken').disabled=true;			
		}
	}
	
	function openWin(url){
		window.open(url,'mywindow','width=400,height=200');
	}
	
	<cfif len(sAuthUrl)>
		openWin("#sAuthUrl#");
	</cfif>
</script>
</head>
<body>
<div>
<h3>oAuth Twitter Test Harness</h3>
</div>
<div>
<form name="oauthInput" method="post">
	<table>
	<tr>
		<td><strong>Token Endpoint</strong>:</td>
		<td colspan="2">#sTokenEndpoint#</td>
	</tr>
	<tr>
		<td><strong>Authorization Endpoint</strong>:</td>	
		<td colspan="2">#sAuthorizationEndpoint#</td>	
	</tr>
	<tr>
		<td><strong>Access Token Endpoint</strong>:</td>	
		<td colspan="2">#sAccessTokenEndpoint#</td>	
	</tr>
	<tr>
		<td><strong>Method</strong>:</td>	
		<td colspan="2"><select name="commethod">
		<option value="get" <cfif form.commethod eq "get">selected="selected"</cfif>>Get</option>
		<option value="post" <cfif form.commethod neq "get">selected="selected"</cfif>>Post</option>
		</select></td>	
	</tr>
	<tr>
		<td>Consumer Key:</td>	
		<td colspan="2"><input type=text" name="ConsumerKey" style="width:300px" value="#sConsumerKey#"></td>	
	</tr>
	<tr>
		<td>Consumer Secret:</td>	
		<td><input type=text" name="Consumersecret" style="width:300px" value="#sConsumerSecret#"></td>
		<td><input type="submit" name="requesttoken" value="Request Token"></td>	
	</tr>
	<tr>
		<td>Request Token:</td>	
		<td colspan="2"><input type="text" name="requestToken" style="width:300px" value="#sRequestToken#"></td>
	</tr>
	<tr>
		<td>Request Token Secret:</td>	
		<td><input type="text" name="requestTokensecret" value="#sRequestTokenSecret#"  style="width:300px" ></td>
		<td><input type="submit" name="authorize" value="Authorize" <cfif #sRequestTokenSecret# eq "">disabled=true</cfif> ></td>
	</tr>
	<tr>
		<td>oAuth Pin</td>	
		<td><input type="text" name="oauthpin" value="" style="width:300px" onKeyUp="enableAccessTokenButton(this)"></td>	
		<td><input type="submit" id="accessToken" name="accesstoken" value="Access Token" disabled=true></td>
	</tr>
	<tr>
		<td>Access Token:</td>	
		<td colspan="2"><input type="text" name="AccessToken" value="#sAccessToken#" style="width:300px" ></td>
	</tr>
	<tr>
		<td>Access Token Secret:</td>	
		<td colspan="2"><input type="text" name="AccessTokenSecret" value="#sAccessTokenSecret#" style="width:300px" ></td>
	</tr>
	</table>
</form>
</div>
</cfoutput>
</body>
</html>