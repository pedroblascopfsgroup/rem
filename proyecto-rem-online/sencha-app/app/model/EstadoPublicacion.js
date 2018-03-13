/**
 * This view is used to present the details of estados de publicacion.
 */
Ext.define('HreRem.model.EstadoPublicacion', {
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