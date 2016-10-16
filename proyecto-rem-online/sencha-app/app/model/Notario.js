/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Notario', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'idActivoProveedorContacto'
    		},
    		{
    			name:'nombreProveedor'
    		},
    		{
    			name: 'direccion'
    		},
    		{
    			name: 'personaContacto'
    		},
    		{
    			name: 'cargo'
    		},
    		{
    			name: 'telefono'
    		},
    		{
    			name: 'email'
    		},
    		{
    			name: 'usuario'
    		},
    		{
    			name: 'provincia'
    		},
    		{
    			name: 'tipoDocIdentificativo'
    		},
    		{
    			name: 'docIdentificativo'
    		},
    		{
    			name: 'codigoPostal'
    		},
    		{
    			name: 'fax'
    		},
    		{
    			name: 'telefono2'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		writeAll: true,
		localUrl: 'notario.json',
		api: {
            
        }
    }

});