/**
 *  Modelo para el tab Informacion comercial de Activos 
 */
Ext.define('HreRem.model.PresupuestoGrafico', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
   		{ 
   			name: 'presupuesto'
     	},
     	{
     		name: 'gastadoPorcentaje'
     	},
     	{
     		name: 'dispuestoPorcentaje'
     	},
     	{
     		name: 'disponiblePorcentaje'
     	},
     	{
     		name: 'gastado'
     	},
     	{
     		name: 'dispuesto'
     	},
     	{
     		name: 'disponible'
     	}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById',
		api: {
            read: 'activo/findLastPresupuesto',
            create: 'activo/findLastPresupuesto',
            update: 'activo/findLastPresupuesto',
            destroy: 'activo/findLastPresupuesto'
        }
    }
    
    

});