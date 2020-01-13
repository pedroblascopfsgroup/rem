Ext.define('HreRem.model.HistoricoFasesDePublicacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'fasePublicacion'
    		},
    		{
    			name:'subfasePublicacion'
    		},
    		{
    			name:'usuario'
    		},
    		{
    			name:'fechaInicio',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaFin',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'comentario'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getHistoricoFasesDePublicacionActivo'
        }
    }
});