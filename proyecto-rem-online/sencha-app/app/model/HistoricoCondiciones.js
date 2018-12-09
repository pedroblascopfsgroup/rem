/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.HistoricoCondiciones', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    //alias: 'viewmodel.HistoricoCondiciones',

    fields: [    
    		{
    			name:'id'
    		},
    		{
    			name:'condicionante'
    		},
    		{
    			name:'fecha',
    			type : 'date',
            	dateFormat: 'c'
    		},
    		{
    			name:'incrementoRenta'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'HistoricoCondiciones.json',
		api: {
			create: 'expedientecomercial/createHistoricoCondiciones'
        }
    }

});