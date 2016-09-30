/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.GestionGasto', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    	{
    		name: 'necesariaAutorizacionPropietario'
   	 	},
   	 	{
   	 		name: 'motivoAutorizacionPropietario'
   	 	},
   	 	{
   	 		name: 'gestoria'
   	 	},
   	 	{
   	 		name: 'idProvision'
   	 	},
    	{
    		name: 'observaciones'
   		},
   		///////////////
   		{
   			name: 'fechaAltaRem',
   			type:'date',
    		dateFormat: 'c'
   		},
   		{
   			name: 'gestorAltaRem'
   		},
   		{
   			name: 'fechaYGestorAltaRem',
   			convert: function(value, record){
   				
   			}
   		},
   		//////////////////
   		{
   			name: 'comboEstadoAutorizacionHaya'
   		},
   		{
   			name: 'fechaAutorizacionHaya',
   			type:'date',
    		dateFormat: 'c'
   		},
   		{
   			name: 'gestorAutorizacionHaya'
   		},
    	{
    		name: 'fechaYGestorAutorizacionHaya',
    		convert: function(value, record){
   				
   			}
    	},
    	{
    		name: 'comboMotivoAutorizacionHaya'
    	},
    	////////////////
    	{
    		name: 'comboEstadoAutorizacionPropietario'
    	},
    	{
   			name: 'fechaAutorizacionPropietario',
   			type:'date',
    		dateFormat: 'c'
   		},
   		{
   			name: 'gestorAutorizacionPropietario'
   		},
    	{
    		name: 'fechaYGestorAutorizacionPropietario',
    		convert: function(value, record){
   				
   			}
    	},
		{
			name : 'comboMotivoAutorizacionPropietario'
		},
		///////////
		{
   			name: 'fechaAnulado',
   			type:'date',
    		dateFormat: 'c'
   		},
   		{
   			name: 'gestorAnulado'
   		},
		{
			name : 'fechaYGestorAnulado',
			convert: function(value, record){
   				
   			}
		},
		{
			name : 'comboMotivoAnulado'
		},
		/////////////
		{
   			name: 'fechaRetenerPago',
   			type:'date',
    		dateFormat: 'c'
   		},
   		{
   			name: 'gestorRetenerPago'
   		},
		{
			name : 'fechaYGestorRetenerPago',
			convert: function(value, record){
   				
   			}
		},
		{
			name: 'comboMotivoRetenerPago'
		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'gestiongasto.json',
		api: {
            read: 'gastosproveedor/getTabGestion',
            update: 'gastosproveedor/updateGestionGasto'
        },
		
        extraParams: {tab: 'gestion'}
    }

});