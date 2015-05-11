<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

app.crearBotonBuscar({
		handler : function(){

		if (validarEmptyForm()){
			if (validaMinMax()){
				panelFiltros.collapse(true);
				
				//Enviar los datos.
				asuntosStore.webflow(getParametros());
				botonesTabla.show();	
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
			}
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
		}
	})



		
		