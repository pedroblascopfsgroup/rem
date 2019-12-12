/**
 *  Modelo para el grid de tarifas asignadas al trabajo
 */
Ext.define('HreRem.model.TarifasTrabajo', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
            {
            	name:'idTrabajo'
            },
            {
            	name:'idConfigTarifa'
            },
    		{
    			name:'subtipoTrabajoCodigo'
    		},
    		{
    			name:'subtipoTrabajoDescripcion'
    		},
    		{
    			name:'codigoTarifa'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'unidadMedida'
    		},
    		{
    			name:'precioUnitario',
    			type: 'float'
    		},
    		{
    			name:'medicion',
    			type: 'float',
    			defaultValue: 1
    		},
    		{
    			name:'cuentaContable'
    		},
    		{
    			name:'partidaPresupuestaria'
    		},
    		{
    			name:'importeTotal',
    			type: 'float',
    			calculate: function (data) {
     				if(!Ext.isEmpty(data.medicion) && !Ext.isEmpty(data.precioUnitario)) {
     					return  data.medicion * data.precioUnitario;
     				}
     				else
     				{
     					return null;
     				}
     				
    			}
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'trabajo/getTrabajoById',

		api: {
            read: 'trabajo/getTarifasTrabajo',
            create: 'trabajo/createTarifaTrabajo',
            update: 'trabajo/saveTarifaTrabajo',
            destroy: 'trabajo/deleteTarifaTrabajo'
        }

    }    

});