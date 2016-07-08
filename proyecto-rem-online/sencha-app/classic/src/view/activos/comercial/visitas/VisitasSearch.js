Ext.define('HreRem.view.activos.comercial.visitas.VisitasSearch', {
    extend		: 'Ext.form.Panel',
    xtype		: 'visitassearch',
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
    reference: 'visitassearchform',
    title: 'Filtro de Visitas',
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
            	fieldLabel: 'Nombre'
            },
            { 
            	fieldLabel: 'Nº Documento'
            },
            { 
            	fieldLabel: 'Situación'
            }
        ]
    }, {
        items: [
        	{
        
        		xtype: 'fieldset',
        		cls	 : 'fieldsetBase',
		        title: 'Fecha Solicitud',
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
    		        title: 'Fecha Visita',
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