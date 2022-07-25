Ext.define('HreRem.model.ConductasInapropiadasModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'id'
    		},
			{
				name: 'idProveedor'
    		},
    		{
    			name:'fechaAlta',
    			convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}
    		},
    		{
    			name:'usuarioAlta'
    		},
    		{
    			name:'tipoConducta'
    		},
    		{
    			name:'categoriaConducta'
    		},
    		{
    			name:'nivelConducta'
    		},
    		{
    			name:'comentarios'
    		},
    		{
    			name:'delegacion'
    		},
    		{
    			name:'adjunto'
    		},
    		{
    			name:'idadjunto'
    		},
    		{
    			name:'tamanyoAdjunto'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            create: 'proveedores/saveConductasInapropiadas',
			update: 'proveedores/saveConductasInapropiadas',
            destroy: 'proveedores/deleteConductasInapropiadas'
        }

    }

});