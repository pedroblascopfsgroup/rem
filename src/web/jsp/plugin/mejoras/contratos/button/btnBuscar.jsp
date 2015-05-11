<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
app.crearBotonBuscar({
		handler : function(){

		/* El cliente ya no quiere este requisito de obligatorio
		if (comboEstadoContrato.getValue().trim() == ''){
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.contratos.listado.faltaEstado" text="**El criterio de estado de contrato es obligatorios"/>')
			return;
		}
		*/

		if (validarForm()){
			if (validaMinMax()){
				panelFiltros.collapse(true);				
				var params= getParametros();
        		params.start=0;
        		params.limit=limit;
				contratosStore.webflow(params);
				pagingBar.show();
				
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
			}
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
		}

	}
})



		
		