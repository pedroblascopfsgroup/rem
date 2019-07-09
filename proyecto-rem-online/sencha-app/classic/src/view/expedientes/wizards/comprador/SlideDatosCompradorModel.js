Ext.define('HreRem.view.expedientes.wizards.comprador.SlideDatosCompradorModel', {
	extend: 'HreRem.view.common.DDViewModel',
	alias: 'viewmodel.slidedatoscomprador',

	data: {},
	stores: {		
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

		comboMunicipio: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipio',
				extraParams: {codigoProvincia: '{comprador.provinciaCodigo}'} 
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
		
	   comboEstadoCivilURSUS: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosCivilesURSUS'}
			},
			autoLoad: true   	
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
				remoteUrl: 'generic/getComboMunicipio',
				extraParams: {codigoProvincia: '{comprador.provinciaRteCodigo}'} 
			}
		},
		storeProblemasVenta: {
			model: 'HreRem.model.DatosClienteUrsus',
			autoLoad: true,
			autoSync: true,
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/buscarProblemasVentaClienteUrsus',
				extraParams: {numeroUrsus: '', idExpediente: '{comprador.idExpedienteComercial}'}
			}
		}
	}
});