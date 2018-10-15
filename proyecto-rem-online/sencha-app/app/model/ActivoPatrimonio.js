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
    			name:'tipoAlquilerCodigo'
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
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveDatosPatrimonio',
            update: 'activo/saveDatosPatrimonio',
            destroy: 'activo/getTabActivo'
        },
        extraParams: {tab: 'patrimonio'}
    }

});