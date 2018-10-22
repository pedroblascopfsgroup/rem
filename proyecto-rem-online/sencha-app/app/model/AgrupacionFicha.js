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
		    		name: 'isFormalizacion'
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
	            	name: 'isAsistida',
	            	calculate: function(data) {
	        			return data.tipoAgrupacionCodigo == CONST.TIPOS_AGRUPACION['ASISTIDA'];
	        		},
	        		depends: 'tipoAgrupacionCodigo'
	            },
	            {
	            	name: 'isComercial',
	            	calculate: function(data) {
	            		return data.tipoAgrupacionCodigo == CONST.TIPOS_AGRUPACION['LOTE_COMERCIAL'];
	            	},
	            	depends: 'tipoAgrupacionCodigo'
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
		    	},
		    	{
		    		name: 'esEditable',
		    		type: 'boolean'
		    	},
		    	{
		    		name: 'existenOfertasVivas',
		    		type: 'boolean'
		    	},
		    	{
		    		name: 'codigoGestoriaFormalizacion'
		    	},
		    	{
		    		name: 'codigoGestorActivo'
		    	}
		    	,
		    	{
		    		name: 'codigoGestorComercial'
		    	},
		    	{
		    		name: 'codigoGestorDobleActivo'
		    	}
		    	,
		    	{
		    		name: 'codigoGestorFormalizacion'
		    	},
		    	{
		    		name: 'codigoGestorComercialBackOffice'
		    	},
		    	{
		    		name: 'cartera'
		    	},
		    	{
		    		name: 'subTipoComercial'
		    	},
		    	{
		    		name: 'tipoAlquilerCodigo'
		    	},    	
		    	{
		    		name: 'codigoCartera'
		    	},
		    	{
		    		name: 'estadoActivoCodigo'
		    	},
		    	{
		    		name:'tipoActivoCodigo'
		    	},
		    	{
		    		name:'subtipoActivoCodigo'
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