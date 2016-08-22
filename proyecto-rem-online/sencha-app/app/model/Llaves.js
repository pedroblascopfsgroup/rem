Ext.define('HreRem.model.Llaves', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivoLlave',

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
    			name:'fechaEntrega'
    		},
    		{
    			name:'fechaDevolucion'
    		}
    ],
    
    proxy: {
		type: 'uxproxy',
		
		api: {
            create: 'activo/createLlave',
            update: 'activo/saveLlave',
            destroy: 'activo/deleteLlave'
        }
        
    }  

});