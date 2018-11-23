/**
 * Modelo para el store del grid de histórico de estados de publicación. Sirve para alquiler y venta.
 */
Ext.define('HreRem.model.HistoricoEstadosPublicacion', {
	extend: 'HreRem.model.Base',
	idProperty: 'id',

	fields: [
		{
			name: 'id' 
		},
		{
			name:'idActivo'
		},
		{
			name:'fechaDesde'
		},
		{
			name:'fechaHasta'
		},
		{
			name:'oculto'
		},
		{
			name:'tipoPublicacion'
		},
		{
			name:'estadoPublicacion'
		},
		{
			name:'motivo'
		},
		{
			name: 'usuario'
		},
		{
			name:'diasPeriodo'
		}
	]
});