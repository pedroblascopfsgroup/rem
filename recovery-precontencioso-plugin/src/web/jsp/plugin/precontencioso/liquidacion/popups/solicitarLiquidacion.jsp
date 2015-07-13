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

	<pfsforms:datefield labelKey="asd" label="**Fecha de cierre" name="fechaCierreField" obligatory="true"/>

	<%-- Buttons --%>

	var btnGuardar = new Ext.Button({
		text: '<s:message code="app.guardar" text="**Guardar" />',
		iconCls: 'icon_edit',
		cls: 'x-btn-text-icon',
		style: 'padding-top:0px',
		handler: function() {
			if (validarForm() == '') {
				Ext.Ajax.request({
					url: page.resolveUrl('liquidacion/solicitar'),
					params: {idLiquidacion: ${liquidacion.id}, fechaCierre: fechaCierreField.getValue().format('d/m/Y')},
					method: 'POST',
					success: function ( result, request ) {
						page.fireEvent(app.event.DONE);
					}
				});
			} else {
				Ext.Msg.alert('<s:message code="asd" text="**Error" />', validarForm());
			}
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
		items: [fechaCierreField],
		bbar: new Ext.Toolbar()
	});

	panelEdicion.getBottomToolbar().addButton([btnGuardar]);
	panelEdicion.getBottomToolbar().addButton([btnCancelar]);
	page.add(panelEdicion);

	<%-- Utils --%>

	var validarForm = function() {
		return fechaCierreField.getActiveError();
	}

</fwk:page>