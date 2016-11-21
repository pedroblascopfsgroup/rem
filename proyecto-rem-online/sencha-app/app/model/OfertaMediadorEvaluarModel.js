/**
 * Modelo para el grid de lista de mediadores para evaluar en pestana de administracion.
 */
Ext.define('HreRem.model.OfertaMediadorEvaluarModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',	  
    fields: [
		{
			name: 'id'
		},
		{
			name: 'idOferta'
		},
		{
			name: 'numOferta'
		},
		{
			name: 'idAgrupacion'
		},
		{
			name: 'numAgrupacion'
		},
		{
			name: 'idActivo'
		},
		{
			name: 'numActivo'
		},
		{
			name: 'codEstadoOferta'
		},
		{
			name: 'desEstadoOferta'
		},
		{
			name: 'codTipoOferta'
		},
		{
			name: 'desTipoOferta'
		},
		{
			name: 'idExpediente'
		},
		{
			name: 'numExpediente'
		},
		{
			name: 'codEstadoExpediente'
		},
		{
			name: 'desEstadoExpediente'
		},
		{
			name: 'codSubtipoActivo'
		},
		{
			name: 'desSubtipoActivo'
		},
		{
			name: 'importeAprobadoOferta'
		},
		{
			name: 'idOfertante'
		},
		{
			name: 'nombreOfertante'
		}
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getOfertasCarteraMediadores'
		}
    }
});