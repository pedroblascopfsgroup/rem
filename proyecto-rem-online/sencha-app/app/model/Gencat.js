/**
 * This view is used to present the details of Gencat tab.
 */
Ext.define('HreRem.model.Gencat', {
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
				return !Ext.isEmpty(data.fechaSancion) && data.sancion === CONST.SANCION_GENCAT['EJERCE'];
			},
			depends: [ 'fechaSancion', 'sancion']
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
			name:'usuarioValido',
			calculate: function(data) {
				if(data.estadoComunicacion === CONST.ESTADO_COMUNICACION_GENCAT['COMUNICADO'] && ($AU.userIsRol(CONST.PERFILES['HAYAGESTFORMADM']) || $AU.userIsRol(CONST.PERFILES['GESTIAFORM']))){
					return true
				}else{
					return false
				}
			},
			depends: 'estadoComunicacion'
		},
		{
			name:'fechaComunicacionVacia',
			calculate: function(data) {
				return Ext.isEmpty(data.fechaComunicacion);
			},
			depends: 'fechaComunicacion'
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
		{
			name: 'IsUserAllowed',
			calculate: function(data){
				if (data.usuarioCompleto)
					return false;
				return ($AU.userIsRol(CONST.PERFILES['HAYAGESTFORMADM']) || $AU.userIsRol(CONST.PERFILES['GESTIAFORM']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']));
			},
			depends: ['usuarioCompleto']
		},
		
		
		//Adecuacion
		{
			name:'necesitaReforma'
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
		},
		{
			name:'comunicadoAnulacionAGencat2',
			type: 'boolean'	
		},
		{
			name:'ofertasAsociadasEstanAnuladas',
			type: 'boolean'	
		}
    ],
    
	proxy: {
		type: 'uxproxy',
		//localUrl: 'gencat.json',
		remoteUrl: 'gencat/getDetalleGencatByIdActivo',
		api: {
            read: 'gencat/getDetalleGencatByIdActivo',
            create: 'gencat/saveDatosComunicacion',
            update: 'gencat/saveDatosComunicacion',
            destroy: 'gencat/getDetalleGencatByIdActivo'
        }
    }

});