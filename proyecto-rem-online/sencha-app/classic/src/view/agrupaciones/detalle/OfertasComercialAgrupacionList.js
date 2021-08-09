Ext.define('HreRem.view.agrupacion.detalle.OfertasComercialAgrupacionList', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'ofertascomercialagrupacionlist',
    bind: {
        store: '{storeOfertasAgrupacion}',
        topBar: '{agrupacionficha.esEditable}',
		editOnSelect: '{agrupacionficha.esEditable}'
    },
    requires: ['HreRem.view.agrupaciones.detalle.AnyadirNuevaOfertaAgrupacion', 'HreRem.view.activos.detalle.MotivoRechazoOfertaForm'],
    
   	removeButton: false,
   	
    listeners	: {
    	select: 'onSelectedRow',
    	deselect: 'onDeselectedRow',
    	boxready: function(){
    		me = this;    		
			me.calcularMostrarBotonClonarExpediente();
    	}
    },
    
    initComponent: function () {
    	        
        var me = this;
        
        me.topBar = $AU.userHasFunction(['EDITAR_TAB_COMERCIAL_AGRUPACION']);
        
        me.columns= [
        
		          {
		        	dataIndex: 'numOferta',
		            text: HreRem.i18n('header.oferta.numOferta'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'fechaCreacion',
		            text: HreRem.i18n('header.oferta.fechaAlta'),
		            formatter: 'date("d/m/Y H:i")',
		            flex: 1
		        },
		        {
		            dataIndex: 'descripcionTipoOferta',
		            text: HreRem.i18n('header.oferta.tipoOferta'),
		            flex: 1
		        },
		        /*{
		            dataIndex: 'numAgrupacionRem',
		            text: HreRem.i18n('header.oferta.numAgrupacion'),
		            flex: 1
		        },*/
		        {
		            dataIndex: 'ofertante',
		            text: HreRem.i18n('header.oferta.ofertante'),
		            flex: 2
		        },
		        {
		            dataIndex: 'comite',
		            text: HreRem.i18n('header.oferta.comite'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'precioPublicado',
		            text: HreRem.i18n('header.oferta.precioPublicado'),
		            flex: 1
		        },
		        {
		            dataIndex: 'importeOferta',
		            text: HreRem.i18n('header.oferta.importeOferta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'codigoEstadoOferta',
		            text: HreRem.i18n('header.oferta.estadoOferta'),
					editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'estadosOfertas'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
					renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {								        		
			        		var me = this,
			        		comboEditor = me.columns  && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor() : null,
			        		store, record;
			        		
			        		if(!Ext.isEmpty(comboEditor)) {
				        		store = comboEditor.getStore(),							        		
				        		record = store.findRecord("codigo", value);
			        		
				        		if(!Ext.isEmpty(record)) {								        			
				        			return record.get("descripcion");								        		
				        		} else {
				        			comboEditor.setValue(value);								        			
				        		}
			        		}
			        },
		            flex: 1
		        },
		        {
	    			xtype: 'actioncolumn',
	    			text: HreRem.i18n('header.oferta.expediente'),
		        	dataIndex: 'numExpediente',
			        items: [{
			            tooltip: HreRem.i18n('tooltip.ver.expediente'),
			            getClass: function(v, metadata, record ) {
			            	if (!Ext.isEmpty(record.get("numExpediente"))) {
			            		return 'fa fa-folder-open blue-medium-color';
			            	}			            	
			            },
			            handler: 'onClickAbrirExpedienteComercial'
			        }],
			        renderer: function(value, metadata, record) {			        	
			        	if(Ext.isEmpty(record.get("numExpediente"))) {
			        		return "";
			        	} else {
			        		return '<div style="display:inline; margin-right: 15px; font-size: 11px;">'+ value+'</div>'
			        	}
			        },
		            flex     : 1,            
		            align: 'right',
		            menuDisabled: true,
		            hideable: false
		        },
		        {
		            dataIndex: 'descripcionEstadoExpediente',
		            text: HreRem.i18n('header.oferta.estadoExpediente'),
		            flex: 1
		        },
		        {
		        	text: HreRem.i18n('header.oferta.express'),
					dataIndex: 'ofertaExpress',
					align	 : 'center',
					hideable: false,
					renderer: function(data) {
	                	if(data == 'true'){
	                		var data = 'resources/images/green_16x16.png';
	                		return '<div> <img src="'+ data +'"></div>';
					    }
	                }
						
				},
		        {
		            dataIndex: 'fechaEntradaCRMSF',
		            text: HreRem.i18n('header.oferta.fechaEntradaCRMSF'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        }
        ];
        
         me.addListener ('beforeedit', function(editor, context) {
         	
         	if(this.editOnSelect) {
	            var estado = context.record.get("codigoEstadoOferta");  
	            var allowEdit = estado != '01' && estado != '02' && estado != '05' && estado != '06';
	            this.editOnSelect = allowEdit;
         	}
            return this.editOnSelect;
        });
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'ofertasPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeOfertasAgrupacion}'
		            }
		        }
		];
		
		me.cloneExpedienteButton = true; // No modificar este, la logica de mostrar o no el bot�n est� en el metodo calcularMostrarBotonClonarExpediente
		
        me.callParent(); 
        
    },
    
    onAddClick: function (btn) {
		var me = this;
		var items= me.up('agrupacionesdetalle').getRefItems();
		var numActivos,
		viewPortWidth = Ext.Element.getViewportWidth(),
		viewPortHeight = Ext.Element.getViewportHeight();

		for(var i=0;i<=items.length;i++){
			if(items[i].getXType()=='fichaagrupacion'){
				var record= items[i].getBindRecord(),
				idAgrupacion= record.get('id'),
				numAgrupacionRem= record.get('numAgrupRem');
				numActivos= record.get('numeroActivos');
				break;
			}
		}
			
		if (numActivos == null || numActivos == '' || numActivos == '0') {
			me.fireEvent("errorToast", HreRem.i18n("msg.comercialAnyadirOferta.agrupacion.sin.activos.error"));	
		}else {
			var parent= me.up('ofertascomercialagrupacion');
			oferta = Ext.create('HreRem.model.OfertaComercial', {idAgrupacion: idAgrupacion, numAgrupacionRem: numAgrupacionRem});
			Ext.create('HreRem.view.common.WizardBase',
					{
						slides: [
							'slidedocumentoidentidadcliente',
							'slidedatosoferta',
							'slideadjuntardocumento'
						],
						title: HreRem.i18n('title.nueva.oferta'),
						oferta: oferta,
						parent: parent,
						modoEdicion: true,
						width: viewPortWidth > 1370 ? viewPortWidth / 2 : viewPortWidth / 1.5,
						height: viewPortHeight > 500 ? 500 : viewPortHeight - 100,
						x: viewPortWidth / 2 - ((viewPortWidth > 1370 ? viewPortWidth / 2 : viewPortWidth /1.5) / 2),
						y: viewPortHeight / 2 - ((viewPortHeight > 500 ? 500 : viewPortHeight - 100) / 2)
					}
				).show();
		}    	
		
	},
	
	editFuncion: function(editor, context){

		var me= this;
		var estado = context.record.get("codigoEstadoOferta");
		var gencat = context.record.get("gencat");
		var msg = HreRem.i18n('msg.desea.aceptar.oferta');
		
		if(CONST.ESTADOS_OFERTA['PENDIENTE'] != estado){
			var agrupacion = me.lookupController().getViewModel().get('agrupacionficha');
			if (agrupacion.get('codigoCartera')==CONST.CARTERA['BANKIA'] && (agrupacion.get('tipoAgrupacionCodigo')==CONST.TIPOS_AGRUPACION['COMERCIAL_VENTA'] 
				|| agrupacion.get('tipoAgrupacionCodigo')==CONST.TIPOS_AGRUPACION['COMERCIAL_ALQUILER'] || agrupacion.get('tipoAgrupacionCodigo')==CONST.TIPOS_AGRUPACION['RESTRINGIDA']))
			{
				if(agrupacion.get('cambioEstadoActivo')){
					if($AU.userHasFunction(['CAMBIAR_ESTADO_OFERTA_BANKIA'])){
						me.fireEvent("warnToast", HreRem.i18n("msg.cambio.estado.activo"));
					}else{
						me.fireEvent("errorToast", HreRem.i18n("msg.cambio.estado.activo"));
						me.lookupController().lookupReference('activosagrupacion').lookupController().refrescarAgrupacion(true);
						return false;
					}
				}
				if(agrupacion.get('cambioEstadoPrecio')){
					if($AU.userHasFunction(['CAMBIAR_ESTADO_OFERTA_BANKIA'])){
						me.fireEvent("warnToast", HreRem.i18n("msg.cambio.valor.precio"));
					}else{
						me.fireEvent("errorToast", HreRem.i18n("msg.cambio.valor.precio"));
						me.lookupController().lookupReference('activosagrupacion').lookupController().refrescarAgrupacion(true);
						return false;
					}
				}
				if(agrupacion.get('cambioEstadoPublicacion')){
					if($AU.userHasFunction(['CAMBIAR_ESTADO_OFERTA_BANKIA']) || activo.get('estadoVentaCodigo') == '03'){
						me.fireEvent("warnToast", HreRem.i18n("msg.cambio.estado.publicacion"));
					}else{
						me.fireEvent("errorToast", HreRem.i18n("msg.cambio.estado.publicacion"));
						me.lookupController().lookupReference('activosagrupacion').lookupController().refrescarAgrupacion(true);
						return false;
					}
				}
				
			} 
		}
		
		if(CONST.ESTADOS_OFERTA['ACEPTADA'] == estado){
			var url = $AC.getRemoteUrl('ofertas/isEpaAlquilado');
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params:{
					idAgrupacion : agrupacion.id
				},
				success: function (response){
					var data = JSON.parse(response.responseText);
					if(data.agrupacionEpaAlquilado == '1'){
						msg = HreRem.i18n('msg.activo.epa');
					}
					if (data.agrupacionEpaAlquilado == '2'){
						msg = HreRem.i18n("msg.activo.alquilados");
					}if(data.agrupacionEpaAlquilado == '3'){
						msg = HreRem.i18n("msg.activo.epa.alquilados");
					}
					if (gencat == "true") {
						msg = HreRem.i18n('msg.desea.aceptar.oferta.activos.gencat');
					}
					Ext.Msg.show({
					   title: HreRem.i18n('title.confirmar.oferta.aceptacion'),
					   msg: msg,
					   buttons: Ext.MessageBox.YESNO,
					   fn: function(buttonId) {
					        if (buttonId == 'yes' && context.record.get("descripcionTipoOferta") == CONST.TIPO_COMERCIALIZACION_ACTIVO['VENTA']) {
					        	me.up('agrupacionesdetallemain').lookupController().mostrarCrearOfertaTramitada(editor, me, context);
					        	
					        	//me.saveFn(editor, me, context);
							} else if (buttonId == 'yes') {
								me.saveFn(editor, me, context);
							} else{
					    		me.getStore().load();	
					    	}
						}
					});
				}
			})
			
		} else {
			
			//Si todos los estados de las Ofertas = Rechazada -> Se podran agregar activos a al agrupacion
			// HREOS-2814 El cambio a anulada/denegada (rechazada) abre el formulario de motivos de rechazo
			if(CONST.ESTADOS_OFERTA['RECHAZADA'] == estado || CONST.ESTADOS_OFERTA['CADUCADA']) {
				if(!Ext.isEmpty(me.lookupController().lookupReference('listadoactivosagrupacion'))) {
					var arrayOfertas = me.getView().getStore();
					var mostrarTopBarListaActivos = true;
					for(var i=0; i< arrayOfertas.count();i++) {
						if(arrayOfertas.getAt(i).get('codigoEstadoOferta') != CONST.ESTADOS_OFERTA['RECHAZADA']) {
							mostrarTopBarListaActivos = false;
							break;	
						}
						if(arrayOfertas.getAt(i).get('codigoEstadoOferta') != CONST.ESTADOS_OFERTA['CADUCADA']) {
							mostrarTopBarListaActivos = false;
							break;	
						}
					}
					
					me.lookupController().lookupReference('listadoactivosagrupacion').setTopBar(mostrarTopBarListaActivos);
				}
				
            	me.onCambioARechazoOfertaList(me, context.record);

            } else {
            	
            	me.saveFn(editor, me, context);
			}
		}
					
	},
	
	saveFn: function (editor, grid, context) {
		var me = grid;
		if (me.isValidRecord(context.record)) {				
			me.mask(HreRem.i18n("msg.mask.espere"));
    		context.record.save({

                params: {
                    idEntidad: Ext.isEmpty(me.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(me.idPrincipal)
                },
                success: function (a, operation, c) {																			
					me.saveSuccessFn(a, operation, c);
				},
                
				failure: function (a, operation) {
                	me.saveFailureFn(operation);
              	
                },
                callback: function() {
                	me.unmask();
                	me.getStore().load();
                }
      		});	                            
        	me.disableAddButton(false);
        	me.disablePagingToolBar(false);
        	me.getSelectionModel().deselectAll();
        	editor.isNew = false;
		} else {
			me.getStore().load(); 	
		}
	},
	
    onCambioARechazoOfertaList: function (grid, record) {
    	
    	var me = this;
    	var motivoForm = Ext.create("HreRem.view.activos.detalle.MotivoRechazoOfertaForm", {ofertaRecord: record, gridOfertas: grid});
    	motivoForm.show();
  	    	
    },
	
	isValidRecord: function (record, context) {
		
		var me = this;
		var hayOfertaAceptada=false;
		for (i=0; !hayOfertaAceptada && i<me.getStore().getData().items.length;i++){
			
			if(me.getStore().getData().items[i].data.idOferta != record.data.idOferta){
				var codigoEstadoOferta=  me.getStore().getData().items[i].data.codigoEstadoOferta;
				hayOfertaAceptada = CONST.ESTADOS_OFERTA['ACEPTADA'] == codigoEstadoOferta;
				var codigoEstadoExpediente=  me.getStore().getData().items[i].data.codigoEstadoExpediente;
				var expedienteBlocked = CONST.ESTADOS_EXPEDIENTE['APROBADO'] == codigoEstadoExpediente || CONST.ESTADOS_EXPEDIENTE['RESERVADO'] == codigoEstadoExpediente 
						|| CONST.ESTADOS_EXPEDIENTE['EN_DEVOLUCION'] == codigoEstadoExpediente || CONST.ESTADOS_EXPEDIENTE['VENDIDO'] == codigoEstadoExpediente 
						|| CONST.ESTADOS_EXPEDIENTE['FIRMADO'] == codigoEstadoExpediente || CONST.ESTADOS_EXPEDIENTE['BLOQUEO_ADM'] == codigoEstadoExpediente;
				hayOfertaAceptada = CONST.ESTADOS_OFERTA['ACEPTADA'] == codigoEstadoOferta && expedienteBlocked;
			}
		}
		
		var codigoEstadoNuevo = record.data.codigoEstadoOferta;
		
		if(hayOfertaAceptada && CONST.ESTADOS_OFERTA['ACEPTADA'] == codigoEstadoNuevo){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.ya.aceptada"));
			return false;
		} else if(hayOfertaAceptada && CONST.ESTADOS_OFERTA['RECHAZADA'] != codigoEstadoNuevo){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.solo.rechazar"));
			return false;
		} else if(!hayOfertaAceptada && CONST.ESTADOS_OFERTA['RECHAZADA'] != codigoEstadoNuevo && CONST.ESTADOS_OFERTA['ACEPTADA'] != codigoEstadoNuevo && CONST.ESTADOS_OFERTA['CONGELADA'] != codigoEstadoNuevo && CONST.ESTADOS_OFERTA['CADUCADA'] != codigoEstadoNuevo){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.solo.aceptar.rechazar"));
			return false;
		} else if (hayOfertaAceptada && CONST.ESTADOS_OFERTA['CADUCADA'] != codigoEstadoNuevo) {
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.solo.rechazar"));
			return false;
		}
		
		//HREOS-2814 Validacion si estado oferta = rechazada, tipo y motivo obligatorios.
		if(CONST.ESTADOS_OFERTA['RECHAZADA'] == codigoEstadoNuevo){
			if (record.data.tipoRechazoCodigo == null || record.data.motivoRechazoCodigo == null){
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.rechazar.motivos"));
				return false;
			}
		}
		if(CONST.ESTADOS_OFERTA['CADUCADA'] == codigoEstadoNuevo){
			if (record.data.tipoRechazoCodigo == null || record.data.motivoRechazoCodigo == null){
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.rechazar.motivos"));
				return false;
			}
		}
		
		if(!me.up('agrupacionesdetallemain').down('fichaagrupacion').getBindRecord().data.tramitable && CONST.ESTADOS_OFERTA['ACEPTADA'] == codigoEstadoNuevo){
			me.fireEvent("errorToast", HreRem.i18n("msg.oferta.no.tramitable"));
			return false
		}
		
		return true;		
	},
	
	saveSuccessFn: function (oferta, operation, c) {
   		var me = this;
		if(oferta.get('codigoEstadoOferta') == CONST.ESTADOS_OFERTA['ACEPTADA']){
			me.mask(HreRem.i18n("msg.mask.espere"));			
			Ext.Ajax.request({
				url : $AC.getRemoteUrl('tramitacionofertas/doTramitacionOferta'),
				params : {
					idOferta : oferta.id,
					idAgrupacion : oferta.get('idAgrupacion')
				},
				method : 'POST',
				success : function(response, opts) {
					me.lookupController().lookupReference('activosagrupacion').lookupController().refrescarAgrupacion(true);
			        me.getStore().load();
			        me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				},
				failure : function(record, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				},
				callback: function(){
					me.unmask();
				}
			});
		}else{
			me.lookupController().lookupReference('activosagrupacion').lookupController().refrescarAgrupacion(true);
	        me.getStore().load();
	        me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		}
   		
		return true;
	},
	
	saveFailureFn: function(operation) {
		var me = this;
        try {
    		var response = Ext.JSON.decode(operation.getResponse().responseText)
    		
    	}catch(err) {}
    	
    	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msg)) {
    		me.fireEvent("errorToast", response.msg);
    	} else {
    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    	}  
		
	},
   	
   	onClickCloneExpedienteButton : function(btn) {

		var me = this;

		var selectionModel = me.getSelectionModel();

		var ofertasData = me.getNavigationModel().store.data.items;
		var ofertaSeleccionadaData = selectionModel.getSelection()[0].data;

		var sePuedeClonarExpediente = ofertaSeleccionadaData.codigoEstadoOferta == CONST.ESTADOS_OFERTA['RECHAZADA'] && ofertaSeleccionadaData.codigoEstadoOferta == CONST.ESTADOS_OFERTA['CADUCADA'];
						
		if (!sePuedeClonarExpediente) {
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.clonar.oferta.no.anulada"));
			return false;
		}
				
		if(!ofertaSeleccionadaData.numExpediente){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.clonar.oferta.sin.expediente"));
			return false;
		}
		
		if (!ofertaSeleccionadaData.idAgrupacion) {
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.clonar.oferta.agrupacion.sin.agrupacion"));
			return false;
		}

		sePuedeClonarExpediente = ofertaSeleccionadaData.codigoTipoOferta === CONST.TIPOS_COMERCIALIZACION['VENTA'];
		
		if (!sePuedeClonarExpediente) {
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.clonar.oferta.no.venta"));
			return false;
		}
		
		for (var i = 0, len = ofertasData.length; i < len; i++) {
			if (ofertasData[i].data.codigoEstadoOferta == CONST.ESTADOS_OFERTA['ACEPTADA']) {
				sePuedeClonarExpediente = false;
				break;
			}
		}
		if (!sePuedeClonarExpediente) {
			me.fireEvent("errorToast",HreRem.i18n("msg.operacion.ko.clonar.mas.ofertas.tramitadas"));
		} else {
			var ofertasGrid = btn.up().up();
			
			Ext.Msg.confirm(
				HreRem.i18n("msg.info.clonar.expediente"),
				HreRem.i18n("msg.confirm.clonar.oferta"),
				function(btnConfirm){
					if (btnConfirm == "yes"){
						ofertasGrid.mask(HreRem.i18n("msg.mask.loading"));
						me.lookupController().clonateOferta(ofertaSeleccionadaData.id, ofertasGrid);
					}
				}
			);
		}
	},
   	
   	calcularMostrarBotonClonarExpediente: function(){
		var me = this;

		mostrarCloneButtonExpediente = ($AU.userIsRol('HAYASUPER') || $AU.userIsRol('HAYAGESTCOM') || $AU.userIsRol('HAYAGBOINM')
										&& (me.lookupController().getViewModel().data.agrupacionficha.data.tipoComercializacionCodigo === CONST.TIPOS_COMERCIALIZACION['VENTA'] 
											|| me.lookupController().getViewModel().data.agrupacionficha.data.tipoComercializacionCodigo === CONST.TIPOS_COMERCIALIZACION['ALQUILER_VENTA'])
										/*&& (me.lookupController().getViewModel().data.agrupacionficha.data.codSubcartera === CONST.SUBCARTERA['APPLEINMOBILIARIO'] 
											|| me.lookupController().getViewModel().data.agrupacionficha.data.codSubcartera === CONST.SUBCARTERA['DIVARIAN'])*/
										);
		me.mostrarBotonClonarExpediente(mostrarCloneButtonExpediente);
	}
   	
});

