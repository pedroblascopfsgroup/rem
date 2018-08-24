/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.TareaGestSustituto', {
    extend: 'HreRem.model.Base',
    
    fields: [
	    	{
	    		name : 'contrato'//id del tramite
	    	},
	    	{
	    		name : 'idGestorOriginal'
	    	},
	    	{
	    		name : 'idGestorSustituto'
	    	},
	    	{
	    		name : 'codEntidad'/*numero del activo*/
	    	},
	    	{
	    		name : 'idTarea'
	    	},
	    	{
	    		name : 'nombreTarea'/*Descripcion de la tarea*/
	    	},
	    	{
	    		name : 'descripcionEntidad'//Tipo de tramite
	    	},
	    	{
	    		name : 'codigoTipoTramite'
	    	},
	    	{
	    		name : 'gestor'//Usuario responsable
	    	},
	    	{
	    		name : 'fechaInicio',
	    		type : 'date',
	    		dateFormat: 'c'
	    	},
	    	{
	    		name : 'fechaVenc',
	    		type : 'date',
	    		dateFormat: 'c'
	    	},
	    	{
	    		name : 'diasVencidaNumber'//Plazo para vencimiento
	    	},
	    	{
	    		name : 'semaforo'//prioridad
	    	},
	    	{
	    		name: 'idEntidad'//id activo
	    	}
    	]
});
    
