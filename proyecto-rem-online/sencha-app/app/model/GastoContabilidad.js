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
        },
        {
        	name: 'idElemento'
        },
        {
        	name: 'tipoElemento'
        },
        {
        	name: 'importeGasto'
        },
        {
        	name:'subPartidas'
        },
        {
        	name:'diario1'
        },
        {
        	name: 'diario1Base'
        },
        {
        	name: 'diario1Tipo'
        },
        {
        	name: 'diario1Cuota'
        },
        {
        	name:'diario2'
        },
        {
        	name:'diario2Base'
        },
        {
        	name: 'diario2Tipo'
        },
        {
        	name: 'diario2Cuota'
        },
        {
        	name:'errorDiarios'
        },
        {
        	name:'resultadoDiarios',
        	type:'boolean'
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