/**
 * This view is used to present the details of a agrupación.
 */
Ext.define('HreRem.model.Agrupaciones', {
    extend: 'HreRem.model.Base',

    fields: [
    	{
    		name : 'nombre'
    	},
    	{
    		name: 'tipoAgrupacion'
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
    		name : 'fechaBaja',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'numAgrupacionRem'
    	},
    	{
    		name : 'activos'
    	},
    	{
    		name : 'publicados'
    	},
    	{
    		name : 'provincia'
    	},
    	{
    		name : 'localidad'
    	},
    	{
    		name : 'direccion'
    	}
    ],
    
    proxy: {
		type: 'uxproxy',
		api: {
            create: 'agrupacion/createAgrupacion',
            destroy: 'agrupacion/deleteAgrupacionById'
        }
    }    
});