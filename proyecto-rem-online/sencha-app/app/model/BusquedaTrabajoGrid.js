/**
 * Modelo que representa un registro de la busqueda de trabajos
 */
Ext.define('HreRem.model.BusquedaTrabajoGrid', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',    
    

    fields: [ 
        	{
    			name: 'tipoEntidad'
    		},    
    		{
    			name: 'numTrabajo'
    		},
    		{
    			name: 'numActivoAgrupacion'    			
    		},    		
    		{
    			name: 'tipoTrabajoCodigo'
    		},
    		{
    			name: 'tipoTrabajoDescripcion'
    		},
    		{
    			name: 'subtipoTrabajoCodigo'
    		},
    		{
    			name: 'subtipoTrabajoDescripcion'
    		},
    		{
    			name: 'estadoTrabajoCodigo'
    		},
    		{
    			name: 'estadoTrabajoDescripcion'
    		},
    		{
    			name: 'proveedor'
    		},
    		{
    			name: 'solicitante'
    		},    		
    		{
    			name: 'provinciaCodigo'	
    		},    
    		{
    			name: 'provinciaDescripcion'	
    		},    
    		{
    			name: 'localidadDescripcion'
    		},
    		{
    			name: 'codPostal'
    		},    		
    		{
    			name: 'fechaSolicitud'
    		},
    		{
    			name: 'gestorActivo'
    		},
    		{
    			name: 'numActivo'
    		},
    		{
    			name: 'numAgrupacion'
    		},    		
    		{
    			name: 'fechaPeticionDesde'
    		},
    		{
    			name: 'fechaPeticionHasta'
    		},
    		{
    			name: 'carteraCodigo'
    		},
    		{
    			name: 'idProveedor'
    		}
    		
    ] 
    

});