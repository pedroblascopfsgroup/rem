/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.OrigenLead', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'id'
    		},
    		{
    			name:'origenCompradorLead'
    		},
    		{
    			name: 'proveedorPrescriptorLead'
    		},
    		{
    			name: 'proveedorRealizadorLead'
    		},
    		{
    			name: 'fechaAltaLead'
    		},
    		{
    			name: 'fechaAsignacionRealizadorLead'
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