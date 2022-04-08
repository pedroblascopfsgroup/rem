/**
 * This view is used to present the details of a single Proveedor item.
 */
Ext.define('HreRem.model.FichaProveedorModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
		    {
		    	name: 'id'
		    },
		    {
		    	name: 'codigo'
		    },
		    {
		    	name: 'fechaUltimaActualizacion',
    			type:'date',
    			dateFormat: 'c'
		    },
		    {
		    	name: 'nombreProveedor'
		    },
		    {
		    	name: 'fechaAltaProveedor',
    			type:'date',
    			dateFormat: 'c'
		    },
		    {
		    	name: 'tipoProveedorCodigo'
		    },
		    {
		    	name: 'nombreComercialProveedor'
		    },
		    {
		    	name: 'fechaBajaProveedor',
    			type:'date',
    			dateFormat: 'c'
		    },
		    {
		    	name: 'subtipoProveedorCodigo'
		    },
		    {
		    	name: 'tipoDocumentoCodigo'
		    },
		    {
		    	name: 'nifProveedor'
		    },
		    {
		    	name: 'localizadaProveedorCodigo'
		    },
		    {
		    	name: 'estadoProveedorCodigo'
		    },
		    {
		    	name: 'tipoPersonaProveedorCodigo'
		    },
		    {
		    	name: 'observacionesProveedor'
		    },
		    {
		    	name: 'webUrlProveedor'
		    },
		    {
		    	name: 'fechaConstitucionProveedor',
    			type:'date',
    			dateFormat: 'c'
		    },
		    {
		    	name: 'territorialCodigo'
		    },
		    {
		    	name: 'carteraCodigo',
		    	convert: function(value) {
		    		if(Ext.isEmpty(value)){
		    			return 'VALOR_POR_DEFECTO';
		    		} else {
		    			return value;
		    		}
		    	}
		    },	    
		    {
		    	name: 'custodioCodigo'
		    },
		    {
		    	name: 'tipoActivosCarteraCodigo'
		    },
		    {
		    	name: 'calificacionCodigo'
		    },
		    {
		    	name: 'incluidoTopCodigo'
		    },
		    {
		    	name: 'numCuentaIBAN'
		    },
		    {
		    	name: 'titularCuenta'
		    },
		    {
		    	name: 'retencionPagoCodigo'
		    },
		    {
		    	name: 'fechaRetencion',
    			type:'date',
    			dateFormat: 'c'
		    },
		    {
		    	name: 'motivoRetencionCodigo'
		    },
		    {
		    	name: 'fechaProceso',
    			type:'date',
    			dateFormat: 'c'
		    },
		    {
		    	name: 'resultadoBlanqueoCodigo'
		    },
            {
            	name: 'isEntidad',
            	calculate: function(data) {
        			return data.tipoProveedorCodigo == CONST.TIPOS_PROVEEDOR['ENTIDAD'];
        		},
        		depends: 'tipoProveedorCodigo'
            },
            {
            	name: 'isSociedadTasadora',
            	calculate: function(data) {
        			return data.subtipoProveedorCodigo == CONST.SUBTIPOS_PROVEEDOR['SOCIEDAD_TASADORA'];
        		},
        		depends: 'subtipoProveedorCodigo'
            },
            {
            	name: 'isAdministracion',
            	calculate: function(data) {
        			return data.tipoProveedorCodigo == CONST.TIPOS_PROVEEDOR['ADMINISTRACION'];
        		},
        		depends: 'tipoProveedorCodigo'
            },
            {
            	name: 'isProveedor',
            	calculate: function(data) {
        			return data.tipoProveedorCodigo == CONST.TIPOS_PROVEEDOR['PROVEEDOR'];
        		},
        		depends: 'tipoProveedorCodigo'
            },
            {
            	name: 'isMediador',
            	calculate: function(data) {
        			return data.subtipoProveedorCodigo == CONST.SUBTIPOS_PROVEEDOR['MEDIADOR'];
        		},
        		depends: 'subtipoProveedorCodigo'
            },
            {
            	name: 'isEntidadOrAdministracionOrMediador',
            	calculate: function(data) {
            		if(data.tipoProveedorCodigo == CONST.TIPOS_PROVEEDOR['ENTIDAD'] ||
            		   data.tipoProveedorCodigo == CONST.TIPOS_PROVEEDOR['ADMINISTRACION'] ||
            		   data.subtipoProveedorCodigo == CONST.SUBTIPOS_PROVEEDOR['MEDIADOR']){
            			return true;
            		}
        			return false;
        		},
        		depends: 'tipoProveedorCodigo'
            },
            {
            	name: 'homologadoCodigo'
            },
            {
            	name: 'operativaCodigo'
            },
            {
            	name: 'criterioCajaIVA'
            },
            {
            	name: 'fechaEjercicioOpcion',
    			type:'date',
    			dateFormat: 'c'
            },
            {
            	name: 'codProveedorUvem'
            },
            {
            	name: 'codigoApiProveedor'
            },
            {
            	name:'idMediadorRelacionado'
            },
            
            {
            	name:'origenPeticionHomologacionCodigo'
            },
            {
            	name:'peticionario'
            },
            {
            	name:'lineaNegocioCodigo'
            },
            {
            	name:'gestionClientesNoResidentesCodigo'
            },
            {
            	name:'numeroComerciales'
            },
            {
            	name: 'fechaUltimoContratoVigente',
    			type:'date',
    			dateFormat: 'c'
            },
            {
            	name:'motivoBaja'
            },
            {
            	name:'especialidadCodigo'
            },
            {
            	name:'idiomaCodigo'
            }
            
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getProveedorById',
            create: 'proveedores/createProveedor',
            update: 'proveedores/saveProveedorById',
            destroy: 'proveedores/deleteProveedorById'
        }
    }    
});