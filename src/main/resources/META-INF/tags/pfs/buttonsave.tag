<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="flow" required="true" type="java.lang.String"%>
<%@ attribute name="parameters" required="true" type="java.lang.String"%>

<%@ attribute name="successMsgKey" required="false" type="java.lang.String"%>
<%@ attribute name="successMsg" required="false" type="java.lang.String"%>

<%@ attribute name="successHandler" required="false" type="java.lang.String"%>

<c:if test="${successHandler==null}">
var ${name}_successEventHandler = function(){
								<c:if test="${successMsgKey != null}"> 
								Ext.Msg.alert('<s:message code="pfs.tags.buttonsave.guardar" text="**Guardar" />', '<s:message code="${successMsgKey}" text="${successMsg}" />');
								</c:if>
								page.fireEvent(app.event.DONE); 
							};
</c:if>

<c:if test="${successHandler!=null}">
var ${name}_successEventHandler = ${successHandler};
</c:if>

var ${name} = new Ext.Button({
		text : '<s:message code="pfs.tags.buttonsave.guardar" text="**Guardar" />'
		<app:test id="btnGuardar_${name}" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function() {
						page.webflow({
							flow: '${flow}'
							,params: ${parameters}
							,success : ${name}_successEventHandler
						});
				   }
	});