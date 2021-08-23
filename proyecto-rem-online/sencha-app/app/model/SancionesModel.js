Ext.define('HreRem.model.SancionesModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'id'
    		},
    		{
    			name:'comite'
    		},
    		{
    			name:'fecha'
    		},
    		{
    			name:'observaciones'
    		}
    ],
	proxy: {
		type: 'uxproxy',
		localUrl: 'adjuntos.json',
		remoteUrl: 'expedientecomercial/getSancionesBk',
		api: {
            read: 'expedientecomercial/getSancionesBk'
        }
    }
});