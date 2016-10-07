/**
 * This view is used to present the details of a single Agrupacion Item.
 */
Ext.define('HreRem.model.AgrupacionFicha', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
     			{
		    		name : 'numAgrupRem'
		    	},
		    	{
		    		name: 'numAgrupUvem'
		    	},
		    	{
		    		name: 'tipoAgrupacion'
		    	},
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
		    		name : 'fechaBaja',
		    		type : 'date',
		    		dateFormat: 'c'
		    	},
		    	{
		    		name: 'existeFechaBaja',
		    		type: 'boolean'
		    	},
		    	{
		    		name : 'numeroPublicados'
		    	},
		    	{
		    		name : 'numeroActivos'
		    	},
		    	{
		    		name : 'municipioDescripcion'
		    	},
		    	{
		    		name : 'provinciaDescripcion'
		    	},
		    	{
		    		name : 'municipioCodigo'
		    	},
		    	{
		    		name : 'provinciaCodigo'
		    	},
		    	{
		    		name : 'direccion'
		    	},
		    	{
		    		name : 'tipoAgrupacionDescripcion'
		    	},
		    	{
		    		name : 'tipoAgrupacionCodigo'
		    	},
		    	{
		    		name : 'acreedorPDV'
		    	},
		    	{
		    		name : 'codigoPostal'
		    	},
		    	{
    			name: 'propietario',
    			convert: function (value) {
	    				if(!Ext.isEmpty(value) && value=='varios') {
	    					return HreRem.i18n('txt.varios');
	    				} else {
	    					return value;
	    				}
	    			}
	    		},
	    		{
		    		name : 'fechaInicioVigencia',
		    		type : 'date',
		    		dateFormat: 'c'
		    	},
		    	{
		    		name : 'fechaFinVigencia',
		    		type : 'date',
		    		dateFormat: 'c'
		    	}
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'agrupacion/getAgrupacionById',
            create: 'agrupacion/saveAgrupacion',
            update: 'agrupacion/saveAgrupacion',
            destroy: 'agrupacion/getAgrupacionById'
        },
		extraParams: {pestana: '1'}
    }    

});