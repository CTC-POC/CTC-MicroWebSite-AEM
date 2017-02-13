<%@page session="false"%><%--
  ADOBE CONFIDENTIAL
  __________________

   Copyright 2012 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%><%
%><%@page contentType="text/html" pageEncoding="utf-8" import="
      com.adobe.cq.commerce.api.Product,
      java.math.BigDecimal,
      com.day.cq.i18n.I18n,
      com.day.cq.wcm.api.WCMMode,
      java.text.MessageFormat,
      com.adobe.cq.commerce.common.CommerceHelper" %><%
%><%@include file="/libs/foundation/global.jsp"%><%

    I18n i18n = new I18n(slingRequest);

    String discountType = properties.get("discountType", "percentage");
    if (discountType.equals("absolute")) {
        discountType = i18n.get("fixed amount");
    }

    String exampleProductPagePath = properties.get("pairings/pair1/firstProductPath", String.class);
    Page exampleProductPage = exampleProductPagePath != null ? pageManager.getPage(exampleProductPagePath) : null;
    Product exampleProduct = exampleProductPage != null ? CommerceHelper.findCurrentProduct(exampleProductPage) : null;
    String exampleProductTitle = "{" + (exampleProduct != null ? exampleProduct.getTitle() : i18n.get("Halifax Snow", "example product title")) + "}";

    String message = properties.get("message", i18n.get("not defined"));
    message = MessageFormat.format(message, "", exampleProductTitle, i18n.get("{$12}", "example promotional savings"));

    if (WCMMode.fromRequest(request) != WCMMode.DISABLED) { %>
        <cq:includeClientLib categories="cq.wcm.edit"/> <%
        String dlgPath = null;
        if (editContext != null && editContext.getComponent() != null) {
            dlgPath = editContext.getComponent().getDialogPath();
        } %>
        <script type="text/javascript" >
            CQ.WCM.launchSidekick("<%= currentPage.getPath() %>", {
                actions:[{
                    text: CQ.I18n.getMessage("Import Product Pairings..."),
                    handler: function() {
                        var fileSelected = function(field, value) {
                            var dialog = field.findParentByType("dialog");
                            if (dialog && value instanceof FileList && value.length > 0) {
                                var file = value[0];
                                var reader = new FileReader();
                                reader.onload = function() {
                                    dialog.find("componentId", "previewLabel")[0].updateText(CQ.I18n.getMessage("Preview:"));
                                    var previewHTML = "<pre>" + CQ.shared.XSS.getXSSValue(reader.result) + "</pre>";
                                    dialog.find("componentId", "preview")[0].updateHtml(previewHTML);

                                    var json = "{"
                                            + "'jcr:primaryType':'nt:unstructured',"
                                            + "'sling:resourceType':'foundation/components/parsys'";
                                    var lines = reader.result.split("\n");
                                    for (var i = 0; i < lines.length; i++) {
                                        var line = lines[i];
                                        var paths = line.split(",");
                                        if (paths.length >= 2) {
                                            json += ", 'pair" + i + "':{"
                                                    + "'jcr:primaryType':'nt:unstructured',"
                                                    + "'sling:resourceType':'geometrixx-outdoors/components/perfect_partner_promotion/pairing',"
                                                    + "'firstProductPath':'" + CQ.shared.XSS.getXSSValue(paths[0].trim()) +"',"
                                                    + "'secondProductPath':'" + CQ.shared.XSS.getXSSValue(paths[1].trim()) + "'"
                                                    + "}";
                                        }
                                    }
                                    json += "}";
                                    dialog.find("name", ":content")[0].setValue(json);
                                };
                                reader.readAsText(file);
                            }
                        };
                        var dialogConfig = {
                            "jcr:primaryType": "cq:Dialog",
                            "title": CQ.I18n.getMessage("Import Product Pairings"),
                            "formUrl": this.path + "/jcr:content/config",
                            "bodyCssClass": "cq-import-pairings-dialog",
                            "items": {
                                "jcr:primaryType": "cq:Panel",
                                "items": {
                                    "jcr:primaryType": "cq:WidgetCollection",
                                    "filepicker": {
                                        "xtype": "html5fileuploadfield",
                                        "fieldLabel": CQ.I18n.getMessage("File"),
                                        "name": "",
                                        "fileNameParameter": "",
                                        "multiple": false,
                                        "mimeTypes": "text/plain;text/csv",
                                        "mimeTypesDescription": CQ.I18n.getMessage("text file or CSV file"),
                                        "listeners": {
                                            "fileselected": fileSelected
                                        }
                                    },
                                    "fileDescription": {
                                        "xtype": "static",
                                        "cls": "x-form-fieldset-description",
                                        "text": CQ.I18n.getMessage("File should contain one pair of product paths per line, separated by a comma.")
                                    },
                                    "previewLabel": {
                                        "xtype": "static",
                                        "cls": "cq-margin-top",
                                        "text": CQ.I18n.getMessage("Example:"),
                                        "componentId": "previewLabel"
                                    },
                                    "preview": {
                                        "xtype": "static",
                                        "cls": "x-form-fieldset-description",
                                        "html": "<pre>/content/geometrixx-outdoors/en/men/marka-sport,/content/geometrixx-outdoors/en/men/bambara-cargo\n"
                                             + "/content/geometrixx-outdoors/en/men/marka-sport,/content/geometrixx-outdoors/en/men/ashanti-nomad</pre>",
                                        "componentId": "preview"
                                    },
                                    "operation":   {"xtype": "hidden", "name": ":operation",   "value": "import"},
                                    "contentType": {"xtype": "hidden", "name": ":contentType", "value": "json"},
                                    "name":        {"xtype": "hidden", "name": ":name",        "value": "pairings"},
                                    "replace":     {"xtype": "hidden", "name": ":replace",     "value": true},
                                    "content":     {"xtype": "hidden", "name": ":content"}
                                }
                            }
                        };
                        var dialog = CQ.WCM.getDialog(dialogConfig);
                        dialog.success = function() {
                            CQ.Util.reload(CQ.WCM.getContentWindow());
                        };
                        dialog.failure = function() {
                            CQ.Ext.Msg.alert(CQ.I18n.getMessage("Error"), CQ.I18n.getMessage("Could not upload product pairings."));
                        };
                        dialog.show();
                    }
                }],
                locked: <%= currentPage.isLocked() %>
            });
        </script> <%
    }
%>
<h2 class="no-icon"><%= i18n.get("Perfect Partner Configuration")%></h2>
<ul>
    <li><%= i18n.get("Discount type: ") %><strong><%= xssAPI.encodeForHTML(discountType) %></strong></li>
    <li><%= i18n.get("Discount value: ") %><strong><%= properties.get("discountValue", BigDecimal.ZERO) %></strong></li>
    <li><%= i18n.get("Shopper message: ") %><strong><%= xssAPI.filterHTML(message) %></strong></li>
    <cq:include path="pairings" resourceType="foundation/components/parsys" />
    <li><%= i18n.get("Create pairings by dragging the Product Pairing component from the Sidekick.  Set the products in each pairing by dragging a catalog page from the Content Finder's Pages tab.") %></li>
</ul>
