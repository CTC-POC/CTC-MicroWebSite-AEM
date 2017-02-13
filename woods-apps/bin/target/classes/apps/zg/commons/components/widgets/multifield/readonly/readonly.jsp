<%--
	Copy of /libs/granite/ui/components/foundation/form/multifield/readonly/readonly.jsp
	
	Changed the way the data is being retrieved to be unified with the default rendering.
	Request property set in init.jsp is used instead of newly computed variable as in original script.
--%><%
%><%@include file="/libs/granite/ui/global.jsp" %><%
%><%@page session="false"
		  import="java.lang.reflect.Array,
				  java.util.HashMap,
				  org.apache.sling.api.resource.ValueMap,
				  org.apache.sling.api.wrappers.ValueMapDecorator,
				  com.adobe.granite.ui.components.AttrBuilder,
				  com.adobe.granite.ui.components.ComponentHelper,
				  com.adobe.granite.ui.components.ComponentHelper.Options,
				  com.adobe.granite.ui.components.Config,
				  com.adobe.granite.ui.components.Field,
				  com.adobe.granite.ui.components.Tag,
				  com.adobe.granite.ui.components.Value" %><%

Config cfg = cmp.getConfig();

Tag tag = cmp.consumeTag();
AttrBuilder attrs = tag.getAttrs();

String fieldLabel = cfg.get("fieldLabel", String.class);

Resource field = cfg.getChild("field");
Config fieldCfg = new Config(field);
String name = fieldCfg.get("name", String.class);

// Custom code injected here:
attrs.addClass(cfg.get("class", String.class));
ValueMap vm = (ValueMap) request.getAttribute("com.adobe.granite.ui.components.Field");
Object[] array = vm.get("value", new Object[] {});

if (cmp.getOptions().rootField()) {
	attrs.addClass("coral-Form-fieldwrapper");

	%><div <%= attrs.build() %>><%
		if (fieldLabel != null) {
			%><label class="coral-Form-fieldlabel"><%= outVar(xssAPI, i18n, fieldLabel) %></label><%
		}
	
		%><ol class="coral-Form-field coral-List coral-List--minimal"><%
			for (int i = 0; i < array.length; i++) {
				%><li class="coral-List-item"><% include(field, cmp.getReadOnlyResourceType(field), name, array[i], cmp, request); %></li><%
			}
		%></ol>
	</div><%
} else {
	%><ol class="coral-List"><%
		for (int i = 0; i < array.length; i++) {
			%><li class="coral-List-item"><% include(field, cmp.getReadOnlyResourceType(field), name, array[i], cmp, request); %></li><%
		}
	%></ol><%
}
%><%!

private void include(Resource field, String resourceType, String name, Object value, ComponentHelper cmp, HttpServletRequest request) throws Exception {
	ValueMap map = new ValueMapDecorator(new HashMap<String, Object>());
	map.put(name, value);
	
	ValueMap existing = (ValueMap) request.getAttribute(Value.FORM_VALUESS_ATTRIBUTE);
	request.setAttribute(Value.FORM_VALUESS_ATTRIBUTE, map);
	
	cmp.include(field, resourceType, new Options().rootField(false));
	
	request.setAttribute(Value.FORM_VALUESS_ATTRIBUTE, existing);
}
%>
