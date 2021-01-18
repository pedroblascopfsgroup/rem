/**
 * Modelo que representa un registro de la búsqueda de trabajos
 */
Ext.define('HreRem.model.BusquedaTrabajoGasto', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',    
    

    fields: [ 
        	{
    			name: 'tipoEntidad'
    		},    
    		{
    			name:'numTrabajo'
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
    		}
    ] 
    

});