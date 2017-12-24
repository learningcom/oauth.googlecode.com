<cfcomponent	output="true"
				name="oauth testcase"
				extends="org.cfcunit.framework.TestCase">

	<!--- setUp & tearDown --->
	<cffunction name="setUp" returntype="void" access="private" output="false">
		<cfset variables.bDebug = false>
		<cfset variables.oUtil = CreateObject("component","oauth.oauthutil").init()>
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
	<cffunction name="tearDown" returntype="void" access="private" output="false">
	</cffunction>

	<cffunction name="getTestValuesForParameterEncoding" returntype="struct">
		<cfset var stResult = StructNew()>
		<cfset var aValues = ArrayNew(1)>
		<cfset var aEncoded = ArrayNew(1)>

		<!--- http://wiki.oauth.net/TestCases, section 5.1, parameter encoding --->
		<!--- parameter names or values + expected encoded values --->
		<cfset ArrayAppend(aValues, "abcABC123")><cfset ArrayAppend(aEncoded,"abcABC123")>
		<cfset ArrayAppend(aValues, "-._~")><cfset ArrayAppend(aEncoded,"-._~")>
		<cfset ArrayAppend(aValues, "%")><cfset ArrayAppend(aEncoded,"%25")>
		<cfset ArrayAppend(aValues, "+")><cfset ArrayAppend(aEncoded,"%2B")>
		<cfset ArrayAppend(aValues, "&=*")><cfset ArrayAppend(aEncoded,"%26%3D%2A")>
		<!--- line feed 	-	unicode 0x000A = chr(10) --->
		<cfset ArrayAppend(aValues, "U+000A")><cfset ArrayAppend(aEncoded,"%0A")>
		<!--- space --->
		<cfset ArrayAppend(aValues, "U+0020")><cfset ArrayAppend(aEncoded,"%20")>
		<cfset ArrayAppend(aValues, "U+007F")><cfset ArrayAppend(aEncoded,"%7F")>
		<cfset ArrayAppend(aValues, "U+0080")><cfset ArrayAppend(aEncoded,"%C2%80")>
		<cfset ArrayAppend(aValues, "U+3001")><cfset ArrayAppend(aEncoded,"%E3%80%81")>

		<cfset StructInsert(stResult, "values", aValues)>
		<cfset StructInsert(stResult, "encoded",aEncoded)>

		<cfreturn stResult>
	</cffunction>

	<cffunction name="getTestValuesForNormalization" returntype="struct">
		<cfset var stResult = StructNew()>
		<cfset var aParameters = ArrayNew(1)>
		<cfset var aNormalized = ArrayNew(1)>

		<cfset ArrayAppend(aParameters, "name")><cfset ArrayAppend(aNormalized, "name=")>
		<cfset ArrayAppend(aParameters, "a=b")><cfset ArrayAppend(aNormalized, "a=b")>
		<cfset ArrayAppend(aParameters, "a=b&c=d")><cfset ArrayAppend(aNormalized, "a=b&c=d")>
		<!--- note: parameters with same name allowed and are sorted (lexicographically) --->
		<!--- example contained  '+' for space, --->
		<cfset ArrayAppend(aParameters, "a=x!y&a=x y")><cfset ArrayAppend(aNormalized, "a=x%20y&a=x%21y")>
		<!--- note: parameters are sorted --->
		<cfset ArrayAppend(aParameters, "x!y=a&x=a")><cfset ArrayAppend(aNormalized, "x=a&x%21y=a")>
		<cfset ArrayAppend(aParameters, "a=1&c=hi there&f=50&f=25&f=a&z=p&z=t")>
		<cfset ArrayAppend(aNormalized, "a=1&c=hi%20there&f=25&f=50&f=a&z=p&z=t")>

		<cfset StructInsert(stResult, "params", aParameters)>
		<cfset StructInsert(stResult, "normalized", aNormalized)>

		<cfreturn stResult>
	</cffunction>

	<cffunction name="getTestValuesConcatRequestElements" returntype="struct">
		<cfset var stResult = StructNew()>
		<cfset var aRequestMethod = ArrayNew(1)>
		<cfset var aURL = ArrayNew(1)>
		<cfset var aParams = ArrayNew(1)>
		<cfset var aExpected = ArrayNew(1)>

		<cfset ArrayAppend(aRequestMethod, "GET")>
		<cfset ArrayAppend(aURL, "http://example.com/")>
		<cfset ArrayAppend(aParams, "n=v")>
		<cfset ArrayAppend(aExpected, "GET&http%3A%2F%2Fexample.com%2F&n%3Dv")>

		<!--- http://wiki.oauth.net/TestCases#note1 --->
		<!--- <cfset ArrayAppend(aURL, "http://example.com")> --->
		<cfset ArrayAppend(aRequestMethod, "GET")>
		<cfset ArrayAppend(aURL, "http://example.com/")>
		<cfset ArrayAppend(aParams, "n=v")>
		<cfset ArrayAppend(aExpected, "GET&http%3A%2F%2Fexample.com%2F&n%3Dv")>

		<cfset ArrayAppend(aRequestMethod, "POST")>
		<cfset ArrayAppend(aURL, "https://photos.example.net/request_token")>
		<cfset ArrayAppend(aParams, "oauth_version=1.0&oauth_consumer_key=dpf43f3p2l4k3l03&oauth_timestamp=1191242090&oauth_nonce=hsu94j3884jdopsl&oauth_signature_method=PLAINTEXT&oauth_signature=ignored")>
		<cfset ArrayAppend(aExpected, "POST&https%3A%2F%2Fphotos.example.net%2Frequest_token&oauth_consumer_key%3Ddpf43f3p2l4k3l03%26oauth_nonce%3Dhsu94j3884jdopsl%26oauth_signature_method%3DPLAINTEXT%26oauth_timestamp%3D1191242090%26oauth_version%3D1.0")>

		<cfset ArrayAppend(aRequestMethod, "GET")>
		<cfset ArrayAppend(aURL, "http://photos.example.net/photos")>
		<cfset ArrayAppend(aParams, "file=vacation.jpg&size=original&oauth_version=1.0&oauth_consumer_key=dpf43f3p2l4k3l03&oauth_token=nnch734d00sl2jdk&oauth_timestamp=1191242096&oauth_nonce=kllo9940pd9333jh&oauth_signature=ignored&oauth_signature_method=HMAC-SHA1")>
		<cfset ArrayAppend(aExpected, "GET&http%3A%2F%2Fphotos.example.net%2Fphotos&file%3Dvacation.jpg%26oauth_consumer_key%3Ddpf43f3p2l4k3l03%26oauth_nonce%3Dkllo9940pd9333jh%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1191242096%26oauth_token%3Dnnch734d00sl2jdk%26oauth_version%3D1.0%26size%3Doriginal")>

		<cfset ArrayAppend(aRequestMethod, "GET")>
		<cfset ArrayAppend(aURL, "http://photos.example.net/photos")>
		<cfset ArrayAppend(aParams, "file=vacation.jpg&oauth_consumer_key=dpf43f3p2l4k3l03&oauth_nonce=kllo9940pd9333jh&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1191242096&oauth_token=nnch734d00sl2jdk&oauth_version=1.0&size=original")>
		<cfset ArrayAppend(aExpected, "GET&http%3A%2F%2Fphotos.example.net%2Fphotos&file%3Dvacation.jpg%26oauth_consumer_key%3Ddpf43f3p2l4k3l03%26oauth_nonce%3Dkllo9940pd9333jh%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1191242096%26oauth_token%3Dnnch734d00sl2jdk%26oauth_version%3D1.0%26size%3Doriginal")>

		<cfset stResult["METHOD"] = aRequestMethod>
		<cfset stResult["URL"] = aURL>
		<cfset stResult["PARAMS"] = aParams>
		<cfset stResult["EXPECTED"] = aExpected>

		<cfreturn stResult>
	</cffunction>

	<cffunction name="getTestDataHMAC_SHA1">
		<!--- HMAC-SHA1 (section 9.2) --->
		<cfset var stResult = StructNew()>
		<cfset var aConsumerSecret = ArrayNew(1)>
		<cfset var aTokenSecret = ArrayNew(1)>
		<cfset var aBaseString = ArrayNew(1)>
		<cfset var aExpected = ArrayNew(1)>

		<cfset ArrayAppend(aConsumerSecret, "cs")>
		<cfset ArrayAppend(aTokenSecret, "")>
		<cfset ArrayAppend(aBaseString, "bs")>
		<cfset ArrayAppend(aExpected, "egQqG5AJep5sJ7anhXju1unge2I=")>

		<cfset ArrayAppend(aConsumerSecret, "cs")>
		<cfset ArrayAppend(aTokenSecret, "ts")>
		<cfset ArrayAppend(aBaseString, "bs")>
		<cfset ArrayAppend(aExpected, "VZVjXceV7JgPq/dOTnNmEfO0Fv8=")>

		<cfset ArrayAppend(aConsumerSecret, "kd94hf93k423kf44")>
		<cfset ArrayAppend(aTokenSecret, "pfkkdhi9sl3r4s00")>
		<cfset ArrayAppend(aBaseString, "GET&http%3A%2F%2Fphotos.example.net%2Fphotos&file%3Dvacation.jpg%26oauth_consumer_key%3Ddpf43f3p2l4k3l03%26oauth_nonce%3Dkllo9940pd9333jh%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1191242096%26oauth_token%3Dnnch734d00sl2jdk%26oauth_version%3D1.0%26size%3Doriginal")>
		<cfset ArrayAppend(aExpected, "tR3+Ty81lMeYAr/Fid0kMTYa/WM=")>

		<cfset stResult["CONSUMER_SECRET"] = aConsumerSecret>
		<cfset stResult["TOKEN_SECRET"] = aTokenSecret>
		<cfset stResult["BASE_STRING"] = aBaseString>
		<cfset stResult["EXPECTED"] = aExpected>
		<cfreturn stResult>
	</cffunction>

	<!--- Parameter Encoding (section 5.1) --->
	<cffunction name="testParameterEncoding" access="public" returntype="void">
		<cfset var stTestValues = getTestValuesForParameterEncoding()>
		<cfset var aValues = stTestValues["values"]>
		<cfset var aEncoded = stTestValues["encoded"]>
		<cfset var i = 0>

		<cfset AssertTrue(	ArrayLen(aValues) EQ ArrayLen(aEncoded),
							"Both arrays must have same length! aValues = #ArrayLen(aValues)#, aEncoded = #ArrayLen(aEncoded)#" )>

		<cfloop from="1" to="#ArrayLen(aValues)#" index="i">
			<cfset AssertEqualsString(aEncoded[i], variables.oUtil.encodePercent(variables.oUtil.toUnicodeChar(aValues[i])),"MESSAGE")>
		</cfloop>
	</cffunction>

	<!--- Normalize Request Parameters (section 9.1.1) --->
	<cffunction name="testParameterNormalization" access="public" returntype="void">
		<cfset var stTest = getTestValuesForNormalization()>
		<cfset var aParams = stTest["params"]>
		<cfset var aNormalized = stTest["normalized"]>
		<cfset var i = 0>
		<cfset var inner = 0>
		<cfset var aKeys = ArrayNew(1)>
		<cfset var aValues = ArrayNew(1)>
		<cfset var sTempSigned = "">

		<cfset AssertTrue(	ArrayLen(aParams) EQ ArrayLen(aNormalized),
							"Both arrays must have the same length! aParams = #ArrayLen(aParams)#, aNormalized = #ArrayLen(aNormalized)#" )>

		<cfloop from="1" to="#ArrayLen(aParams)#" index="i">
			<cfset aKeys = ArrayNew(1)>
			<cfset aValues = ArrayNew(1)>
			<cfloop list="#aParams[i]#" index="inner" delimiters="&">
				<cfset ArrayAppend(aKeys, ListFirst(inner,'='))>
				<cfset ArrayAppend(aValues, ListRest(inner,'='))>
			</cfloop>
			<cfset variables.oRequest.clearParameters()>
			<cfset variables.oRequest.setParameters(aParameterKeys = aKeys,aParameterValues = aValues)>
			<cfset sTempSigned = variables.oRequest.getSignableParameters()>
			<cfset AssertEqualsString(aNormalized[i], sTempSigned, "NORM:#aNormalized[i]#, GOT:#sTempSigned#")>
		</cfloop>

	</cffunction>

	<!--- Concatenate Request Elements (section 9.1.2) --->
	<cffunction name="testConcatRequestElements" access="public" returntype="void">
		<cfset var stTest = getTestValuesConcatRequestElements()>
		<cfset var aRequestMethod = stTest["METHOD"]>
		<cfset var aURL = stTest["URL"]>
		<cfset var aParams = stTest["PARAMS"]>
		<cfset var aExpected = stTest["EXPECTED"]>
		<cfset var i = 0>
		<cfset var inner = 0>
		<cfset var aKeys = ArrayNew(1)>
		<cfset var aValues = ArrayNew(1)>
		<cfset var sTempSigned = "">


		<cfloop from="1" to="#ArrayLen(aRequestMethod)#" index="i">
			<cfset variables.oRequest.setHttpMethod(aRequestMethod[i])>
			<cfset variables.oRequest.setHttpURL(aURL[i])>
			<cfset aKeys = ArrayNew(1)>
			<cfset aValues = ArrayNew(1)>
			<cfloop list="#aParams[i]#" index="inner" delimiters="&">
				<cfset ArrayAppend(aKeys, ListFirst(inner,'='))>
				<cfset ArrayAppend(aValues, ListRest(inner,'='))>
			</cfloop>
			<cfset variables.oRequest.clearParameters()>
			<cfset variables.oRequest.setParameters(aParameterKeys = aKeys,aParameterValues = aValues)>
			<cfset sTempSigned = variables.oRequest.signatureBaseString()>
			<cfif i EQ ArrayLen(aRequestMethod) AND variables.bDebug>
				<span style="color:green"><cfdump var="#aExpected[i]#"></span><br>
				<span style="color:red"><cfdump var="#sTempSigned#"></span><cfabort>
			</cfif>
			<cfset AssertEqualsString(aExpected[i], sTempSigned, "NORM:#aExpected[i]#, GOT:#sTempSigned#")>
		</cfloop>
	</cffunction>

	<cffunction name="testHMAC_SHA1" access="public" returntype="void">
		<cfset var stTestData = getTestDataHMAC_SHA1()>
		<cfset var aConsumerSecrets = stTestData["consumer_secret"]>
		<cfset var aTokenSecrets = stTestData["token_secret"]>
		<cfset var aBaseString = stTestData["base_string"]>
		<cfset var aExpected = stTestData["expected"]>
		<cfset var i = "">
		<cfset var sKey = "">
		<cfset var sComputedSignature = "">
		<cfset var oSigMethod = CreateObject("component", "oauth.oauthsignaturemethod_hmac_sha1")>

		<cfloop from="1" to="#ArrayLen(aExpected)#" index="i">
			<cfset sKey = aConsumerSecrets[i] & "&" & aTokenSecrets[i]>
			<cfset sComputedSignature = oSigMethod.hmac_sha1( signKey = sKey, signMessage = aBaseString[i])>
			<cfset AssertEqualsString(aExpected[i], sComputedSignature, "Failed : consumer_secret&token_secret => " & sKey & ", message:" & aBaseString[i])>
		</cfloop>
	</cffunction>

	<cffunction name="testSignatureValueCalculation" access="public" returntype="void">
		<!--- signature base string from the example in Appendix A.5.1.  Generating Signature Base String --->
		<cfset var sBaseString = "GET&http%3A%2F%2Fphotos.example.net%2Fphotos&file%3Dvacation.jpg%26oauth_consumer_key%3Ddpf43f3p2l4k3l03%26oauth_nonce%3Dkllo9940pd9333jh%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1191242096%26oauth_token%3Dnnch734d00sl2jdk%26oauth_version%3D1.0%26size%3Doriginal">
		<cfset var sKey = "kd94hf93k423kf44&pfkkdhi9sl3r4s00">
		<cfset var sExpectedSignature = "tR3+Ty81lMeYAr/Fid0kMTYa/WM=">
		<cfset var oSigMethod = CreateObject("component", "oauth.oauthsignaturemethod_hmac_sha1")>
		<cfset var sComputedSignature = oSigMethod.hmac_sha1( signKey = sKey, signMessage = sBaseString)>

		<!--- Appendix A.5.2.  Calculating Signature Value, HMAC-SHA1 --->
		<cfset AssertEqualsString(sExpectedSignature, sComputedSignature)>
	</cffunction>
</cfcomponent>