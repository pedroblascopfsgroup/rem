Ext.define('HreRem.model.Llaves', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
     		{
    			name:'id'
    		},
    		{
    			name:'numLlave'
    		},
    		{
    			name:'idActivo'
    		},
    		{
    			name:'codCentroLlave'
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
    		}
    ],
    
    proxy: {
		type: 'uxproxy',
		//writeAll: true,
		api: {
			read: 'activo/getListLlavesById',
            create: 'activo/createLlave',
            update: 'activo/saveLlave',
            destroy: 'activo/deleteLlave'
        }
    }  
});