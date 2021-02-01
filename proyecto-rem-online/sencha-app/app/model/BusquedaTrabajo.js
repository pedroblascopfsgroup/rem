/**
 * Modelo que representa un registro de la búsqueda de trabajos
 */
Ext.define('HreRem.model.BusquedaTrabajo', {
    extend: 'HreRem.model.Base',
    idProperty: 'idTrabajo',    
    

    fields: [ 
        	{
    			name: 'tipoEntidad'
    		},    
    		{
    			name:'numTrabajo'
    		},
    		{
    			name: 'numActivoAgrupacion',
    			convert: function(value,model) {
    				if(model.get('tipoEntidad')=='listado'){
    					return '-';
    				}
    				return value == -1? '-' : value;
    			}
    		}, 
    		{
    			name:'numActivo'
    		},
    		{
    			name: 'numActivoRem'
    		}, 
    		{
    			name: 'numAgrupacionRem'
    		},    	
    		{
    			name: 'codigoTipo'
    		},
    		{
    			name: 'codigoSubtipo'
    		},
    		{
    			name:'codigoEstado'
    		},
    		{
    			name: 'descripcionTipo'
    		},
    		{
    			name: 'descripcionSubtipo'
    		},
    		{
    			name:'descripcionEstado'
    		},
    		{
    			name:'proveedor'
    		},
    		{
    			name:'solicitante'
    		},
    		{
    			name:'propietario'
    		},
    		{
    			name: 'codigoProvincia'	
    		},
    		{
    			name: 'descricionProvincia'	
    		},
    		{
    			name: 'descripcionPoblacion'
    		},
    		{
    			name: 'codPostal'
    		},
    		{
    			name: 'cubreSeguro',
    			convert: function(value) {
    				return value == 0? 'No' : 'Si';
    			}
    		},
    		{
    			name: 'fechaCierreEconomico'
    		},
    		{
    			name: 'fechaEjecutado'
    		},
    		{
    			name: 'fechaSolicitud'
    		},
    		{
    			name: 'importeTotal'
    		},
    		{
    			name:'descripcionLinea'
    		},
    		{
    			name:'idLinea'
    		}
    ] 
    

});