Ext.define('HreRem.model.Llaves', {
    extend: 'HreRem.model.Base',
    idProperty: 'idLlave',

    fields: [    
  
     		{
    			name:'idMovimiento'
    		},
     		{
    			name:'idLlave'
    		},
    		{
    			name:'idActivo'
    		},
    		{
    			name:'nomCentroLlave'
    		},
    		{
    			name:'archivo1'
    		},
    		{
    			name:'archivo2'
    		},
    		{
    			name:'archivo3'
    		},
    		{
    			name:'juegoCompleto'
    		},
    		{
    			name:'motivoIncompleto'
    		},
    		{
    			name:'codigoTipoTenedor'
    		},
    		{
    			name:'descripcionTipoTenedor'
    		},
    		{
    			name:'codTenedor'
    		},
    		{
    			name:'nomTenedor'
    		},
    		{
    			name:'fechaEntrega',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaDevolucion',
    			type:'date',
    			dateFormat: 'c'
    		}
    ],
    
    proxy: {
		type: 'uxproxy',
		writeAll: true,
		api: {
			read: 'activo/getListLlavesById',
            create: 'activo/createLlave',
            update: 'activo/saveLlave',
            destroy: 'activo/deleteLlave'
        }
    }  
});