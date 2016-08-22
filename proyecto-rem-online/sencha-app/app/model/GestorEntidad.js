/**
 * This view is used to present the details of a single Gestor.
 */
Ext.define('HreRem.model.Gestor', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',    
    

    fields: [    
    		{
    			name:'idEntidad'
    		},
    		{
    			name: 'tipoEntidad'
    		},
    		{
    			name:'idTipoGestor'
    		},
    		{
    			name:'idUsuario'
    		},
    		{
    			name:'idTipoDespacho'
    		}
    ]

});