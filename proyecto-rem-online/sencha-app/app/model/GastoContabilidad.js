/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.GastoContabilidad', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    	{
    		name: 'ejercicioImputaGasto'
   	 	},
   	 	{
   	 		name: 'periodicidad'
   	 	},
   	 	{
   	 		name: 'partidaPresupuestaria'
   	 	},
   	 	{
   	 		name: 'cuentaContable'
   	 	},
    	{
    		name: 'fechaDevengo',
    		type : 'date',
			dateFormat: 'c'
   		},
   		{
    		name: 'fechaDevengoEspecial',
    		type : 'date',
			dateFormat: 'c'
   		},
   		{
   			name: 'periodicidadEspecial'
   		},
   		{
   			name: 'partidaPresupuestariaEspecial'
   		},
   		{
   			name: 'cuentaContableEspecial'
   		},
    	{
    		name: 'fechaContabilizacion', 
    		type : 'date',
			dateFormat: 'c'
    	},
    	{
    		name: 'contabilizadoPor'
    	},
    	{
    		name: 'cartera'
    	},
    	{
    		name: 'subcartera'
    	},    	
    	{
    		name: 'idSubpartidaPresupuestaria'
    	},
        {
            name: 'comboActivable'
        },
        {
        	name: 'isEmpty',
        	type: 'boolean'
        },
        {
            name: 'gicPlanVisitasBoolean',
            type: 'boolean'
        },
        {
            name: 'tipoComisionadoHreCodigo'
        },
        {
            name: 'tipoComisionadoHreDescripcion'
        }
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'gastocontabilidadproveedor.json',
		api: {
            read: 'gastosproveedor/getTabGasto',
            update: 'gastosproveedor/updateGastoContabilidad'
        },
		
        extraParams: {tab: 'contabilidad'}
    }

});