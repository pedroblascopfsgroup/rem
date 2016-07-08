/**
 * This view is used to present the details of a single AgendaItem.
 */

Ext.define('HreRem.model.Visita', {
    extend: 'HreRem.model.Base',

    fields: [
    
    	{
    		name: 'fullName', 
    		calculate: function (data) {
    			return Ext.isEmpty(data.apellidos) ? data.nombre : data.apellidos + ', ' + data.nombre;
    		}
    	},
    
    	'id,', 'idActivo', 'nombre', 'apellidos', 'numDocumento', 'tpDocumento',  'tel1', 'tel2', 
    	
    	{
    		name: 'estadoSolicitud',
    		defaultValue: 'INICIADA'
    	},
    	{
    		name: 'fechaSolicitud',
    		defaultValue: Ext.Date.format(new Date(), 'd/m/Y')
    	},
    	 'pais', 'email'
    ]

});
