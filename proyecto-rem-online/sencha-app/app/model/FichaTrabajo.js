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
    			name: 'cubreSeguro',
    			type: 'boolean'
    		},
    		{
    			name: 'ciaAseguradora'
    		},
    		{
    			name: 'importePrecio'
    		},
    		{
    			name: 'urgente',
    			type: 'boolean'
    		},
    		{
    			name: 'riesgosTerceros',
    			type: 'boolean'
    		},
    		{
    			name: 'aplicaComite',
    			type: 'boolean'
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
    			name: 'tomaPosesion'
    		},
    		{
    			name: 'fechaConcreta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'horaConcreta',
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
    			name: 'tarifaPlana',
    			type: 'boolean'
    		},
    		{
    			name: 'riesgoSiniestro',
    			type: 'boolean'
    		},
    		{
    			name: 'idProveedorLlave'
    		},
    		{
    			name: 'fechaEntregaLlaves',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'idProveedorReceptor'
    		},
    		{
    			name: 'llavesNoAplica',
    			type: 'boolean'
    		},
    		{
    			name: 'llavesMotivo'

    		},
    		{
    			name: 'idTarea'
    		},
    		{
    			name: 'importePresupuesto'
    		},
    		{
    			name: 'refImportePresupueso'
    		},
    		{
    			name: 'idTarifas'

    		},
    		{
    			name: 'visualizarLlaves',
    			type: 'boolean'
    		},
    		{
    			name: 'nombreProyecto' 
    		},
    		{
    			name: 'trabajoDnd'
    		},
    		{
    			name: 'esTrabajoDND',
    			calculate: function(data) {
    				 return data.tipoTrabajoCodigo == CONST.TIPOS_TRABAJO['EDIFICACION'] || data.tipoTrabajoCodigo == CONST.TIPOS_TRABAJO['SUELO'];
    			},
    			depends: 'tipoTrabajoCodigo'
    		},
			{	
    			name: 'identificadorReamCodigo'
    		},
    		{
    			name: 'tipoTrabajoCodigo'
    		},
    		{
    			name: 'perteneceGastoOPrefactura',
    			type: 'boolean'
    		},
    		{
    			name: 'refacturacionTrabajoDescripcion'
    		},
    		{
    			name: 'tipoCalculoMargenDescripcion'
    		},
    		{
    			name: 'porcentajeMargen'
    		},
    		{
    			name: 'importeMargen'
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