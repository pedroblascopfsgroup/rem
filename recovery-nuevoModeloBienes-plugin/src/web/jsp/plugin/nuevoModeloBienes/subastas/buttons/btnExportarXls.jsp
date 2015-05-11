<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a Excel" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
        
         Ext.Ajax.request({       
	               	url : page.resolveUrl('/subasta/exportacionSubastasCount'),
	        		params: getParametros(),
	        		success : function(data) {     	
        				var data = Ext.decode(data.responseText);
						var count = data.count;
						var limit = data.limit;
						if(count < limit){
							var flow='/pfs/subasta/generarInformeBusquedaSubastasManager';
					        var params=getParametros();
							app.openBrowserWindow(flow,params);	 
						}else{
							Ext.MessageBox.hide();
							Ext.Msg.alert('<s:message code="plugin.coreextension.ws.error" text="**Error" />', '<s:message code="plugin.nmb.subastas.exportarExcel.limiteSuperado1" text="Se ha establecido un límite máximo de " />'+ limit + ' '+
								'<s:message code="plugin.nmb.subastas.exportarExcel.limiteSuperado2" text="subastas a exportar. Por favor utilice los filtros para limitar el número de resultados." />');
						}							    			
					},
					failure: function (result) {
						Ext.MessageBox.hide();
						Ext.Msg.alert('<s:message code="plugin.coreextension.ws.error" text="**Error" />', '<s:message code="plugin.coreextension.asuntos.exportarExcel.errorExportando" text="Se ha producido un error durante el proceso de validación de la exportación a excel." />');
				    }
				});         
             }
        })
		
		