Ext.define('HreRem.model.ActivoBbvaUicGridModel', {
	extend: 'HreRem.model.Base',
	idProperty: 'id',
	requires: ['HreRem.model.Activo'],
	
	fields: [
		{
			name: 'uicBbva'
		},{
			name: 'idActivo'
		},{
			name: 'id'
		},
		{
			name: 'activoEpa',
			type: 'boolean'
		},
		{
			name: 'cexperBbva'
		},
		{
			name: 'empresa'
		},
		{
			name: 'oficina'
		},
		{
			name: 'contrapartida'
		},
		{
			name: 'folio'
		},
		{
			name: 'cdpen'
		}
	],

	proxy: {
		type: 'uxproxy',	
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoBbvaUic',
		api: {        
	        create: 'activo/createActivoBbvaUic',
	        update: 'activo/createActivoBbvaUic',
	        destroy: 'activo/destroyDeudorById'
	
	    }
	}
});

