<%--
| Copyright 2013 Adobe
|
| Licensed under the Apache License, Version 2.0 (the "License");
| you may not use this file except in compliance with the License.
| You may obtain a copy of the License at
|
| http://www.apache.org/licenses/LICENSE-2.0
|
| Unless required by applicable law or agreed to in writing, software
| distributed under the License is distributed on an "AS IS" BASIS,
| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
| See the License for the specific language governing permissions and
| limitations under the License.
--%>
<%@ page session="false"
         contentType="text/javascript" %><%
%><%@ include file="/libs/foundation/global.jsp" %><%
%>

if (CQ_Analytics.CustomStoreMgr) {
console.log('begin CQ_Analytics.CustomStoreMgr');
	CQ_Analytics.CustomStoreMgr.init();
console.log('begin CQ_Analytics.CustomStoreMgr');
}
