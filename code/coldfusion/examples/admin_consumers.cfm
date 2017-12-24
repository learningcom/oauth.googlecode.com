<cfsilent>
<!--- 
Description:
============
	service provider consumer administration, e.g.:
		list existing consumers, add new consumers, edit consumer entries

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
<title>Consumer administration [ Add new consumers | List existing consumers ]</title>
<link rel="stylesheet" type="text/css" href="oauth.css">	
</head>

<cfinclude template="common.cfm">

<cfset iMaxValue = CreateObject("java", "java.lang.Integer").MAX_VALUE>
<cfset sConsumerName = "">
<cfset sConsumerFullName = "">
<cfset sConsumerEmail = "">
<cfset sConsumerSecret = "">
<cfset sConsumerKey = "">
<cfset iSortColumnID = 0>
<cfset iEditorID = 0>

<cfif IsDefined('URL.sortid') AND Len('URL.sortid') GT 0>
	<cfset iSortColumnID = URL.sortid>
	<cfset FORM.listexisting = "List existing consumers, sort by column " & iSortColumnID>
</cfif>

<cfif IsDefined('FORM.consumername') AND Len(FORM.consumername) GT 0>
	<cfset sConsumerName = Trim(FORM.consumername)>
</cfif>
<cfif IsDefined('FORM.consumerfullname') AND Len(FORM.consumerfullname) GT 0>
	<cfset sConsumerFullName = Trim(FORM.consumerfullname)>
</cfif>
<cfif IsDefined('FORM.consumeremail') AND Len(FORM.consumeremail) GT 0>
	<cfset sConsumerEmail = Trim(FORM.consumeremail)>
</cfif>
<cfif IsDefined('FORM.consumerkey') AND Len(FORM.consumerkey) GT 0>
	<cfset sConsumerKey = Trim(FORM.consumerkey)>
</cfif>
<cfif IsDefined('FORM.consumersecret') AND Len(FORM.consumersecret) GT 0>
	<cfset sConsumerSecret = Trim(FORM.consumersecret)>
</cfif>
<cfif IsDefined('FORM.editorid') AND FORM.editorid GT 0>
	<cfset iEditorID = Trim(FORM.editorid)>
<cfelse>
	<cfset iEditorID = 1>
</cfif>

<cfif IsDefined('FORM.clearhash')>
	<cfset sConsumerSecret = "">
	<cfset sConsumerKey = "">
</cfif>

<cfset bInsertionSuccess = false>

<!--- create consumer --->
<cfif IsDefined('FORM.createconsumer')>
	<cfif Len(sConsumerEmail) GT 0
		AND	Len(sConsumerName) GT 0
		AND	Len(sConsumerFullName) GT 0
		AND	Len(sConsumerKey) GT 0
		AND	Len(sConsumerSecret) GT 0>
			
		<cfset oConsumerDAO = CreateObject("component", "oauth.oauthconsumerdao").init(sDataSource)>
		<cftransaction>		
		<cftry>							
			<cfset stCreateData = StructNew()>
			<cfset stCreateData.consumername = sConsumerName>
			<cfset stCreateData.consumerfullname = sConsumerFullName>
			<cfset stCreateData.consumerkey = sConsumerKey>
			<cfset stCreateData.consumersecret = sConsumerSecret>
			<cfset stCreateData.consumeremail = sConsumerEmail>
			<cfset stCreateData.editorid = iEditorID>
			
			<cfset oConsumerDAO.create(stCreateData)>			
			<!--- clear values --->
			<cfset sConsumerName = "">
			<cfset sConsumerFullName = "">
			<cfset sConsumerEmail = "">
			
			<cfcatch type="database">
				<span id="errormessage">
				<b>Error creating consumer:</b><br>
				Message : #cfcatch.Message#<br>
				Detail	: #cfcatch.Detail#<br>
				SQL 	: #cfcatch.SQL#</span>
			</cfcatch>
		</cftry>
		</cftransaction>
		<cfset bInsertionSuccess = true>
	</cfif>
</cfif>

<!--- insertion succeeded, clear consumer secret & key - autogenerate --->
<cfif bInsertionSuccess>
	<cfset sConsumerSecret = "">
	<cfset sConsumerKey = "">
</cfif>

