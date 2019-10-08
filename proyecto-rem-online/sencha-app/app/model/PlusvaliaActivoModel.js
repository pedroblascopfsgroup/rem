/**
 *  Modelo para el tab Plusvalia 
 */
Ext.define('HreRem.model.PlusvaliaActivoModel', {
    extend: 'HreRem.model.Base',
    //idProperty: 'id',

    fields: [
     		
    		{
    			name:'idPlusvalia'
    		},
    		{
    			name:'idActivo'
    		},
    		{
    			name:'dateRecepcionPlus',
    			type:'date',
    			dateFormat: 'c'
			},
			{
				name:'datePresentacionPlus',
    			type:'date',
    			dateFormat: 'c'
			},
			{
    			name:'datePresentacionRecu',
    			type:'date',
    			dateFormat: 'c'
			},
			{
				name:'dateRespuestaRecu',
    			type:'date',
    			dateFormat: 'c'
			},
			{
    			name: 'aperturaSeguimientoExp'
    		},
    		{
    			name: 'importePagado'
    		},
    		{
    			name: 'idGasto'
    		},
    		{
    			name: 'minusvalia'
    		},
    		{
    			name: 'numGastoHaya'
    		},
    		{
    			name: 'exento'
    		},
    		{
    			name: 'autoliquidacion'
    		},
    		{
    			name: 'observaciones'
    		},
    		{
    			name: 'estadoGestion'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveDatosPlusvalia',
            update: 'activo/saveDatosPlusvalia',
            destroy: 'activo/getTabActivo' 
        },
        extraParams: {tab: 'plusvalia'}
    }

});