/**
 * Modelo para el store del grid de hist�rico de estados de publicaci�n. Sirve para alquiler y venta.
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