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
    			name:'porcentajeCompra',
    			type: 'float'
    		},
    		{
    			name:'telefono'
    		},
    		{
    			name:'email'
    		},
    		{
    			name:'descripcionEstadoPbc'
    		},
    		{
    			name:'relacionHre'
    		},
    		{
    			name:'titularContratacion'
    		},
    		{
    			name:'idExpedienteComercial'
    		},
    		{
    			name:'numFactura'
    		},
    		{
    			name:'fechaFactura',
        		type : 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'borrado',
    			type: 'boolean'
    		},
    		{
    			name:'fechaBaja',
    			type : 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'codigoGradoPropiedad'
    		},
    		{
    			name:'descripcionGradoPropiedad'
    		},
    		{
    			name:'numeroClienteUrsus'
    		}
    		
    ],
    
    proxy: {
		type: 'uxproxy',
		api: {
			read: 'expedientecomercial/getCompradoresExpediente',
			destroy: 'expedientecomercial/deleteCompradorExpediente'
        }
    }    

});