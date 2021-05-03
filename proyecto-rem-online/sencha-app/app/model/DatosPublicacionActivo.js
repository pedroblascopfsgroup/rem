Ext.define('HreRem.model.DatosPublicacionActivo', {
	extend: 'HreRem.model.Base',
	idProperty: 'idActivo',

	fields: [
		{
			name: 'estadoPublicacionVenta'
		},
		{
			name: 'estadoPublicacionAlquiler'
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
            name: 'adecuacionAlquilerDescripcion'
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
			name:'totalDiasPublicadoHistoricoVenta',
			type: 'number'
		},
		{
			name:'totalDiasPublicadoHistoricoAlquiler',
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
			name:'motivoOcultacionVentaDescripcion'
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
			name:'motivoOcultacionAlquilerDescripcion'
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
	    {
	    	name:'motivoPublicacion'
	    },
	    {
	    	name:'motivoPublicacionAlquiler'
	    },
	    {
	    	name: 'estadoPublicacionAlquilerCodigo'
	    },
	    {
	    	name: 'isMatriz',
	    	type:'boolean'
		},
		{
	    	name:'diasCambioPublicacionVenta'
	    },
	    {
	    	name:'diasCambioPublicacionAlquiler'
	    },
        {
	    	name:'diasCambioPrecioVentaWeb'
	    },
	    {
	    	name:'diasCambioPrecioAlqWeb'
	    },
        {
            name:'fechaRevisionPublicacionesVenta',
            type:'date',
            dateFormat: 'c'
        },
        {
            name:'fechaRevisionPublicacionesAlquiler',
            type:'date',
            dateFormat: 'c'
        },
        {
        	name:'fechaUltimaPublicacionMin',
            type:'date',
            dateFormat: 'c'
        },
        {
        	name:'fechaPrimeraPublicacionMin',
            type:'date',
            dateFormat: 'c'
        },
        {
        	name:'fechaUltimaPublicacionMay',
            type:'date',
            dateFormat: 'c'
        },
        {
        	name:'fechaPrimeraPublicacionMay',
            type:'date',
            dateFormat: 'c'
        },
        {
        	name:'canalDePublicacion'
        },
        {
        	name:'canalDePublicacionDescripcion'
        }
        
	],

	proxy: {
		type: 'uxproxy',
		api: {
			create: 'activo/setDatosPublicacionActivo',
			read: 'activo/getDatosPublicacionActivo',
			update: 'activo/setDatosPublicacionActivo'
		},
		extraParams: {tab: 'datospublicacion'}
	}
});
