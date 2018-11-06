Ext.define('HreRem.model.HistoricoMediadorModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

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
    		},
    		{
    			name:'responsableCambio'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getHistoricoMediadorByActivo',
            create: 'activo/createHistoricoMediador'
        }
    }
});