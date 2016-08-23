Ext.define('HreRem.model.DatosPublicacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'totalDiasPublicado'
    		},
    		{
    			name:'portalesExternos'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getDatosPublicacionByActivo'
        }

    }

});