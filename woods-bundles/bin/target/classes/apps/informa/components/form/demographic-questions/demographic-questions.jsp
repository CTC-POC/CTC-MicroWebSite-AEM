<%@include file="/libs/foundation/global.jsp"%>
<div data-sly-test="${wcmmode.edit}" data-emptytext="Demographic Questions" class="cq-placeholder"></div>
<%@ page import="com.informa.components.commons.model.MultifieldModel,
    			 java.util.List,
				 com.informa.components.commons.Multifield ,
				 java.util.List,java.util.Iterator,
				 org.apache.sling.api.resource.ResourceResolver,
				 org.apache.sling.api.resource.Resource,
				 javax.jcr.Node,
				 javax.jcr.NodeIterator" %>

<%

    String question = properties.get("question","");
    String authorablequestion = properties.get("authorablequestion","");
	boolean demographicRequired = properties.get("demographicRequired",false);
	String demographicRequiredMessage = properties.get("demographicRequiredMessage","Please select demographic question");
	String tooltip=properties.get("tooltip",String.class);
	Resource resparent = resource.getParent();
	ValueMap parentProperties = resparent.getParent().getValueMap();
	Boolean formError = parentProperties.get("formerror",false);
	String dataplacement = "right";
	if(formError)
    {
        dataplacement="bottom";
    }




    Multifield multifield=resource.adaptTo(Multifield.class);
    MultifieldModel answerName = null;
	Iterator listOfAnswers=null;
    List answersList=multifield.getChildList();

        if( null != answersList && !answersList.isEmpty()){
			listOfAnswers=answersList.iterator();
        }


    Node demographicNodes;
    NodeIterator childrenNodes;
    Node questionNode;
    String demographicQuestionType = "";
    String questionCode = "";
    Resource demographicNodePath = resourceResolver.getResource("/etc/informareferencedata/demographicQuestions");
        if(null != demographicNodePath ){
    
            demographicNodes = demographicNodePath.adaptTo(Node.class);
            childrenNodes = demographicNodes.getNodes();
        
             while (childrenNodes.hasNext()) {
        
                questionNode = childrenNodes.nextNode();
                questionCode = questionNode.getProperty("demographicQuestionCode").getValue().toString();
        
                  if(question.equals(questionCode)){
        
                    demographicQuestionType = questionNode.getProperty("demographicQuestionType").getValue().toString();
        
                  }
             }   
        } 
    

        if(!authorablequestion.isEmpty()){

        %>

	<input type="hidden" value="<%=demographicRequired%>" id="demographicRequired">
	<input type="hidden" value="<%=demographicRequiredMessage%>" id="demographicRequiredMessage">

	<div class="form-group demographic_gender">

		<fieldset class="custom-checkbox-fieldset">
			<label for="demographicvalues" class="col-md-3 col-sm-3 form-one-control-label forms-title-color-fo">         
			<%=authorablequestion%>
			<%if(demographicRequired==true){%>
			<span class="asterisk-sign-clr">*</span>
			<%}%>   
			</label>
			<div class="col-md-9 col-lg-7 col-sm-9 col-xs-11 input-div interest-levle-checkBox-component genderRadioBox forms-custom-radio-btn "> 
				<% 
				if( "QT_LOV".equals(demographicQuestionType) ){
				if( null != listOfAnswers)	{
				while(listOfAnswers.hasNext()){
				answerName = (MultifieldModel)listOfAnswers.next();
				if(null != answerName){	
				%>	
				<div class="radio  demographic-values-checkBox Gender-option "> 
					<% 	
                    if(demographicRequired==true){
                    %>

					<input  id="<%=question+"|"+demographicQuestionType %>" type="radio" class="demographicvalues" name="<%=question+"|"+demographicQuestionType %>" value="<%=answerName.getAnswer()%>" 
                    data-bv-validatorname="true" data-bv-notempty data-bv-notempty-message="<%= demographicRequiredMessage%>" data-bv-trigger="blur" />
                    <%}
                        else{
                     %>       
					<input  id="<%=question+"|"+demographicQuestionType %>" type="radio" class="demographicvalues " name="<%=question+"|"+demographicQuestionType %>" value="<%=answerName.getAnswer()%>"/>
                    <%
                        }
                     %>   
					<label for=<%=question+"|"+demographicQuestionType %> > 
						<span> <%=answerName.getAuthorableans()%></span>
					</label>                                               
				</div> 

				<% 
				}
				}

                if(tooltip!=null){
                      %>  
                     <span class="custom-tool-tip  ">
            <a  href="javascript:void(0)" class="tooltip-mobile hidden-xs" data-toggle="tooltip" data-placement="<%=dataplacement%>" title="<%=tooltip%>">
                <img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
            </a>
            <a  href="javascript:void(0)" class="tooltip-mobile visible-xs " data-toggle="tooltip" data-placement="bottom" title="<%=tooltip%>">
                <img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
            </a>
            </span>
                <%}    
				} 
				}
				if("QT_FREETEXT".equals(demographicQuestionType) ){
                    if(demographicRequired==true){

				%>
					<input type="text" name="<%=question+"|"+demographicQuestionType %>" id="demographicvalues"  class="demographicvalues"  data-bv-validatorname="true" data-bv-notempty data-bv-notempty-message="<%= demographicRequiredMessage%>" data-bv-trigger="blur" />
				<%
				}
                     else{
				%>
					<input type="text" name="<%=question+"|"+demographicQuestionType %>" id="demographicvalues"  class="demographicvalues" />
                <%
            }

                if(tooltip!=null){ 
                      %>  
                     <span class="custom-tool-tip  ">
            <a  href="javascript:void(0)" class="tooltip-mobile hidden-xs" data-toggle="tooltip" data-placement="<%=dataplacement%>" title="<%=tooltip%>">
                <img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
            </a>
            <a  href="javascript:void(0)" class="tooltip-mobile visible-xs " data-toggle="tooltip" data-placement="bottom" title="<%=tooltip%>">
                <img class="tool-tip-img" src="/etc/designs/informa/globalstyle/clientlibs/images/Question-mark.png" alt="tooltip_image" />
            </a>
            </span>
                <%}   
                }

            	%>

				</div>
		</fieldset>
        
	</div>

        <%
         }
        
        %>
