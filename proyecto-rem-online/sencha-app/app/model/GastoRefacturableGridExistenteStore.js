/*
 * Lista de gastos refacturables de un activo.
 */
Ext.define('HreRem.model.GastoRefacturableGridExistenteStore', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',    
    

    fields: [ 
        	{
    			name: 'isGastoRefacturableExistente'
    		},    
    		{
    			name:'numeroGastoRefacturableExistente'
    		}		        
    ] 
    

});