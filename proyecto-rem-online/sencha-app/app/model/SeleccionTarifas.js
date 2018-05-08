/**
 *  Modelo para el grid de seleccion de tarifa
 */
Ext.define('HreRem.model.SeleccionTarifas', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'idTrabajo'
    		},
    		{
    			name:'codigoTarifa'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'precioUnitario'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'trabajo/getTrabajoById',

		api: {
            read: 'trabajo/getSeleccionTarifasTrabajo'
        },
        extraParams: {pestana: 'gestionEconomica'}

    }    

});