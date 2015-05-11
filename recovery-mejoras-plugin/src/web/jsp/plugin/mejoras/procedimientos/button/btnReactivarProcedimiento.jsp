<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

<c:if test="${paralizado && (esGestor || esSupervisor)}">
	new Ext.Button({
		id : 'button_reactivar_procedimiento'
		,text : '<s:message code="plugin.mejoras.procedimientos.boton.reactivar" text="**Reactivar" />'
		,iconCls: 'icon_reanudar'
		,handler : function() {
			Ext.Ajax.request({
				url: page.resolveUrl('plugin/mejoras/procedimientos/plugin.mejoras.procedimientos.reanudasProcedimiento')
				,params: {id:"${procedimiento.id}"}
				,method: 'POST'
				,success: function (response, options){
					Ext.getCmp('button_reactivar_procedimiento').setDisabled(true); 
					Ext.Msg.alert('<s:message code="plugin.mejoras.procedimientos.boton.reactivar" text="**Reactivar" />',
								  '<s:message code="plugin.mejoras.procedimientos.boton.resultadoCorrecto" text="**Ok" />');
					app.abreProcedimientoTab('${procedimiento.id}'
					 		, '<s:message text="${procedimiento.nombreProcedimiento}" javaScriptEscape="true" />'
					 		, procedimientoTabPanel.getActiveTab().initialConfig.nombreTab);
				},failure: function (response, options){
					Ext.Msg.alert('<s:message code="plugin.mejoras.procedimientos.boton.reactivar" text="**Reactivar" />',
								  '<s:message code="plugin.mejoras.procedimientos.boton.resultadoFallo" text="**Fail" />');
				}				
			});
		}
	})
</c:if>


		
		