Ext.define('HreRem.view.activos.detalle.AdmisionRevisionTituloModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.admisionRevisionTitulo',
	requires: ['HreRem.ux.data.Proxy', 'HreRem.model.AdmisionRevisionTitulo'],
    data: {
    	admisionRevisionTitulo: null
    },
    stores : {
    	comboSiNoNoAplica: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'siNoNoAplica'}
			}
    	},
    	comboSituacionInicialInscripcion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'situacionInicialInscripcion'}
			}
    	},
    	comboSituacionPosesoriaInicial: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'situacionPosesoriaInicial'}
			}
    	},
    	comboSituacionInicialCargas: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'situacionInicialCargas'}
			}
    	},
    	comboTipoTitularidad: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoTitularidad'}
			}
    	},
    	comboAutorizacionTransmision: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'autorizacionTransmision'}
			}
    	},
    	comboAnotacionConcurso: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'anotacionConcurso'}
			}
    	},
    	comboEstadoGestion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoGestion'}
			}
    	},
    	comboLicenciaPrimeraOcupacion: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadoGestion'}
			}
    	},
    	comboBoletines: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'boletines'}
			}
    	},
    	comboSeguroDecenal: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'boletines'}
			}
    	},
    	comboCedulaHabitabilidad: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'cedulaHabitabilidad'}
			}
    	},
    	comboTipoArrendamiento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoArrendamiento'}
			}
    	},
    	comboTipoExpediente: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoExpediente'}
			}
    	},
    	comboTipoIncidenciaRegistral: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoIncidenciaRegistral'}
			}
    	},
    	comboTipoOcupacionLegal: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoOcupacionLegal'}
			}
    	}
    }
      
});