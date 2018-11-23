Ext.define('HreRem.view.activos.detalle.WizardAltaOferta', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'wizardaltaoferta',
    title		: HreRem.i18n('title.nueva.oferta'),
    layout		: 'card',
    bodyStyle	: 'padding:10px',
    width		: Ext.Element.getViewportWidth() / 2,    
    height		: Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() - 50 ,
    closable	: true,	
    defaults: {
        border: true
    },
    bbar: [
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
    ],

    items: [{
        id: 'card-0',
        html: '<h1>Bienvenidos al Mago de PFS!</h1><p>Paso 1 de 3</p>'
    },{
    	id: 'card-1',
        html: '<h1>Bienvenidos al Mago de PFS!</h1><p>Paso 2 de 3</p>'
    	 //xtype: 'anyadirnuevaofertaactivo'
    },{
    	xtype: 'anyadirnuevaofertaactivoadjuntardocumento'
    }],
    renderTo: Ext.getBody()
});

var navigate = function(panel, direction){

    var layout = panel.getLayout();
    layout[direction]();
    Ext.getCmp('move-prev').setDisabled(!layout.getPrev());
    Ext.getCmp('move-next').setDisabled(!layout.getNext());
};