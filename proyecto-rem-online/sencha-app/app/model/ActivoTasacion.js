/**
 *  Modelo para el tab Valoracion y precios de Activos 
 */
Ext.define('HreRem.model.ActivoTasacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
     		{
    			name:'numActivo'
    		},
    		{
    			name:'numActivoRem'
    		},
    		{
    			name:'trabajoTasacion'
    		},
    		{
    			name:'tipoTasacion'
    		},
    		{
    			name:'fechaInicioTasacion',
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
    			name:'fechaValorTasacion',
    			type:'date'
    			/* HREOS-628 Cambiado por [type:'date'] para poder ordenar correctamente
    			 
    			  convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}*/
    		},
    		{
    			name:'fechaRecepcionTasacion',
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
    			name:'fechaSolicitudTasacion',
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
    			name:'codigoFirma'
    		},
    		{
    			name:'nomTasador'
    		},
    		{
    			name:'importeTasacionFin'
    		},
    		{
    			name:'costeRepoNetoActual'
    		},
    		{
    			name:'costeRepoNetoFinalizado'
    		},
    		{
    			name:'coeficienteMercadoEstado'
    		},
    		{
    			name:'coeficientePondValorAnanyadido'
    		},
    		{
    			name:'valorReperSueloConst'
    		},
    		{
    			name:'costeConstConstruido'
    		},
    		{
    			name:'indiceDepreFisica'
    		},
    		{
    			name:'indiceDepreFuncional'
    		},
    		{
    			name:'indiceTotalDepre'
    		},
    		{
    			name:'costeConstDepreciada'
    		},
    		{
    			name:'costeUnitarioRepoNeto'
    		},
    		{
    			name:'costeReposicion'
    		},
    		{
    			name:'porcentajeObra'
    		},
    		{
    			name:'importeValorTerminado'
    		},
    		{
    			name:'idTextoAsociado'
    		},
    		{
    			name:'importeValorLegalFinca'
    		},
    		{
    			name:'importeValorSolar'
    		},
    		{
    			name:'observaciones'
    		}
    		
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById',
		api: {
            read: 'activo/getTasacionById',
            create: 'activo/saveActivoValoracionesPrecios',
            update: 'activo/saveActivoValoracionesPrecios',
            destroy: 'activo/getActivoById'
        },
		extraParams: {pestana: '6'}
		
		
    }
    
    

});