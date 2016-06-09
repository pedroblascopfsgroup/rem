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
        		var parametros=getParametros();
        		Ext.getCmp('btnXLSExport').setDisabled(true);
        		Ext.Ajax.request({
					url: page.resolveUrl('subasta/validarLimiteExcel')
					,params: parametros
					,method: 'POST'
					,success: function (result, request){
						
						var r = Ext.util.JSON.decode(result.responseText);
						
						if(r.msgError == '') {
					
							var flow='/pfs/subasta/generarInformeBusquedaSubastasManager';
		                	var params= getParametros();
	        				params.start=0;
	        				params.limit=limit;	       			     		
	        			    params.succesFunction=function(){Ext.getCmp('btnXLSExport').setDisabled(false)}
	        			    params.tiempoSuccess=<fwk:const value="es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto.XLS_WAIT_TIME" />;
		        			app.openBrowserWindow(flow,params);
			    			page.fireEvent(app.event.DONE);
			    		}
			    		else {
			    			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>', r.msgError);
			    			Ext.getCmp('btnXLSExport').setDisabled(false);
			    			return false;
			    		}	
		    		}
				});				
             }
        })
		
		