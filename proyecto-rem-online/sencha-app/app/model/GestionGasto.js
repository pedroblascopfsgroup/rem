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
   	 		name: 'comboMotivoAutorizacionPropietario'
   	 	},
   	 	{
   	 		name: 'gestoria'
   	 	},
   	 	{
   	 		name: 'numProvision'
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
   			calculate: function(record){
   				var res='';
   				if(!Ext.isEmpty(record.fechaAltaRem)){
   					var date= new Date(record.fechaAltaRem);
   					res= res + date.getDate() + "/"+ (date.getMonth()+1) + "/" + date.getFullYear();
   				}
   				if(!Ext.isEmpty(record.gestorAltaRem)){
   					res= res + " - " + record.gestorAltaRem;
   				}
   				return res;
   			}
   			,depends: ['gestorAltaRem', 'fechaAltaRem']
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
    		calculate: function(record){
   				var res='';
   				if(CONST.ESTADOS_AUTORIZACION_HAYA['PENDIENTE'] != record.comboEstadoAutorizacionHaya){
	   				if(!Ext.isEmpty(record.fechaAutorizacionHaya)){
	   					var date= new Date(record.fechaAutorizacionHaya);
	   					res= res + date.getDate() + "/"+ (date.getMonth()+1) + "/" + date.getFullYear();
	   				}
	   				if(!Ext.isEmpty(record.gestorAutorizacionHaya)){
	   					res= res + " - " + record.gestorAutorizacionHaya;
	   				}
   				}
   				return res;
   			}
   			,depends: ['gestorAutorizacionHaya', 'fechaAutorizacionHaya']
    	},
    	{
    		name: 'comboMotivoAutorizadoHaya'
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
    		calculate: function(record){
   				var res='';
   				if(!Ext.isEmpty(record.fechaAutorizacionPropietario)){
   					var date= new Date(record.fechaAutorizacionPropietario);
   					res= res + date.getDate() + "/"+ (date.getMonth()+1) + "/" + date.getFullYear();
   				}
   				if(!Ext.isEmpty(record.gestorAutorizacionPropietario)){
   					res= res + " - " + record.gestorAutorizacionPropietario;
   				}
   				return res;
   			}
   			,depends: ['fechaAutorizacionPropietario', 'gestorAutorizacionPropietario']
    	},
		{
			name : 'motivoRechazoAutorizacionPropietario'
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
			calculate: function(record){
   				var res='';
   				if(!Ext.isEmpty(record.fechaAnulado)){
   					var date= new Date(record.fechaAnulado);
   					res= res + date.getDate() + "/"+ (date.getMonth()+1) + "/" + date.getFullYear();
   				}
   				if(!Ext.isEmpty(record.gestorAnulado)){
   					res= res + " - " + record.gestorAnulado;
   				}
   				return res;
   			}
   			,depends: ['fechaAnulado', 'gestorAnulado']
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
			calculate: function(record){
   				var res='';
   				if(!Ext.isEmpty(record.fechaRetenerPago)){
   					var date= new Date(record.fechaRetenerPago);
   					res= res + date.getDate() + "/"+ (date.getMonth()+1) + "/" + date.getFullYear();
   				}
   				if(!Ext.isEmpty(record.gestorRetenerPago)){
   					res= res + " - " + record.gestorRetenerPago;
   				}
   				return res;
   			}
   			,depends: ['fechaRetenerPago', 'gestorRetenerPago']
		},
		{
			name: 'comboMotivoRetenerPago'
		},
		{
			name : 'gestionGastoRepercutido',
			type : 'boolean'
		},
		{
   			name: 'fechaGestionGastoRepercusion',
   			type:'date',
    		dateFormat: 'c'
   		},
   		{
			name : 'motivoRechazoGestionGasto'
		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'gestiongasto.json',
		api: {
            read: 'gastosproveedor/getTabGasto',
            update: 'gastosproveedor/updateGestionGasto'
        },
		
        extraParams: {tab: 'gestion'}
    }

});