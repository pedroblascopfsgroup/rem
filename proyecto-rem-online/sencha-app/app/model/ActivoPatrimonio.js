/**
 *  Modelo para el tab Patrimonio de Activos 
 */
Ext.define('HreRem.model.ActivoPatrimonio', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    

    fields: [    
     		
    		{
    			name:'chkPerimetroAlquiler'
    		},
    		
    		{
    			name:'codigoAdecuacion'
    		},
    		{
    			name:'descripcionAdecuacion'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		remoteUrl: 'activo/getTabActivo',
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveDatosPatrimonio',
            update: 'activo/saveDatosPatrimonio'
        },
        extraParams: {tab: 'patrimonio'}
    }

});