Ext.define('HreRem.view.expedientes.wizards.comprador.SlideDatosCompradorModel', {
	extend: 'Ext.app.ViewModel',
	alias: 'viewmodel.slidedatoscomprador',

	data: {},

	stores: {		
		comboTipoPersona: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'tipoPersona'
				}
			},
			autoLoad: true
		},

		comboTipoGradoPropiedad: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'tiposGradoPropiedad'
				}
			}
		},

		comboTipoDocumento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'tiposDocumentos'
				}
			}
		},

		comboProvincia: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'provincias'
				}
			}
		},

		comboMunicipio: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipio'
			}
		},

		comboPaises: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'paises'
				}
			}
		},

		comboClienteUrsus: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/buscarClientesUrsus',
				extraParams: {
					numeroDocumento: null,
					tipoDocumento: null
				}
			}
		},
		
		comboClienteUrsusConyuge: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/buscarClientesUrsus',
				extraParams: {
					numeroDocumento: null, 
					tipoDocumento: null
				}
			}
		},

		comboEstadoCivil: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'estadosCiviles'
				}
			}
		},

		comboRegimenesMatrimoniales: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'regimenesMatrimoniales'
				}
			}
		},

		comboMunicipioRte: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipio'
			}
		}
	}
});