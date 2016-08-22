/**
 *  Modelo para el fieldset del presupuesto seleccion en el tab de gestión económica
 */
Ext.define('HreRem.model.PresupuestoTrabajo', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
            {
            	name:'idTrabajo'
            },
            {
            	name:'tipoTrabajoDescripcion'
            },
            {
            	name:'subtipoTrabajoDescripcion'
            },
    		{
    			name:'estadoPresupuestoCodigo'
    		},
    		{
    			name:'estadoPresupuestoDescripcion'
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
    			name:'comentarios'
    		},
    		{
    			name:'refPresupuestoProveedor'
    		},
    		{
    			name:'nombreProveedor'
    		},
    		{
    			name:'usuarioProveedor'
    		},
    		{
    			name:'emailProveedor'
    		},
    		{
    			name:'telefonoProveedor'
    		},
    		{
    			name:'cuentaContable'
    		},
    		{
    			name:'partidaPresupuestaria'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'trabajo/getTrabajoById',

		api: {
            read: 'trabajo/getPresupuestoById'
        }

    }    

});