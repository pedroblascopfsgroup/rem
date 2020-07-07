Ext.define('HreRem.model.SuministrosActivoModel', {
	extend: 'HreRem.model.Base',
	requires: ['HreRem.model.Activo'],
	idProperty: 'idSuministro',
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
			name : 'tipoSuministroDescripcion'
		},
		{
			name : 'subtipoSuministro'
		},
		{
			name : 'subtipoSuministroDescripcion'
		},
		{
			name : 'companiaSuministro'
		},
		{
			name : 'companiaSuministroNombre'
		},
		{
			name : 'companiaSuministroCodRem'
		},
		{
			name : 'domiciliado'
		},
		{
			name : 'domiciliadoDescripcion'
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
			name : 'periodicidadDescripcion'
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
			name : 'motivoAltaDescripcion'
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
			name: 'motivoBajaDescripcion'
		},
		{
			name: 'validado'
		},
		{
			name: 'validadoDescripcion'
		}
	],

	proxy: {
		type: 'uxproxy',
		
		api: {
			read: 'activo/getSuministrosActivo',
			create: 'activo/createSuministroActivo',
			update: 'activo/updateSuministroActivo',
			destroy: 'activo/deleteSuministroActivo'
		}
	}

});