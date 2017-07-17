/**
 *  Modelo para el tab Administración de Activos 
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