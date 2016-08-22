/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.AgrupacionesActivo', {
    extend: 'HreRem.model.Base',

    fields: [
    	
    	{
    		name : 'nombre'
    	},
    	{
    		name : 'descripcion'
    	},
    	{
    		name : 'fechaAlta',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'fechaInclusion',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'numAgrupRem'
    	},
    	{
    		name : 'tipoAgrupacionDescripcion'
    	}, 
    	{
    		name : 'idAgrupacion'
    	},
    	{
    		name: 'tipoAgrupacionCodigo'
    	}
    	

    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById',

		api: {
            create: 'agrupacion/createAgrupacion',
            destroy: 'agrupacion/deleteAgrupacionById'
        }
        
    }    

});