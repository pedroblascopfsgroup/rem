/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.FechaArrasModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
            {
                name: 'fechaAlta',
                type: 'date',
                dateFormat: 'c'
            },
        	{
                name: 'fechaEnvio',
                type:'date',
                dateFormat: 'c'
            },
    		{
                name: 'fechaPropuesta',
                type:'date',
                dateFormat: 'c'
            },
    		{
    			name: 'fechaBC',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'validacionBC'
    		},
    		{
    			name: 'validacionBCcodigo'
    		},
    		{
    		    name: 'fechaAviso',
    		    type: 'date',
    		    dateFormat: 'c'
    		},
    		{
    			name: 'comentariosBC'
    		},
            {
                name: 'observaciones'
            },
            {
            	name: 'motivoAnulacion'
            }
    ],
    
    proxy: {
		type: 'uxproxy',
		writeAll: true,
		localUrl: 'fechaarras.json',
		api: {
			create: 'expedientecomercial/saveFechaArras',
            update: 'expedientecomercial/updateFechaArras'
            //destroy: 'expedientecomercial/deleteFechaArras'
        }
    }

});