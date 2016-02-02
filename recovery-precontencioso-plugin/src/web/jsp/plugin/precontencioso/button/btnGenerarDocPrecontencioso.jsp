<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>


new Ext.Button({
	id:'prc-btnGenerarDocPrecontencioso-padre',
	text: '<s:message code="plugin.precontencioso.button.generar.documento.titulo" text="**Generar Documento" />',
	menu: {
		items: [{
			text: '<s:message code="plugin.precontencioso.button.documento.instancia.registro" text="**Documento de instancia al registro" />',
			icon:'/pfs/css/book_next.png',
			handler: function() {
				var w = app.openWindow({
					flow: 'expedienteJudicial/documentoInstanciaRegistro'
					,params:{idPCO:data.precontencioso.id}
					,title: '<s:message code="plugin.precontencioso.button.documento.instancia.registro" text="**Documento de instancia al registro" />'
					,width: 640
				});
				w.on(app.event.DONE, function() {
					refrescarDocumentosGrid();
					w.close();
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
			}
		}]
	}
})