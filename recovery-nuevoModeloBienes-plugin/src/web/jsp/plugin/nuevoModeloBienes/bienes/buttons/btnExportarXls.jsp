<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a Excel" />'
        ,iconCls:'icon_exportar_csv'
        ,id:'btnXLSExport'
        ,handler: function() {
					var params=getParametros();
					var hayParametros = false;
					for (var i in params) {
						if (i != 'solvenciaNoEncontrada') {
							if (params[i]!='') {
								hayParametros = true;
								break;
							}
						}
					}
					
					if (hayParametros) {
						Ext.getCmp('btnXLSExport').setDisabled(true);
						Ext.Ajax.request({
							url: page.resolveUrl('nmbbien/exportacionBienesCount')
							,params: params
							,method: 'POST'
							,success: function(result, request) {
								var r = Ext.util.JSON.decode(result.responseText);
								if (r.count <= r.limit) {
									var flow='plugin/nuevoModeloBienes/bienes/busquedas/NMBlistadoBienesExcel';
		                			params.REPORT_NAME='listado_bienes.xls';
		                			params.tiempoSuccess=<fwk:const value="es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto.XLS_WAIT_TIME" />;
									params.succesFunction=function(){Ext.getCmp('btnXLSExport').setDisabled(false)}
		                			app.openBrowserWindow(flow,params);
		                		} else {
		                			if (r.count !=undefined && r.limit !=undefined) {
		                				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.exportarExcel.limiteSuperado1"/> ' + r.limit + ' <s:message code="plugin.nuevoModeloBienes.busquedaBienes.exportarExcel.limiteSuperado2"/>');
		                			}
		                			Ext.getCmp('btnXLSExport').setDisabled(false);
		                			return false;
		                		}
		                	}
		                });
	                } else {
                		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
            		}
             }
        })
		
		