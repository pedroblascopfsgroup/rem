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
	controller: 'expedientedetalle',
	viewModel: {
		type: 'expedientedetalle'
	},
	requires: ['HreRem.view.expedientes.DatosCompradorWizard', 'HreRem.view.activos.detalle.AnyadirNuevaOfertaDocumento', 
		'HreRem.view.activos.detalle.AnyadirNuevaOfertaActivoAdjuntarDocumento'],
	defaults : {
		border : true
	},
	controller: 'expedientedetalle',
    viewModel: {
        type: 'expedientedetalle'
    },
	/*
	Wizard Compradores: Barra inferior para mostrar los botones de avanzar y volver atr�s base del wizard, nosotros utilizamos los
	botones de las vistas
	bbar : [ {
		id : 'move-prev',
		text : 'Back',
		handler : function(btn) {
			navigate(btn.up("panel"), "prev");
		},
		disabled : true
	}, '->', {
		id : 'move-next',
		text : 'Next',
		handler : function(btn) {
			navigate(btn.up("panel"), "next");
		}
	} ],*/

	items : [ {
		xtype : 'anyadirnuevaofertadocumento'

	}, {
		xtype : 'datoscompradorwizard'
	}, {
		xtype : 'anyadirnuevaofertaactivoadjuntardocumento'
	} ],
	renderTo : Ext.getBody()
});


/*
Wizard Compradores: funcion base para navegar entre las ventanas del wizard
var navigate = function(panel, direction) {

	var layout = panel.getLayout();
	layout[direction]();
	Ext.getCmp('move-prev').setDisabled(!layout.getPrev());
	Ext.getCmp('move-next').setDisabled(!layout.getNext());
};
*/