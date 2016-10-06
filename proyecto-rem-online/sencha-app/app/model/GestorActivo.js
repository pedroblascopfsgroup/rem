/**
 * This view is used to present the details of a single Gestor.
 */
Ext.define('HreRem.model.GestorActivo', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',    

    fields: [
    		{
    			name:'descripcion'
    		},
    		{
    			name: 'apellidoNombre'
    		},
    		{
    			name:'fechaDesde',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaHasta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'telefono'
    		},
    		{
    			name:'email'
    		}
    ]    

});