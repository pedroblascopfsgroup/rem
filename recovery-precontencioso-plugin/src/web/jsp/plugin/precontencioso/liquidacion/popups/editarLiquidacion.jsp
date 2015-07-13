<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>

	<%-- Fields --%>

	<pfsforms:numberfield name="capitalVencidoField" labelKey="asd" label="**Capital vencido" value="${liquidacion.capitalVencido}" />
	<pfsforms:numberfield name="capitalNoVencidoField" labelKey="asd" label="**Capital no vencido" value="${liquidacion.capitalNoVencido}" />
	<pfsforms:numberfield name="interesesOrdinariosField" labelKey="asd" label="**Intereses ordinarios" value="${liquidacion.interesesOrdinarios}" />
	<pfsforms:numberfield name="interesesDemoraField" labelKey="asd" label="**Intereses demora" value="${liquidacion.interesesDemora}" />
	<pfsforms:numberfield name="totalField" labelKey="asd" label="**Total" value="${liquidacion.total}" />
	<!-- Apoderado (Según valores de diccionario) -->

	<%-- Buttons --%>

	var btnGuardar = new Ext.Button({
		text: '<s:message code="app.guardar" text="**Guardar" />',
		iconCls: 'icon_edit',
		cls: 'x-btn-text-icon',
		style: 'padding-top:0px',
		handler: function() {
			Ext.Ajax.request({
				url: page.resolveUrl('liquidacion/editar'),
				params: getParametros(),
				method: 'POST',
				success: function ( result, request ) {
					page.fireEvent(app.event.DONE);
				}
			});
		}
	});

	var btnCancelar = new Ext.Button({
		text: '<s:message code="app.cancelar" text="**Cancelar" />',
		iconCls: 'icon_cancel',
		handler: function() {
			page.fireEvent(app.event.CANCEL);
		}
	});

	<%-- Panel --%>

	var panelEdicion = new Ext.form.FormPanel({
		autoHeight: true,
		bodyStyle:'padding:10px;cellspacing:20px',
		defaults: {xtype: 'panel', cellCls: 'vtop', border: false},
		items: [capitalVencidoField, capitalNoVencidoField, interesesOrdinariosField, interesesDemoraField, totalField],
		bbar: new Ext.Toolbar()
	});

	panelEdicion.getBottomToolbar().addButton([btnGuardar]);
	panelEdicion.getBottomToolbar().addButton([btnCancelar]);
	page.add(panelEdicion);

	<%-- Utils --%>

	var getParametros = function() {
		var parametros = {};
		
		parametros.id = '${liquidacion.id}';
		parametros.capitalVencido = capitalVencidoField.getValue();
		parametros.capitalNoVencido = capitalNoVencidoField.getValue();
		parametros.interesesOrdinarios= interesesOrdinariosField.getValue();
		parametros.interesesDemora = interesesDemoraField.getValue();
		parametros.total = totalField.getValue();

		return parametros;
	}

</fwk:page>