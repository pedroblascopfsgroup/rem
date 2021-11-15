Ext.define('HreRem.model.SancionesModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    
    		{
    			name:'comite'
    		},
    		{
    			name:'fechaRespuestaBC',
    			type:'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'respuestaBC'
    		},
    		{
    			name:'observacionesBC'
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