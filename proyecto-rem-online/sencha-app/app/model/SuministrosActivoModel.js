/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.SuministrosActivoModel', {
	extend: 'HreRem.model.Base',

	fields: [
		{
			name : 'idSuministro'
		},
		{
			name : 'idActivo'
		},
		{
			name : 'tipoSuministro'
		},
		{
			name : 'subtipoSuministro'
		},
		{
			name : 'companiaSuministro'
		},
		{
			name : 'domiciliado'
		},
		{
			name : 'numContrato'
		},
		{
			name : 'numCups'
		},
		{
			name : 'periodicidad'
		},
		{
			name: 'fechaAlta',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'motivoAlta'
		},
		{
			name: 'fechaBaja',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name: 'motivoBaja'
		},
		{
			name: 'validado'
		}

	],

	proxy: {
		type: 'uxproxy',
		
		api: {
			read: 'activo/getSuministrosActivo',
			create: 'activo/createSuministroActivo',
			update: 'activo/updateSuministroActivo',
			destroy: 'activo/updateSuministroActivo'
		},
		extraParams: {tab: 'suministros'}
	
	}

});