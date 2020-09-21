/**
 * Esta view es usada para ver la lista de deudores.
 */
Ext.define('HreRem.model.ActivoDeudorAcreditador', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

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
		remoteUrl: 'activo/getListDeudoresById',
		api: {
            read: 'activo/getListDeudoresById',
            create: 'activo/saveActivoPropietarioTab',
            update: 'activo/updateActivoPropietarioTab',
            destroy: 'activo/getListDeudoresById'

        }
    }
    
    

});