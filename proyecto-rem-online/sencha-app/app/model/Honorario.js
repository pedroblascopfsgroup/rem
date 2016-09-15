/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Honorario', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'id'
    		},
    		{
    			name:'colaborador'
    		},
    		{
    			name: 'tipoProveedor'
    		},
    		{
    			name: 'proveedor'
    		},
    		{
    			name: 'domicilio'
    		},
    		{
    			name: 'tipoCalculo'
    		},
    		{
    			name: 'importeCalculo'
    		},
    		{
    			name: 'honorarios'
    		},
    		{
    			name: 'telefono'
    		},
    		{
    			name: 'email'
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