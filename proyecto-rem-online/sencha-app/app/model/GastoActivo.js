/**
 *  Modelo para el grid de presupuestos asignados al trabajo
 */
Ext.define('HreRem.model.GastoActivo', {
    extend: 'HreRem.model.Base',

    fields: [    
  
            {
            	name: 'idGasto',
            	critical: true
            },
            {
            	name:'idActivo'
            },
            {
            	name:'idAgrupacion'
            },
            {
            	name:'numActivo'
            },
            {
            	name:'numAgrupacion'
            },
            {
            	name: 'idGastoActivo'	
            },
            {
            	name: 'direccion'
            },
            {
            	name: 'participacion',
            	type: 'number'
            },
            {
            	name: 'importeProporcinalTotal',
            	type: 'number'
            },
            {
            	name: 'referenciasCatastrales'
            },
            {
            	name: 'referenciaCatastral'
            },
            {
            	name: 'subtipoCodigo'
            },
            {
            	name: 'subtipoDescripcion'
            }
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'gastoactivo.json',
		api: {
            read: '',
            create: 'gastosproveedor/createGastoActivo',
            update: 'gastosproveedor/updateGastoActivo',
            destroy: ''
        }

    }    

});