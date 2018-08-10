/**
 * This view is used to present the details Seguro Rentas Expediente.
 */
Ext.define('HreRem.model.SeguroRentasExpediente', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

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