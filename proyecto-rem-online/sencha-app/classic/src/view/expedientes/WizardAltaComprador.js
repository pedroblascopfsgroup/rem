Ext.define('HreRem.view.expedientes.WizardAltaComprador', {
	extend : 'HreRem.view.common.WindowBase',
	xtype : 'wizardaltacomprador',
	title : 'Asistente nuevo comprador',
	layout : 'card',
	bodyStyle : 'padding:10px',
	width		: Ext.Element.getViewportWidth() > 1370 ? Ext.Element.getViewportWidth() / 2 : Ext.Element.getViewportWidth() /1.5,    
    height		: Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() -100 ,
    x			: Ext.Element.getViewportWidth() / 2 - ((Ext.Element.getViewportWidth() > 1370 ? Ext.Element.getViewportWidth() / 2 : Ext.Element.getViewportWidth() /1.5) / 2),
    y			: Ext.Element.getViewportHeight()/2 - ((Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() -100)/2),
	closable : false,
	requires: ['HreRem.view.expedientes.DatosCompradorWizard', 'HreRem.view.activos.detalle.AnyadirNuevaOfertaDocumento', 
		'HreRem.view.activos.detalle.AnyadirNuevaOfertaActivoAdjuntarDocumento'],
	viewModel: {
        type: 'expedientedetalle'
    },
	defaults : {
		border : true
	},

	items : [ {
		xtype : 'anyadirnuevaofertadocumento',
		resizable: true
	}, {
		xtype : 'datoscompradorwizard',
		resizable: true
	}, {
		xtype : 'anyadirnuevaofertaactivoadjuntardocumento',
		resizable: true
	} ],
	renderTo : Ext.getBody()
});