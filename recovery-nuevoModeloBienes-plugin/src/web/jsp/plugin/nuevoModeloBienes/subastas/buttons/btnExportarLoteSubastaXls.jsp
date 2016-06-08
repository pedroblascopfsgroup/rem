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
       			 	Ext.getCmp('btnXLSExport').setDisabled(true);
					var params=getParametros();
	                var flow='/pfs/subasta/buscarLotesSubastasXLS';
	        		var params= getParametros();
        			params.start=0;
        			params.limit=limit;	        			     		
					params.tiempoSuccess=<fwk:const value="es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto.XLS_WAIT_TIME" />;
					params.succesFunction=function(){Ext.getCmp('btnXLSExport').setDisabled(false)}
	        		app.openBrowserWindow(flow,params);
		    		page.fireEvent(app.event.DONE)
             }
        })
		
		