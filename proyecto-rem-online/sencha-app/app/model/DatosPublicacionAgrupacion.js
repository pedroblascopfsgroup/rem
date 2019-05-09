Ext.define('HreRem.model.DatosPublicacionAgrupacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

	fields: [
	 		{
	 			name: 'estadoPublicacionVenta'
	 		},
	 		{
	 			name: 'estadoPublicacionAlquiler'
	 		},
	 		{
	 			name: 'codigoEstadoPublicacionVenta'
	 		},
	 		{
	 			name: 'codigoEstadoPublicacionAlquiler'
	 		},
	 		{
	 			name: 'precioWebVenta'
	 		},
	 		{
	         	name: 'precioWebAlquiler'
	        },
	        {
	            name: 'adecuacionAlquilerCodigo'
	        },
	 		{
	 			name:'totalDiasPublicadoVenta',
	 			type: 'number'
	 		},
	 		{
	 			name:'totalDiasPublicadoAlquiler',
	 			type: 'number'
	 		},
	 		{
	 			name: 'publicarVenta',
	 			type: 'boolean'
	 		},
	 		{
	 			name:'ocultarVenta',
	 			type: 'boolean'
	 		},
	 		{
	 			name:'publicarSinPrecioVenta',
	 			type: 'boolean'
	 		},
	 		{
	 			name:'noMostrarPrecioVenta',
	 			type: 'boolean'
	 		},
	 		{
	 			name:'motivoOcultacionVentaCodigo'
	 		},
	 		{
	 			name:'motivoOcultacionManualVenta'
	 		},
	 		{
	 			name: 'publicarAlquiler',
	 			type: 'boolean'
	 		},
	 		{
	 			name:'ocultarAlquiler',
	 			type: 'boolean'
	 		},
	 		{
	 			name:'publicarSinPrecioAlquiler',
	 			type: 'boolean'
	 		},
	 		{
	 			name:'noMostrarPrecioAlquiler',
	 			type: 'boolean'
	 		},
	 		{
	 			name:'motivoOcultacionAlquilerCodigo'
	 		},
	 		{
	 			name:'motivoOcultacionManualAlquiler'
	 		},
	 		{
	            name:'deshabilitarCheckPublicarVenta',
	            type: 'boolean'
	        },
	        {
	            name:'deshabilitarCheckOcultarVenta',
	            type: 'boolean'
	        },
	        {
	            name:'deshabilitarCheckPublicarSinPrecioVenta',
	            type: 'boolean'
	        },
	        {
	            name:'deshabilitarCheckNoMostrarPrecioVenta',
	            type: 'boolean'
	        },
	        {
	            name:'deshabilitarCheckPublicarAlquiler',
	            type: 'boolean'
	        },
	        {
	            name:'deshabilitarCheckOcultarAlquiler',
	            type: 'boolean'
	        },
	        {
	            name:'deshabilitarCheckPublicarSinPrecioAlquiler',
	            type: 'boolean'
	        },
	        {
	            name:'deshabilitarCheckNoMostrarPrecioAlquiler',
	            type: 'boolean'
	        },
	        {
	            name:'fechaInicioEstadoVenta',
	            type:'date',
	            dateFormat: 'c'
	        },
	        {
	            name:'fechaInicioEstadoAlquiler',
	            type:'date',
	            dateFormat: 'c'
	        },
	        {
	            name:'tipoPublicacionVentaCodigo'
	        },
	        {
	            name:'tipoPublicacionAlquilerCodigo'
	        },
	        {
	 	        name:'tipoPublicacionVentaDescripcion'
	 	    },
	 	    {
	 	        name:'tipoPublicacionAlquilerDescripcion'
	 	    },
	 	    {
	 	        name:'eleccionUsuarioTipoPublicacionAlquiler'
	 	    },
	 	    // Condicionantes
	 	    {
    			name:'ruina',
    			type: 'boolean'
    		},
    		{
    			name:'pendienteInscripcion',
    			type: 'boolean'
    		},
    		{
    			name:'obraNuevaSinDeclarar',
    			type: 'boolean'
    		},
    		{
    			name:'sinTomaPosesionInicial',
    			type: 'boolean'
    		},
    		{
    			name:'proindiviso',
    			type: 'boolean'
    		},
    		{
    			name:'obraNuevaEnConstruccion',
    			type: 'boolean'
    		},
    		{
    			name:'ocupadoConTitulo',
    			type: 'boolean'
    		},
    		{
    			name:'tapiado',
    			type: 'boolean'
    		},
    		{
    			name:'otro'
    		},
    		{
    			name: 'portalesExternos',
    			type: 'boolean'
    		},
    		{
    			name: 'portalesExternosDescripcion',
				calculate: function(data){
					if(data.portalesExternos){
						return HreRem.i18n('fieldlabel.estado.portal.externo.publicado');
					} else {
						return HreRem.i18n('fieldlabel.estado.portal.externo.no.publicado');
					}
				},
				depends: 'portalesExternos'
    		},
    		{
    			name:'ocupadoSinTitulo',
    			type: 'boolean'
    		},
    		{
    			name:'divHorizontalNoInscrita',
    			type: 'boolean'
    		},
    		{
    			name: 'isCondicionado',
    			type: 'boolean'
    		},
    		// Referente a la cabecera de datos publicacion. Campo calculado con datos de este modelo.
    		{
    			name: 'estadoCondicionadoCodigo'
    		},
    		{
    			name: 'sinInformeAprobado',
    			type: 'boolean'
    		},
    		{
    			name: 'vandalizado',
    			type: 'boolean'
    		},
    		{
    			name: 'conCargas',
    			type: 'boolean'
    		},
    		{
            	name: 'claseActivoCodigo'
            },
            {
            	name: 'motivoPublicacion'
            }
	 	],
    
	proxy: {
		type: 'uxproxy',
		api: {
            create: 'agrupacion/setDatosPublicacionAgrupacion',
            read: 'agrupacion/getDatosPublicacionAgrupacion',
            update: 'agrupacion/setDatosPublicacionAgrupacion'            
        }
    }
});