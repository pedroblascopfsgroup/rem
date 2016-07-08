Ext.define('HreRem.view.activos.comercial.solicitudes.SolicitudesSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'solicitudessearch',
    isSearchForm	: true,
    reference: 'solicitudessearchform',
    title: 'Filtro de Solicitudes',
    layout: 'column',
    
    defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'textfield',
        style: 'width: 50%'
    },
    
    items: [{
        items: [
            { 
            	fieldLabel: 'Nombre'
            },
            { 
            	fieldLabel: 'Nº Documento'
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
    }]
});