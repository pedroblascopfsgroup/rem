Ext.define('HreRem.view.activos.detalle.WizardAltaOferta', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'wizardaltaoferta',
    title		: 'Asistente - A&ntilde;adir nueva oferta',//HreRem.i18n('title.nueva.oferta'),
    layout		: 'card',
    bodyStyle	: 'padding:10px',
    width		: Ext.Element.getViewportWidth() / 2,    
    height		: Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() -50 ,
    x: 150,
    y: 50,
    closable	: true,	
    defaults: {
        border: true
    },
   /*bbar: [
        {
            id: 'move-prev',
            text: 'Back',
            handler: function(btn) {
                navigate(btn.up("panel"), "prev");
            },
            disabled: true
        },
        '->',
        {
            id: 'move-next',
            text: 'Next',
            handler: function(btn) {
                navigate(btn.up("panel"), "next");
            }
        }
    ],*/

    items: [{
        xtype: 'anyadirnuevaofertadocumento'
        	
    },{
    	xtype: 'anyadirnuevaofertadetalle'

    },{
    	xtype: 'anyadirnuevaofertaactivoadjuntardocumento'
    }],
    renderTo: Ext.getBody()
});
/*
var navigate = function(panel, direction){

    var layout = panel.getLayout();
    layout[direction]();
    Ext.getCmp('move-prev').setDisabled(!layout.getPrev());
    Ext.getCmp('move-next').setDisabled(!layout.getNext());
};*/