/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.VisitasActivo', {
    extend: 'HreRem.model.Base',

    fields: [
    	
    	{
    		name : 'idVisita'
    	},
    	{
    		name : 'fechaSolicitud',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'nombre'
    	},
    	{
    		name : 'numDocumento'
    	},
    	{
    		name : 'fechaVisita',
    		type : 'date',
    		dateFormat: 'c'
    	},  
    	{
    		name : 'estadoVisitaDescripcion'
    	},
    	{
    		name : 'subEstadoVisitaDescripcion'
    	}

    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById'
        
    }    

});