/**
 *  Modelo para el tab Seguros renta 
 */
Ext.define('HreRem.model.HstcoSeguroRentas', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
    	
    		{
    			name:'id'
    		},
    		{
    			name:'idSeguro'
    		},
    		{
    			name: 'fechaSancion',
        		type : 'date',
        		dateFormat: 'c'
    		},
    		{
    			name: 'estado'
    		},
    		{
    			name: 'solicitud'
    		},
    		{
    			name: 'docSco'
    		},
    		{
    			name: 'mesesFianza'
    		},
    		{
    			name: 'importeFianza'
    		},
    		{
    			name: 'version'
    		},
    		{
    			name: 'usuarioCrear'
    		},
    		{
    			name: 'fechaCrear'
    		},
    		{
    			name: 'usuarioModificar'
    		},
    		{
    			name: 'fechaModificar'
    		},
    		{
    			name: 'usuarioBorrar'
    		},
    		{
    			name: 'fechaBorrar'
    		},
    		{
    			name: 'borrado'
    		},
    		{
    			name: 'proveedor'
    		}
    ]
    
/*	proxy: {
		type: 'uxproxy',
		writeAll: true,
		localUrl: 'gastoGestionEconomica.json',
		api: {
			create: 'expedientecomercial/createHonorario',
            update: 'expedientecomercial/saveHonorario',
            destroy: 'expedientecomercial/deleteHonorario'
        }
    }*/

});