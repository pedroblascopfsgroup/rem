Ext.define('HreRem.model.ReclamacionActivo', {
    extend: 'HreRem.model.Base',

    fields: [
    	{
    		name : 'fechaAviso',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'fechaReclamacion',
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