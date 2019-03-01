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
	            		return data.tipoAgrupacionCodigo == CONST.TIPOS_AGRUPACION['COMERCIAL_ALQUILER']
	            			|| data.tipoAgrupacionCodigo == CONST.TIPOS_AGRUPACION['COMERCIAL_VENTA'];
	            	},
	            	depends: 'tipoAgrupacionCodigo'
	            },
	            {
	            	name: 'isComercialVenta',
	            	calculate: function(data) {
	            		return data.tipoAgrupacionCodigo == CONST.TIPOS_AGRUPACION['COMERCIAL_VENTA']
	            	},
	            	depends: 'tipoAgrupacionCodigo'
	            },
	            {
	            	name: 'isRestringida',
	            	calculate: function(data) {
	            		return data.tipoAgrupacionCodigo == CONST.TIPOS_AGRUPACION['RESTRINGIDA'];
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
                    name: 'codigoCartera'
                },
                {
                	name: 'activoMatriz'
                },
                {
                    name: 'estadoActivoCodigo'
                },
                {
                    name:'tipoActivoCodigo'
                },
                {
                    name:'subtipoActivoCodigo'
                },
		    	{
		    		name: 'estadoVenta'
		    	},
		    	{
		    		name: 'estadoAlquiler'
		    	},
		    	{
		    		name: 'tipoComercializacionCodigo'
		    	},
		    	{
					name: 'tipoComercializacionDescripcion'
				},
			    {
	                name: 'incluyeDestinoComercialAlquiler',
	                calculate: function(data) {
	                    return data.tipoComercializacionCodigo ===  CONST.TIPOS_COMERCIALIZACION['SOLO_ALQUILER'] || data.tipoComercializacionCodigo ===  CONST.TIPOS_COMERCIALIZACION['ALQUILER_VENTA'];
	                },
	                depends: 'tipoComercializacionCodigo'
	            },
	            {
	                name: 'incluyeDestinoComercialVenta',
	                calculate: function(data) {
	                    return data.tipoComercializacionCodigo ===  CONST.TIPOS_COMERCIALIZACION['VENTA'] || data.tipoComercializacionCodigo ===  CONST.TIPOS_COMERCIALIZACION['ALQUILER_VENTA'];
	                },
	                depends: 'tipoComercializacionCodigo'
	            },
	            {
	                name: 'incluyeDestinoComercialAlquilerYIsRestringida',
	                calculate: function(data) {
	                    return data.isRestringida && data.tipoComercializacionCodigo ===  CONST.TIPOS_COMERCIALIZACION['SOLO_ALQUILER'] || data.isRestringida && data.tipoComercializacionCodigo ===  CONST.TIPOS_COMERCIALIZACION['ALQUILER_VENTA'];
	                },
	                depends: ['tipoComercializacionCodigo', 'isRestringida']
	            },
	            {
	                name: 'incluyeDestinoComercialVentaYIsRestringida',
	                calculate: function(data) {
	                    return data.isRestringida && data.tipoComercializacionCodigo ===  CONST.TIPOS_COMERCIALIZACION['VENTA'] || data.isRestringida && data.tipoComercializacionCodigo ===  CONST.TIPOS_COMERCIALIZACION['ALQUILER_VENTA'];
	                },
	                depends: ['tipoComercializacionCodigo', 'isRestringida']
	            },
	            {
	            	name: 'incluidoEnPerimetro',
	            	type: 'boolean'
	            },
	            {
	            	name: 'estadoAlquilerDescripcion'
	            },
	            {
	            	name: 'estadoVentaDescripcion'
	            },
	            {
	            	name: 'estadoAlquilerCodigo'
	            },
	            {
	            	name: 'estadoVentaCodigo'
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
		timeout: 60000,
		api: {
            read: 'agrupacion/getAgrupacionById',
            create: 'agrupacion/saveAgrupacion',
            update: 'agrupacion/saveAgrupacion',
            destroy: 'agrupacion/getAgrupacionById'
        },
		extraParams: {pestana: '1'}
    }    

});