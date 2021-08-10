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
		},
		comboMunicipioSinFiltro: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipioSinFiltro'
			}
		},
		comboVinculoCaixa: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'vinculoCaixa'}
			},
			autoLoad: true   	
	    },
	    comboEstadoCivilCustom: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/comboEstadoCivilCustom',
				extraParams: {codCartera: '{comprador.entidadPropietariaCodigo}'}
			},
			//session: true,
			autoLoad: true
	    }
	}
});