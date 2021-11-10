Ext.define('HreRem.model.DescuentoColectivosGridModel', {
	extend: 'HreRem.model.Base',

	fields: [
		
		{
			name: 'id' //Id activos descuento colectivos
		},
		{
			name: 'activoId'
		},
		{
			name: 'numActivo'
		},
		{
			name: 'descuentosCod'
		},
		{			
			name: 'descuentosDesc'
		},
		{
			name: 'preciosCod'
		},
		{
			name: 'preciosDesc'
		}
	],

	proxy: {
		type: 'uxproxy',
		api: {
			
		}
	}
});
