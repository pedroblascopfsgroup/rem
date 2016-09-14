/**
 * This view is used to present the details of a single ExpedienteComercial.
 */
Ext.define('HreRem.model.CompradorExpediente', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [   
    		
		    {
		    	name: 'idCliente'
		    },
		    {
		    	name: 'nombreComprador'
		    },      
    		{
    			name:'numDocumentoComprador'
    		},
    		{
		    	name: 'nombreRepresentante'
		    },      
    		{
    			name:'numDocumentoRepresentante'
    		},
    		{
    			name:'porcentajeCompra'
    		},
    		{
    			name:'telefono'
    		},
    		{
    			name:'email'
    		},
    		{
    			name:'estadoPbc'
    		},
    		{
    			name:'relacionHre'
    		},
    		{
    			name:'titularContratacion'
    		},
    		{
    			name:'idExpedienteComercial'
    		}
    		
    ],
    
    proxy: {
		type: 'uxproxy',
		writeAll: true,
		api: {
			read: 'expedientecomercial/getCompradoresExpediente'
        }
    }    

});