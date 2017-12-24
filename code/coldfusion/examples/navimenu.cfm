<cfsilent>
<!--- 
Description:
============
	navigation

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
<ul id="menu">
	<li><a href="#sServerURL#">OAuth Test Server</a></li>
	<li><a href="#sClientURL#">OAuth Test Client</a></li>
	<li><a href="#sAdminConsumersURL#">Consumer Admin</a></li>
	<li><a href="#sRequestTokenURL#">Request Token URL</a></li>
	<li><a href="#sAuthorizeURL#">Authorize URL</a></li>
	<li><a href="#sAccessTokenURL#">Access Token URL</a></li>
	<li><a href="hashgenerator.cfm">Hash Generator</a></li>
</ul>
</cfoutput>