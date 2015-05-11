<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrezcar" />'
		,iconCls: 'icon_refresh'
		,handler: function() {

			if (contratoTabPanel.getActiveTab() != null && contratoTabPanel.getActiveTab().initialConfig.nombreTab != null)
				app.abreContratoTab(${contrato.id}, '${contrato.codigoContrato}', contratoTabPanel.getActiveTab().initialConfig.nombreTab);
			else
				app.abreContrato(${contrato.id}, '${contrato.codigoContrato}');
		
		}
	})