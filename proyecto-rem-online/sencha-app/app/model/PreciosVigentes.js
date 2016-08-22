/**
 *  Modelo para el grid de precios vigentes
 */
Ext.define('HreRem.model.PreciosVigentes', {
    extend: 'HreRem.model.Base',
    fields: [    
  
     		{
    			name:'idActivo'
    		},
    		{
    			name:'idPrecioVigente'
    		},
    		{
    			name:'descripcionTipoPrecio'
    		},
    		{
    			name:'codigoTipoPrecio'
    		},
    		{
    			name:'importe'
    		},
    		{
    			name:'fechaAprobacion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaCarga',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaInicio',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaFin',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'gestor'
    		},
    		{
    			name:'observaciones'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		writeAll: true,
		api: {
            update: 'activo/savePrecioVigente',
            destroy: 'activo/deletePrecioVigente'
        }
    }  

});