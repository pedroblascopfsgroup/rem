/**
 * This view is used to present the details of a single Proveedor item.
 */
Ext.define('HreRem.model.BloqueoApis', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    	{
    		name:'idBloqueo'
    	},
    	{
    		name:'carteraCodigo',
    		convert: function(value) {
	    		if(Ext.isEmpty(value)){
	    			return 'VALOR_POR_DEFECTO';
	    		} else {
	    			return value;
	    		}
	    	}
    	},
    	{
    		name:'lineaNegocioCodigo',
    		convert: function(value) {
	    		if(Ext.isEmpty(value)){
	    			return 'VALOR_POR_DEFECTO';
	    		} else {
	    			return value;
	    		}
	    	}
    	},
    	{
    		name:'especialidadCodigo',
    		convert: function(value) {
	    		if(Ext.isEmpty(value)){
	    			return 'VALOR_POR_DEFECTO';
	    		} else {
	    			return value;
	    		}
	    	}
    	},
    	{
    		name:'provinciaCodigo',
    		convert: function(value) {
	    		if(Ext.isEmpty(value)){
	    			return 'VALOR_POR_DEFECTO';
	    		} else {
	    			return value;
	    		}
	    	}
    	},
    	{
    		name:'motivo'
    	},
    	{
    		name:'id'
    	},
    	{
    	    name:'motivoAnterior'
    	}
		    
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getBloqueoByProveedorId',
            update: 'proveedores/saveBloqueoProveedorById'
        }
    }    
});