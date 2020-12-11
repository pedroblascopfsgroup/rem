Ext.define('HreRem.model.ActivoEvolucion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    	//EvolucionGrid
    	{
			name:'estadoEvolucion'
		},
		{
			name:'subestadoEvolucion'
		},
		{
			name:'fechaEvolucion',
			type:'date',
			dateFormat: 'c'
		},{
			name:'observacionesEvolucion'
		},{
			name:'gestorEvolucion'
		}
		
    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getTabActivo',

		api: {
            //read: 'activo/getTabActivo',
            //create: 'activo/saveActivoDatosRegistrales',
            //update: 'activo/saveActivoDatosRegistrales',
            //destroy: 'activo/getTabActivo'
        },
        extraParams: {tab: 'evolucion'}
    }

});