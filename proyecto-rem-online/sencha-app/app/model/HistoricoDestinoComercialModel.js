/**
 *  Modelo para el grid de historico destino comercial / tipo comercializacion
 */
Ext.define('HreRem.model.HistoricoDestinoComercialModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    

    fields: [    
     		
    		{
    			name:'tipoComercializacion'
    		},
    		{
    			name:'fechaInicio',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaFin',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'gestorActualizacion'
    		}
    		
    ]

});