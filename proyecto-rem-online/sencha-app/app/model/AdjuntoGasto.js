/**
 * This view is used to present the details of a single AdmisionDocumento.
 */
Ext.define('HreRem.model.AdjuntoGasto', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [   
    		
		    
    		{
		    	name: 'idEntidad'
		    },
		    {
		    	name: 'idGasto',
    			calculate: function(data) { 
    				return Ext.isEmpty(data.idGasto) ? data.idEntidad : data.idGasto; 
    			},
    			depends: 'idEntidad' 
		    },
		    {
		    	name: 'codigoTipo'
		    },      
    		{
    			name:'descripcionTipo'
    		},
    		{
    			name:'nombre'
    		},
    		{
    			name:'contentType'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'tamanyo'
    		},
    		{
    			name:'fechaDocumento',
    			type:'date',
    			dateFormat: 'c'
    		}   



    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'adjuntos.json',
		remoteUrl: 'gastosproveedor/getAdjuntoById',
		api: {
            read: 'gastosproveedor/getAdjunto',
            create: 'gastosproveedor/saveAdjunto',
            update: 'gastosproveedor/updateAdjunto',
            destroy: 'gastosproveedor/deleteAdjunto'
        }
    }   

});