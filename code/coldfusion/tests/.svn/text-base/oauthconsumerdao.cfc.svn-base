<!---
Description:
============
	oauth.oauthconsumerdao testcase

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
	name="oauth.oauthconsumerdao testcase"
	extends="org.cfcunit.framework.TestCase"
	output="false"
	hint="oauth.oauthconsumerdao testcase">

	<cffunction name="setUp" returntype="void" access="private" output="false" hint="test fixture">
		<cfset variables.sDataSource = "oauth">
		<cfset variables.oDAO = CreateObject("component", "oauth.oauthconsumerdao").init(variables.sDataSource)>
		<cfset variables.stData = StructNew()>
		<cfset variables.stData.consumername = "_testusername">
		<cfset variables.stData.consumerfullname = "test user name">
		<cfset variables.stData.consumeremail = "test@example.com">
		<cfset variables.stData.consumerkey = "CONSUMER_KEY_TEST">
		<cfset variables.stData.consumersecret = "CONSUMER_SECRET_TEST">
		<cfset variables.oDAO.create(variables.stData)>
		<cfset variables.iDeleteID = variables.oDAO.read(variables.stData.consumerkey).consumerID>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="testread" returntype="void" access="public" output="false">
		<cfset var stRead = variables.oDAO.read(variables.stData.consumerkey)>
		<cfset assertFalse(StructIsEmpty(stRead))>
	</cffunction>

	<cffunction name="testcreate" returntype="void" access="public" output="false">
		<cfset var oTemp = variables.oDAO.create(variables.stData)>
		<cfset assertTrue(StructKeyExists(oTemp, "_insertOk") AND oTemp._insertOk)>
	</cffunction>

	<cffunction name="testgetConsumerCount" returntype="void" access="public" output="false">
		<cfset assertTrue(IsNumeric(variables.oDAO.getConsumerCount()))>
	</cffunction>

	<cffunction name="testupdate" returntype="void" access="public" output="false">
		<cfset var iConsumerID = 0>
		<cfset var oTemp = 0>
		<cfset var sColumnList = "consumername, consumerfullname">

		<cfset testcreate()>

		<cfset iConsumerID = variables.oDAO.read(variables.stData.consumerkey).consumerID>
		<cfset variables.stData.consumerID = iConsumerID>
		<cfset variables.stData.consumername = "testname">
		<cfset variables.stData.consumerfullname = "Test Name">
		<cfset oTemp = variables.oDAO.update(stUpdateData = variables.stData, columnList = sColumnList)>
		<cfset assertTrue(StructKeyExists(oTemp, "_insertOk") AND oTemp._insertOk)>
	</cffunction>

	<cffunction name="testdelete" returntype="void" access="public" output="false">
		<cfset var stRead = variables.oDAO.read(variables.stData.consumerkey)>
		<cfloop condition="NOT StructIsEmpty(variables.oDAO.read(variables.stData.consumerkey))">
			<cfset stRead = variables.oDAO.read(variables.stData.consumerkey)>
			<cfset variables.oDAO.delete(stRead.consumerID)>
		</cfloop>
		<cfset assertTrue(StructIsEmpty(variables.oDAO.read(variables.stData.consumerkey)))>
	</cffunction>

	<cffunction name="testlistAll" returntype="void" access="public" output="false">
		<cfset assertTrue( IsQuery(variables.oDAO.listAll()) )>
	</cffunction>

	<cffunction name="testinit" returntype="void" access="public" output="false">
		<cfset assertTrue(IsInstanceOf(variables.oDAO, "oauth.oauthconsumerdao"))>
	</cffunction>

	<!--------------------------------------------------------------->

	<cffunction name="tearDown" returntype="void" access="private" output="false"
		hint="Tears down the fixture, for example, close a network connection.">
		<cfset variables.oDAO.delete(variables.iDeleteID)>
	</cffunction>

</cfcomponent>