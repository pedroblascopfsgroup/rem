/**
 * Modelo para el grid de estadisticas de mediadores en pestana de administracion.
 */
Ext.define('HreRem.model.CarteraMediadorEvaluarModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',	  
    fields: [
		{
			name: 'id'
		},
		{
			name: 'numActivos'
		},
		{
			name: 'numVisitas'
		},
		{
			name: 'numOfertas'
		},
		{
			name: 'numReservas'
		},
		{
			name: 'numVentas'
		},
		{
			name: 'codigoCalificacion'
		},
		{
			name: 'descripcionCalificacion'
		},
		{
			name: 'esTop'
		}
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getStatsCarteraMediadores'
		}
    }
});