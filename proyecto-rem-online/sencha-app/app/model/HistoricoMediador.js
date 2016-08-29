Ext.define('HreRem.model.HistoricoMediador', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivo',

    fields: [
    		{
    			name:'fechaDesde'
    		},
    		{
    			name:'fechaHasta'
    		},
    		{
    			name:'codigo'
    		},
    		{
    			name:'mediador'
    		},
    		{
    			name:'telefono'
    		},
    		{
    			name:'email'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getHistoricoMediadorByActivo'
        }

    }

});