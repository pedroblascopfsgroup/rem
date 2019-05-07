Ext.define('HreRem.model.DocumentoActivoGencat', {
    extend: 'HreRem.model.Base',

    fields: [
    	{
    		name : 'nombre'
    	},
    	{
    		name : 'fechaDocumento',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'gestor'
    	}
    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById',
			api: {
	            destroy: 'gencat/deleteAdjunto'
	        }
    } 

});