/**
 *  Modelo para el tab Publicacion > Informacion comercial de Activos 
 */
Ext.define('HreRem.model.ActivoInformeComercial', {
    extend: 'HreRem.model.ActivoInformacionComercial',
    idProperty: 'id',

    fields: [
        
     		{
    			name:'autorizacionWeb'
    		},
     		{
    			name:'fechaAutorizacionHasta'
    		},
     		{
    			name:'fechaRecepcionLlaves',
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
    			name:'tipoActivoCodigo'
    		},
    		{
    			name: 'isInformeGeneralVisible',
    			calculate: function(data) {    				
    				if(Ext.isEmpty(data.tipoActivoCodigo)){
    					return false;
    				}
    				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['VIVIENDA'] || data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO'] 
    							|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['OTROS'] );
    			},
    			depends: 'tipoActivoCodigo'
    		},
     		{
    			name:'subtipoActivoCodigo'
    		},
     		{
    			name:'estadoActivo'
    		},
     		{
    			name:'tipoViaCodigo'
    		},
     		{
    			name:'nombreVia'
    		},
     		{
    			name:'numeroVia'
    		},
     		{
    			name:'escalera'
    		},
     		{
    			name:'planta'
    		},
     		{
    			name:'puerta'
    		},
     		{
    			name:'latitud'
    		},
     		{
    			name:'longitud'
    		},
     		{
    			name:'zona'
    		},
     		{
    			name:'distrito'
    		},
     		{
    			name:'localidad'
    		},
     		{
    			name:'provincia'
    		},
     		{
    			name:'codigoPostal'
    		},
     		{
    			name:'inscritaComunidad'
    		},
     		{
    			name:'cuotaMediaComunidad'
    		},
     		{
    			name:'nomPresidenteComunidad'
    		},
     		{
    			name:'telPresidenteComunidad'
    		},
     		{
    			name:'nomAdministradorComunidad'
    		},
     		{
    			name:'telAdministradorComunidad'
    		},
     		{
    			name:'valorEstimadoVenta'
    		},
     		{
    			name:'valorEstimadoRenta'
    		},
     		{
    			name:'justificacionVenta'
    		},
     		{
    			name:'justificacionRenta'
    		},
    		{
    			name:'fechaEstimacionVenta',
    			type:'date',
    			dateFormat: 'c'
    		},
     		{
    			name:'fechaEstimacionRenta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'inferiorMunicipioCodigo'
    		},
    		{
    			name: 'ubicacionActivoCodigo'
    		},
    		{
    			name: 'derramaOrientativaComunidad'
    		},
    		{
    			name: 'cuotaOrientativaComunidad'
    		},
    		// Datos Plaza aparcamiento - Varios (otros)
    		{
    			name: 'aparcamientoAltura'
    		},
    		{
    			name: 'aparcamientoLicencia',
    			convert: function(data) {
    				return data == 1;
    			}
    		},
    		{
    			name: 'aparcamientoSerbidumbre',
    			convert: function(data) {
    				return data == 1;
    			}
    		},
    		{
    			name: 'aparcamientoMontacarga',
    			convert: function(data) {
    				return data == 1;
    			}
    		},
    		{
    			name: 'aparcamientoColumnas',
    			convert: function(data) {
    				return data == 1;
    			}
    		},
    		{
    			name: 'aparcamientoSeguridad',
    			convert: function(data) {
    				return data == 1;
    			}
    		},
    		{
    			name: 'maniobrabilidadCodigo'
    		},
    		{
    			name: 'subtipoPlazagarajeCodigo'
    		},
    		{
    			name: 'posibleInforme'/*,
    			convert: function(data) {
    				if (data) {
    					return 1;
    				} else {
    					return 0;
    				}
    			}*/
    		},
    		{
    			name: 'motivoNoPosibleInforme'
    		},
    		{
    			name: 'tieneProveedorTecnico',
    			type: 'boolean'
    		}
    ],
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveActivoInformeComercial',
            update: 'activo/saveActivoInformeComercial'
        },
        extraParams: {tab: 'informecomercial'}
    }
    
    

});