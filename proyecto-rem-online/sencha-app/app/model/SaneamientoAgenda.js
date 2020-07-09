/**
 * Modelo para el grid del buscador de impuestos de la pestaña de administración.
 */
Ext.define('HreRem.model.SaneamientoAgenda', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
	    {
	    	name:'idSan'
	    },
    	{
    		name:'idActivo'
    	},
    	{
           	name:'tipologiaCod'
        },
        {
          	name:'subtipologiacod'
        },
        {
           	name:'observaciones'
        },
        {
           	name:'usuariocrear'
        },
        {
          	name:'fechaCrear',
           	type:'date',
    		dateFormat:'c'
        }
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'saneamientoagenda.json',
		api: {
			//update: '',
            //read: 'activo/getSaneamientosAgendaByActivo',
            create: 'activo/createSaneamientoAgenda',
            destroy: 'activo/deleteSaneamientoAgenda'
		}
    }
});