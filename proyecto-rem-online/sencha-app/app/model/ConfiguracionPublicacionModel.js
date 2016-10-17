Ext.define('HreRem.model.ConfiguracionPublicacionModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'idRegla',    
    

    fields: [    
  
    		{
    			name:'idRegla'
    		},
    		{
    			name: 'carteraCodigo'
    		},
    		{
    			name: 'incluidoAgrupacionAsistida'
    		},
    		{
    			name: 'tipoActivoCodigo'
    		},
    		{
    			name: 'subtipoActivoCodigo'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getReglasPublicacionAutomatica',
            create: 'activo/createReglaPublicacionAutomatica',
            destroy: 'activo/deleteReglaPublicacionAutomatica'
        }
    }
});