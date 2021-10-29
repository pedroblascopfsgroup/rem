Ext.define('HreRem.view.expedientes.wizards.oferta.SlideDatosOfertaModel', {
	extend: 'Ext.app.ViewModel',
	alias: 'viewmodel.slidedatosoferta',

	data: {},
	
	formulas: {
		isLiberbank: function(get){
	    	this._view.down('field[name=claseOferta]').setHidden(!get('activo.isCarteraLiberbank'));
	    	this._view.down('field[name=claseOferta]').allowBlank = !get('activo.isCarteraLiberbank');	 
	    	this._view.down('field[name=numOferPrincipal]').setHidden(!get('activo.isCarteraLiberbank')); 
	    	this._view.down('field[name=numOferPrincipal]').allowBlank = !get('activo.isCarteraLiberbank');
	    	this._view.down('field[name=buscadorNumOferPrincipal]').setHidden(!get('activo.isCarteraLiberbank')); 
	    	this._view.down('field[name=buscadorNumOferPrincipal]').allowBlank = !get('activo.isCarteraLiberbank');
		 },
		 
		 mostrarCamposLiberbank: function(){						
			var tipoOferta = this._view.getForm().findField('tipoOferta').getSelection();
			
			if (tipoOferta ==null || tipoOferta == undefined){
				this._view.down('field[name=claseOferta]').setHidden(true);	    			 
	    		this._view.down('field[name=numOferPrincipal]').setHidden(true);	    		
	    		this._view.down('field[name=buscadorNumOferPrincipal]').setHidden(true);
				}			
		}

    },

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

		comboTipoDocumento: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'tipoDeDocumento'
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

		comboClaseOferta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'claseOferta'
				}
			}
		},
		comboMunicipioSinFiltro: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipioSinFiltro'
			}
		}, 
		
		comboMunicipioOfr: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipio',
				extraParams: {codigoProvincia: '{oferta.provinciaCodigo}'} 
			},
			autoLoad: true
		},
				
		comboTipologiaVentaBcOfr: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {
					diccionario: 'tipologiaVentaBc'
				},
			autoLoad: true
			}
		},
		comboMunicipioNacimientoOfr: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipio',
				extraParams: {codigoProvincia: '{oferta.provinciaNacimiento}'} 
			},
			autoLoad: true
		},
    	
    	comboTipoOferta: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionarioTipoOfertas'
			}
    	}, 
		
		comboMunicipioRpr: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipio',
				extraParams: {codigoProvincia: '{oferta.provinciaRteCodigo}'} 
			},
			autoLoad: true
		},
    	
		comboMunicipioNacimientoRrp: {
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboMunicipio',
				extraParams: {codigoProvincia: '{oferta.provinciaNacimientoRepresentanteCodigo}'} 
			},
			autoLoad: true
		},	

		comboSiNoBoolean: {
			data : [	        	
	        	{"codigo":"false", "descripcion":"No"},
	        	{"codigo":"true", "descripcion":"Si"}
	    	]
		}
	}
});
