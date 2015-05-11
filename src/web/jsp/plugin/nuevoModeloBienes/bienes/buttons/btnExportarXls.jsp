<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a Excel" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
					var params=getParametros();
					var flow='plugin/nuevoModeloBienes/bienes/busquedas/NMBlistadoBienesExcel';
	                params.REPORT_NAME='listado_bienes.xls';
	                app.openBrowserWindow(flow,params);
             }
        })
		
		