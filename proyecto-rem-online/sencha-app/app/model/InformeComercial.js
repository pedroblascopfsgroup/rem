Ext.define('HreRem.model.InformeComercial', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivo',

    fields: [
    		{
    			name:'fecha'
    		},
    		{
    			name:'estadoInfoComercial'
    		},
    		{
    			name:'motivo'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getEstadoInformeComercialByActivo'
        }

    }

});