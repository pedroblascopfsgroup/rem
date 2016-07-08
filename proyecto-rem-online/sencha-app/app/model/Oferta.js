/**
 * This view is used to present the details of a single Oferta.
 */

Ext.define('HreRem.model.Oferta', {
    extend: 'HreRem.model.Base',

    fields: [
    
    	{
    		name: 'fullName', 
    		calculate: function (data) {
    			return Ext.isEmpty(data.apellidos) ? data.nombre : data.apellidos + ', ' + data.nombre;
    		}
    	},
    
    	'idOferta',
    	'idActivo',
    	'nombre',
    	'apellidos',
    	'numDocumento',
    	'idLote',
    	'idTipoOferta',
    	'tipoOferta',
    	'importe',
    	'idActuacion',
    	'idEstado',
    	'estado',
    	'fechaSolicitud',
    	'idVisita',
    	'fechaVisita',
    	 {
        	name: 'descItemMenu',
        	convert: function (value, rec) {
        		
        		return rec.get('tipoOferta') + '-' + rec.get('idOferta') + '<br/>' + rec.get('fullName') + ' - ' + rec.get('importe')+'€'
        		
        	}
    	}
    ]

});
          