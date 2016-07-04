<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**exportar a xls" />'
        ,iconCls:'icon_exportar_csv'
        ,id:'btnXLSExport'
        ,handler: function() {
        
        			if (validarForm()){
						if (validaMinMax()){
                    		busquedaClientesMask.show();
		                    var params=getParametros();
							Ext.getCmp('btnXLSExport').setDisabled(true);
							limiteClientesStore.webflow(params);
						}else{
							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
						}
					}else{
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
					}
      
                }
        }
    )	