/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.AdmisionRevisionTitulo', {
			extend : 'HreRem.model.Base',
			idProperty : 'id',
			fields : [{
						name : 'idActivo'
					}, {
						name : 'revisado'
					}, {
						name : 'instLibArrendataria'
					}, {
						name : 'ratificacion'
					}, {
						name : 'situacionInicialInscripcion'
					}, 
					{
						name: 'posesoriaInicial'
					},
					{
						name : 'posesoriaInicial'
					}, {
						name : 'situacionInicialCargas'
					}, {
						name : 'tipoTitularidad'
					}, {
						name : 'estadoAutorizaTransmision'
					}, {
						name : 'anotacionConcurso'
					}, {
						name : 'estadoGestionCa'
					}, {
						name : 'consFisica'
					}, {
						name : 'consJuridica'
					}, {
						name : 'estadoCertificadoFinObra'
					}, {
						name : 'estadoAfoActaFinObra'
					}, {
						name : 'licenciaPrimeraOcupacion'
					}, {
						name : 'boletines'
					}, {
						name : 'seguroDecenal'
					}, {
						name : 'cedulaHabitabilidad'
					}, {
						name : 'tipoArrendamiento'
					}, {
						name : 'notificarArrendatarios'
					}, {
						name : 'tipoExpediente'
					}, {
						name : 'estadoGestionEa'
					}, {
						name : 'tipoIncidenciaRegistral'
					}, {
						name : 'estadoGestionCr'
					}, {
						name : 'tipoOcupacionLegal'
					}, {
						name : 'estadoGestionIl'
					}, {
						name : 'estadoGestionOt'
					}, {
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