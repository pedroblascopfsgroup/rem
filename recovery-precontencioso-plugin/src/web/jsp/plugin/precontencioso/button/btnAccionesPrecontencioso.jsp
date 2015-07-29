<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

new Ext.Button({
	text: '<s:message code="plugin.precontencioso.button.titulo" text="**Acciones" />',
	menu: {
		items: [{
			text: '<s:message code="plugin.precontencioso.button.finalizarPreparacion" text="**Finalizar preparación" />',

			handler: function() {
				var page = new fwk.Page("pfs", "", "", "");
				Ext.Ajax.request({
					url: page.resolveUrl('expedientejudicial/finalizarpreparacion'),
					params: {idProcedimiento: data.id},
					method: 'POST',
					success: function ( result, request ) {

					}
				});
			}
		}]
	}
})
