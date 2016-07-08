/**
 * This view is used to present the details of a single AgendaItem.
 */

Ext.define('HreRem.model.Comision', {
    extend: 'HreRem.model.Base',

    fields: [
    
    	{
    		name: 'fullName', 
    		calculate: function (data) {
    			return Ext.isEmpty(data.apellidos) ? data.nombre : data.apellidos + ', ' + data.nombre;
    		}
    	},
    
    	'idComision', 'idActivo', 'idOferta', 'idTipoPersona', 'tipoPersona' , 'nombre', 'apellidos', 'porcentajedefecto','porcentajenuevo', 'importe'
    
    ]

});
