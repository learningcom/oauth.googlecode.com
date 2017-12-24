<!--- Example to connect to twitter
----------------------------------------------------------------------------
1) Assumes there is a CF mapping of oauth pointing to the oauth folder.
2) add your consumerkey and secret
3) save and run
--->

<!--- set up the parameters --->
<cfset sConsumerKey = ""> <!--- the consumer key you got from twitter when registering you app  --->
<cfset sConsumerSecret = ""> <!--- the consumer secret you got from twitter --->
<cfset sTokenEndpoint = "https://api.twitter.com/oauth/request_token"> <!--- Access Token URL --->
<cfset sAuthorizationEndpoint = "https://api.twitter.com/oauth/authorize"> <!--- Authorize URL --->
<cfset sCallbackURL = "www.somesite.com/mashup/authorize.cfm"> <!--- where twitter will redirect to after the user enters their details --->
<cfset sClientToken = ""> <!--- returned after an access token call --->
<cfset sClientTokenSecret = ""> <!--- returned after an access token call --->

<!--- set up the required objects including signature method--->
<cfset oReqSigMethodSHA = CreateObject("component", "oauth.oauthsignaturemethod_hmac_sha1")>
<cfset oToken = CreateObject("component", "oauth.oauthtoken").createEmptyToken()>
<cfset oConsumer = CreateObject("component", "oauth.oauthconsumer").init(sKey = sConsumerKey, sSecret = sConsumerSecret)>

<cfset oReq = CreateObject("component", "oauth.oauthrequest").fromConsumerAndToken(
	oConsumer = oConsumer,
	oToken = oToken,
	sHttpMethod = "GET",
	sHttpURL = sTokenEndpoint)>
<cfset oReq.signRequest(
	oSignatureMethod = oReqSigMethodSHA,
	oConsumer = oConsumer,
	oToken = oToken)>

<cfhttp url="#oREQ.getString()#" method="get" result="tokenResponse"/>

<!--- grab the token and secret from the response if its there--->
<cfif findNoCase("oauth_token",tokenresponse.filecontent)>
	<cfset sClientToken = listlast(listfirst(tokenResponse.filecontent,"&"),"=")>
	<cfset sClientTokenSecret = listlast(listlast(tokenResponse.filecontent,"&"),"=")>

	<!--- you can add some additional parameters to the callback --->
	<cfset sCallbackURL = sCallbackURL & "?" &
		"key=" & sConsumerKey &
		"&" & "secret=" & sConsumerSecret &
		"&" & "token=" & sClientToken &
		"&" & "token_secret=" & sClientTokenSecret &
		"&" & "endpoint=" & URLEncodedFormat(sAuthorizationEndpoint)>

	<cfset sAuthURL = sAuthorizationEndpoint & "?oauth_token=" & sClientToken & "&" & "oauth_callback=" & URLEncodedFormat(sCallbackURL) >

	<cflocation url="#sAuthURL#">
<cfelse>
	<cfoutput>#tokenResponse.filecontent#</cfoutput>
</cfif>
