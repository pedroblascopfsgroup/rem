<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

   new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a xls" />'
        ,iconCls:'icon_exportar_csv'
        ,id:'btnXLSExport'
        ,handler: function() {
				var params = getParametros();
				var flow='plugin/busquedaProcedimientos/plugin.busquedaProcedimientos.buscaProcedimientosExcelData';
                params.REPORT_NAME='listado_procedimientos.xls';
                params.tiempoSuccess=<fwk:const value="es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto.XLS_WAIT_TIME" />;
                params.succesFunction=function(){Ext.getCmp('btnXLSExport').setDisabled(false)}
				Ext.getCmp('btnXLSExport').setDisabled(true);
                app.openBrowserWindow(flow,params);
           }
    })
		
		