/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.FichaTrabajo', {
	extend : 'HreRem.model.Base',
	idProperty : 'id',


    fields: [ 
    		
		    {
		    	name: 'idTrabajo'
		    },
		    {
		    	name: 'idActivo'
		    },
		    {
		    	name: 'idAgrupacion'
		    },      
    		{
    			name:'numTrabajo'
    		},
    		{
    			name: 'descripcionGeneral'
    		},
    		{
    			name: 'gestorActivoCodigo'
    		},
    		{
    			name: 'numAlbaran'
    		},
    		{
    			name: 'numGasto'
    		},
    		{
    			name: 'estadoGastoCodigo'
    		},
    		{
    			name: 'cubiertoSeguro'
    		},
    		{
    			name: 'ciaAseguradora'
    		},
    		{
    			name: 'importePrecio'
    		},
    		{
    			name: 'urgente'
    		},
    		{
    			name: 'riesgosTerceros'
    		},
    		{
    			name: 'aplicaComite'
    		},
    		{
    			name: 'resolucionComiteCodigo'
    		},
    		{
    			name: 'fechaResolucionComite',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'resolucionComiteId'
    		},
    		{
    			name: 'fechaConcreta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaConcretaHora',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaTope',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'estadoTrabajoCodigo'
    		},
    		{
    			name: 'fechaEjecucionTrabajo',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'tarifaPlana'
    		},
    		{
    			name: 'riesgoSiniestro'
    		},
    		{
    			name: 'proovedorCodigo'
    		},
    		{
    			name: 'fechaEjecucionTrabajo'
    		},
    		{
    			name: 'receptorCodigo'
    		},
    		{
    			name: 'llavesNoAplica'
    		},
    		{
    			name: 'llavesMotivo'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'trabajo.json',
		remoteUrl: 'trabajo/getTrabajoById',
		timeout: 3000000,
		api: {
            read: 'trabajo/findOne',
            create: 'trabajo/create',
            update: 'trabajo/saveFichaTrabajo',
            destroy: 'trabajo/findOne'
        },
        extraParams: {pestana: 'ficha'},
        reader:{
        	messageProperty: 'error'
        }
    }    


});