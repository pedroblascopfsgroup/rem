<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>


new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrezcar" />'
		,iconCls: 'icon_refresh'
		,handler: function() {
			if ('${tarea}'!=''){
				app.openTab('<s:message text="${procedimiento.nombreProcedimiento}" javaScriptEscape="true" />', 'procedimientos/consultaProcedimiento', {id:'${procedimiento.id}',tarea:'${tarea}',fechaVenc:'${fechaVenc}',nombreTab:procedimientoTabPanel.getActiveTab().initialConfig.nombreTab} , {id:'procedimiento'+'${procedimiento.id}',iconCls:'icon_procedimiento'});
			}else{
				if (procedimientoTabPanel.getActiveTab() != null && procedimientoTabPanel.getActiveTab().initialConfig.nombreTab != null)
					app.abreProcedimientoTab('${procedimiento.id}', '<s:message text="${procedimiento.nombreProcedimiento}" javaScriptEscape="true" />', procedimientoTabPanel.getActiveTab().initialConfig.nombreTab);
				else
					app.abreProcedimiento('${procedimiento.id}', '<s:message text="${procedimiento.nombreProcedimiento}" javaScriptEscape="true" />');
		
			}
		}
	})