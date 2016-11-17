/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Posicionamiento', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'idPosicionamiento'
    		},
    		{
    			name:'fechaAviso',
    			type : 'date',
				dateFormat: 'c'
    		},
    		{
    			name:'horaAviso',
    			type : 'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'idProveedorNotario'
    		},
    		{
    			name: 'fechaPosicionamiento',
    			type : 'date',
				dateFormat: 'c'
    		},
    		{
    			name:'horaPosicionamiento',
    			type : 'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'motivoAplazamiento'
    		}

    		
    ],
    
	proxy: {
		type: 'uxproxy',
		writeAll: true,
		localUrl: 'posicionamiento.json',
		api: {
			create: 'expedientecomercial/createPosicionamiento',
            update: 'expedientecomercial/savePosicionamiento',
            destroy: 'expedientecomercial/deletePosicionamiento'
        }
    }

});