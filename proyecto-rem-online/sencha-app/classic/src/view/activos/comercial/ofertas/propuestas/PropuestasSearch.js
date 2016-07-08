Ext.define('HreRem.view.activos.comercial.ofertas.propuestas.PropuestasSearch', {
    extend		: 'Ext.form.Panel',
    xtype		: 'propuestassearch',
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
    reference: 'propuestassearchform',
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
            	xtype: 'comboestadopropuesta'
            }
        ]
    }, {
        items: [
        	{
        
        		xtype: 'fieldset',
        		cls	 : 'fieldsetBase',
		        title: 'Fecha propuesta',
		        defaults: {
		            layout: 'hbox'
		        },
		        items: [
		        		{
				            xtype: 'datefield',
				            fieldLabel: 'Desde'
				        }, {
				            xtype     : 'datefield',
				            fieldLabel: 'Hasta'
        				}
		        ]
        	}
        ]
    }, {
    	items: [
            	{
            
            		xtype: 'fieldset',
            		cls	 : 'fieldsetBase',
    		        title: 'Fecha resolucion',
    		        defaults: {
    		            layout: 'hbox'
    		        },
    		        items: [
    		        		{
    				            xtype: 'datefield',
    				            fieldLabel: 'Desde'
    				        }, {
    				            xtype     : 'datefield',
    				            fieldLabel: 'Hasta'
            				}
    		        ]
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