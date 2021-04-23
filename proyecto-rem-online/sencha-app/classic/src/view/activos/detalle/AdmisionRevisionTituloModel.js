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
				extraParams: {diccionario: 'licenciaPrimeraOcupacion'}
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
				extraParams: {diccionario: 'seguroDecenal'}
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
				extraParams: {diccionario: 'tipoExpedienteAdministrativo'}
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
    	},
		storeTituloOrigenActivo: {								        		
    			model: 'HreRem.model.ComboBase',   
      		     proxy: {
        		        type: 'uxproxy',
        		        remoteUrl: 'activo/getOrigenActivo',
        		        extraParams: {id: '{activo.id}'}
    	    	}
			},    		
		comboSubtipoTitulo: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'subtiposTitulo'}
			},
			filters: {
                property: 'codigoTipoTitulo',
                value: '{admisionRevisionTitulo.tipoTituloCodigo}'
			}
		},
		comboSituacionConstructivaRegistral: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'situacionConstructivaRegistral'}
			}
		},
		comboProteccionOficial: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'proteccionOficial'}
			}
		},
		comboTipoIncidencia: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoIncidencia'}
			}
		}
    }
      
});