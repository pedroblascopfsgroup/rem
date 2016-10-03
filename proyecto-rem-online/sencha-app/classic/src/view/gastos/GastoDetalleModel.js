Ext.define('HreRem.view.gastos.GastoDetalleModel', {
    extend: 'HreRem.view.common.GenericViewModel',
    alias: 'viewmodel.gastodetalle',
    requires : ['HreRem.ux.data.Proxy', 'HreRem.model.ComboBase', 'HreRem.model.GastoActivo', 'HreRem.model.GestionGasto'],
    
    data: {
    	gasto: null,
    	gestion: null
    },
    
    formulas: {   
    	
	     getConEmisor: function(get){
	     	var me= this;
	     	var gasto= me.getData().gasto;
	     	if(Ext.isEmpty(gasto)) {
	     		return false
	     	} else {
		     	var nifEmisor= gasto.get('nifEmisor');
		     	var nombreEmisor= gasto.get('nombreEmisor');
		     	var codigoEmisor= gasto.get('codigoEmisor');
	     	}
	     	
	     	if(Ext.isEmpty(nifEmisor) && Ext.isEmpty(nombreEmisor) && Ext.isEmpty(codigoEmisor)){
	     		return false
	     	}
	     	
	     	return true;
	     },
	     
		getConPropietario: function(get){
	     	var me= this;
	     	var gasto= me.getData().gasto;
	     	if(Ext.isEmpty(gasto)) {
	     		return false;
	     	} else {
		     	var nifPropietario= gasto.get('nifPropietario');
		     	var nombrePropietario= gasto.get('nombrePropietario');
	     	}
	     	
	     	if(Ext.isEmpty(nifPropietario) && Ext.isEmpty(nombrePropietario)){
	     		return false
	     	}
	     	
	     	return true;
	     }  		
		
	 },


    stores: {
    	
		comboPeriodicidad: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoPeriocidad'}
			}   
    	},
    	
    	comboTiposGasto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposGasto'}
			}   
    	},
    	
    	comboDestinatarios: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'destinatariosGasto'}
			}   
    	},
    	
    	comboSubtiposGasto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboSubtipoGasto',
				extraParams: {codigoTipoGasto: '{gasto.tipoGastoCodigo}'}
			}   
    	},

    	comboSubtiposNuevoGasto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboSubtipoGasto',
				extraParams: {codigoTipoGasto: '{gastoNuevo.tipoGastoCodigo}'}
			}   
    	},
    	
    	comboPropietarios: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'propietariosGasto'}
			}   
    	},
    	
    	comboPagadoPor: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoPagador'}
			}  
    	},
    	
    	comboDestinatarioPago: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'destinataioPago'}
			}  
    	},
    	
    	comboTipoImpuesto: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposImpuestos'}
			}
    	},

    	storeActivosAfectados: {    
    		 pageSize: $AC.getDefaultPageSize(),
    		 model: 'HreRem.model.GastoActivo',
		     proxy: {
		        type: 'uxproxy',
		        remoteUrl: 'gastosproveedor/getListActivosGastos',
		        extraParams: {idGasto: '{gasto.id}'}
	    	 }
    	},
    	
    	comboEjercicioContabilidad: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getComboEjercicioContabilidad'
			}
    	},
    	
    	comboMotivoAutorizacion: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosAutorizacionPropietaro'}
			}
    	},
    	
    	comboEstadoAutorizacionHaya: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosAutorizacionHaya'}
			}
    	},
    	
    	comboMotivoAutorizacionHaya: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosAutorizacionHaya'}
			}
    	},
    	
    	comboEstadoAutorizacionPropietario: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'estadosAutorizacionPropietario'}
			}
    	},
    	
    	comboMotivoAnulado: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosAnulados'}
			}
    	},
    	
    	comboMotivoRetenerPago: {
    		model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'motivosRetenerPago'}
			}
    	}
    	
	
    }
  
});