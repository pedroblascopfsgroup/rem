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
		}
	],

	proxy: {
		type: 'uxproxy',	
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoBbvaUic',
		api: {        
	        create: 'activo/createActivoBbvaUic',
	        update: 'activo/updateDeudorAcreditado',
	        destroy: 'activo/destroyDeudorById'
	
	    }
	}
});

