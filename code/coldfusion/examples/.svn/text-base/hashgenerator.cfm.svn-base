<cfsilent>
<!--- 
Description:
============
	hash generator testfile

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

<cfset sPageTitle = "Hash Generator">

<cfoutput>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="oauth.css">
	<title>#sPageTitle#</title>
</head>

<body>
<cfinclude template="common.cfm">
<cfinclude template="navimenu.cfm">

<form action="#CGI.SCRIPT_NAME#" method="POST">
	<table id="oauth">
		<tr>
			<td class="desc">Text input:</td> 
			<td>
				<textarea cols="50" rows="5" id="inputText" name="inputText"><cfif IsDefined('FORM.inputText')>#Trim(FORM.inputText)#</cfif></textarea>
			</td>
		</tr>
		<tr>
			<td class="desc">MD5:<br>Base64:</td>
			<td class="hash">
				<cfif IsDefined('FORM.hiddenValue') AND IsDefined('FORM.inputText')><cfset strValue = Hash(FORM.inputText, "MD5")>
					[#Trim(LCase(strValue))#]
					<cfset strValue = ToBase64(strValue)>
					<br>
					[#Trim(LCase(strValue))#]
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="desc">SHA-1:<br>Base64:</td>
			<td class="hash">
				<cfif IsDefined('FORM.hiddenValue') AND IsDefined('FORM.inputText')>
					<cfset strValue = Hash(FORM.inputText, "SHA")>
					[#Trim(LCase(strValue))#]
					<cfset strValue = ToBase64(strValue)>
					<br>
					[#Trim(LCase(strValue))#]
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="desc">SHA-224:<br>Base64:</td>
			<td class="hash">
				<cfif IsDefined('FORM.hiddenValue') AND IsDefined('FORM.inputText')>
					<cfset strValue = Hash(FORM.inputText, "SHA-224")>
					[#Trim(LCase(strValue))#]
					<cfset strValue = ToBase64(strValue)>
					<br>
					[#Trim(LCase(strValue))#]
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="desc">SHA-256:<br>Base64:</td>
			<td class="hash">
				<cfif IsDefined('FORM.hiddenValue') AND IsDefined('FORM.inputText')>
					<cfset strValue = Hash(FORM.inputText, "SHA-256")>
					[#Trim(LCase(strValue))#]
					<cfset strValue = ToBase64(strValue)>
					<br>
					[#Trim(LCase(strValue))#]
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="desc">SHA-384:<br>Base64:</td>
			<td class="hash">
				<cfif IsDefined('FORM.hiddenValue') AND IsDefined('FORM.inputText')>
					<cfset strValue = Hash(FORM.inputText, "SHA-384")>
					[#Trim(LCase(strValue))#]
					<cfset strValue = ToBase64(strValue)>
					<br>
					[#Trim(LCase(strValue))#]
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="desc">SHA-512:<br>Base64:</td>
			<td class="hash">
				<cfif IsDefined('FORM.hiddenValue') AND IsDefined('FORM.inputText')>
					<cfset strValue = Hash(FORM.inputText, "SHA-512")>
					[#Trim(LCase(strValue))#]
					<cfset strValue = ToBase64(strValue)>
					[#Trim(LCase(strValue))#]
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="submit" title="submit" value="generate hash" >
				<input type="hidden" value="formsubmitted" name="hiddenValue">
			</td>
		</tr>
	</table>	
</form>
</body>
</html>
</cfoutput>
