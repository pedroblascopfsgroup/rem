Ext.define('HreRem.model.ActualizacionRentaModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'id'
    		},
    		{
    			name:'fechaActualizacion',
    			type:'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'tipoActualizacionCodigo'
    		},
    		{
    			name:'importeActualizacion'
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