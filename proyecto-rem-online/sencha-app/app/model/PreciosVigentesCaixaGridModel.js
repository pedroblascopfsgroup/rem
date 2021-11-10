Ext.define('HreRem.model.PreciosVigentesCaixaGridModel', {
	extend: 'HreRem.model.Base',
	idProperty: 'id',

	fields: [
		
		{
			name:'idActivo'
		},
		{
			name:'idPrecioVigente'
		},
		{
			name:'descripcionTipoPrecio'
		},
		{
			name:'codigoTipoPrecio'
		},
		{
			name:'importe'
		},
		{
			name:'fechaAprobacion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'fechaCarga',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'fechaInicio',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'fechaFin',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'gestor'
		},
		{
			name:'observaciones'
		}
	],

	proxy: {
		type: 'uxproxy',
		api: {
			
		}
	}
});
