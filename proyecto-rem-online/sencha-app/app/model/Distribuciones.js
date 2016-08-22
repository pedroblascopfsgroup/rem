/**
 *  Modelo para el grid de distribuciones de Información comercial
 */
Ext.define('HreRem.model.Distribuciones', {
    extend: 'HreRem.model.Base',
    idProperty: 'idDistribucion',

    fields: [    
     		{
    			name:'numActivo'
    		},
    		{
    			name:'numActivoRem'
    		},
    		{
    			name:'numPlanta'
    		},
    		{
    			name:'cantidad'
    		},
    		{
    			name:'superficie'
    		},
    		{
    			name:'tipoHabitaculoCodigo'
    		},
    		{
    			name:'tipoHabitaculo'
    		}
    		
    ],
    
    proxy: {
		type: 'uxproxy',

		api: {
            create: 'activo/createDistribucion',
            update: 'activo/saveDistribucion',
            destroy: 'activo/deleteDistribucion'
        }

    }  

});