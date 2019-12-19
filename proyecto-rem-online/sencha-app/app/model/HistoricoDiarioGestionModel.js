Ext.define('HreRem.model.HistoricoGestionGrid', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'estadoLocId'
    		},
    		{
    			name:'estadoLocDesc'
    		},
    		{
    			name:'subEstadoDesc'
    		},
    		{
    			name:'nombreGestorDesc'
    		},
    		{
    			name:'fechaCambioEstado'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getHistoricoDiarioGestion'
        }
    }
});