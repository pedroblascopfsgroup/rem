Ext.define('HreRem.model.ActivoJuntaPropietarios', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    
    fields: [ 
    	{
    		name: 'activo'
    	},
    	
    	{
    		name: 'numActivo'
    	},
    	
    	{
    		name: 'codProveedor'
    	},
    	
    	{
    		name: 'proveedor'
    	},
    	
    	{
			name : 'fechaJunta',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'fechaDesde',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'fechaHasta',
			type : 'date',
			dateFormat: 'c'
		},
		
		{
    		name: 'comunidad'
    	},
    	
    	{
    		name: 'cartera'
    	},
    	
    	{
    		name: 'localizacion'
    	},
    	
    	{
    		name: 'porcentaje'
    	},
    	
    	{
    		name: 'promoMayor50'
    	},
    	
    	{
    		name: 'promo20a50'
    	},
    	
    	{
    		name: 'junta'
    	},
    	
    	{
    		name: 'judicial'
    	},
    	
    	{
    		name: 'derrama'
    	},
    	
    	{
			name : 'estatutos'
		},
		
		{
			name : 'ite'
		},
		
		{
			name : 'morosos'
		},
		
		{
			name : 'cuota'
		},
		
		{
			name : 'otros'
		},
		
		{
			name : 'importe'
		},
		
		{
			name : 'ordinaria'
		},
		
		{
			name : 'extra'
		},
		
		{
			name : 'suministros'
		},
		
		{
			name : 'propuesta'
		},
		
		{
			name : 'voto'
		},
		
		{
			name : 'indicaciones'
		}		
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activojuntapropietarios.json',
		timeout: 60000,
		api: {
            read: 'activojuntapropietarios/getListJuntas'           
        }
    }

});