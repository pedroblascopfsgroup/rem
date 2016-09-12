Ext.define('HreRem.model.PropuestaActivosVinculados', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
			{
				name: 'id'
			},
			{
				name:'activoOrigenID'
			},
    		{
    			name:'activoVinculadoNumero'
    		},
    		{
    			name: 'activoVinculadoID'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getPropuestaActivosVinculadosByActivo',
            create: 'activo/createPropuestaActivosVinculadosByActivo',
            destroy: 'activo/deletePropuestaActivosVinculadosByActivo'
        }
    }

});