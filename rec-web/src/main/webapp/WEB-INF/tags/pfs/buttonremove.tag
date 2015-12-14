<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="flow" required="true" type="java.lang.String"%>
<%@ attribute name="datagrid" required="true" type="java.lang.String"%>
<%@ attribute name="paramId" required="true" type="java.lang.String"%>
<%@ attribute name="novalueMsgKey" required="true" type="java.lang.String"%>
<%@ attribute name="novalueMsg" required="true" type="java.lang.String"%>
<%@ attribute name="parameters" required="false" type="java.lang.String"%>

<%@ attribute name="onSuccessMode" required="false" type="java.lang.String"%>

<c:choose>
	<%--  	/* BKREC-1349
			* Alternativa al handler de arriba, la diferencia reside en que en el siguiente handler, mostrar un mensaje de  
		 	* 'Guardando...' cuando esta procesando la operación de, oscureciendo la pantalla. 
		 	* De esta forma el user puede ver que al pulsar el botón, esta realizando cálculos, y debe esperar. 
		 	*/ --%> 
	<c:when test="${onSuccessMode == 'tabConMsgGuardando'}">
		var ${name}_handler =  function() {
			if (${datagrid}.getSelectionModel().getCount()>0){
				Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == 'yes'){
    					<c:if test="${parameters != null}">var parms = ${parameters}();</c:if>
    					<c:if test="${parameters == null}">var parms = {};</c:if>
    					parms.${paramId} = ${datagrid}.getSelectionModel().getSelected().get('id');
    					
    					new Ext.LoadMask(${datagrid}.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando"/>'}).show();
    					page.webflow({
							flow: '${flow}'
							,params: parms
							,success : function(){ 
								${datagrid}.store.webflow(parms); 
								new Ext.LoadMask(${datagrid}.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando"/>'}).hide();
								${name}.setDisabled(false);
								${datagrid}.getBottomToolbar().items.items[0].setDisabled(false);
								
							}
						});
						
    				}
    				else{
    					${name}.setDisabled(false);
						${datagrid}.getBottomToolbar().items.items[0].setDisabled(false);
    				}
				});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="${novalueMsgKey}" text="${novalueMsg}" />');
			}
		};	
	</c:when>
	
	<c:otherwise>
		var ${name}_handler =  function() {
			if (${datagrid}.getSelectionModel().getCount()>0){
				Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == 'yes'){
    					<c:if test="${parameters != null}">var parms = ${parameters}();</c:if>
    					<c:if test="${parameters == null}">var parms = {};</c:if>
    					parms.${paramId} = ${datagrid}.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: '${flow}'
							,params: parms
							,success : function(){ 
								${datagrid}.store.webflow(parms); 
							}
						});
    				}
				});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="${novalueMsgKey}" text="${novalueMsg}" />');
			}
		};
	</c:otherwise>
</c:choose>

var ${name}= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,handler : ${name}_handler
});
