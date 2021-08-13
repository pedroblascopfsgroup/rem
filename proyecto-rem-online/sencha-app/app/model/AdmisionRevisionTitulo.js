/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.AdmisionRevisionTitulo', {
			extend : 'HreRem.model.Base',
			idProperty : 'id',
			fields : [{
						name : 'idActivo'
					}, 
					{
						name : 'revisado'
					}, 
					{
						name : 'instLibArrendataria'
					}, 
					{
						name : 'ratificacion'
					}, 
					{
						name : 'situacionInicialInscripcion'
					},
					{
						name : 'situacionInicialInscripcionDescripcion'
					},
					{
						name: 'posesoriaInicial'
					},
					{
						name : 'posesoriaInicialDescripcion'
					}, 
					{
						name : 'situacionInicialCargas'
					}, 
					{
						name : 'situacionInicialCargasDescripcion'
					},
					{
						name : 'tipoTitularidad'
					}, 
					{
						name : 'tipoTitularidadDescripcion'
					},
					{
						name : 'estadoAutorizaTransmision'
					},
					{
						name : 'estadoAutorizaTransmisionDescripcion'
					},
					{
						name : 'anotacionConcurso'
					},
					{
						name : 'anotacionConcursoDescripcion'
					},
					{
						name : 'estadoGestionCa'
					},
					{
						name : 'estadoGestionCaDescripcion'
					},
					{
						name : 'consFisica'
					}, {
						name : 'consJuridica'
					}, 
					{
						name : 'estadoCertificadoFinObra'
					},
					{
						name : 'estadoCertificadoFinObraDescripcion'
					},
					{
						name : 'estadoAfoActaFinObra'
					},
					{
						name : 'estadoAfoActaFinObraDescripcion'
					},
					{
						name : 'licenciaPrimeraOcupacion'
					},
					{
						name : 'licenciaPrimeraOcupacionDescripcion'
					},
					{
						name : 'boletines'
					},
					{
						name : 'boletinesDescripcion'
					},
					{
						name : 'seguroDecenal'
					},
					{
						name : 'seguroDecenalDescripcion'
					},
					{
						name : 'cedulaHabitabilidad'
					},
					{
						name : 'cedulaHabitabilidadDescripcion'
					},
					{
						name : 'tipoArrendamiento'
					},
					{
						name : 'tipoArrendamientoDescripcion'
					},
					{
						name : 'notificarArrendatarios'
					},
					{
						name : 'tipoExpediente'
					},
					{
						name : 'tipoExpedienteDescripcion'
					},
					{
						name : 'estadoGestionEa'
					},
					{
						name : 'estadoGestionEaDescripcion'
					},
					{
						name : 'tipoIncidenciaRegistral'
					},
					{
						name : 'tipoIncidenciaRegistralDescripcion'
					},
					{
						name : 'estadoGestionCr'
					},
					{
						name : 'estadoGestionCrDescripcion'
					},
					{
						name : 'tipoOcupacionLegal'
					},
					{
						name : 'tipoOcupacionLegalDescripcion'
					},
					{
						name : 'estadoGestionIl'
					},
					{
						name : 'estadoGestionIlDescripcion'
					},
					{
						name : 'estadoGestionOt'
					},
					{
						name : 'estadoGestionOtDescripcion'
					},
					{
						name : 'fechaRevisionTitulo',
						type : 'date',
						dateFormat : 'c'
					}, {
						name : 'porcentajePropiedad'
					}, {
						name : 'observaciones'
					}, {
						name : 'porcentajeConsTasacionCf'
					}, {
						name : 'porcentajeConsTasacionCj'
					}, {
						name : 'fechaContratoAlquiler',
						type : 'date',
						dateFormat : 'c'
					}, {
						name : 'legislacionAplicableAlquiler'
					}, {
						name : 'duracionContratoAlquiler'
					}, {
						name : 'tipoIncidenciaIloc'
					}, {
						name : 'deterioroGrave'
					}, {
						name : 'tipoIncidenciaOtros'
					}, {
						name : 'tipoTituloActivo'
					}, {
						name : 'subtipoTituloActivo'
					},
					{
						name : 'tipoTituloActivoRef'
					},
					{
						name : 'subtipoTituloActivoRef'
					},
					{
						name : 'tipoTituloCodigo'
					},
					{
						name : 'tipoTituloDescripcion'
					},
					{
						name : 'subtipoTituloCodigo'
					},
					{
						name : 'subtipoTituloDescripcion'
					},
					{
						name : 'situacionConstructivaRegistral'
					},
					{
						name : 'situacionConstructivaRegistralDescripcion'
					},
					{
						name : 'proteccionOficial'
					},
					{
						name : 'proteccionOficialDescripcion'
					}

			],
			proxy : {
				type : 'uxproxy',
				remoteUrl : 'admision/getTabDataRevisionTitulo',
				api : {
					read : 'admision/getTabDataRevisionTitulo',
					create : 'admision/saveTabDataRevisionTitulo',
					update : 'admision/saveTabDataRevisionTitulo'
				}
			}
		});