/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Visitas', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    	{
    		name: 'tipoEntidad'
    	},
    	{
    		name: 'numActivo'
    	},
    	{
    		name: 'idActivo'
    		
    	},
		{
			name : 'idVisita'
		},
		{
           name:'numVisita'
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
			name : 'estadoVisita'
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
    			name:'observacionesVisita'
    	},
    	{
    		name:'fechaFinalizacion',
    		type : 'date',
		  	dateFormat: 'c'
    	},
    	{
    		name:'motivoFinalizacion'
    	},
    	{
           	name:'solicitante'
        },
        {
        	name:'nifSolicitante'
        },
    	{
    		name:'telefonoSolicitante'
    	},
    	{
    		name:'emailSolicitante'
    	},
    	{
    		name:'fechaContacto',
    		type : 'date',
		   	dateFormat: 'c'
    	},
    	{
    		name:'estadoVisitaCodigo'
    	},
    	{
    		name:'estadoVisitaDescripcion'
    	},
    	{
    		name:'subEstadoVisitaCodigo'
    	},
    	{
    		name:'subEstadoVisitaDescripcion'
    	},
    	{
    		name:'fechaConcertacion',
    		type : 'date',
		   	dateFormat: 'c'
    	}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'visitas/getVisitaDetalleById'
    }

});