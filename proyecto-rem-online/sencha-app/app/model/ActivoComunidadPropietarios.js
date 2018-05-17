/**
 * This view is used to present the details of an Activo.
 */
Ext.define('HreRem.model.ActivoComunidadPropietarios', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
      
    		{
    			name:'fechaComunicacionComunidad',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'envioCartas'
    		},
    		{
    			name:'numCartas'
    		},
    		{
    			name:'contactoTel'
    		},
    		{
    			name:'visita'
    		},
    		{
    			name: 'burofax'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',

		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveActivoComunidadPropietarios',
            update: 'activo/saveActivoComunidadPropietarios'
        },
        
		extraParams: {tab: 'datosComunidad'}

    }

});