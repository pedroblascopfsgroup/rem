/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.VisitasAgrupacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
		{
			name : 'numVisita'
		},
		{
			name : 'fechaSolicitud',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'nombreCompleroCliente'
		},
		{
			name : 'documentoCliente'
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
		remoteUrl: 'activo/getActivoById'
    }

});