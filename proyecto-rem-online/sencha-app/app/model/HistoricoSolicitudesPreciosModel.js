Ext.define('HreRem.model.HistoricoSolicitudesPreciosModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
		    {
		    	name:'idPeticion'
		    },
    		{
    			name:'idActivo'
    		},
    		{
    			name:'tipoFecha'
    		},
    		{
    			name:'fechaSolicitud',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'fechaSancion',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'observaciones'
    		},
    		{
    			name:'usuarioModificar'
    		},
    		{
    			name:'esEditable',
    			type:'boolean'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		//localUrl: 'historicosolicitudesprecios.json',
		api: {
            create: 'activo/createHistoricoSolicitudPrecios',
            update: 'activo/updateHistoricoSolicitudPrecios'
        }
    }
});