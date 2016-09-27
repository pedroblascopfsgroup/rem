/**
 *  Modelo para el grid de presupuestos asignados al trabajo
 */
Ext.define('HreRem.model.GastoActivo', {
    extend: 'HreRem.model.Base',

    fields: [    
  
            {
            	name:'id'
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
            }
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'gastoactivo.json',
		api: {
            read: '',
            create: 'gastosproveedor/createGastoActivo',
            update: '',
            destroy: ''
        }

    }    

});