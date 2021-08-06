/**
 * Controlador global de aplicación que gestiona la funcionalidad de la entidad Activo
 */
Ext.define('HreRem.controller.ActivosController', {
    extend: 'HreRem.ux.controller.ControllerBase',
   
    models: ['HreRem.model.Activo','HreRem.model.ActivoDatosRegistrales','HreRem.model.ActivoPropietario','HreRem.model.ActivoInformacionAdministrativa',
    'HreRem.model.ActivoCargas', 'HreRem.model.ActivoCargasTab', 'HreRem.model.ActivoSituacionPosesoria', 'HreRem.model.ActivoValoraciones', 'HreRem.model.ActivoTasacion',
    'HreRem.model.ActivoInformacionComercial','HreRem.model.Tramite','HreRem.model.FichaTrabajo', 'HreRem.model.ActivoAviso', 
    'HreRem.model.AgrupacionAviso', 'HreRem.model.TrabajoAviso', 'HreRem.model.ExpedienteAviso','HreRem.view.activos.tramites.TramitesDetalle', 'HreRem.model.GestionEconomicaTrabajo', 
    'HreRem.model.SeleccionTarifas', 'HreRem.model.TarifasTrabajo', 'HreRem.model.PresupuestosTrabajo', 'HreRem.model.ExpedienteComercial','HreRem.view.comercial.ComercialMainMenu',
    'HreRem.model.FichaProveedorModel', 'HreRem.model.PerfilDetalleModel','HreRem.model.FichaPerfilModel', 'HreRem.model.GastoProveedor', 'HreRem.model.GastoAviso',
    'HreRem.view.expedientes.ExpedienteDetalleMain', 'HreRem.model.FichaProveedorModel', 'HreRem.view.configuracion.administracion.proveedores.detalle.ProveedoresDetalleMain', 
    'HreRem.view.gastos.GastoDetalleMain', 'HreRem.model.GastoProveedor', 'HreRem.model.GastoAviso', 'HreRem.view.administracion.juntas.JuntasDetalleMain',
    'HreRem.view.administracion.juntas.GestionJuntas','HreRem.model.ActivoSaneamiento', 'HreRem.model.GastoAsociadoAdquisicionModel'],


    requires: ['HreRem.view.configuracion.administracion.perfiles.detalle.DetallePerfil', 'HreRem.view.expedientes.ExpedienteDetalleMain', 'HreRem.view.gastos.GastoDetalleMain', 
    	'HreRem.view.configuracion.administracion.proveedores.detalle.ProveedoresDetalleMain'],
    
    refs: [
				{
					ref: 'activosMain',
					selector: 'activosmain'
				},
				{
					ref: 'agrupacionesMain',
					selector: 'agrupacionesmain'
				},
				{
					ref: 'trabajosMain',
					selector: 'trabajosmain'
				},
				{
					ref: 'activosDetalleMain',
					selector: 'activosdetallemain'
				},
				{
					ref: 'DatosGeneralesActivo',
					selector: 'datosgeneralesactivo'
				},
				{
					ref: 'configuracionMain',
					selector: 'configuracionmain'
				},
				{
				    ref: 'gastodetallemain',
				    selector: 'gastodetallemain'
				}
					
	],
    
    
    control: {
    	
    	'activosmain' : {    		
    		abrirDetalleActivo : 'abrirDetalleActivo',
    		abrirDetalleActivoOfertas: 'abrirDetalleActivoComercialOfertas',
    		abrirDetalleActivoById: 'abrirDetalleActivoById',
    		onSaveFormularioCompleto: 'onSaveFormularioCompleto',
    		cerrarTodas: 'cerrarTodas',
    		abrirDetalleExpedienteOferta: 'abrirDetalleExpedienteOferta'
    	},
    	
    	/**
		 * De esta manera conseguimos que todas aquellas pestañas marcadas para refrescar, llamen a su funcion de refresco correspondiente.
		 * En este punto la función funcionRecargar existirá porque unicamente se marcan aquellas pestañas que la tengan.
		 */
    	'activosmain component[recargar=true]' : {
    		beforeshow: function(tab) {tab.funcionRecargar();}
    	},
    	
    	'agrupacionesactivo' : {
			abrirDetalleAgrupacion : 'abrirDetalleAgrupacionActivo'
    	},
    	
    	'visitascomercialdetalle':{
    		abrirDetalleProveedorDirectly: 'abrirDetalleProveedorById'
    	},

    	'activosdetallemain' : {
        	crearnotificacion: 'crearNotificacion',
        	abrirDetalleTramite : 'abrirDetalleTramite',
        	abrirDetalleTrabajo: 'abrirDetalleTrabajo',
        	abrirDetalleExpediente: 'abrirDetalleExpediente',
        	refrescarActivo: 'refrescarDetalleActivo',
        	abrirDetalleActivo: 'abrirDetalleActivoById',
        	abrirDetalleProveedor: 'abrirDetalleProveedor',
        	abrirDetalleExpedienteById: 'abrirDetalleExpedienteById',
        	abrirDetallePlusvalia: 'abrirDetallePlusvalia',
        	abrirDetalleGasto: 'abrirDetalleGasto',
        	abrirDetalleGastoTasacion: 'abrirDetalleGastoTasacion'
    	},

    	'tareagenerica' : {
        	actualizarGridTareas: 'actualizarGridTareas',
			abrirDetalleTrabajoById: 'abrirDetalleTrabajoById',
			abrirDetalleActivoPrincipal: 'abrirDetalleActivoPrincipal',
        	abrirDetalleExpedienteById: 'abrirDetalleExpedienteById'
		},
		    	
    	'tareaNotificacion' : {
        	actualizarGridTareas: 'actualizarGridTareas',
			abrirDetalleTrabajoById: 'abrirDetalleTrabajoById',
			abrirDetalleActivoPrincipal: 'abrirDetalleActivoPrincipal',
        	abrirDetalleExpedienteById: 'abrirDetalleExpedienteById',
        	abrirDetalleAgrupacionById: 'abrirDetalleAgrupacionById'
    	},
    	
    	'agrupacionesmain' : {
    		
    		abrirDetalleAgrupacion : 'abrirDetalleAgrupacion',
		    abrirDetalleActivo : 'abrirDetalleActivo',
		    abrirDetalleAgrupacionDirecto: 'abrirDetalleAgrupacionDirecto'
		    
    	},
    	
    	'agrupacionesdetallemain' : {    		
		    abrirDetalleActivo : 'abrirDetalleActivoById',
		    refrescarAgrupacion: 'refrescarDetalleAgrupacion',
		    abrirDetalleExpediente: 'abrirDetalleExpediente'
    	},
    	
    	'trabajosmain' : {    		
			abrirDetalleTrabajo: 'abrirDetalleTrabajo',
			abrirDetalleAgrupacion: function(idAgrupacion) {
				var me = this;
    			me.abrirDetalleAgrupacionById(idAgrupacion);      
			},
			abrirDetalleAgrupacionByNum: function(numAgrupRem){
				var me= this;
				me.abrirDetalleAgrupacionByNumAgrupRem(numAgrupRem);
			},
			abrirDetalleActivo: function(idActivo) {
				var me = this;
    			me.abrirDetalleActivoById(idActivo);      
			},
			abrirDetalleTrabajoDirecto: 'abrirDetalleTrabajoDirecto'
    	},
    	
    	'trabajosdetalle' : {
    		abrirDetalleActivo: 'abrirDetalleActivoById',
        	abrirDetalleTramite : 'abrirDetalleTramite',
        	abrirDetalleTramiteTarea : 'abrirDetalleTramiteTarea',
        	abrirDetalleTramiteHistoricoTarea : 'abrirDetalleTramiteHistoricoTarea',
    		refrescarTrabajo: 'refrescarDetalleTrabajo',
    		abrirDetalleGastoById: 'abrirDetalleGastoById'
    	},
    	
    	'tramitesdetalle' : {
            abrirDetalleActivo: 'abrirDetalleActivo',
            abrirDetalleActivoPrincipal: 'abrirDetalleActivoPrincipal',
    		refrescarTramite: 'refrescarDetalleTramite'
    	},
	
    	'publicacionmain' : {
    		abrirDetalleActivoPrincipal: 'abrirDetalleActivoPublicacion'
    	},
    	
    	'preciosmain' : {
    		abrirDetalleActivoPrincipal: 'abrirDetalleActivoPropuestaPrecio',
			abrirDetalleTrabajo: 'abrirDetalleTrabajo'
    	},
    	
    	'menufavoritos': {
    		
    		abrirfavoritoactivo: function(menuFavoritos, favorito) {
    			
    			var me = this;
    			menuFavoritos.lookupController().redirectTo('activos' , true);
    			me.abrirDetalleActivoById(favorito.openId, favorito.text);      			
    			
    		},
    		
    		abrirfavoritoagrupacion: function(menuFavoritos, favorito) {
    			    			
    			var me = this;
    			menuFavoritos.lookupController().redirectTo('activos' , true);
    			me.abrirDetalleAgrupacionById(favorito.openId, favorito.text);  
    			
    		},
    		
    		abrirfavoritotrabajo: function(menuFavoritos, favorito) {
    			    			
    			var me = this;
    			menuFavoritos.lookupController().redirectTo('activos' , true);
    			me.abrirDetalleTrabajoById(favorito.openId, favorito.text);  
    			
    		}
    	},
    	
    	'visitascomercialmain': {    		
			abrirDetalleActivo: 'abrirDetalleActivoComercialVisitas'
    	},
    	
    	'gencatcomercialactivo': {    		
			abrirDetalleActivo: 'abrirDetalleActivoComercialGencat'
    	},
    	
    	'ofertascomercialmain': {
    		abrirDetalleActivo: 'abrirDetalleActivoComercialOfertas',
			abrirDetalleAgrupacion : 'abrirDetalleAgrupacionComercialOfertas',
			abrirDetalleExpediente: 'abrirDetalleExpediente',
			abrirDetalleExpedienteDirecto: 'abrirDetalleExpedienteDirecto'
    	},
    	
    	'expedientedetallemain': {
    		abrirDetalleActivoPrincipal: 'abrirDetalleActivoPrincipal',
    		abrirDetalleTramiteTarea : 'abrirDetalleTramiteTarea',
    		abrirDetalleTramiteHistoricoTarea : 'abrirDetalleTramiteHistoricoTarea',
			refrescarExpediente: 'refrescarExpedienteComercial',
			abrirDetalleTrabajoById: 'abrirDetalleTrabajoById'
    	},
    	
    	'expedientedetalle': {
    		abrirDetalleExpedienteOferta: 'abrirDetalleExpedienteOferta' 
    	},
    	
    	'configuracionmain': {
    		abrirDetalleProveedor: 'abrirDetalleProveedor',
    		abrirDetallePerfil: 'abrirDetallePerfil'
    	},
    	'administraciongastosmain': {
    		abrirDetalleGasto: 'abrirDetalleGasto',
    		abrirDetalleGastoDirecto: 'abrirDetalleGastoDirecto'
    	},
    	'gestionplusvalia': {
    		abrirDetallePlusvalia: 'abrirDetallePlusvalia'
    	},
    	'administracionjuntasmain': {
    		abrirDetalleJunta: 'abrirDetalleJunta'
    		
    	},
    	'gastodetallemain': {
    		abrirDetalleActivo: 'abrirDetalleActivoGastosActivos',
    		abrirDetalleTrabajo: 'abrirDetalleTrabajo',
    		refrescarGasto: 'refrescarDetalleGasto',
    		abrirDetalleActivoPreciosTasacion: 'abrirDetalleActivoPreciosTasacion'
    	},
    	
    	'gencatcomercialactivo':{
    		abrirDetalleExpedienteOferta: 'abrirDetalleExpedienteOferta'
    	},
    	'albaranesMain': {
    		abrirDetalleTrabajo: 'abrirDetalleTrabajo'
    	}

    },

    refrescarDetalleActivo: function (detalle) {
    	var me = this,
    	id = detalle.getViewModel().get("activo.id");

    	HreRem.model.Activo.load(id, {
    		scope: this,
		    success: function(activo) {
				if(!Ext.isEmpty(detalle.getViewModel())) {
					// Continuar si el activo sigue abierto en el tabpanel y su modelo existe.
					detalle.getViewModel().getStore('comboTipoGestorByActivo').load();
					detalle.getViewModel().set("activo", activo);
					detalle.configCmp(activo);

			        HreRem.model.ActivoAviso.load(id, {
			            scope: this,
						success: function(avisos) {
							detalle.getViewModel().set("avisos", avisos);
					    }
					});
			        me.logTime("Fin Set values");
			       }
		    }
		});
    },

    abrirDetalleActivo: function(record) {
    	var me = this,
    	id = record.get("id");    	
	    var titulo = "Activo " + record.get("numActivo");    
    	
    	me.abrirDetalleActivoById(id, titulo );    	
    	
    },
    
    abrirDetalleActivoPrincipal: function(idActivo, refLinks) {
    	var me = this;
    	
    	me.abrirDetalleActivoById(idActivo, null, refLinks);
    },
    
    abrirDetalleActivoById: function(id, titulo, refLinks) {
    	var me = this,   	
    	cfg = {}, 
    	tab = null;
    	cfg.title = titulo;
    	tab = me.createTab (me.getActivosMain(), 'activo', "activosdetallemain",  id, cfg);
    	//Ext.suspendLayouts();
    	tab.mask(HreRem.i18n("msg.mask.loading"));
    	me.setLogTime();
    	HreRem.model.Activo.load(id, {
    		scope: this,
		    success: function(activo) {

		    	me.logTime("Load activo success"); 
		    	me.setLogTime();
		    	
		    	if(Ext.isEmpty(titulo)) {
		    		titulo = "Activo " + activo.get("numActivo");
		    		tab.setTitle(titulo);
		    	}
		    	tab.getViewModel().set("activo", activo);
		    	tab.configCmp(activo);
		    	
		    	HreRem.model.ActivoAviso.load(id, {
		    		scope: this,
				    success: function(avisos) {
				    	if (tab != null && tab.getViewModel() != null)
				    		tab.getViewModel().set("avisos", avisos);
				    }
				});
				tab.unmask();
		    	//Ext.resumeLayouts(true);
		    	
				/* Selector de subPestanyas del Trabajo:
		    	 * - Se hace la comprobacion aqui (ademas de dentro de la funcion), 
		    	 * para evitar el uso de Notify() si no hay activacion de pesta�as (refLinks != null)
		    	 */
		    	if (refLinks != null){
		    		var selectTab = new Ext.util.DelayedTask(function(){
						tab.getViewModel().notify();
						me.seleccionarTabByXtype(tab, refLinks);
					});
					// Necesario para priorizar el renderizado de la primera pestaña, y para el caso de tener que seleccionar otra más del segundo nivel.
					selectTab.delay(1);
				}
				
		     	me.logTime("Fin Set values " + id);
		     	
		     	//me.getView().fireEvent('openModalWindow', "HreRem.view.activos.detalle.seleccionmasivo.SeleccionCambiosMasivo");
		    },
		    failure: function (a, operation) {
				if(!Ext.isEmpty(operation) && !Ext.isEmpty(operation.getResponse())){
			    	if(operation.getResponse().status === 408){
			    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			    	}else{
			    		var response = Ext.decode(operation.getResponse().responseText);
		 		    	me.fireEvent("errorToast", response.error);
			    	}
				}else{
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				}
				tab.unmask();
				//Ext.resumeLayouts(true);
	       	}
		});
		
    },
    
    seleccionarTabByXtype: function (tab, refLinks) {

		/* - seleccionarTabByXtype es una funcion que se llama a si misma recursivamente, 
		 *   tantas veces como xtype de pesta�as contenga refLinks, separados por puntos
		 * - Cada llamada activa una pesta�a por xtype y pasa a la siguiente llamada el resto
    	 * - La 1a llamada debe ir precedida por un Notify(), que es necesario para evitar un error
    	 *   por falta de alg�n dato. El error bloquea la aplicacion 
    	 * - Notify() se hace fuera de la funcion selectora porque no se puede usar en llamadas recursivas
		 */
		if (refLinks != null){
	    	var me = this,
	    	tabActivo= null,
	    	activeTabXtype = null,
	    	refs = refLinks.split('.');
	    	
	    	var array = tab.getXTypes().split('/')
	    	
	    	if(array.indexOf('tabpanel') != -1){
	    		var tabActivo = tab;
	    	}
	    	else{
	    		tabActivo = tab.down('tabpanel');
	    	}
	    	
	    	activeTabXtype = refs[0];
			var slicedRefLinks = refLinks.split('.').slice(1).join('.');
			var nextActiveTab = tabActivo.down('[xtype='+ activeTabXtype +']');
	    	tabActivo.getLayout().setActiveItem(tabActivo.items.indexOf(nextActiveTab));

			if (refs.length > 1){
				tabActivo = tab.down(' '+activeTabXtype+' ');
				me.seleccionarTabByXtype(tabActivo, slicedRefLinks);
			}

    	}

    },
    
    refrescarDetalleAgrupacion: function (detalle) {
    	
    	var me = this,
    	id = detalle.getViewModel().get("agrupacionficha.id");
    	
    	HreRem.model.AgrupacionFicha.load(id, {
    		scope: this,
		    success: function(agrupacion) {
		    	me.logTime("Load agrupacion success"); 
		    	me.setLogTime();    	
		    	
		    	detalle.getViewModel().set("agrupacionficha", agrupacion);
		    	detalle.configCmp(agrupacion);
		    	
		    	HreRem.model.AgrupacionAviso.load(id, {
		    		scope: this,
				    success: function(avisos) {
				    	detalle.getViewModel().set("avisos", avisos);
				    	
				    }
				});
		    }
		});
    	
    },
    
    abrirDetalleActivoPublicacion: function(record) {
    	var me = this,
    	titulo = "Activo " + record.get("numActivo"),
    	id = record.get("id");
		me.redirectTo('activos', true);
    	me.abrirDetalleActivoPrincipal(id, CONST.MAP_TAB_ACTIVO_XTYPE['PUBLICACION_DATOS']);
    },
    
    abrirDetalleAgrupacion: function(record) {
 
    	var me = this,
    	titulo = "Agrupación " + record.get("numAgrupacionRem"),
    	id = record.get("id");		
		me.redirectTo('activos', true);   
		
    	me.abrirDetalleAgrupacionById(id, titulo);    	
    	
    },
    abrirDetalleAgrupacionDirecto: function(id, titulo) {
    	   	 
    	var me = this;
    	me.redirectTo('activos', true);   		
    	
    	me.abrirDetalleAgrupacionById(id, titulo);    	
        	
     },
    
    abrirDetalleAgrupacionById: function(id, titulo) {
    	var me = this,    	
    	cfg = {}, 
    	tab = null;

    	cfg.title = titulo;

    	tab = me.createTab (me.getActivosMain(), 'agrupacion', "agrupacionesdetallemain",  id, cfg);
    	tab.mask(HreRem.i18n("msg.mask.loading"));
    	me.setLogTime(); 
    	
    	HreRem.model.AgrupacionFicha.load(id, {
    		scope: this,
		    success: function(agrupacion) {
		    	
		    	me.logTime("Load agrupacion success"); 
		    	me.setLogTime();
		    	
		    	if(Ext.isEmpty(titulo)) {
		    		titulo = "Agrupacion " + agrupacion.get("numAgrupRem");
		    		tab.setTitle(titulo);
		    	}
		    	
		    	tab.getViewModel().set("agrupacionficha", agrupacion);
		    	tab.configCmp(agrupacion);
		    	
		    	HreRem.model.AgrupacionAviso.load(id, {
		    		scope: this,
				    success: function(avisos) {
				    	if (tab != null && tab.getViewModel() != null)
				    		tab.getViewModel().set("avisos", avisos);
				    	
				    }
				});

				tab.unmask();
		    	me.logTime("Fin Set values"); 
		    },
		    failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				tab.unmask();
	       	}
		});

    },  
    
    abrirDetalleAgrupacionByNumAgrupRem: function(numAgrupRem, titulo) {
    	var me = this,    	
    	cfg = {}, 
    	tab = null;
    	cfg.title = titulo;

    	tab = me.createTab (me.getActivosMain(), 'agrupacion', "agrupacionesdetallemain",  numAgrupRem, cfg);
    	tab.mask(HreRem.i18n("msg.mask.loading"));
    	me.setLogTime(); 
    	
    	
    	var url =  $AC.getRemoteUrl('agrupacion/getAgrupacionBynumAgrupRem');
    	var data;
		Ext.Ajax.request({
			
		     url: url,
		     params: {numAgrupRem : numAgrupRem},
		
		     success: function(response, opts) {
		    	 data = Ext.decode(response.responseText);
		    	 var id= data.data;
		    	 HreRem.model.AgrupacionFicha.load(id, {
		     		scope: this,
		 		    success: function(agrupacion) {
		 		    	me.logTime("Load agrupacion success"); 
		 		    	me.setLogTime();
		 		    	if(Ext.isEmpty(titulo)) {
		 		    		titulo = "Agrupacion " + agrupacion.get("numAgrupRem");
		 		    		tab.setTitle(titulo);
		 		    	}
		 		    	
		 		    	tab.getViewModel().set("agrupacionficha", agrupacion);
		 		    	tab.configCmp(agrupacion);
		 		    	
		 		    	HreRem.model.AgrupacionAviso.load(id, {
		 		    		scope: this,
		 				    success: function(avisos) {
		 				    	if (tab != null && tab.getViewModel() != null)
		 				    		tab.getViewModel().set("avisos", avisos);
		 				    	
		 				    }
		 				});

		 				tab.unmask();
		 		    	me.logTime("Fin Set values"); 
		 		    },
		 		    failure: function (a, operation) {
		 				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		 				tab.unmask();
		 	       	}
		 		});
		         
		     }		     
		 });
    	
    },
    
    //FIXME: Unir con el método abrirDetalleAgrupacion cuando se modifique para que no traiga objetos a la vista
    
    abrirDetalleAgrupacionActivo: function(record) {
    	
    	var me = this,
    	titulo = "Agrupación " + record.get("numAgrupRem"),
    	id = record.get("idAgrupacion");
		
		me.redirectTo('activos', true);    	
    	me.abrirDetalleAgrupacionActivoById(id, titulo);    	
    	
    },

    abrirDetalleAgrupacionActivoById: function(id, titulo) {
    	var me = this,    	
    	cfg = {}, 
    	tab = null;
    	cfg.title = titulo;
     	
    	if(!Ext.isEmpty(titulo)) {
    		tab = me.createTab (me.getActivosMain(), 'agrupacion', "agrupacionesdetallemain",  id, cfg);
    		me.getActivosMain().mask(HreRem.i18n("msg.mask.loading"));
    	}

    	me.setLogTime(); 
    	HreRem.model.AgrupacionFicha.load(id, {
    		scope: this,
		    success: function(agrupacion) {
		    	me.logTime("Load agrupacion success"); 
		    	me.setLogTime();
		    	var tab = me.getActivosMain().items.getByKey('agrupacion_' + id);
		    	if(Ext.isEmpty(tab)) {		    		
		    		cfg.title = "Agrupacion " + agrupacion.get("numAgrupRem");
		    		tab = me.createTab (me.getActivosMain(), 'agrupacion', "agrupacionesdetallemain",  id, cfg);
    				me.getActivosMain().mask(HreRem.i18n("msg.mask.loading"));		    		
		    	}
		    	
		    	tab.getViewModel().set("agrupacionficha", agrupacion);
		    	tab.configCmp(agrupacion);
		    	
		    	HreRem.model.AgrupacionAviso.load(id, {
		    		scope: this,
				    success: function(avisos) {
				    	if (tab != null && tab.getViewModel() != null)
				    		tab.getViewModel().set("avisos", avisos);
				    	
				    }
				});
		    	
		    	me.getActivosMain().unmask();
		    	me.logTime("Fin Set values"); 
		    },
		    failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				tab.unmask();
	       	}
		});

    },
    
    refrescarDetalleTrabajo: function (detalle) {
    	
    	var me = this,
    	id = detalle.getViewModel().get("trabajo.id");
    	
    	HreRem.model.FichaTrabajo.load(id, {
    		scope: this,
		    success: function(trabajo) {
		    	detalle.getViewModel().set("trabajo", trabajo);		    	
		    	detalle.configCmp(trabajo);
		    	
		    	HreRem.model.TrabajoAviso.load(id, {
		    		scope: this,
				    success: function(avisos) {
				    	detalle.getViewModel().set("avisos", avisos);
				    }
				});
		    	me.logTime("Fin Set values"); 
		    }
		});
    	
    },
    
    abrirDetalleTrabajo: function(record, refLinks) {
		
    	var me = this,
    	titulo = "Trabajo " + record.get("numTrabajo"),
    	id = record.get("id");
		me.redirectTo('activos', true);    	
    	me.abrirDetalleTrabajoById(id, titulo, refLinks);    	
    	
    },
    abrirDetalleTrabajoDirecto: function(id, titulo) {
    	var me = this;
    	me.redirectTo('activos', true);    	
    	me.abrirDetalleTrabajoById(id, titulo);    	
    },
    
    abrirDetalleTrabajoById: function(id, titulo, refLinks) {
		
    	var me = this,
    	cfg = {}, 
    	tab=null;

    	cfg.title = titulo;
    	tab = me.createTab (me.getActivosMain(), 'trabajo', "trabajosdetalle",  id, cfg);
    	tab.mask(HreRem.i18n('msg.mask.loading'));
    	me.setLogTime(); 
    	
    	HreRem.model.FichaTrabajo.load(id, {
    		scope: this,
		    success: function(trabajo) {
		    	me.logTime("Load trabajo success"); 
		    	me.setLogTime();
		    			    	
		    	if(Ext.isEmpty(titulo)) {		    		
		    		titulo = "Trabajo " + trabajo.get("numTrabajo");
		    		tab.setTitle(titulo);
		    	}
		    	
		    	tab.getViewModel().set("trabajo", trabajo);
		    	tab.configCmp(trabajo);
		    	var form = tab.lookupController().lookupReference("fichatrabajo");
		    	if(Ext.isFunction(form.afterLoad)) {
		    		form.afterLoad();
		    	}
		    	HreRem.model.TrabajoAviso.load(id, {
		    		scope: this,
				    success: function(avisos) {
			    		var tab = me.getActivosMain().items.getByKey('trabajo_' + id);
			    		if (tab != null && tab.getViewModel() != null)
			    			tab.getViewModel().set("avisos", avisos);				    	
				    }
				});
				
				
				/* Selector de subPestanyas del Trabajo:
		    	 * - Se hace la comprobacion aqui (ademas de dentro de la funcion), 
		    	 * para evitar el uso de Notify() si no hay activacion de pesta�as (refLinks != null)
		    	 */
		    	if (refLinks != null){
		    		tab.getViewModel().notify();
					me.seleccionarTabByXtype(tab, refLinks);
				}
				
				tab.unmask();

		    	me.logTime("Fin Set values"); 
		    },
		    failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				tab.unmask();
	       	}
		});

    },
    
    refrescarExpedienteComercial: function (detalle) {
    	
    	var me = this,
    	id = detalle.getViewModel().get("expediente.id");
    	HreRem.model.ExpedienteComercial.load(id, {
    		scope: this,
		    success: function(expediente) {
		    	
		    	detalle.getViewModel().set("expediente", expediente);		    	
		    	detalle.configCmp(expediente);
		    	
		    	HreRem.model.ExpedienteAviso.load(id, {
		    		scope: this,
				    success: function(avisos) {
			    		detalle.getViewModel().set("avisos", avisos);				    	
				    }
				});
		    }
		});
    	
    },
    
    abrirDetalleExpediente: function(record, refLinks) {
    	var me = this,
    	titulo = "Expediente " + record.get("numExpediente"),
    	id = record.get("idExpediente");
		me.redirectTo('activos', true);    	
    	me.abrirDetalleExpedienteById(id, titulo, refLinks);    	   	
    },
    
    abrirDetalleExpedienteOferta: function(data, refLinks) {
    	var me = this,
    	titulo = "Expediente " + data.numExpediente,
    	id = data.id;
		me.redirectTo('activos', true);    	
    	me.abrirDetalleExpedienteById(id, titulo, refLinks);    	   	
    },
    
    abrirDetalleExpedienteDirecto: function(id, titulo, refLinks) {
    	var me = this;
    	me.redirectTo('activos', true);    	
    	me.abrirDetalleExpedienteById(id, titulo, refLinks);
    },
    
    abrirDetalleExpedienteById: function(id, titulo, refLinks) {
    	var me = this,
    	cfg = {}, 
    	tab=null;

    	cfg.title = titulo;
    	tab = me.createTab (me.getActivosMain(), 'expediente', "expedientedetallemain",  id, cfg);
    	tab.mask(HreRem.i18n('msg.mask.loading'));
    	me.setLogTime(); 
    	
    	HreRem.model.ExpedienteComercial.load(id, {
    		scope: this,
		    success: function(expediente) {
		    	me.logTime("Load expediente success"); 
		    	me.setLogTime();	    	
		    	if(Ext.isEmpty(titulo)) {		    		
		    		titulo = "Expediente " + expediente.get("numExpediente");
		    		tab.setTitle(titulo);
				}
				
		    	tab.getViewModel().set("expediente", expediente);
		    	tab.configCmp(expediente);
		    	
		    	HreRem.model.ExpedienteAviso.load(id, {
		    		scope: this,
				    success: function(avisos) {
			    		//var tab = me.getActivosMain().items.getByKey('expediente_' + id);
			    		if (tab != null && tab.getViewModel() != null)
			    			tab.getViewModel().set("avisos", avisos);				    	
				    }
				});
				
				
				/* Selector de subPestanyas del Trabajo:
		    	 * - Se hace la comprobacion aqui (ademas de dentro de la funcion), 
		    	 * para evitar el uso de Notify() si no hay activacion de pesta�as (refLinks != null)
		    	 */
		    	if (refLinks != null){
		    		tab.getViewModel().notify();
					me.seleccionarTabByXtype(tab, refLinks);
				}
				
				tab.unmask();

		    	me.logTime("Fin Set values"); 
		    },
		   	failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				tab.unmask();
	       	}
		});

    },
    
    abrirDetalleAgrupacionComercialOfertasById: function(id, titulo, refLinks) {
    	var me = this,
    	cfg = {}, 
    	tab=null;

    	cfg.title = titulo;
    	tab = me.createTab (me.getActivosMain(), 'agrupacion', "agrupacionesdetallemain",  id, cfg);
    	tab.mask(HreRem.i18n('msg.mask.loading'));
    	me.setLogTime(); 
    	
    	HreRem.model.AgrupacionFicha.load(id, {
    		scope: this,
		    success: function(agrupacion) {
		    	me.logTime("Load agrupacion success"); 
		    	me.setLogTime();	    	
		    	if(Ext.isEmpty(titulo)) {		    		
		    		titulo = "Agrupacion " + agrupacion.get("numAgrupRem");
		    		tab.setTitle(titulo);
		    	}
		    	
		    	tab.getViewModel().set("agrupacionficha", agrupacion);
		    	tab.configCmp(agrupacion);
		    	
		    	
				HreRem.model.AgrupacionAviso.load(id, {
		    		scope: this,
				    success: function(avisos) {
				    	if (tab != null && tab.getViewModel() != null)
				    		tab.getViewModel().set("avisos", avisos);
				    	
				    }
				});
				tab.unmask();
				/* Selector de subPestanyas del Trabajo:
		    	 * - Se hace la comprobacion aqui (ademas de dentro de la funcion), 
		    	 * para evitar el uso de Notify() si no hay activacion de pesta�as (refLinks != null)
		    	 */
		    	if (refLinks != null){
		    		tab.getViewModel().notify();
					me.seleccionarTabByXtype(tab, refLinks);
				}
				
		    	me.logTime("Fin Set values"); 
		    },
		    failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				tab.unmask();
	       	}
		});

    },

    
    /**
     * Crea una pestaña en función de los parametros recibidos.
     * @param {} tabpanel donde crear el tab
     * @param {} prefix para añadir al id del tab
     * @param {} xtype clase a instanciar
     * @param {} rec modelo que servirá para pintar la información el tab
     * @param {} cfg configuración del tab
     */
	createTab: function (tabpanel, prefix, xtype, id, cfg) {


    	var me = this,
		itemId = prefix + '_' + id,
		tab = tabpanel.items.getByKey(itemId);
		
		if(Ext.isEmpty(cfg)) {
			cfg = {};
		}
		me.setLogTime();
		
		Ext.suspendLayouts();
		
        if (!tab) {
            cfg.itemId = itemId;
            cfg.xtype = xtype;
            cfg.closable = true;
            cfg.session= true;
            tab = tabpanel.add(cfg);
            me.logTime("tabpanel add");
        }     
        
        tabpanel.setActiveTab(tab);
		me.setLogTime();
		Ext.resumeLayouts(true);
	    me.logTime("setActive(tab)");
	    
	    return tab;

	},
	
	onSaveFormularioCompleto: function(form) {		

		var recordTemporal = form.getRecord();
		var record = form.updateRecord(recordTemporal).getRecord();
		record.save();	

	},
	
    crearNotificacion: function(idActivo){
        var window;
        window = Ext.create('HreRem.view.activos.CrearNotificacion',idActivo);
        window.getViewModel().set("idActivo",idActivo);
	    window.show();
    },
    
    refrescarDetalleTramite: function(detalle) {
    	
    	var me = this,
    	id = detalle.getViewModel().get("tramite.idTramite") ;    	
    	HreRem.model.Tramite.load(id, {
    		scope: this,
		    success: function(tramite) {
		        if(!Ext.isEmpty(detalle.getViewModel())) {
		            // Continuar si el trámite sigue abierto en el tabpanel y su modelo existe.
		            detalle.getViewModel().set("tramite", tramite);
		        }
		    }
		});
    	
    },
    
    abrirDetalleTramite: function(grid,record) {

    	var me = this;
    	//Sacar que valor le paso para referenciar el trámite
    	var titulo = "Tramite " + record.get("idTramite");
    	var idRecord = record.get("idTramite");
    	
    	me.abrirDetalleTramiteById(idRecord, titulo );    	
    	
    },

    abrirDetalleTramiteTarea: function(grid,record) {

    	var me = this;
    	//Sacar que valor le paso para referenciar el trámite
    	var titulo = "Tramite " + record.get("idTramite");
    	var idRecord = record.get("idTramite");
    	
    	me.abrirDetalleTramiteTareasById(idRecord, titulo, 'tareaslist' );    	
    	
    },

    abrirDetalleTramiteHistoricoTarea: function(grid,record) {

    	var me = this;
    	//Sacar que valor le paso para referenciar el trámite
    	var titulo = "Tramite " + record.get("idTramite");
    	var idRecord = record.get("idTramite");
    	
    	me.abrirDetalleTramiteTareasById(idRecord, titulo, 'historicotareaslist' );    	
    	
    },
                
    abrirDetalleTramiteById: function(id, titulo) {
    	
    	var me = this;
    	var cfg = {};
    	cfg.title = titulo;
     	
    	var tab = me.createTab (me.getActivosMain(), 'tramite', "tramitesdetalle",  id, cfg);    	
		tab.mask(HreRem.i18n('msg.mask.loading'));
    	me.setLogTime(); 
    	HreRem.model.Tramite.load(id, {
    		scope: this,
		    success: function(tramite) {
		    	me.logTime("Load tramite success"); 
		    	me.setLogTime(); 
		    	tab.getViewModel().set("tramite", tramite);
		    	me.logTime("Fin Set values");
				tab.unmask();
		    },
		    failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				tab.unmask();
	       	}
		});
    },
    
    abrirDetalleTramiteTareasById: function(id, titulo, activeTabXtype) {
    	
    	var me = this;
    	var cfg = {};
    	cfg.title = titulo;
     	
    	var tab = me.createTab (me.getActivosMain(), 'tramite', "tramitesdetalle",  id, cfg);    	
		tab.mask(HreRem.i18n('msg.mask.loading'));
    	me.setLogTime(); 
    	HreRem.model.Tramite.load(id, {
    		scope: this,
		    success: function(tramite) {
		    	me.logTime("Load tramite success"); 
		    	me.setLogTime(); 
		    	tab.getViewModel().set("tramite", tramite);
		    	//tab.configCmp(tramite);
		    	me.logTime("Fin Set values");
		    	me.idActivo = tramite.get("idActivo");
				tab.unmask();
		    },
		    failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				tab.unmask();
	       	}
		});

    	var tabTramites = tab.down('[xtype=tramitesdetalletab]');
    	tabTramites.getLayout().setActiveItem(tabTramites.items.indexOf(tabTramites.down('[xtype='+ activeTabXtype +']')));
    },
    
    actualizarGridTareas: function() {
		this.getActivosMain().getActiveTab().down('grid').getStore().load();
		this.getActivosMain().getActiveTab().down('historicotareaslist').down('grid').getStore().load();
        
    },
    

    cerrarTodas: function(tabpanel) {
    	
    	var me = this;
    	
    	var numTabs = tabpanel.items.length;
    	Ext.suspendLayouts();
    	for(var i = numTabs; i > 0; i--)
    	{
    		var tab = tabpanel.items.getAt(i-1);
    		if (tab.closable) {
        		tabpanel.remove(tab);
        		tab.destroy();
    		}
    	}
    	Ext.resumeLayouts(true);
    },
    
    
    abrirDetalleAgrupacionComercialOfertas: function(record) {
    	var me = this,
    	titulo = null,//,"Agrupación " + record.get("numAgrupacionRem"),
    	id = record.get("idAgrupacion");
		me.redirectTo('activos', true);
    	me.abrirDetalleAgrupacionComercialOfertasById(id, titulo, CONST.MAP_TAB_ACTIVO_XTYPE['OFERTASAGRU'])
    },
    
    abrirDetalleActivoComercialVisitas: function(record) {
    	var me = this,
    	titulo = "Activo " + record.get("numActivo"),
    	id = record.get("idActivo");
		me.redirectTo('activos', true);
    	me.abrirDetalleActivoPrincipal(id, CONST.MAP_TAB_ACTIVO_XTYPE['VISITAS'])
    },
    
    abrirDetalleActivoComercialGencat: function(record) {
    	var me = this,
    	titulo = "Activo " + record.get("numActivo"),
    	id = record.get("idActivo");
		me.redirectTo('activos', true);
    	me.abrirDetalleActivoPrincipal(id, CONST.MAP_TAB_ACTIVO_XTYPE['GENCAT'])
    },
    
    abrirDetalleActivoGastosActivos: function(record) {
    	var me = this,
    	titulo = "Activo " + record.get("numActivo"),
    	id = record.get("idActivo");
		me.redirectTo('activos', true);
    	me.abrirDetalleActivoPrincipal(id, null)
    },
    
    abrirDetalleActivoComercialOfertas: function(record) {
    	var me = this,
    	titulo = "Activo " + record.get("numActivo"),
    	id = record.get("idActivo");
		me.redirectTo('activos', true);
		me.abrirDetalleActivoPrincipal(id, CONST.MAP_TAB_ACTIVO_XTYPE['OFERTAS']);
    },

    abrirDetalleActivoPropuestaPrecio: function(record) {
    	var me = this,
    	titulo = "Activo " + record.get("numActivo"),
    	id = record.get("idActivo");
		me.redirectTo('activos', true);
    	me.abrirDetalleActivoPrincipal(id, CONST.MAP_TAB_ACTIVO_XTYPE['PROPUESTAS'])
    },
    
    abrirDetalleProveedor: function(record, refLinks) {
    	var me = this,
    	titulo = "Proveedor " + record.get("codigo"),
    	id = record.get("id");
		me.redirectTo('activos', true);    	
    	me.abrirDetalleProveedorById(id, titulo, refLinks);    	
    	
    },
    
    abrirDetalleProveedorById: function(id, titulo, refLinks) {
    	var me = this,
    	cfg = {}, 
    	tab=null;

    	cfg.title = titulo;
    	tab = me.createTab (me.getActivosMain(), 'proveedor', "proveedoresdetallemain",  id, cfg);
    	tab.mask(HreRem.i18n('msg.mask.loading'));
    	me.setLogTime(); 
    	
    	HreRem.model.FichaProveedorModel.load(id, {
    		scope: this,
		    success: function(proveedor) {
		    	me.logTime("Load provedor success"); 
		    	me.setLogTime();
		    			    	
		    	if(Ext.isEmpty(titulo)) {		    		
		    		titulo = "Proveedor " + proveedor.get("id");
		    		tab.setTitle(titulo);
		    	}
		    	
		    	tab.getViewModel().set("proveedor", proveedor);
		    	tab.configCmp(proveedor);

				tab.unmask();

		    	me.logTime("Fin Set values"); 
		    },
		    failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				tab.unmask();
	       	}
		});

    },
    
    abrirDetallePerfil: function(record, refLinks) {
    	console.log(record);
    	var me = this,
    	id = record.get("pefId"),
    	titulo = "Perfil " + id;
    	console.log(record.get("pefId"));
		me.redirectTo('activos', true); 	
    	me.abrirDetallePerfilById(id, titulo, refLinks);    	
    },
    
    abrirDetallePerfilById: function(id, titulo, refLinks) {
    	var me = this,
    	cfg = {}, 
    	tab=null;

    	cfg.title = titulo;
    	tab = me.createTab(me.getActivosMain(), 'perfil', 'detalleperfil',  id, cfg);
    	tab.mask(HreRem.i18n('msg.mask.loading'));
    	me.setLogTime();
    	
    	HreRem.model.FichaPerfilModel.load(id, {
    		scope: this,
		    success: function(perfil) {
		    	me.logTime("Load perfil success"); 
		    	me.setLogTime();
		    			    	
		    	console.log(perfil);
		    	if(Ext.isEmpty(titulo)) {		    		
		    		titulo = "Perfil " + perfil.get("pefId");
		    		tab.setTitle(titulo);
		    	}
		    	
		    	tab.getViewModel().set("perfil", perfil);
		    	tab.configCmp(perfil);

				tab.unmask();

		    	me.logTime("Fin Set values"); 
		    },
		    failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				tab.unmask();
	       	}
		});

    },
    
    abrirDetalleGasto: function(record, refLinks) {
    	var me = this,
    	numGasto = record.get("numGastoHaya"),
    	id = record.get("id"),
    	titulo = Ext.isEmpty(numGasto)? null : 'Gasto ' + numGasto;
    	
		me.redirectTo('activos', true);    	
    	me.abrirDetalleGastoById(id, titulo, refLinks);    	
    	
    },
    abrirDetalleGastoDirecto: function(id, titulo) {
    	var me = this;
    	
		me.redirectTo('activos', true);    	
    	me.abrirDetalleGastoById(id, titulo);    	
    	    	
    },

    abrirDetalleGastoTasacion: function(record, refLinks) {
       var me = this,
       numGasto = record.get("numGastoHaya"),
       id = record.get("idGasto"),
       titulo = Ext.isEmpty(numGasto)? null : 'Gasto ' + numGasto;

       me.redirectTo('activos', true);
       me.abrirDetalleGastoById(id, titulo, refLinks);

    },
    
    abrirDetallePlusvalia: function(record) {
    	var me = this,
    	titulo = "Activo " + record.get("numActivo"),
    	id = record.get("idActivo");
		me.redirectTo('activos', true);
    	me.abrirDetalleActivoPrincipal(id, CONST.MAP_TAB_ACTIVO_XTYPE['PLUSVALIA']);
    },
    
    abrirDetalleGastoById: function(id, titulo, refLinks) {
    	var me = this,
    	cfg = {}, 
    	tab=null;

    	cfg.title = titulo;
    	tab = me.createTab (me.getActivosMain(), 'gasto', "gastodetallemain",  id, cfg);
    	tab.mask(HreRem.i18n('msg.mask.loading'));
    	me.setLogTime(); 
    	HreRem.model.GastoProveedor.load(id, {
    		scope: this,
		    success: function(gasto) {

		    	me.logTime("Load gasto success"); 
		    	me.setLogTime();	    	
		    	if(Ext.isEmpty(titulo)) {		    		
		    		titulo = "Gasto " + gasto.get("numGastoHaya");
		    		tab.setTitle(titulo);
		    	}
		    	tab.getViewModel().set("gasto", gasto);
		    	tab.configCmp(gasto);
		    	
		    	HreRem.model.GastoAviso.load(id, {
		    		scope: this,
				    success: function(avisos) {
			    		//var tab = me.getActivosMain().items.getByKey('expediente_' + id);
			    		if (tab != null && tab.getViewModel() != null)
			    			tab.getViewModel().set("avisos", avisos);				    	
				    }
				});		    					
				
				/* Selector de subPestanyas del Trabajo:
		    	 * - Se hace la comprobacion aqui (ademas de dentro de la funcion), 
		    	 * para evitar el uso de Notify() si no hay activacion de pesta�as (refLinks != null)
		    	 */
		    	if (refLinks != null){
		    		tab.getViewModel().notify();
					me.seleccionarTabByXtype(tab, refLinks);
				}
				
				tab.unmask();

		    	me.logTime("Fin Set values"); 
		    },
		    failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				tab.unmask();
	       	}
		});

    },
    
    refrescarDetalleGasto: function(detalle, callbackFn) {
    	
    	var me = this,
    	id = detalle.getViewModel().get("gasto.id");
    	
    	HreRem.model.GastoProveedor.load(id, {
    		scope: this,
		    success: function(gasto) {
		    	
		    	detalle.getViewModel().set("gasto", gasto);		    	
		    	detalle.configCmp(gasto);
		    	callbackFn();
		    	HreRem.model.GastoAviso.load(id, {
		    		scope: this,
				    success: function(avisos) {
			    		detalle.getViewModel().set("avisos", avisos);				    	
				    }
				});
		    }
		});
    	
    },
    
    
    abrirDetalleJunta: function(record, refLinks) {
    	var me = this,
    	titulo = "Junta " + record.get("activo"),
    	id = record.get("id");
		me.redirectTo('activos', true);    	
    	me.abrirDetalleJuntaById(id, titulo, refLinks);    	
    	
    },
    
    abrirDetalleJuntaById: function(id, titulo, refLinks) {
    	var me = this,
    	cfg = {}, 
    	tab=null;

    	cfg.title = titulo;
    	tab = me.createTab (me.getActivosMain(), 'junta', "juntasdetallemain",  id, cfg);
    	tab.mask(HreRem.i18n('msg.mask.loading'));
    	me.setLogTime(); 
    	
    	HreRem.model.JuntasPropietarios.load(id, {
    		scope: this,
		    success: function(junta) {
		    	me.logTime("Load junta success"); 
		    	me.setLogTime();
		    			    	
		    	if(Ext.isEmpty(titulo)) {		    		
		    		titulo = "Junta " + junta.get("id");
		    		tab.setTitle(titulo);
		    	}
		    	if (tab != null && tab.getViewModel() != null){
		    		tab.getViewModel().set("junta", junta);
		    		tab.configCmp(junta);
		    	}
		    	tab.unmask();

		    	me.logTime("Fin Set values"); 
		    },
		    failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				tab.unmask();
	       	}
		});

    },

    abrirDetalleActivoPreciosTasacion: function(record) {
    	var me = this,
    	titulo = "Activo " + record.get("numActivo"),
    	id = record.get("idActivo");
		me.redirectTo('activos', true);
		me.abrirDetalleActivoPrincipal(id, CONST.MAP_TAB_ACTIVO_XTYPE['PRECIOS_TASACION']);
    }
    
});
