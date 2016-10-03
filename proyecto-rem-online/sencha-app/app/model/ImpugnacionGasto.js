/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.ImpugnacionGasto', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    	
    	{
   			name: 'fechaTope',
   			type:'date',
    		dateFormat: 'c'
   		},
   		{
   			name: 'fechaPresentacion',
   			type:'date',
    		dateFormat: 'c'
   		},
   		{
   			name: 'fechaResolucion',
   			type:'date',
    		dateFormat: 'c'
   		}, 
   		{
   			name: 'resultado'
   		},
    	{
    		name: 'observaciones'
   		}
   		
   		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'gestiongasto.json',
		api: {
            read: 'gastosproveedor/getTabGasto',
            update: 'gastosproveedor/updateImpugnacionGasto'
        },
		
        extraParams: {tab: 'impugnacion'}
    }

});