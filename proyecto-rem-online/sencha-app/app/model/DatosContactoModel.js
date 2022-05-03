Ext.define('HreRem.model.DatosContactoModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
		    {
		    	name: 'id'
		    },
            {
            	name:'tipoLineaDeNegocioCodigo'
            },
            {
            	name:'tipoLineaDeNegocioDescripcion'
            },
            {
            	name:'gestionClientesCodigo'
            },
            {
            	name:'gestionClientesDescripcion'
            },
            {
            	name:'numeroComerciales'
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
            	name:'idiomaCodigo',
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
            	name:'municipioCodigo',
		    	convert: function(value) {
		    		if(Ext.isEmpty(value)){
		    			return 'VALOR_POR_DEFECTO';
		    		} else {
		    			return value;
		    		}
		    	}
            },
            {
            	name:'codigoPostalCodigo',
		    	convert: function(value) {
		    		if(Ext.isEmpty(value)){
		    			return 'VALOR_POR_DEFECTO';
		    		} else {
		    			return value;
		    		}
		    	}
            }
            
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getDatosContactoById',
            update: 'proveedores/saveDatosContactoById'
        }
    }    
});