/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Notario', {
    extend: 'HreRem.model.Base',
    idProperty: 'idContacto',

    fields: [    
  
    		{
    			name:'id'
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
    			name: 'telefono1'
    		},
    		{
    			name: 'telefono2'
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
    			name: 'localidad'
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