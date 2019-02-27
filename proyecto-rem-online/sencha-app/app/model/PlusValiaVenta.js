/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.PlusValiaVenta', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
     		{
    			name:'exento'
    		},
    		{
    			name:'autoliquidacion'
    		},
    		{
    			name:'fechaEscritoAyt',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'observaciones'
    		}
    	
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'plusValiaVenta.json',
		timeout: 60000,  
		
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/savePlusvaliaVenta'
        },
		
        extraParams: {tab: 'plusvalia'}
    }    
    
    
    

});