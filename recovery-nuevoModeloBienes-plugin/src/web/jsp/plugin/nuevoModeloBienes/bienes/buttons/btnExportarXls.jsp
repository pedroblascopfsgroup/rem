<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a Excel" />'
        ,iconCls:'icon_exportar_csv'
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
						Ext.Ajax.request({
							url: page.resolveUrl('nmbbien/exportacionBienesCount')
							,params: params
							,method: 'POST'
							,success: function(result, request) {
								var r = Ext.util.JSON.decode(result.responseText);
								if (r.count <= r.limit) {
									var flow='plugin/nuevoModeloBienes/bienes/busquedas/NMBlistadoBienesExcel';
		                			params.REPORT_NAME='listado_bienes.xls';
		                			app.openBrowserWindow(flow,params);
		                		} else {
		                			if (r.count !=undefined && r.limit !=undefined) {
		                				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.exportarExcel.limiteSuperado1"/> ' + r.limit + ' <s:message code="plugin.nuevoModeloBienes.busquedaBienes.exportarExcel.limiteSuperado2"/>');
		                			}
		                			
		                			return false;
		                		}
		                	}
		                });
	                } else {
                		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
            		}
             }
        })
		
		