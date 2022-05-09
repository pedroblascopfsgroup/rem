/**
 *  Modelo para el tab Administraci�n de Activos 
 */
Ext.define('HreRem.model.ActivoAdministracion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
     		{
    			name:'numActivo'
    		},
    		{
    			name:'numActivoRem'
    		},
    		{
    			name:'ibiExento',
    			type: 'boolean'
    		},
    		{
    			name:'isUnidadAlquilable',
    			type: 'boolean'
    		},
    		{
    			name: 'segmentacionCarteraCodigo;'
    		},
    		{
    			name: 'segmentacionCarteraDescripcion'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getTabActivo',
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveActivoAdministracion',
            update: 'activo/saveActivoAdministracion'
        },
        extraParams: {tab: 'administracion'}
    }
    
    

});