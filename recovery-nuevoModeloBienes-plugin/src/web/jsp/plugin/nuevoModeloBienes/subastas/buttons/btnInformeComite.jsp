<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
new Ext.Button({
        text:'<s:message code="plugin.nuevoModeloBienes.botonInformeComite" text="**Informe Comité" />'
        ,iconCls:'icon_pdf'
        ,handler: function() {
					var params=getParametros();
					
	                var flow='/pfs/subasta/generarInformeActaComite';
	        		var params= getParametros();
        			params.start=0;
        			params.limit=limit;	        			     		
        			     		
	        		app.openBrowserWindow(flow,params);
		    		page.fireEvent(app.event.DONE)
             }
        })
		
		