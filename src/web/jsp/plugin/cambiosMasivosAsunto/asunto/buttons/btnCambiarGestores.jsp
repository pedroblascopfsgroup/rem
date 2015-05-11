<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

   	new Ext.Button({
		text : '<s:message code="plugin.cambiosMasivosAsunto.asunto.btnCambioGestoresListadoAsuntos" text="**Cambiar gestores" />'
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,handler : function() {
			var parametros = {
				listaAsuntos : getSelectedItems()
			};
			var w= app.openWindow({
				flow: 'cambiosgestores/abreVentanaBuscadorAsuntos'
				,closable: true
				,width : 470
				,title : '<s:message code="asunto.concurso.tabConvenios.tituloModificarConvenioCredito" text="**Cambio de gestores" />'
				,params: parametros
			});
			w.on(app.event.DONE, function(){
				w.close();
				page.fireEvent(app.event.DONE);
			});
			w.on(app.event.CANCEL, function(){w.close();});
		}
   	})
   	

		
		