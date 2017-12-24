<cfsilent>
<!--- 
Description:
============
	creates database tables oauth_consumers and oauth_tokens

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

<!--- modify --->
<cfset sDatasource 	= "oauth">
<cfset sDbsys 		= "mssql"><!--- pgsql, mssql, oracle --->

<cfif sDbsys IS "pgsql">

	<cfquery name="q1" datasource="#sDatasource#">
	CREATE TABLE oauth_consumers (
			consumer_id		  INT NOT NULL,
			editor_id			INT NOT NULL,
			name				 VARCHAR(20) NOT NULL,
			fullname			 VARCHAR(50) NOT NULL,
			email				VARCHAR(50) NOT NULL,
			ckey				 VARCHAR(50) NOT NULL,
			csecret			  VARCHAR(50) NOT NULL,
			datecreated		  TIMESTAMP NOT NULL
	)
	</cfquery>
	
	<cfquery name="q2" datasource="#sDatasource#">
	ALTER TABLE oauth_consumers
			ADD CONSTRAINT PK_oauth_consumers PRIMARY KEY (consumer_id)
	</cfquery>
	
	<cfquery name="q3" datasource="#sDatasource#">
	CREATE TABLE oauth_tokens (
			tkey				 VARCHAR(50) NOT NULL,
			consumer_id		  INT NOT NULL,
			type				 VARCHAR(10),
			tsecret			  VARCHAR(50),
			nonce				VARCHAR(50),
			time_stamp			TIMESTAMP
	)
	</cfquery>
	
	<cfquery name="q4" datasource="#sDatasource#">
	CREATE INDEX IDX_oautt_consumer_id ON oauth_tokens (
			consumer_id
	)
	</cfquery>
	
	<cfquery name="q5" datasource="#sDatasource#">
	ALTER TABLE oauth_tokens
			ADD CONSTRAINT PK_oauth_tokens PRIMARY KEY (tkey)
	</cfquery>
	
	<cfquery name="q6" datasource="#sDatasource#">
	ALTER TABLE oauth_tokens
			ADD CONSTRAINT FK_oautc_oautt
				  FOREIGN KEY (consumer_id)
								 REFERENCES oauth_consumers  (consumer_id)
								 ON DELETE CASCADE
								 ON UPDATE CASCADE;
	</cfquery>

<cfelseif sDbsys IS "mssql">

	<cfquery name="q1" datasource="#sDatasource#">
	CREATE TABLE oauth_consumers (
			consumer_ID		  int NOT NULL,
			editor_ID			int NOT NULL,
			name				 nvarchar(20) NOT NULL,
			fullname			 nvarchar(50) NOT NULL,
			email				nvarchar(50) NOT NULL,
			ckey				 nvarchar(50) NOT NULL,
			csecret			  nvarchar(50) NOT NULL,
			datecreated		  datetime NOT NULL
	)
	</cfquery>
	
	<cfquery name="q2" datasource="#sDatasource#">
	ALTER TABLE oauth_consumers
			ADD CONSTRAINT PK_oauth_consumers PRIMARY KEY CLUSTERED (
				  consumer_ID ASC)
	</cfquery>
	
	<cfquery name="q3" datasource="#sDatasource#">
	CREATE TABLE oauth_tokens (
			tkey				 nvarchar(50) NOT NULL,
			consumer_ID		  int NOT NULL,
			type				 varchar(10) NULL,
			tsecret			  nvarchar(50) NULL,
			nonce				nvarchar(50) NULL,
			time_stamp			datetime NULL
	)
	</cfquery>
	
	<cfquery name="q4" datasource="#sDatasource#">
	CREATE INDEX IDX_oautt_consumer_ID ON oauth_tokens (
			consumer_ID					ASC
	)
	</cfquery>
	
	<cfquery name="q5" datasource="#sDatasource#">
	ALTER TABLE oauth_tokens
			ADD CONSTRAINT PK_oauth_tokens PRIMARY KEY CLUSTERED (tkey ASC)
	</cfquery>
	
	<cfquery name="q6" datasource="#sDatasource#">
	ALTER TABLE oauth_tokens
			ADD CONSTRAINT FK_oautc_oautt
				  FOREIGN KEY (consumer_ID)
								 REFERENCES oauth_consumers  (consumer_ID)
								 ON DELETE CASCADE
								 ON UPDATE CASCADE
	</cfquery>

<cfelseif sDbsys IS "oracle">

	<cfquery name="q1" datasource="#sDatasource#">
	CREATE TABLE oauth_consumers (
			consumer_ID		  INTEGER NOT NULL,
			editor_ID			INTEGER NOT NULL,
			name				 NVARCHAR2(20) NOT NULL,
			fullname			 NVARCHAR2(50) NOT NULL,
			email				NVARCHAR2(50) NOT NULL,
			ckey				 NVARCHAR2(50) NOT NULL,
			csecret			  NVARCHAR2(50) NOT NULL,
			datecreated		  DATE NOT NULL
	)
	</cfquery>
	
	<cfquery name="q2" datasource="#sDatasource#">
	ALTER TABLE oauth_consumers
			ADD CONSTRAINT PK_oauth_consumers PRIMARY KEY (consumer_ID)
	</cfquery>
	
	<cfquery name="q3" datasource="#sDatasource#">
	CREATE TABLE oauth_tokens (
			tkey				 NVARCHAR2(50) NOT NULL,
			consumer_ID		  INTEGER NOT NULL,
			type				 VARCHAR2(10) NULL,
			tsecret			  NVARCHAR2(50) NULL,
			nonce				NVARCHAR2(50) NULL,
			time_stamp			DATE NULL
	)
	</cfquery>
	
	<cfquery name="q4" datasource="#sDatasource#">
	CREATE INDEX IDX_oautt_consumer_ID ON oauth_tokens
	(
			consumer_ID					ASC
	)
	</cfquery>
	
	<cfquery name="q5" datasource="#sDatasource#">
	ALTER TABLE oauth_tokens
			ADD CONSTRAINT PK_oauth_tokens PRIMARY KEY (tkey)
	</cfquery>
	
	<cfquery name="q6" datasource="#sDatasource#">
	ALTER TABLE oauth_tokens
			ADD CONSTRAINT FK_oautc_oautt
				  FOREIGN KEY (consumer_ID)
								 REFERENCES oauth_consumers  (consumer_ID)
								 ON DELETE CASCADE
	</cfquery>
</cfif>