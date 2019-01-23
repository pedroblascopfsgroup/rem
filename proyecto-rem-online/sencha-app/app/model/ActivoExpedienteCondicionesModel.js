Ext.define('HreRem.model.ActivoExpedienteCondicionesModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    		
		    {
		    	name: 'situacionPosesoriaCodigoInformada'
		    },
		    {
		    	name: 'posesionIniciaInformadal'
		    },
		    {
		    	name: 'estadoTituloInformada'
		    },
		    {
		    	name: 'situacionPosesoriaCodigoInformada'
		    },
		    {
		    	name: 'posesionInicial'
		    },
		    {
		    	name: 'estadoTitulo'
		    },
		    {
		    	name: 'eviccion'
		    },
		    {
		    	name: 'viciosOcultos'
		    },
		    {
		    	name: 'ecoId'
		    },
		    {
		    	name: 'activoId'
		    }
		    
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activoExpediente.json',
		api: {
            read: 'expedientecomercial/getActivoExpedienteCondiciones',
            update: 'expedientecomercial/saveActivoExpedienteCondiciones'
            //update: 'expedientecomercial/getExpedienteComercialPropagables'
        }
    }

});