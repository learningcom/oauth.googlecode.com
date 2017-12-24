<cfsilent>
<!--- 
Description:
============
	configuration

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
<cfset variables.sDataSource = "oauth">
<cfset variables.sBaseURL = "http://localhost/oauth_test/examples">

<!--- links --->
<cfset sRequestTokenURL = "request_token.cfm">
<cfset sAccessTokenURL = "access_token.cfm">
<cfset sAuthorizeURL = "authorize.cfm">
<cfset sEchoURL = "echo.cfm">
<cfset sServerURL = "index.cfm">
<cfset sClientURL = "client.cfm">
<cfset sAdminConsumersURL = "admin_consumers.cfm">
<cfset sOAuthURL = "http://oauth.net/core/1.0/##request_urls">
