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
		    	name: 'codTipoDocumentoConyuge'
		},
		{
	    		name: 'descripcionTipoDocumentoConyuge'
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
				name: 'codigoRegimenMatrimonial'
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
			name: 'numeroClienteUrsusConyuge'
		},
		{
			name: 'numeroClienteUrsusBhConyuge'
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
			name: 'esBankia',
			type : 'boolean'
		},
		{
			name: 'esBH',
			type : 'boolean'
		},
		{
    		name: 'esCarteraBankia', 
    		type : 'boolean'
    			
    	},
    	{
    		name: 'mostrarUrsus', 
    		type : 'boolean'
    			
    	},
    	{
    		name: 'mostrarUrsusBh', 
    		type : 'boolean'
    			
    	},
		{
			name: 'entidadPropietariaCodigo'
		},
		{
			name: 'idDocAdjunto'
		},
		{
        	name: 'cesionDatos',
        	type : 'boolean'
        },
        {
        	name: 'comunicacionTerceros',
        	type : 'boolean'
        },
        {
        	name: 'transferenciasInternacionales',
        	type : 'boolean'
        },
        {
        	name: 'pedirDoc',
        	type : 'boolean'
        },
        {
        	name: 'relacionHre'
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
			name:'nombreConyugeURSUS'
		},
		{
			name:'idBC4C'
		},
		{
			name:'compradorPrp',
			type:'boolean'
		},
		{
			name:'representantePrp',
			type:'boolean'
		},
		{
			name:'fechaNacimientoConstitucion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'formaJuridica' 
		},
		{
			name:'codEstadoContraste'
		},
		{
			name:'usufructuario'
		},
		{
			name: 'fechaNacimientoComprador',
			type:'date',
			dateFormat: 'c'
		},
		{
			name: 'localidadNacimientoCompradorCodigo'
		},
		{
			name: 'localidadNacimientoCompradorDescripcion'
		},
		{
			name: 'fechaNacimientoRepresentante',
			type:'date',
			dateFormat: 'c'
		},
		{
			name: 'localidadNacimientoRepresentanteCodigo'
		},
		{
			name: 'localidadNacimientoRepresentanteDescripcion'
		},
		{
			name: 'paisNacimientoRepresentanteCodigo'
		},
		{
			name: 'paisNacimientoRepresentanteDescripcion'
		},
		{
			name: 'vinculoCaixaCodigo'
		},
		{
			name:'paisNacimientoCompradorCodigo'
		},
		{
			name:'fechaNacimientoRepresentante',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'paisNacimientoCompradorCodigo'
		},
		{
			name:'paisNacimientoCompradorDescripcion'
		},
		{
			name:'paisNacimientoRepresentanteCodigo'
		},
		{
			name:'paisNacimientoRepresentanteDescripcion'
		},
		{
			name:'provinciaNacimientoCompradorCodigo'
		},
		{
			name:'provinciaNacimientoCompradorDescripcion'
		},
		{
			name:'provinciaNacimientoRepresentanteCodigo'
		},
		{
			name:'provinciaNacimientoRepresentanteDescripcion'
		},
		{
			name:'localidadNacimientoCompradorCodigo'
		},
		{
			name:'localidadNacimientoCompradorDescripcion'
		},
		{
			name:'localidadNacimientoRepresentanteCodigo'
		},
		{
			name:'localidadNacimientoRepresentanteDescripcion'
		},
		{
			name:'sociedad'
		},
		{
			name:'oficinaTrabajo'
		},
		{
			name:'nacionalidadCodigo'
		},
		{
			name:'nacionalidadRprCodigo'
		},
		{
			name:'motivoEdicionCompradores'
		},
		{
			name:'isExpedienteAprobado',
			type : 'boolean'
		}
		
		
    ],
    
	proxy: {
		type: 'uxproxy',
		writeAll: true,
		remoteUrl: 'expedientecomercial/getCompradorById',
		api: {
            read: 'expedientecomercial/getCompradorById',
            create: 'expedientecomercial/createComprador',
            update: 'expedientecomercial/saveFichaComprador',
            destroy: 'expedientecomercial/findOne'
        }       
	}    

});