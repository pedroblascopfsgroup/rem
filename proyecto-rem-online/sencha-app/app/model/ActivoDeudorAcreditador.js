/**
 * Esta view es usada para ver la lista de deudores.
 */
Ext.define('HreRem.model.ActivoDeudorAcreditador', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
	requires: ['HreRem.model.Activo'],
    fields: [    

    		{
    			name:'id'
    		},
    		{
    			name:'idActivo'
    		},
    		{
    			name:'fechaAlta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'gestorAlta'
    		},
    		{
    			name:'nombre'
    		},
    		{
    			name:'apellido1'
    		},
    		{
    			name:'apellido2'
    		},
    		{
    			name:'tipoDocIdentificativoDesc'
    		},
    		{
    			name:'docIdentificativo'
    		}
    ],
    
    
	proxy: {
		type: 'uxproxy',	
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById',
		api: {        
            create: 'activo/createDeudorAcreditado',
            update: 'activo/updateDeudorAcreditado',
            destroy: 'activo/destroyDeudorById'

        }/*,
		extraParams: {idActivo: '{activo.id}'}*/
    }
    
    

});