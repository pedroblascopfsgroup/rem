Ext.define('HreRem.view.expedientes.WizardAltaComprador', {
	extend : 'HreRem.view.common.WindowBase',
	xtype : 'wizardaltacomprador',
	title : 'Asistente nuevo comprador',
	layout : 'card',
	bodyStyle : 'padding:10px',
	width : Ext.Element.getViewportWidth() / 2,
	height : Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() - 100,
	x : 50,
	y : 50,
	closable : false,

	requires: ['HreRem.view.expedientes.DatosCompradorWizard', 'HreRem.view.activos.detalle.AnyadirNuevaOfertaDocumento', 
		'HreRem.view.activos.detalle.AnyadirNuevaOfertaActivoAdjuntarDocumento'],
	defaults : {
		border : true
	},

	items : [ {
		xtype : 'anyadirnuevaofertadocumento'

	}, {
		xtype : 'datoscompradorwizard'
	}, {
		xtype : 'anyadirnuevaofertaactivoadjuntardocumento'
	} ],
	renderTo : Ext.getBody()
});