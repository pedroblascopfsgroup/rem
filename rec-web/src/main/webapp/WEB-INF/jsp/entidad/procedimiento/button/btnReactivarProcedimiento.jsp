<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>


	new Ext.Button({
		id : 'button_reactivar_procedimiento'
		,text : '<s:message code="plugin.mejoras.procedimientos.boton.reactivar" text="**Reactivar" />'
		,iconCls: 'icon_reanudar'
		,condition: '(data.esGestor || data.esSupervisor) && data.toolbar.paralizado	'
		,handler : function() {
			Ext.Ajax.request({
				url: page.resolveUrl('plugin/mejoras/procedimientos/plugin.mejoras.procedimientos.reanudasProcedimiento')
				,params: {id:panel.getProcedimientoId()}
				,method: 'POST'
				,success: function (response, options){
					Ext.getCmp('button_reactivar_procedimiento').setDisabled(true); 
					Ext.Msg.alert('<s:message code="plugin.mejoras.procedimientos.boton.reactivar" text="**Reactivar" />',
								  '<s:message code="plugin.mejoras.procedimientos.boton.resultadoCorrecto" text="**Ok" />');
					app.abreProcedimientoTab(panel.getProcedimientoId()
					 		, '<s:message text="${procedimiento.nombreProcedimiento}" javaScriptEscape="true" />'
					 		, procedimientoTabPanel.getActiveTab().initialConfig.nombreTab);
				},failure: function (response, options){
					Ext.Msg.alert('<s:message code="plugin.mejoras.procedimientos.boton.reactivar" text="**Reactivar" />',
								  '<s:message code="plugin.mejoras.procedimientos.boton.resultadoFallo" text="**Fail" />');
				}				
			});
		}
	})



		
		