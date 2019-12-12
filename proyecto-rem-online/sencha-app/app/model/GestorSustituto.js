/**
 * Modelo para el grid del buscador de gestores sustituto
 */
Ext.define('HreRem.model.GestorSustituto', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    fields: [
            {
            	name:'usernameOrigen'
            },
            {
            	name:'usernameSustituto'
            },
            {
            	name:'nombreOrigen'
            },
            {
            	name:'nombreSustituto'
            },
            {
            	name: 'fechaInicio',
    			type:'date',
    			dateFormat: 'c'
            },
            {
            	name: 'fechaFin',
    			type:'date',
    			dateFormat: 'c'
            },
            {
            	name: 'vigente',
            	type: 'boolean'
            }
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'gestorsustituto/getGestoresSustitutos',
            create: 'gestorsustituto/createGestorSustituto',
            destroy: 'gestorsustituto/deleteGestorSustitutoById'
		}
    }
});