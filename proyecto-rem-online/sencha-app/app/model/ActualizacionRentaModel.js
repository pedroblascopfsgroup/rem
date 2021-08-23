Ext.define('HreRem.model.ActualizacionRentaModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'id'
    		},
    		{
    			name:'fechaAplicacion',
    			type:'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'tipoActualizacionCodigo'
    		},
    		{
    			name:'incrementoRenta'
    		}
    ],
	proxy: {
		type: 'uxproxy',
		localUrl: 'adjuntos.json',
		remoteUrl: 'expedientecomercial/getActualizacionRenta',
		api: {
            read: 'expedientecomercial/getActualizacionRenta'
        }
    }
});