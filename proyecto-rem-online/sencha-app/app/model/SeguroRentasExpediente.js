/**
 * This view is used to present the details Seguro Rentas Expediente.
 */
Ext.define('HreRem.model.SeguroRentasExpediente', {
    extend: 'HreRem.model.Base',
    idProperty: 'idSeguroRentas',

    fields: [ 
		    {
		    	name: 'id'
		    },
    		{
    			name:'motivoRechazo'
    		},
    		{
    			name:'revision'
    		},
    		{
    			name:'emailPoliza'
    		},
    		{
    			name:'aseguradoras'
    		},
    		{
    			name:'estado'
    		},
    		{
    			name:'version'
    		},
    		{
    			name:'usuarioCrear'
    		},
    		{
    			name:'fechaCrear',
        		type : 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'usuarioModificar'
    		},
    		{
    			name:'fechaModificar',
        		type : 'date',
        		dateFormat: 'c'
    		},
    		
    		{
    			name:'usuarioBorrar'
    		},
    		{
    			name:'fechaBorrar',
        		type : 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'borrado'
    		},
    		{
    			name:'comentarios'
    		},
    		{
    			name: 'enRevision',
    			calculate: function(data) {
    				return data.revision == 'true'
    			},
    			depends: 'revision'
    		},
    		{
    			name:'estaEnTramite',
    			calculate: function(data) {
    				return data.estado == 'En trámite'
    			},
    			depends: 'estado'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'expedienteComercial.json',
		
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveSeguroRentasExpediente'
        },
		
        extraParams: {tab: 'segurorentasexpediente'}
    }    

});