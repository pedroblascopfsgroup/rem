Ext.define('HreRem.model.GastosRepercutidosModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'id'
    		},
    		{
    			name:'tipoGastoCodigo'
    		},
    		{
    			name:'importe'
    		},
    		{
    			name:'meses'
    		}
    ],
	proxy: {
		type: 'uxproxy',
		localUrl: 'adjuntos.json',
		remoteUrl: 'expedientecomercial/getGastosRepercutidosList',
		api: {
            read: 'expedientecomercial/getGastosRepercutidosList'
        }
    }
});