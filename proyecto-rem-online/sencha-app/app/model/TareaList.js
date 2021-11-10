/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.TareaList', {
    extend: 'HreRem.model.Base',
    idProperty: 'idTramite',

    fields: [
             'idTareaExterna',
             'id',
             'tipoTarea',
             'idTramite',
             'tipoTramite',
          	 {
         		name : 'fechaInicio',
         		type : 'date',
    			dateFormat: 'c'
         	 },
         	 {
          		name : 'fechaFin',
          		type : 'date',
    			dateFormat: 'c'
          		
          	 },
          	 {
          		name : 'fechaVenc',
          		type : 'date',
    			dateFormat: 'c'
          	 },
             'idGestor',
             'gestor',
             'subtipoTareaCodigoSubtarea',
             'codigoTarea',
             {
          		 name: 'nombre'
             }
    ],
    
	proxy: {
		type: 'uxproxy',
		remoteUrl: 'activo/getTareasTramite'
    }    

});
