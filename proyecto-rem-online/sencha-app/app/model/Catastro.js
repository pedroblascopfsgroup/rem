/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Catastro', {
    extend: 'HreRem.model.Base',
    idProperty: 'idCatastro',

    fields: 
    	[    
    		{
    			name: 'idActivoCatastro'
    		},
    		{
    			name: 'idActivo'
    		},
    		{
    			name:'refCatastral'
    		},
    		{
    			name: 'correcto'
    		},
    		{
    			name:'valorCatastralConst'
    		},
    		{
    			name:'valorCatastralSuelo'
    		},
    		{
    			name:'fechaRevValorCatastral',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaAltaCatastro',
    			type:'date',
    			dateFormat: 'c'    			
    		},
            {
	            name: 'superficieParcela'
	        },
	        {   
	        	name: 'superficieConstruida'
	        },
	        {
	            name: 'anyoConstruccion'
	        }, 
	        {   
	        	name: 'codigoPostal'
	        }, 
	        {
	            name: 'tipoVia'
	        },
	        {   
	        	name: 'nombreVia'
	        },
	        {  
	        	name: 'numeroVia'
	        },
	        {   
	        	name: 'puerta'
	        },
	        {   
	        	name: 'planta'
	        },
	        {   
	        	name: 'escalera'
	        },
	        {
	        	name: 'provincia'
	        },
	        {   
	        	name: 'municipio'
	        },
	        {   
	        	name: 'latitud'
	        },
	        {   
	        	name: 'longitud'
	        }
	  ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            create: 'catastro/createCatastro',
            update: 'catastro/saveCatastro',
            destroy: 'catastro/deleteCatastro'
        }
    }
});