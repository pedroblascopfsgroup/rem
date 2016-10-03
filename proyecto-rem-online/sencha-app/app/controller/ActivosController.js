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
    'HreRem.view.expedientes.ExpedienteDetalleMain', 'HreRem.model.FichaProveedorModel', 'HreRem.view.configuracion.administracion.proveedores.detalle.ProveedoresDetalleTabPanel', 
    'HreRem.view.gastos.GastoDetalleMain', 'HreRem.model.GastoProveedor'],

    
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
				}
				
	],
    
    
    control: {
    	
    	'activosmain' : {    		
    		abrirDetalleActivo : 'abrirDetalleActivo',
    		onSaveFormularioCompleto: 'onSaveFormularioCompleto',
    		cerrarTodas: 'cerrarTodas'
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
    	
    	'activosdetallemain' : {
        	crearnotificacion: 'crearNotificacion',
        	abrirDetalleTramite : 'abrirDetalleTramite',
        	abrirDetalleTrabajo: 'abrirDetalleTrabajo',
        	abrirDetalleExpediente: 'abrirDetalleExpediente',
        	refrescarActivo: 'refrescarDetalleActivo',
        	abrirDetalleActivo: 'abrirDetalleActivoById'
    	},

    	'tareagenerica' : {
        	actualizarGridTareas: 'actualizarGridTareas',
			abrirDetalleTrabajoById: 'abrirDetalleTrabajoById',
			abrirDetalleActivoPrincipal: 'abrirDetalleActivoPrincipal'
    	},
    	
    	'tareaNotificacion' : {
        	actualizarGridTareas: 'actualizarGridTareas',
			abrirDetalleTrabajoById: 'abrirDetalleTrabajoById',
			abrirDetalleActivoPrincipal: 'abrirDetalleActivoPrincipal'
    	},
    	
    	'agrupacionesmain' : {
    		
    		abrirDetalleAgrupacion : 'abrirDetalleAgrupacion',
		    abrirDetalleActivo : 'abrirDetalleActivo'
		    
    	},
    	
    	'agrupacionesdetallemain' : {    		
		    abrirDetalleActivo : 'abrirDetalleActivoById',
		    refrescarAgrupacion: 'refrescarDetalleAgrupacion',
		    abrirDetalleExpediente: 'abrirDetalleExpediente'
    	},
    	
    	'trabajosmain' : {    		
			abrirDetalleTrabajo: 'abrirDetalleTrabajo',
			abrirDetalleActivo: function(idActivo) {
				var me = this;
    			me.abrirDetalleActivoById(idActivo);      
				
			}
    	},
    	
    	'trabajosdetalle' : {
    		abrirDetalleActivo: 'abrirDetalleActivoById',
        	abrirDetalleTramite : 'abrirDetalleTramite',
        	abrirDetalleTramiteTarea : 'abrirDetalleTramiteTarea',
        	abrirDetalleTramiteHistoricoTarea : 'abrirDetalleTramiteHistoricoTarea',
    		refrescarTrabajo: 'refrescarDetalleTrabajo'
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
    	
    	'ofertascomercialmain': {
    		abrirDetalleActivo: 'abrirDetalleActivoComercialOfertas',
			abrirDetalleAgrupacion : 'abrirDetalleAgrupacionComercialOfertas',
			abrirDetalleExpediente: 'abrirDetalleExpediente'
    	},
    	
    	'expedientedetallemain': {
    		abrirDetalleActivoPrincipal: 'abrirDetalleActivoPrincipal',
    		abrirDetalleTramiteTarea : 'abrirDetalleTramiteTarea'
    	},
    	
    	'configuracionmain': {
    		abrirDetalleProveedor: 'abrirDetalleProveedor'
    	},
    	'administraciongastosmain': {
    		abrirDetalleGasto: 'abrirDetalleGasto'
    	}

    },
    
    refrescarDetalleActivo: function (detalle) {
    	
    	var me = this,
    	id = detalle.getViewModel().get("activo.id");	;
    	
    	HreRem.model.Activo.load(id, {
    		scope: this,
		    success: function(activo) {
		    	
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
    	Ext.suspendLayouts();
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
		    	Ext.resumeLayouts(true);
		    	
		    	/* Selector de subpestanyas del activo:
		    	 * - Se hace la comprobacion aqui (ademas de dentro de la funcion), 
		    	 * para evitar el uso de Notify() si no hay activacion de pesta�as (refLinks != null)
		    	 */
		    	if (refLinks != null){
		    		tab.getViewModel().notify();
					me.seleccionarTabByXtype(tab, refLinks);				
				}
				
		     	me.logTime("Fin Set values " + id);
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
			
	    	tabActivo.getLayout().setActiveItem(tabActivo.items.indexOf(tabActivo.down('[xtype='+ activeTabXtype +']')));

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
    	me.abrirDetalleActivoPrincipal(id, CONST.MAP_TAB_ACTIVO_XTYPE['PUBLICACION'])
    },
    
    abrirDetalleAgrupacion: function(record) {
    	
    	var me = this,
    	titulo = "Agrupación " + record.get("numAgrupacionRem"),
    	id = record.get("id");		
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
		    		titulo = "Agrupacion " + agrupacion.get("numAgrupacionRem");
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
		    }
		});

    },
    
    refrescarDetalleTrabajo: function (detalle) {
    	
    	var me = this,
    	id = detalle.getViewModel().get("trabajo.id");	;
    	
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
		    		titulo = "Agrupacion " + agrupacion.get("numAgrupacionRem");
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
    	//debugger;
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
		    	detalle.getViewModel().set("tramite", tramite);
		    }
		});
    	
    },
    
    abrirDetalleTramite: function(grid,record) {

    	var me = this;
    	//debugger;
    	//Sacar que valor le paso para referenciar el trámite
    	var titulo = "Tramite " + record.get("idTramite");
    	var idRecord = record.get("idTramite");
    	
    	me.abrirDetalleTramiteById(idRecord, titulo );    	
    	
    },

    abrirDetalleTramiteTarea: function(grid,record) {

    	var me = this;
    	//debugger;
    	//Sacar que valor le paso para referenciar el trámite
    	var titulo = "Tramite " + record.get("idTramite");
    	var idRecord = record.get("idTramite");
    	
    	me.abrirDetalleTramiteTareasById(idRecord, titulo, 'tareaslist' );    	
    	
    },

    abrirDetalleTramiteHistoricoTarea: function(grid,record) {

    	var me = this;
    	//debugger;
    	//Sacar que valor le paso para referenciar el trámite
    	var titulo = "Tramite " + record.get("idTramite");
    	var idRecord = record.get("idTramite");
    	
    	me.abrirDetalleTramiteTareasById(idRecord, titulo, 'historicotareaslist' );    	
    	
    },
                
    abrirDetalleTramiteById: function(id, titulo) {
    	
    	var me = this;
    	//debugger;
    	var cfg = {};
    	cfg.title = titulo;
     	
    	var tab = me.createTab (me.getActivosMain(), 'tramite', "tramitesdetalle",  id, cfg);    	

    	me.setLogTime(); 
    	HreRem.model.Tramite.load(id, {
    		scope: this,
		    success: function(tramite) {
		    	//debugger;
		    	me.logTime("Load tramite success"); 
		    	me.setLogTime(); 
		    	tab.getViewModel().set("tramite", tramite);
		    	me.logTime("Fin Set values");
		    }
		});
    },
    
    abrirDetalleTramiteTareasById: function(id, titulo, activeTabXtype) {
    	
    	var me = this;
    	//debugger;
    	var cfg = {};
    	cfg.title = titulo;
     	
    	var tab = me.createTab (me.getActivosMain(), 'tramite', "tramitesdetalle",  id, cfg);    	

    	me.setLogTime(); 
    	HreRem.model.Tramite.load(id, {
    		scope: this,
		    success: function(tramite) {
		    	//debugger;
		    	me.logTime("Load tramite success"); 
		    	me.setLogTime(); 
		    	tab.getViewModel().set("tramite", tramite);
		    	//tab.configCmp(tramite);
		    	me.logTime("Fin Set values");
		    	me.idActivo = tramite.get("idActivo");
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
    	titulo = "Agrupación " + record.get("numAgrupacionRem"),
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
    	titulo = "Proveedor " + record.get("id"),
    	id = record.get("id");
		me.redirectTo('activos', true);    	
    	me.abrirDetalleProveedorById(id, titulo, refLinks);    	
    	
    },
    
    abrirDetalleProveedorById: function(id, titulo, refLinks) {

    	var me = this,
    	cfg = {}, 
    	tab=null;

    	cfg.title = titulo;
    	tab = me.createTab (me.getActivosMain(), 'proveedor', "proveedoresdetalletabpanel",  id, cfg);
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
		    }
		});

    },
    
    abrirDetalleGasto: function(record, refLinks) {
    	var me = this,
    	titulo = "Gasto " + record.get("numGastoHaya"),
    	id = record.get("id");
		me.redirectTo('activos', true);    	
    	me.abrirDetalleGastoById(id, titulo, refLinks);    	
    	
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
		    }
		});

    }
    
});