<!--- if no consumer secret is specified, generate --->
<cfif Len(sConsumerSecret) IS 0>
	<cfset iTime = GetTickCount()>
	<cfset iRandom = RandRange(1, iMaxValue)>
	<cfset sConsumerSecret = Hash( iTime & iRandom, "SHA")>
</cfif>

<!--- if no consumer secret is specified, generate --->
<cfif Len(sConsumerKey) IS 0>
	<cfset iTime = GetTickCount()>
	<cfset iRandom = RandRange(1, iMaxValue)>
	<cfset sConsumerKey = Hash( iTime & iRandom, "SHA")>
</cfif>

<cfset oDAO = CreateObject("component", "oauth.oauthconsumerdao").init(sDataSource = sDataSource)>

<cfif IsDefined('FORM.editconsumerid')>

	<cfif IsDefined('FORM.deleteconsumer')>
		<cftransaction>
			<cftry>		
				<cfset oDAO.delete(iConsumerID = FORM.editconsumerid)>

				<cfcatch type="database">
					<cfdump var="#cfcatch#">
				</cfcatch>
			</cftry>
		</cftransaction>
		
	<cfelseif IsDefined('FORM.saveconsumer')>
		<cfset sNewConsumerName = Trim(FORM.editconsumername)>
		<cfset sNewConsumerFullName = Trim(FORM.editconsumerfullname)>
		<cfset sNewConsumerEmail = Trim(FORM.editconsumeremail)>
		<cfset sNewConsumerSecret = Trim(FORM.editconsumersecret)>
		<cfset sNewConsumerKey = Trim(FORM.editconsumerkey)>
		<cfset iNewEditorID = 1>

		<cfif Len(sNewConsumerEmail) GT 0
			AND	Len(sNewConsumerName) GT 0
			AND	Len(sNewConsumerFullName) GT 0
			AND	Len(sNewConsumerSecret) GT 0
			AND	Len(sNewConsumerKey) GT 0
			AND iNewEditorID GT 0>

			<cftransaction>
				<cftry>
					<cfset stUpdate = StructNew()>

					<cfset stUpdate.consumerID = FORM.editconsumerid>
					<cfset stUpdate.consumerkey = sNewConsumerKey>		
					<cfset stUpdate.consumername = sNewConsumerName>
					<cfset stUpdate.consumerfullname = sNewConsumerFullName>		
					<cfset stUpdate.consumersecret = sNewConsumerSecret>
					<cfset stUpdate.consumeremail = sNewConsumerEmail>
					<cfset stUpdate.editorid = iNewEditorID>

					<cfset stUpdate.columnList = "name, fullname, csecret, ckey, email, editor_id">
					<cfset oDAO.update(stUpdate)>

					<cfcatch type="database">
						<cfdump var="#cfcatch#">
					</cfcatch>
				</cftry>
			</cftransaction>
		</cfif>	
	</cfif>

</cfif>

<cfset iConsumerCount = oDAO.getConsumerCount()>

