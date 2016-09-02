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