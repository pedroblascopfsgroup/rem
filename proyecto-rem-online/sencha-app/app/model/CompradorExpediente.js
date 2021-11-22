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
    			name:'nombreAdjunto'
    		},
    		{
    			name:'idPersonaHaya'
    		},
    		{
		    	name: 'idExpediente'
		    },
		    {
		    	name: 'idDocAdjunto'
		    },
		    {
		    	name: 'idDocRestClient'
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
    		},
    		{
    			name:'problemasUrsus'
    		},
			{
				name:'numeroClienteUrsusConyuge'
			},
			{
				name:'numeroConyugeUrsus'
			},
			{
				name:'estadoCivilURSUS'
			},
			{
				name:'regimenMatrimonialUrsus'
			},
    		{
    			name:'fechaAcepGdpr',
    			type : 'date',
        		dateFormat: 'c'
			},{
				name:'estadoContraste'
			},{
				name:'fechaContraste',
				type : 'date',
        		dateFormat: 'c'
			},{
				name:'descripcionEstadoECL'
			},{
				name:'codigoEstadoEcl'
			},
			{
				name:'estadoComunicacionBCCodigo'
			},
			{
				name:'estadoComunicacionBCDescripcion'
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

