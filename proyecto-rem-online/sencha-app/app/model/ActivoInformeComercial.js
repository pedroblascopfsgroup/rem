/**
 *  Modelo para el tab Publicacion > Informacion comercial de Activos 
 */
Ext.define('HreRem.model.ActivoInformeComercial', {
    extend: 'HreRem.model.ActivoInformacionComercial',
    idProperty: 'id',

    fields: [
        
     		/*{
    			name:'autorizacionWeb'
    		},
     		{
    			name:'fechaAutorizacionHasta'
    		},
     		{
    			name:'recepcionLlavesApi',
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
    			name:'autorizacionWebEspejo'
    		},
     		{
    			name:'recepcionLlavesEspejo',
    			convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}
    		}*/
    ],
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveActivoInformeComercial',
            update: 'activo/saveActivoInformeComercial'
        },
        extraParams: {tab: 'informecomercial'}
    }
    
    

});