<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	<%@ include file="tabs/tabFiltroProcedimiento.jsp" %>
	<%@ include file="tabs/tabFiltroPersonaContrato.jsp" %>
	<%@ include file="tabs/tabFiltroDocumentos.jsp" %>
	<%@ include file="tabs/tabFiltroLiquidaciones.jsp" %>
	<%@ include file="tabs/tabFiltroBurofax.jsp" %>
	<%@ include file="grids/procedimientoPcoGrid.jsp" %>

<%-- Filtros --%>

	var filtroTabPanel = new Ext.TabPanel({
		items: [filtrosTabDatosProcedimiento, filtrosTabPersonaContrato, filtrosTabDocumentos, filtrosTabLiquidacion, filtrosTabBurofax],
		id: 'idTabFiltros',
		layoutOnTabChange: true, 
		autoScroll: true,
		autoHeight: true,
		autoWidth: true,
		border: false,
		activeItem: 0
	});

	var btnBuscar = new Ext.Button({
		text: '<s:message code="plugin.precontencioso.button.titulo" text="**Acciones" />',
		handler: function() {
			panelFiltros.collapse(true);
			var params = getParametros();
			params.start = 0;
			params.limit = 25;
			procedimientoPcoStore.webflow(params);
			pagingBar.hide();
		}
	})

	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;

	var panelFiltros = new Ext.Panel({
		autoHeight: true,
		autoWidth: true,
		title: '<s:message code="asd" text="**Buscador Expedientes Judiciales" />',
		titleCollapse: true,
		collapsible: true,
		tbar: [btnBuscar],
		defaults: {xtype: 'panel', cellCls: 'vtop', border: false},
		style: 'padding-bottom: 10px;',
		items: [{
			items:[{
				layout: 'form',
				items: [filtroTabPanel]
			}]
		}]
	});

<%-- Grid --%>

	gridProcedimientosPco.on('load', function() {
		panelFiltros.collapse(true);
	});

	var mainPanel = new Ext.Panel({
		bodyStyle: 'padding:15px',
		autoHeight: true,

		border: false,
		items: [panelFiltros, gridProcedimientosPco]
	});

	page.add(mainPanel);

	<%-- Utils --%>

	var getParametros = function() {

		var fusion = function(destination, source) {
		    for (var property in source) {
		        if (source.hasOwnProperty(property)) {
		            destination[property] = source[property];
		        }
		    }
		    return destination;
		};

		var out = {};

		if (filtrosTabDatosProcedimientoActive) {
			out = fusion(out, getParametrosFiltroProcedimiento());
		}

		if (filtrosTabPersonaContratoActive) {
			out = fusion(out, getParametrosFiltroPersonaContrato());
		}

		if (filtrosTabDocumentosActive) {
			out = fusion(out, getParametrosFiltroDocumentos());
		}

		if (filtrosTabLiquidacionActive) {
			out = fusion(out, getParametrosFiltroLiquidaciones());
		}

		if (filtrosTabBurofaxActive) {
			out = fusion(out, getParametrosFiltroBurofax());
		}

		return out;
	}

</fwk:page>