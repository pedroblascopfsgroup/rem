Ext.define('HreRem.view.activos.comercial.ofertas.ofertantes.OfertantesSearch', {
    extend		: 'Ext.form.Panel',
    xtype		: 'ofertantessearch',
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
    reference: 'ofertantessearchform',
    title: 'Buscador',
    layout: 'column',
    
    defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'textfield',
        style: 'width: 33%'
    },
    
    items: [{
        items: [
            { 
            	fieldLabel: 'Ofertante'
            },
            { 
            	fieldLabel: 'Nº Doc. Identificativo'
            }
        ]
    }],
    
	buttonAlign: 'left',
    buttons: [
        { 
        	text: 'Buscar'
        
        }
    ]
});