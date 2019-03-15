/**
 * This view is used to present the details of the historic of Gencat tab.
 */
Ext.define('HreRem.model.GencatHistorico', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
      
		//Datos comunicación
		{
			name:'fechaPreBloqueo',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'fechaComunicacion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'fechaPrevistaSancion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'fechaSancion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'sancion'
		},
		{
			name:'estaActivadoCompradorNuevo',
			calculate: function(data) { 
				return data.sancion === CONST.SANCION_GENCAT['EJERCE'];
			},
			depends: 'sancion'
		},
		{
			name:'nuevoCompradorNif'
		},
		{
			name:'nuevoCompradorNombre'
		},
		{
			name:'nuevoCompradorApellido1'
		},
		{
			name:'nuevoCompradorApellido2'
		},
		{
			name:'ofertaGencat'
		},
		{
			name:'estadoComunicacion'
		},
		{
			name:'estaComunicado',
			calculate: function(data) {
				return data.estadoComunicacion === CONST.ESTADO_COMUNICACION_GENCAT['COMUNICADO'];
			},
			depends: 'estadoComunicacion'
		},
		{
			name:'fechaAnulacion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'comunicadoAnulacionAGencat',
			type: 'boolean'
		},
		
		
		//Adecuacion
		{
			name:'necesitaReforma',
			type: 'boolean'
		},
		{
			name:'importeReforma'
		},
		{
			name:'fechaRevision',
			type:'date',
			dateFormat: 'c'
		},
		
		//Visita
		{
			name:'idVisita'
		},
		{
			name:'estadoVisita'
		},
		{
			name:'apiRealizaLaVisita'
		},
		{
			name:'fechaRealizacionVisita',
			type:'date',
			dateFormat: 'c'
		},
		
		//Notificacion
		{
			name:'checkNotificacion',
			type: 'boolean'
		},
		{
			name:'fechaNotificacion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'motivoNotificacion'
		},
		{
			name:'documentoNotificion'
		},
		{
			name:'fechaSancionNotificacion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'cierreNotificacion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'usuarioCompleto',
			type:'boolean'
		}
		
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'gencat/getDetalleHistoricoByIdComunicacionHistorico'
        }
    }

});