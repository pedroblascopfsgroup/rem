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
			name: 'precioWeb'
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
		}
	],

	proxy: {
		type: 'uxproxy',
		//writeAll: true,
		api: {
			create: 'activo/setDatosPublicacionActivo',
			read: 'activo/getDatosPublicacionActivo',
			update: 'activo/setDatosPublicacionActivo'
		}
	}
});
