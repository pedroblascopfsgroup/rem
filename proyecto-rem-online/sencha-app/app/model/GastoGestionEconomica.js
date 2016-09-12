/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.GastoGestionEconomica', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'id'
    		},
    		{
    			name:'accion'
    		},
    		{
    			name: 'codigo'
    		},
    		{
    			name: 'nombre'
    		},
    		{
    			name: 'tipoCalculo'
    		},
    		{
    			name: 'importeCalculo'
    		},
    		{
    			name: 'importeFinal'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		writeAll: true,
		localUrl: 'gastoGestionEconomica.json',
		api: {
            
        }
    }

});