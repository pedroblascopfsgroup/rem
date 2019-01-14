Ext.define('HreRem.model.OcupacionIlegal', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
     		{
    			name:'id'
    		},
    		{
    			name:'numAsunto'
    		},
    		{
    			name:'fechaInicioAsunto',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaFinAsunto',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaLanzamiento',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'tipoAsunto'
    		},
    		{
    			name:'tipoActuacion'
    		}
    ],
    
    proxy: {
		type: 'uxproxy',
		writeAll: true,
		api: {
			read: 'activo/getListHistoricoOcupacionesIlegales'
//			read: 'activo/getListMovimientosByLlave',
//            create: 'activo/createMovimientoLlave',
//            update: 'activo/saveMovimientoLlave',
//            destroy: 'activo/deleteMovimientoLlave'
        }
    }  
});