<body>
	<cfinclude template="navimenu.cfm">

	<h1>Service provider administration page</h1>
	<h2>Currently [#iConsumerCount#] consumer(s) registered.</h2>

	<form action="#CGI.SCRIPT_NAME#" method="POST">
		<input type="Hidden" name="editorid" value="0">
		<table id="oauth">
			<tr>
				<th colspan="2">Add new consumer</th>
			</tr>
			<tr>
				<td class="description">Consumer user name:</td>
				<td>
					<input <cfif NOT bInsertionSuccess AND Len(sConsumerName) IS 0>class="missing"</cfif>
							type="text" name="consumername" title="consumername" id="consumername" value="#sConsumerName#">
				</td>
			</tr>
			<tr>
				<td class="description">Consumer full name:</td>
				<td><input <cfif NOT bInsertionSuccess AND Len(sConsumerFullName) IS 0>class="missing"</cfif> 
						type="text" name="consumerfullname" title="consumerfullname" id="consumerfullname" value="#sConsumerFullName#"></td>
			</tr>
			<tr>
				<td class="description">Consumer e-mail:</td>
				<td><input <cfif NOT bInsertionSuccess AND Len(sConsumerEmail) IS 0>class="missing"</cfif> 				
						type="text" name="consumeremail" title="consumeremail" id="consumeremail" value="#sConsumerEmail#"></td>
			</tr>
			<tr>
				<td class="description">Consumer key:</td>
				<td>
					<input <cfif NOT bInsertionSuccess AND Len(sConsumerKey) IS 0>class="missing"</cfif>					
							type="text" name="consumerkey" title="consumerkey" id="consumerkey" value="#sConsumerKey#" size="75">
				</td>
			</tr>
			<tr>
				<td class="description">Consumer secret:</td>
				<td>
					<input <cfif NOT bInsertionSuccess AND Len(sConsumerSecret) IS 0>class="missing"</cfif>
							type="text" name="consumersecret" title="consumersecret" id="consumersecret" value="#sConsumerSecret#" size="75">
				</td>
			</tr>			
		</table> 	
		<div id="buttons" style="align:left;">	
			<input type="submit" name="clearhash"		id="clearhash"		value="Generate new hash values." 	title="clearhash">
			<input type="submit" name="createconsumer" 	id="createconsumer"	value="Create new consumer"			title="createconsumer"> 
			<input type="submit" name="listexisting" 	id="listexisting" 	value="List existing consumers" 	title="listexisting">
		</div>
				
		<cfif IsDefined('FORM.listexisting')>
			<cfif NOT IsDefined('oDAO')>			
				<cfset oDAO = CreateObject("component", "oauth.oauthconsumerdao").init(sDataSource = sDataSource)>
			</cfif>
			<cfif iSortColumnID GT 0 AND iSortColumnID LT 10>
				<cfset qListAll = oDAO.listAll(iSortColumnID)>
			<cfelse>
				<cfset qListAll = oDAO.listAll()>
			</cfif>

			<cfif qListAll.recordcount>
				<p><br></p>
				
				<table id="oauth">
					<tr>						
						<th>
							<a href="#CGI.SCRIPT_NAME#?sortid=1">ID</a>							
						</th>
						<th>
							<a href="#CGI.SCRIPT_NAME#?sortid=2">Consumer name</a>
						</th>
						<th>
							<a href="#CGI.SCRIPT_NAME#?sortid=3">Consumer full name</a>
						</th>
						<th>
							<a href="#CGI.SCRIPT_NAME#?sortid=4">Consumer e-mail</a>
						</th>
						<th>
							<a href="#CGI.SCRIPT_NAME#?sortid=5">Key</a>
						</th>
						<th>
							<a href="#CGI.SCRIPT_NAME#?sortid=6">Secret</a>
						</th>
						<th>
							<a href="#CGI.SCRIPT_NAME#?sortid=7">Date</a>
						</th>
						<th>Delete</th>
						<th>Edit</th>
					</tr>
					<cfloop query="qListAll">
					<tr>		
						<form action="#CGI.SCRIPT_NAME#" method="POST">																	
						<td>#qListAll.consumer_id#
							<input name="editconsumerid" type="hidden" value="#qListAll.consumer_id#">
						</td>
						<td><input 	name="editconsumername" 	title="editconsumername"	type="text"
									id="editconsumername" 		value="#qListAll.name#">
						</td>
						<td>
							<input 	name="editconsumerfullname" 	title="editconsumerfullname" type="text"
									id="editconsumerfullname" 		value="#qListAll.fullname#">
						</td>
						<td>
							<input 	name="editconsumeremail" 	title="editconsumeremail" type="text"
									id="editconsumeremail" 		value="#qListAll.email#">
						</td>
						<td>
							<input 	name="editconsumerkey" 	title="editconsumerkey" type="text"
									id="editconsumerkey" 		value="#qlistAll.ckey#">
						</td>
						<td>
							<input 	name="editconsumersecret" 	title="editconsumersecret" type="text"
									id="editconsumersecret" 		value="#qListAll.csecret#">
						</td>
						<td>#DateFormat(qListAll.datecreated, "mm/dd/yyyy")#</td>
						<td><input type="submit" title="deleteconsumer" id="deleteconsumer" value="delete" name="deleteconsumer"></td>
						<td><input type="submit" title="saveconsumer" id="saveconsumer" value="save" name="saveconsumer"></td>
						</form>
					</tr>
					</cfloop>
				</table>
			<cfelse>
				<br>No consumers registered!<br>
			</cfif>
		</cfif>
	</form>
</body>
</html>
</cfoutput>