/**
 * This view is used to present the details of a single CompradorItem.
 */
Ext.define('HreRem.model.FichaComprador', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    
    /**
     * Al crear un registro se genera como id un número negativo y no un String 
     */
	
    fields: [ 
    	{
		    	name: 'id'
		},
		{
		    	name: 'idExpedienteComercial'
		},
		{
		    	name: 'codTipoPersona'
		},
		{
		    	name: 'titularReserva'
		},
		{
		    	name: 'descripcionTipoPersona'
		},
		{
		    	name: 'titularReserva'
		},
		{
		    	name: 'porcentajeCompra'
		},
		{
		    	name: 'titularContratacion'
		},
		{
		    	name: 'codTipoDocumento'
		},
		{
		    	name: 'descripcionTipoDocumento'
		},
		{
		    	name: 'numDocumento'
		},
		{
		    	name: 'nombreRazonSocial'
		},
		{
		    	name: 'direccion'
		},
		{
		    	name: 'municipioCodigo'
		},
		{
		    	name: 'telefono1'
		},
		{
		    	name: 'provinciaCodigo'
		},
		{
		    	name: 'telefono2'
		},
		{
		    	name: 'codigoPostal'
		},
		{
		    	name: 'email'
		},
		{
		    	name: 'codEstadoCivil'
		},
		{
		    	name: 'descripcionEstadoCivil'
		},
		{
		    	name: 'documentoConyuge'
		},
		{
		    	name: 'antiguoDeudor'
		},
		{
		    	name: 'relacionAntDeudor'
		},
		{
		    	name: 'codTipoDocumentoRte'
		},
		{
		    	name: 'descripcionTipoDocumentoRte'
		},
		{
		    	name: 'numDocumentoRte'
		},
		{
		    	name: 'nombreRazonSocialRte'
		},
		{
		    	name: 'direccionRte'
		},
		{
		    	name: 'municipioRteCodigo'
		},
		{
		    	name: 'telefono1Rte'
		},
		{
		    	name: 'provinciaRteCodigo'
		},
		{
		    	name: 'telefono2Rte'
		},
		{
		    	name: 'codigoPostalRte'
		},
		{
		    	name: 'emailRte'
		},
		{
				name: 'responsableTramitacion'
		},
		{
				name: 'estadoPbc'
		},
		{
				name: 'fechaPeticion',
				convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}
		},
		{
				name: 'fechaResolucion',
				convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}
		},
		{
				name: 'importeProporcionalOferta'
		},
		{
				name: 'codUsoActivo'
		},
		{
				name: 'importeFinanciado'
		},
		{
				name: 'conflictoIntereses'
		},
		{
				name: 'riesgoReputacional'
		},
		{
				name: 'regimenMatrimonial'
		},
		{
				name: 'apellidos'
		},
		{
				name: 'apellidosRte'
		},
		{
			name: 'numeroClienteUrsus'
		},
		{
			name: 'numeroClienteUrsusBh'
		},
		{
			name: 'codigoGradoPropiedad'
		},
		{
			name: 'codigoPais'
		},
		{
			name: 'codigoPaisRte'
		},
		{
			name: 'esBH'
		}
		
    ],
    
	proxy: {
		type: 'uxproxy',
		remoteUrl: 'expedientecomercial/getCompradorById',
		api: {
            read: 'expedientecomercial/getCompradorById',
            create: 'expedientecomercial/createComprador',
            update: 'expedientecomercial/saveFichaComprador',
            destroy: 'expedientecomercial/findOne'
        }
        
        
    }    

});