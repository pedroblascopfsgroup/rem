/**
 * This view is used to present the details of the Comercial Tab.
 */
Ext.define('HreRem.model.ComercialActivoModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
		{
			name: 'situacionComercialCodigo'
		},
		{
			name: 'situacionComercialDescripcion'
		},
		{
			name: 'fechaVenta',
			type:'date',
			dateFormat: 'c'
		},
		{
			name: 'expedienteComercialVivo',
			type: 'boolean'
		},
		{
			name: 'observaciones'
		},
		{
			name: 'importeVenta'
		},
		{
			name: 'ventaExterna',
			type: 'boolean'
		},
		{
			name: 'puja',
			type: 'boolean'
		},
		{
			name: 'tramitable',
			type: 'boolean'
		},
		{
			name: 'motivoAutorizacionTramitacionCodigo'
		},
		{
			name: 'motivoAutorizacionTramitacionDescripcion'
		},
		{
			name: 'observacionesAutoTram'
		},
		{
			name:'direccionComercial'
		},
		{
			name:'direccionComercialDescripcion'
		},
		{
			name: 'ventaSobrePlano',
			type: 'boolean'
		},
		{
			name: 'importeComunidadMensualSareb'
		},
		{
			name: 'siniestroSareb'
		},
		{
			name: 'tipoCorrectivoSareb'
		},
		{
			name: 'fechaFinCorrectivoSareb',
			type:'date',
			dateFormat: 'c'
		},
		{
			name: 'tipoCuotaComunidad'
		},
		{
			name: 'ggaaSareb'
		},
		{
			name:'segmentacionSareb'
		},
		{
			name:'activoObraNuevaComercializacion'
		},
		{
			name: 'activoObraNuevaComercializacionFecha',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'campanyaVenta'
		},
		{
			name:'campanyaAlquiler'
		}
    ],
    
	proxy: {
		type: 'uxproxy',
		timeout: 60000,
		remoteUrl : 'activo/getComercialActivo',
		api: {
			remoteUrl: 'activo/getComercialActivo',
            read: 'activo/getComercialActivo',
            update: 'activo/saveComercialActivo'
        },
        extraParams: {tab: 'comercial' }
    }
});