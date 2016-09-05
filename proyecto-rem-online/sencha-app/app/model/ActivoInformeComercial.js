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
    			name:'fechaRecepcionLlaves'
    		},
     		{
    			name:'tipoActivoCodigo'
    		},
    		{
    			name: 'isViviendaMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoCodigo)){
    					return false;
    				}
    				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['VIVIENDA'];
    			},
    			depends: 'tipoActivoCodigo'
    		},
    		{
    			name: 'isPlazaAparcamientoMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoCodigo)){
    					return false;
    				}
    				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['PLAZA_APARCAMIENTO'];
    			},
    			depends: 'tipoActivoCodigo'
    		},
    		{
    			name: 'isLocalComercialMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoCodigo)){
    					return false;
    				}
    				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO'];
    			},
    			depends: 'tipoActivoCodigo'
    		},
    		{
    			name: 'isIndustrialMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoCodigo)){
    					return false;
    				}
    				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['INDUSTRIAL'];
    			},
    			depends: 'tipoActivoCodigo'
    		},
    		{
    			name: 'isEdificioCompletoMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoCodigo)){
    					return false;
    				}
    				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EDIFICIO_COMPLETO'];
    			},
    			depends: 'tipoActivoCodigo'
    		},
    		{
    			name: 'isSueloMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoCodigo)){
    					return false;
    				}
    				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['SUELO'];
    			},
    			depends: 'tipoActivoCodigo'
    		},
    		{
    			name: 'isEnConstruccionMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoCodigo)){
    					return false;
    				}
    				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EN_CONSTRUCCION'];
    			},
    			depends: 'tipoActivoCodigo'
    		},
    		{
    			name: 'isOtrosMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoCodigo)){
    					return false;
    				}
    				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['OTROS'];
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
    			type:'date'
    		},
     		{
    			name:'fechaEstimacionRenta',
    			type:'date'
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