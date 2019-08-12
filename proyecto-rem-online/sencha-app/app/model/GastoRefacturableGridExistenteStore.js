/*
 * Lista de gastos refacturables de un activo.
 */
Ext.define('HreRem.model.GastoRefacturableGridExistenteStore', {
    extend: 'HreRem.model.Base',
    reference: 'GastoRefacturableGridStore',
    idProperty: 'numeroGastoHaya',    
    

    fields: [     
	    		{
	    			name:'numeroGastoHaya'
	    		}		        
	    	]
    

});
