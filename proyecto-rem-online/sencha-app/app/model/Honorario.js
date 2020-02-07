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
    			name: 'codigoTipoCalculo'
    		},
    		{
    			name: 'importeCalculo'
    		},
    		{
    			name: 'honorarios',
    			critical: true
    		},
    		{
    			name: 'telefono'
    		},
    		{
    			name: 'email'
    		},
    		{
    			name: 'observaciones'
    		},
    		{
    			name: 'idProveedor'
    		},
    		{
    			name: 'codigoProveedorRem'
    		},
    		{
    			name: 'codigoTipoProveedor'
    		},
    		{
    			name: 'codigoTipoComision'
    		},
    		{
    			name: 'descripcionTipoComision'
    		},
    		{
    			name: 'storeHoronarios'
    		},
    		{
    			name: 'idActivo'
    		},
    		{
    			name: 'participacionActivo'
    		},
    		{
    			name: 'origenComprador'
    		},
    		{
    			name: 'importeOriginal'
    		}

    ],
    
	proxy: {
		type: 'uxproxy',
		writeAll: true,
		localUrl: 'gastoGestionEconomica.json',
		api: {
			create: 'expedientecomercial/createHonorario',
            update: 'expedientecomercial/saveHonorario',
            destroy: 'expedientecomercial/deleteHonorario'
        }
    }

});