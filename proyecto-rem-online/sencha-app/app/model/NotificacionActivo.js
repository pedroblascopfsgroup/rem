Ext.define('HreRem.model.NotificacionActivo', {
    extend: 'HreRem.model.Base',

    fields: [
    	{
    		name : 'fechaNotificacion',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'motivoNotificacion'
    	},
    	{
    		name : 'fechaSancionNotificacion',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'cierreNotificacion',
    		type : 'date',
    		dateFormat: 'c'
    	}
    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById'
        
    }    

});