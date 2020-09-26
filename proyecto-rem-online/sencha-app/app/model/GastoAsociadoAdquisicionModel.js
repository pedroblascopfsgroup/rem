/**
 *  Modelo para el grid de cargas de gastos asociados 
 */
Ext.define('HreRem.model.GastoAsociadoAdquisicionModel', {
    extend: 'HreRem.model.Base',
	idProperty: 'id',
	
    fields: [    
   			{
   				name: 'activoId'
    		},
    		{
    			name: 'gastoAsociado'			
    		},
    		{
    			name:'usuarioGestordeAlta'
    		},
    		{
    			name:'fechaAltaGastoAsociado',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaSolicitudGastoAsociado',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaPagoGastoAsociado',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'importe'
    		},
    		{
    			name: 'factura'
    		},
    		{
    			name:'observaciones'
    		},
    		{
  				name: 'itp'	
    		},
    		{
  				name: 'plusvaliaAdquisicion'	
    		},
    		{
  				name: 'notaria'	
    		},
    		{
  				name: 'registro'	
    		},
    		{
  				name: 'otrosGastos'	
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',

		api: {
            create: 'activo/saveGastoAsociadoAdquisicion',
            update: 'activo/updateGastoAsociadoAdquisicion',
            destroy: 'activo/deleteGastoAsociadoAdquisicion'
        }
    }
    
    

});