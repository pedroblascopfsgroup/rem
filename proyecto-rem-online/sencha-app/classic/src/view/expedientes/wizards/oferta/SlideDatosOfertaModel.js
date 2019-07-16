Ext.define('HreRem.view.expedientes.wizards.oferta.SlideDatosOfertaModel', {
	extend: 'Ext.app.ViewModel',
	alias: 'viewmodel.slidedatosoferta',

	data: {},
	
	formulas: {
		isLiberbank: function(get){
	    	this._view.down('field[name=claseOferta]').setHidden(!get('activo.isCarteraLiberbank'));
	    	this._view.down('field[name=numOferPrincipal]').setHidden(!get('activo.isCarteraLiberbank')); 
	    	this._view.down('field[name=claseOferta]').allowBlank = !get('activo.isCarteraLiberbank')	 
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
					diccionario: 'tiposDocumentos'
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
		}
	}
});
