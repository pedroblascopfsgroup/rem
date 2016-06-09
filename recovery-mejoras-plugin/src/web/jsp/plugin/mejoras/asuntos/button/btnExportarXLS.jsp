<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>


new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a Excel" />'
        ,iconCls:'icon_exportar_csv'
        ,id:'btnXLSExport'
        ,handler: function() {
                    var flow='asuntos/exportAsuntos';
					if (validarEmptyForm()){
						if (validaMinMax()){
		                    var params=getParametros();
							params.tipoSalida='<fwk:const value="es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto.SALIDA_XLS" />';
							params.tiempoSuccess=<fwk:const value="es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto.XLS_WAIT_TIME" />;
							params.succesFunction=function(){Ext.getCmp('btnXLSExport').setDisabled(false)}
							Ext.getCmp('btnXLSExport').setDisabled(true);
		                    app.openBrowserWindow(flow,params);
						}else{
							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
						}
					}else{
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
					}
                }
        }
    )