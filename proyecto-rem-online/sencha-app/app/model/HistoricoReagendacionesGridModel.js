Ext.define('HreRem.model.HistoricoReagendacionesGridModel', {
	extend: 'HreRem.model.Base',
	idProperty: 'id',

	fields: [
		{
			name: 'fechaReagendacionIngreso',
			type: 'date',
			dateFormat: 'c'
		},
		{
			name: 'fechaAgendacionIngreso',
			type: 'date',
			dateFormat: 'c'
		},
		{
			name: 'importe'
		},
		{
			name: 'ibanDevolucion'
		},
		{
			name: 'fechaIngreso',
			type: 'date',
			dateFormat: 'c'
		},
		{
			name: 'numeroOferta'
		},
		{
			name: 'cuentaVirtual'
		},
		{
			name: 'idExpedienteComercial'
		}
	],

	proxy: {
		type: 'uxproxy',
		localUrl: 'condicionesExpediente.json',
		remoteUrl: 'expedientecomercial/getHistoricoReagendaciones',
		api: {
			read: 'expedientecomercial/getHistoricoReagendaciones'
		}

	}
});
