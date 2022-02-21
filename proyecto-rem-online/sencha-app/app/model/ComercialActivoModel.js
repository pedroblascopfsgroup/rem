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
			name: 'necesidadIfActivo',
			type: 'boolean'
		},
		{
			name: 'necesidadArras',
			type: 'boolean'
		},
		{
			name: 'motivosNecesidadArras'
		},
		{
			name: 'estadoComercialVentaCodigo'
		},
		{
			name: 'estadoComercialVentaDescripcion'
		},
		{
			name: 'estadoComercialAlquilerCodigo'
		},
		{
			name: 'estadoComercialAlquilerDescripcion'
		},
		{
			name: 'fechaEstadoComercialVenta',
			type:'date',
			dateFormat: 'c'
		},
		{
			name: 'fechaEstadoComercialAlquiler',
			type:'date',
			dateFormat: 'c'
		},
		{
			name: 'canalPublicacionVentaCodigo'
		},
		{
			name: 'canalPublicacionAlquilerCodigo'
		},
		{
			name: 'tributacionPropuestaClienteExentoIvaCod'
		},
		{
			name: 'tributacionPropuestaClienteExentoIvaDesc'
		},
		{
			name: 'tributacionPropuestaVentaCod'
		},
		{
			name: 'tributacionPropuestaVentaDesc'
		},
		{
			name: 'carteraConcentrada',
			type: 'boolean'
		},
		{
			name: 'activoAAMM',
			type: 'boolean'
		},
		{
			name: 'activoPromocionesEstrategicas',
			type: 'boolean'
		},
		{
			name: 'fechaInicioConcurrencia',
			type:'date',
			dateFormat: 'c'
		},
		{
			name: 'fechaFinConcurrencia',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'campanyaVenta'
		},
		{
			name:'campanyaAlquiler'
		},
		{
			name: 'tipoTransmisionCodigo'
		},
		{
			name: 'tipoTransmisionDescripcion'
		},
		{
			name: 'segmentacionCarteraCodigo;'
		},
		{
			name: 'segmentacionCarteraDescripcion'
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