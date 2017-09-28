Ext.define('HreRem.model.DatosPublicacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'totalDiasPublicado'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		extraParams:{
			tab: 'datospublicacion'
		},
		api: {
            read: 'activo/getDatosPublicacionByActivo'
        }
    }
});