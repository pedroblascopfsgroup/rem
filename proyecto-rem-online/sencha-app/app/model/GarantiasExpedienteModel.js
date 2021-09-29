Ext.define('HreRem.model.GarantiasExpedienteModel', {
    extend: 'HreRem.model.Base',

    fields: [
    
	    {
	    	name: 'idGarantias'
	    },
	    {
	    	name: 'scoring',
	    	type: 'boolean'
	    },
	    {
	    	name: 'resultadoHayaDesc'	    	
	    },
	    {
	    	name: 'resultadoHayaCod'	    	
	    },
		{
			name:'fechaSancion',
			type:'date',
    		dateFormat: 'c'
		},
		{
			name:'numeroExpediente'
		},
		{
			name:'resultadoPropiedadDesc'
		},
		{
			name:'resultadoPropiedadCod'
		},		
		{
			name:'motivoRechazo'
		},
		{
			name:'motivoRechazoCod'
		},		
		{
			name:'ratingHayaDesc'
		},
		{
			name:'ratingHayaCod'
		},
	    {
	    	name: 'aval',
	    	type: 'boolean'
	    },
		{
	    	name: 'avalista' //TODO ¿dicionario o tabla?
	    },
	    {
	    	name: 'documento'
	    },
	    {
	    	name: 'entidadBancariaCod'
	    },
	    {
	    	name: 'entidadBancariaDesc'
	    },
	    {
	    	name: 'mesesAval'
	    },
	    {
	    	name: 'importeAval'
	    },
		{
			name:'fechaVencimiento',
			type:'date',
    		dateFormat: 'c'
		},
	    {
	    	name: 'seguroRentas',
	    	type: 'boolean'
	    },
	    {
	    	name: 'aseguradoraCod'
	    },
	    {
	    	name: 'aseguradoraDesc'
	    },
		{
			name:'fechaSancionRentas',
			type:'date',
    		dateFormat: 'c'
		},
		{
			name:'mesesRentas'
		},
		{
			name:'importeRentas'
		},{
			name:'scoringEditable',
	    	type: 'boolean'
		}
	    	    
    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'garantiasExpediente.json',
		timeout: 60000,
		
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveGarantiasExpediente' //update: 'expedientecomercial/saveCondicionesExpediente'
        },
		
        extraParams: {tab: 'garantias'}
    }    

});
          