Ext.define('HreRem.model.ReqFaseVentaModel', {
    extend: 'HreRem.model.Base',
    requires: ['HreRem.model.Activo'],
    idProperty: 'id',

    fields: [
    		{
    			name:'idReq'
    		},
    		{
    			name:'idActivo'
    		},
    		{
    			name:'fechapreciomaximo',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'fecharespuestaorg',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'preciomaximo'
    		},
    		{
    			name:'fechavencimiento',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'usuariocrear'
    		},
    		{
    			name:'fechacrear',
               	type: 'date',
        		dateFormat: 'c'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		localUrl: 'reqfaseventa.json',
		api: {
            create: 'activo/createReqFaseVenta',
            destroy: 'activo/deleteReqFaseVenta'
        }
    }
});