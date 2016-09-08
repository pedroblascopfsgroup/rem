/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.ComparecienteVendedor', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'idComparecienteVendedor'
    		},
    		{
    			name:'tipoCompareciente'
    		},
    		{
    			name: 'nombre'
    		},
    		{
    			name: 'direccion'
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
		localUrl: 'comparecienteVendedor.json',
		api: {
            
        }
    }

});