Ext.define('HreRem.view.activos.detalle.WizardAltaOferta', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'wizardaltaoferta',
    title		: 'Asistente - A&ntilde;adir nueva oferta',
    layout		: 'card',
    bodyStyle	: 'padding:10px',
    width		: Ext.Element.getViewportWidth() > 1370 ? Ext.Element.getViewportWidth() / 2 : Ext.Element.getViewportWidth() /1.5,
    height		: Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() -100 ,
    x: Ext.Element.getViewportWidth() / 2 - ((Ext.Element.getViewportWidth() > 1370 ? Ext.Element.getViewportWidth() / 2 : Ext.Element.getViewportWidth() /1.5) / 2),
    y: Ext.Element.getViewportHeight()/2 - ((Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() -100)/2),
    closable	: false,
    requires: ['HreRem.model.OfertaComercial'],
    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    defaults: {
        border: true
    },
    idAgrupacion: null,
    items: [{
        xtype: 'anyadirnuevaofertadocumento',
		resizable: true        	
    },{
    	xtype: 'anyadirnuevaofertadetalle',
		resizable: true
    },{
    	xtype: 'anyadirnuevaofertaactivoadjuntardocumento',
		resizable: true
    }],
    renderTo: Ext.getBody()
});