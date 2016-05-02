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
					flow: 'expedientejudicial/documentoInstanciaRegistro'
					,title: '<s:message code="plugin.precontencioso.button.documento.instancia.registro" text="**Documento de instancia al registro" />'
					,width: 900
				});
				w.on(app.event.DONE, function() {
					w.close();
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
			}
		},
		{
			text: '<s:message code="plugin.precontencioso.button.documento.instancia.canarias" text="**Documento de instancia al registro para Canarias" />',
			icon:'/pfs/css/book_next.png',
			handler: function() {
				var w = app.openWindow({
					flow: 'expedientejudicial/documentoInstanciaRegistroCanarias'
					,title: '<s:message code="plugin.precontencioso.button.documento.instancia.canarias" text="**Documento de instancia al registro para Canarias" />'
					,width: 900
				});
				w.on(app.event.DONE, function() {
					w.close();
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
			}
		}]
	}
})