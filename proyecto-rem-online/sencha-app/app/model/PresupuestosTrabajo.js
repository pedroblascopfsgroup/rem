/**
 *  Modelo para el grid de presupuestos asignados al trabajo
 */
Ext.define('HreRem.model.PresupuestosTrabajo', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
            {
            	name:'id'
            },
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
            	name:'idProveedor'
            },
            {
            	name:'proveedorDescripcion'
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
    			name:'importeCliente'
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
    			name:'repartirProporcional'
    		},
    		{
    			name:'comentarios'
    		},
    		{
    			name:'refPresupuestoProveedor'
    		},
    		{
    			name: 'idProveedorContacto'
    		},
    		{
    			name: 'codigoTipoProveedor'
    		},
    		{
    			name: 'nombreProveedorContacto'
    		},
    		{
    			name: 'emailProveedorContacto'
    		},
    		{
    			name: 'usuarioProveedorContacto',
    			convert: function(value){
    				if(Ext.isEmpty(value)){
    					return '---';
    				}else{
    					return value;
    				}
    			}
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'trabajo/getTrabajoById',

		api: {
            read: 'trabajo/getPresupuestosTrabajo',
            create: 'trabajo/createPresupuestoTrabajo',
            update: 'trabajo/savePresupuestoTrabajo',
            destroy: 'trabajo/deletePresupuestoTrabajo'
        }

    }    

});