/**
 *  Modelo para el grid de tarifas asignadas al trabajo
 */
Ext.define('HreRem.model.ProvisionSuplido', {
    extend: 'HreRem.model.Base',
    idProperty: 'idProvisionSuplido',

    fields: [    
            {
            	name:'idTrabajo'
            },
            {
            	name: 'tipoCodigo'
            },
            {
            	name: 'tipoDescripcion'
            },
            {
            	name:'importe'
            },
            {
            	name:'fecha',
            		convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}    
            },
            {
            	name:'concepto'
            }

    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'trabajo/getProvisionSuplido',

		api: {
            read: 'trabajo/getProvisionSuplido',
            create: 'trabajo/createProvisionSuplido',
            update: 'trabajo/saveProvisionSuplido',
            destroy: 'trabajo/deleteProvisionSuplido'
        }

    }    

});