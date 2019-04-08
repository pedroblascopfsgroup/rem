Ext.define('HreRem.model.HistoricoComunicacionGencat', {
    extend: 'HreRem.model.Base',

    fields: [
    	{
			name:'id'
		},
    	{
    		name : 'fechaPreBloqueo',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'fechaComunicacion',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'fechaSancion',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
			name:'sancion'
		},
		{
			name:'estadoComunicacion'
		}
    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById'
    }    

});