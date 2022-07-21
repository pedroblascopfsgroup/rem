Ext.define('HreRem.view.activos.detalle.OfertasComercialActivoList', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'ofertascomercialactivolist',
    bind		: {
        store: '{storeOfertasActivo}'
    },
	topBar: true,
    requires	: ['HreRem.view.activos.detalle.AnyadirNuevaOfertaActivo', 'HreRem.view.activos.detalle.MotivoRechazoOfertaForm', 'HreRem.view.expedientes.wizards.oferta.SlideDatosOferta'],
	removeButton: false,
    listeners	: {    	
    	select: 'onSelectedRow',
    	deselect: 'onDeselectedRow',
    	boxReady: function() {
    		var me = this;
    		me.evaluarEdicion();
    		me.calcularMostrarBotonClonarExpediente();
    	},
		focusenter: function() {
    		var me = this;
    		me.evaluarEdicion();
    	},
    	rowclick: 'onOfertaListClick'    		
    },

    initComponent: function () {
        var me = this;
      
        var activo = me.lookupController().getViewModel().get('activo').getData();
        var isBk = activo.isCarteraBankia;
		var vistaDeConcurrencia = me.lookupController().getViewModel().getData().activo.get('vistaDeConcurrencia');
		var enConcurrencia = me.lookupController().getViewModel().getData().activo.get('enConcurrencia');
        var userPefSuper = $AU.userIsRol(CONST.PERFILES['HAYASUPER']);
        
        me.columns= [
		        {
		        	dataIndex: 'numOferta',
		            text: HreRem.i18n('header.oferta.numOferta'),
		            flex: 1
		        },
		        {	  
		        	xtype: 'actioncolumn',
		            dataIndex: 'numActivoAgrupacion',
		            text: HreRem.i18n('header.numero.activo.agrupacion'),
		            flex: 1,
		            items: [{
			            tooltip: HreRem.i18n('tooltip.ver.activo.agrupacion'),
			            getClass: function(v, metadata, record ) {
			            	if (Ext.isEmpty(record.get("numAgrupacion"))) {
			            		return 'app-list-ico ico-ver-activov2';
			            	}
			            	else{
			            		return 'app-list-ico ico-ver-agrupacion'
			            	}
			            },
			            handler: 'onClickAbrirActivoAgrupacion'
			        }],
			        renderer: function(value, metadata, record) {
			        	return '<div style="float:left; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>';
			        },
		            flex     : 1,
		            align: 'center',
		            hideable: false,
		            sortable: true
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
		        {
		            dataIndex: 'ofertante',
		            text: HreRem.i18n('header.oferta.ofertante'),
		            flex: 1
		        },
		        {
		            dataIndex: 'comite',
		            text: HreRem.i18n('header.oferta.comite'),
		            flex: 1,
		            hidden: true
		        },
		        {
		        	dataIndex: 'canalDescripcion',
		        	text: HreRem.i18n('header.canal.prescripcion'),
		            flex: 1,
		            hidden: vistaDeConcurrencia
		        },
		        {
		            dataIndex: 'precioPublicado',
		            text: HreRem.i18n('header.oferta.precioPublicado'),
		            flex: 1,
		            hidden: vistaDeConcurrencia
		        },
		        {
					text: HreRem.i18n('header.oferta.importeOferta'),
		            dataIndex: 'importeOferta',
		            flex: 1,
			        renderer: function(value, metadata, record) {
			        	if (!userPefSuper && enConcurrencia) {
			        		return "*****";
			        	} else {
			        		return  value;
			        	}
			        }
		        },
		        {
		        	xtype: 'numbercolumn',
		            dataIndex: 'importeContraoferta',
		            text: HreRem.i18n('header.oferta.importeContraoferta'),
		            flex: 1,
		            decimalPrecision: 2,
			        decimalSeparation: ',',
			        thousandSeparation: '.',
			        hidden: vistaDeConcurrencia
		        },
		        {
		            dataIndex: 'estadoOferta',
		            text: HreRem.i18n('header.oferta.estadoOferta'),
		            reference: 'estadoOferta',
					editor: {
						xtype: 'combobox',
						reference:'estadoOfertaCombo',
		        		store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionarioEstadosOfertas',
								extraParams: {cartera: activo.entidadPropietariaCodigo,
												equipoGestion: activo.tipoEquipoGestionCodigo,
												idActivo: activo.id}
							},
							autoLoad: true,
							bind: {
								disabled: activo.aplicaComercializar
							}
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
				        			if(value == "03"){
				        				store.add({codigo:"03", descripcion:HreRem.i18n('fieldlabel.congelada')})
				        				record = store.findRecord("codigo", value);
				        				return record.get("descripcion");
				        			}else{
					        			//comboEditor.setValue(value);
				        				return value;
				        			}
				        		}
			        		}
			        },
		            flex: 1
		        },
		        /*
				 * { dataIndex: 'numExpediente', text:
				 * HreRem.i18n('header.oferta.expediente'), flex: 1 },
				 */
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
					hidden: vistaDeConcurrencia,
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
		        },
		        //codigoEstadoC4C
		        
		        {
		            dataIndex: 'codigoEstadoC4C',
		            text: HreRem.i18n('fieldlabel.estado.comunicacion.c4c'),
		            reference: 'codigoEstadoC4C',
		            hidden: !isBk,
					editor: {
						xtype: 'combobox',
						reference:'codigoEstadoC4CCo',
						disabled:true,
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
				  				remoteUrl: 'generic/getDiccionario',
				  				extraParams: {diccionario: 'estadoComunicacionC4C'}
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
		            dataIndex: 'estadoDeposito',
		            text: HreRem.i18n('fieldlabel.estado.deposito'),
		            flex: 1,
		            hidden: false
		        }
		        
		        
        ];
        
        me.addListener ('beforeedit', function(editor, context) {
            var estado = context.record.get("codigoEstadoOferta");
            var numAgrupacion = context.record.get("numAgrupacionRem"); 
            
            var allowEdit = estado != '01' && estado != '02' && estado != '05' && estado != '06' && estado != '08' && estado != '09' && Ext.isEmpty(numAgrupacion);
            if ($AU.userIsRol(CONST.PERFILES['HAYASUPER']) && estado == '08') {
            	allowEdit = true;
            }
			
            this.editOnSelect = allowEdit;
            
            return allowEdit;
        }); 
      

        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'ofertasPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeOfertasActivo}'
		            }
		        },{
					xtype:'checkboxfieldbase',
					
					labelSeparator: '',
				    hideLabel: true,
				    boxLabel: HreRem.i18n('check.comercial.ofertas.anuladas.fieldlabel'),
				    fieldLabel: ' ',
					addUxReadOnlyEditFieldPlugin: false,
					listeners: {
						change: 'onChkbxOfertasAnuladas'
					}
						
	        	}
		        
		];
		
		me.cloneExpedienteButton = true; // No modificar este, la logica de
											// mostrar o no el bot�n est� en
											// el metodo
											// calcularMostrarBotonClonarExpediente
		
        me.callParent(); 
        
    },
	
    //SOY
	onAddClick: function (btn) {

		var me = this;
		var activo = me.lookupController().getViewModel().get('activo'),
		idActivo= activo.get('id'),
		numActivo= activo.get('numActivo'),
		viewPortWidth = Ext.Element.getViewportWidth(),
		viewPortHeight = Ext.Element.getViewportHeight();

		var noContieneTipoAlquiler = false;
		var vistaDeConcurrencia = me.lookupController().getViewModel().getData().activo.get('vistaDeConcurrencia');
		

		if(activo.get('isCarteraBankia')){
			var items = this.getStore().getData().items;
			for( var i = 0; i < items.length; i++){
				var estadoExpediente = items[i].getData().codigoEstadoExpediente;
				if(!Ext.isEmpty(me.estadoExpediente) && CONST.ESTADOS_EXPEDIENTE['EN_TRAMITACION'] != estadoExpediente && CONST.ESTADOS_EXPEDIENTE['PENDIENTE_SANCION'] != estadoExpediente
					&& CONST.ESTADOS_EXPEDIENTE['ANULADO'] != estadoExpediente && CONST.ESTADOS_EXPEDIENTE['DENEGADO'] != estadoExpediente){
					me.fireEvent("errorToast", HreRem.i18n("msg.crear.oferta.estado.error"));
					return;
				}
			}		
		}
		
		if (activo.get('incluyeDestinoComercialAlquiler')) {
			var codigoTipoAlquiler = activo.get('tipoAlquilerCodigo');
			if (codigoTipoAlquiler == null || codigoTipoAlquiler == '' || codigoTipoAlquiler == '05') {
				noContieneTipoAlquiler = true;
			}
		}

		// Comprueba que exista un campo de tipo alquiler antes de anyadir una
		// oferta
		if (!noContieneTipoAlquiler) {
			var parent= me.up('ofertascomercialactivo'),
			oferta = Ext.create('HreRem.model.OfertaComercialActivo', {idActivo: idActivo, numActivo: numActivo});

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

		} else {
			me.fireEvent("errorToast", HreRem.i18n("msg.comercialAnyadirTipoAlquiler.error"));
		}

	},
	
	decisionTramitarOferta: function(editor, context) {
		var me = this;
		var idActivo = me.lookupController().getViewModel().getData().activo.id;
		var activo = me.lookupController().getViewModel().get('activo');
		var enConcurrencia = me.lookupController().getViewModel().getData().activo.get('enConcurrencia');
        var codigoTipoOferta = context.record.get('codigoTipoOferta');
		var gencat = context.record.get('gencat');
		var msg = HreRem.i18n('msg.desea.aceptar.oferta');
		
		var url = $AC.getRemoteUrl('ofertas/isActivoEnDND');
		Ext.Ajax.request({
    		url: url,
    		params: {idActivo: idActivo},
    		success: function(response, opts){
    			var data = Ext.decode(response.responseText);
    			if (me.ofertaActivoEpaAlquilado(activo) == 1){
    				msg = HreRem.i18n('msg.activo.epa');
    			} else if (me.ofertaActivoEpaAlquilado(activo)==2){
    				msg = HreRem.i18n("msg.activo.alquilados");
    			} else if (me.ofertaActivoEpaAlquilado(activo)==3){
    				msg = HreRem.i18n("msg.activo.epa.alquilados");
    			} else if (gencat === "true") {
    				msg = HreRem.i18n('msg.desea.aceptar.oferta.activos.gencat');
    			} else if ((data.isDND != undefined || data.isDND != null) && data.isDND === "true"){
    				msg = HreRem.i18n("msg.desea.aceptar.oferta.activos.dnd.sin.agrupacion") + HreRem.i18n("msg.desea.aceptar.oferta.esta.de.acuerdo");
    			}
    			
    			if (msg == HreRem.i18n('msg.desea.aceptar.oferta') && enConcurrencia) {
    				if (context.record.get("descripcionTipoOferta") == CONST.TIPO_COMERCIALIZACION_ACTIVO['VENTA']) {
						me.up('activosdetalle').lookupController().mostrarCrearOfertaTramitada(editor, me, context);
					} else {
						me.saveFn(editor, me, context);
					}
    			} else {
    				Ext.Msg.show({
					   title: HreRem.i18n('title.confirmar.oferta.aceptacion'),
					   msg: msg,
					   buttons: Ext.MessageBox.YESNO,
					   fn: function(buttonId) {
					        if (buttonId == 'yes' && context.record.get("descripcionTipoOferta") == CONST.TIPO_COMERCIALIZACION_ACTIVO['VENTA']) {
								me.up('activosdetalle').lookupController().mostrarCrearOfertaTramitada(editor, me, context);
							} else if (buttonId == 'yes') {
								me.saveFn(editor, me, context);
							} else{
								me.getStore().load(); 	
							}
						}
					});	
    			}
    		},
		 	failure: function(record, operation) {
		 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
		    },
		    callback: function(record, operation) {
    			me.getView().unmask();
		    }
    	});
	},
	
	editFuncion: function(editor, context){
		var me= this;
		var estado = context.record.get("estadoOferta");
        var codigoTipoOferta = context.record.get('codigoTipoOferta');
        var enConcurrencia = me.lookupController().getViewModel().getData().activo.get('enConcurrencia');
		var codigoEstadoAnterior = context.record.get("codigoEstadoOferta");
		var codigoEstadoNuevo =  context.newValues.estadoOferta;  

        if(enConcurrencia && CONST.TIPOS_OFERTA["VENTA"] === codigoTipoOferta && CONST.ESTADOS_OFERTA['PDTE_DOCUMENTACION'] == codigoEstadoAnterior && CONST.ESTADOS_OFERTA['RECHAZADA'] != codigoEstadoNuevo){
        	me.fireEvent("errorToast", HreRem.i18n("msg.error.periodo.concurrencia.cambio.anulado"));
			me.up('activosdetalle').lookupController().refrescarActivo(true);
			return false;
        }

        if(CONST.ESTADOS_OFERTA['PENDIENTE'] != estado){
			if(CONST.ESTADOS_OFERTA['PDTE_TITULARES'] == estado){
				me.fireEvent("errorToast", HreRem.i18n("msg.estado.oferta.disponible"));
				me.up('activosdetalle').lookupController().refrescarActivo(true);
				return false;
			}
			var activo = me.lookupController().getViewModel().get('activo');
			if (activo.get('entidadPropietariaCodigo')==CONST.CARTERA['BANKIA'] && CONST.TIPOS_OFERTA["VENTA"] === codigoTipoOferta){
				if(activo.get('cambioEstadoActivo')){
					if($AU.userHasFunction(['CAMBIAR_ESTADO_OFERTA_BANKIA'])){
						me.fireEvent("warnToast", HreRem.i18n("msg.cambio.estado.activo"));
					}else{
						me.fireEvent("errorToast", HreRem.i18n("msg.cambio.estado.activo"));
						me.up('activosdetalle').lookupController().refrescarActivo(true);
						return false;
					} 
				}
				if(activo.get('cambioEstadoPrecio')){
					if($AU.userHasFunction(['CAMBIAR_ESTADO_OFERTA_BANKIA'])){
						me.fireEvent("warnToast", HreRem.i18n("msg.cambio.valor.precio"));
					}else{
						me.fireEvent("errorToast", HreRem.i18n("msg.cambio.valor.precio"));
						me.up('activosdetalle').lookupController().refrescarActivo(true);
						return false;
					}
				}
				if(activo.get('cambioEstadoPublicacion')){
					if($AU.userHasFunction(['CAMBIAR_ESTADO_OFERTA_BANKIA']) || activo.get('estadoVentaCodigo') == '03'){
						me.fireEvent("warnToast", HreRem.i18n("msg.cambio.estado.publicacion"));
					}else{
						me.fireEvent("errorToast", HreRem.i18n("msg.cambio.estado.publicacion"));
						me.up('activosdetalle').lookupController().refrescarActivo(true);
						return false;
					}
				}
				
			}
			
			if (activo.get('tipoComercializacionCodigo') == CONST.TIPOS_COMERCIALIZACION['SOLO_ALQUILER'] && activo.get('perimetroMacc')=="1"){
				me.fireEvent("errorToast", HreRem.i18n("msg.oferta.haya.home"));
				me.up('activosdetalle').lookupController().refrescarActivo(true);
				return false;
			} 

		}
		
		if(CONST.ESTADOS_OFERTA['ACEPTADA'] === estado){
			if (activo.get('entidadPropietariaCodigo')==CONST.CARTERA['BANKIA']){
				if(CONST.TIPOS_OFERTA["VENTA"] === codigoTipoOferta){
					if(Ext.isEmpty(me.lookupController().getViewModel().get('canalVentaBC').selection)){
						me.fireEvent("errorToast", HreRem.i18n("msg.cambio.canal.venta.bc"));
						me.getStore().load();
						return;
					}
				}else if(CONST.TIPOS_OFERTA["ALQUILER"] === codigoTipoOferta){
					if(Ext.isEmpty(me.lookupController().getViewModel().get('canalAlquilerBC').selection)){
						me.fireEvent("errorToast", HreRem.i18n("msg.cambio.canal.alquiler.bc"));
						me.getStore().load();
						return;
					}
				}
			} 
			
			if(enConcurrencia && context.rowIdx != 0) {
				Ext.Msg.show({
				   title: HreRem.i18n('title.confirmar.oferta.aceptacion'),
				   msg: HreRem.i18n('msg.desea.aceptar.oferta.concurrencia'),
				   buttons: Ext.MessageBox.YESNO,
				   fn: function(buttonId) {
				        if (buttonId == 'yes') {
				        	me.decisionTramitarOferta(editor, context);
				        } else {
							me.getStore().load(); 	
						}
					}
				});	
			} else {
				me.decisionTramitarOferta(editor, context);
			}
			
		} else {
			// HREOS-2814 El cambio a anulada/denegada (rechazada) abre el
			// formulario de motivos de rechazo
			if (CONST.ESTADOS_OFERTA['RECHAZADA'] == estado){
				me.onCambioARechazoOfertaList(me, context.record);
			} else if (CONST.ESTADOS_OFERTA['CADUCADA'] == estado){
				me.onCambioARechazoOfertaList(me, context.record);
			} else if((CONST.ESTADOS_OFERTA['PENDIENTE'] == estado && $AU.userIsRol(CONST.PERFILES['HAYASUPER']))
			    || (CONST.ESTADOS_OFERTA['PDTE_DEPOSITO'] == estado && $AU.userIsRol(CONST.PERFILES['HAYASUPER']) && CONST.TIPOS_OFERTA["VENTA"] === codigoTipoOferta)){
				var idOferta = context.record.get('idOferta');
			    if(Ext.isEmpty(idOferta)) {
			    	idOferta = context.record.get('id');
			    }
			    var url = $AC.getRemoteUrl('ofertas/actualizaEstadoOferta');
                Ext.Ajax.request({
                    url: url,
                	params: {idOferta: idOferta, codigoEstado: estado},
                	success: function(response, opts){
                	    me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                	},
                    callback: function(record, operation) {
                        me.getStore().load();
                    }
                });
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
// me.up('formBase').fireEvent('openModalWindow',"HreRem.view.activos.detalle.MotivoRechazoOfertaForm",
// {oferta: record.data});
  	    	
    },

	isValidRecord: function (record, context) {
		var me = this;
		var hayOfertaAceptada=false;
		var codigoEstadoAnterior;
		var codigoTipoOfertaAnterior;
        var activo = me.lookupController().getViewModel().get('activo');
        var enConcurrencia = me.lookupController().getViewModel().getData().activo.get('enConcurrencia');

		for (i=0; !hayOfertaAceptada && i<me.getStore().getData().items.length;i++){
			
			if(me.getStore().getData().items[i].data.idOferta != record.data.idOferta){
				var codigoEstadoOferta=  me.getStore().getData().items[i].data.codigoEstadoOferta;
				var codigoEstadoExpediente=  me.getStore().getData().items[i].data.codigoEstadoExpediente;
				var expedienteBlocked = CONST.ESTADOS_EXPEDIENTE['APROBADO'] == codigoEstadoExpediente || CONST.ESTADOS_EXPEDIENTE['RESERVADO'] == codigoEstadoExpediente 
					|| CONST.ESTADOS_EXPEDIENTE['EN_DEVOLUCION'] == codigoEstadoExpediente || CONST.ESTADOS_EXPEDIENTE['VENDIDO'] == codigoEstadoExpediente 
					|| CONST.ESTADOS_EXPEDIENTE['FIRMADO'] == codigoEstadoExpediente || CONST.ESTADOS_EXPEDIENTE['BLOQUEO_ADM'] == codigoEstadoExpediente
					|| CONST.ESTADOS_EXPEDIENTE['RES_PTE_MAN'] == codigoEstadoExpediente || CONST.ESTADOS_EXPEDIENTE['AP_PTE_MAN'] == codigoEstadoExpediente
					|| CONST.ESTADOS_EXPEDIENTE['AP_CES_PTE_MAN'] == codigoEstadoExpediente || CONST.ESTADOS_EXPEDIENTE['CONT_CES'] == codigoEstadoExpediente;
				hayOfertaAceptada = CONST.ESTADOS_OFERTA['ACEPTADA'] == codigoEstadoOferta && expedienteBlocked;
			}else{
				if(!Ext.isEmpty(me.getStore().getData().items[i].modified)){
					codigoEstadoAnterior = me.getStore().getData().items[i].modified.codigoEstadoOferta;
				}
			    codigoTipoOfertaAnterior = me.getStore().getData().items[i].data.codigoTipoOferta;
			}
		}
		var codigoEstadoNuevo = record.data.codigoEstadoOferta;

		if(enConcurrencia && CONST.TIPOS_OFERTA["VENTA"] === codigoTipoOfertaAnterior && CONST.ESTADOS_OFERTA['PDTE_DOCUMENTACION'] == codigoEstadoAnterior && CONST.ESTADOS_OFERTA['RECHAZADA'] != codigoEstadoNuevo){
        	me.fireEvent("errorToast", HreRem.i18n("msg.error.periodo.concurrencia.cambio.anulado"));
			me.up('activosdetalle').lookupController().refrescarActivo(true);
			return false;
        }
		
        if(hayOfertaAceptada
            && CONST.ESTADOS_OFERTA['CONGELADA'] == codigoEstadoAnterior
            && CONST.ESTADOS_OFERTA['PENDIENTE'] == codigoEstadoNuevo){
                me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.solo.rechazar"));
                return false;
        }

		if (codigoTipoOfertaAnterior != null && CONST.TIPOS_OFERTA['VENTA'] != codigoTipoOfertaAnterior && CONST.ESTADOS_OFERTA['PDTE_DEPOSITO'] == codigoEstadoNuevo){
			me.fireEvent("errorToast", HreRem.i18n("msg.estado.oferta.disponible"));
            return false;
		}

		//Si no está en estado "Pendiente", no se puede tramitar
		if(codigoEstadoAnterior != null && CONST.ESTADOS_OFERTA['PENDIENTE'] != codigoEstadoAnterior
		    && CONST.ESTADOS_OFERTA['ACEPTADA'] == codigoEstadoNuevo){
		    me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.tramitar.oferta.no.pendiente"));
            return false;
		}
				
		if(codigoEstadoAnterior != null && CONST.ESTADOS_OFERTA['PDTE_DEPOSITO'] == codigoEstadoAnterior 
				&& CONST.ESTADOS_OFERTA['RECHAZADA'] != codigoEstadoNuevo && CONST.ESTADO_DEPOSITO['COD_INGRESADO'] != record.get('codigoEstadoDeposito')){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.oferta.solo.tramitar.deposito.contabilizado"))
			return false;
		}
		
		if(codigoEstadoAnterior != null && CONST.ESTADOS_OFERTA['PDTE_DOCUMENTACION'] == codigoEstadoAnterior 
				&& CONST.ESTADOS_OFERTA['RECHAZADA'] != codigoEstadoNuevo && CONST.ESTADOS_OFERTA['PDTE_DEPOSITO'] != codigoEstadoNuevo 
					&& !Ext.isEmpty(record.get('codigoEstadoDeposito'))){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.oferta.solo.tramitar.deposito.contabilizado"))
			return false;
		}
		
		if(me.lookupViewModel().get('activo.tipoEstadoAlquiler') == CONST.COMBO_ESTADO_ALQUILER['LIBRE'] && (me.lookupViewModel().get('activo.situacionComercialCodigo') != CONST.SITUACION_COMERCIAL['ALQUILADO'] || me.lookupViewModel().get('activo.situacionComercialCodigo') != CONST.SITUACION_COMERCIAL['VENDIDO'])) {
			if(!activo.get('isCarteraBankia') && CONST.ESTADOS_OFERTA['ACEPTADA'] != codigoEstadoNuevo && CONST.ESTADOS_OFERTA['RECHAZADA'] != codigoEstadoNuevo){
                me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.oferta.solo.tramitar.pendiente"));
                return false;
			}
			return true;
		}
		else if(hayOfertaAceptada && CONST.ESTADOS_OFERTA['ACEPTADA'] == codigoEstadoNuevo){
			if (codigoTipoOfertaAnterior != null && CONST.TIPOS_OFERTA['ALQUILER_NO_COMERCIAL'] == codigoTipoOfertaAnterior
					&& me.lookupViewModel().get('activo.isCarteraBankia')
					&& me.lookupViewModel().get('activo.tipoEstadoAlquiler') == CONST.COMBO_ESTADO_ALQUILER['ALQUILADO']
					&& me.lookupViewModel().get('activo.situacionComercialCodigo') == CONST.SITUACION_COMERCIAL['ALQUILADO']) {
				return true;
			} else {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.ya.aceptada"));
				return false;
			}
		} else if(hayOfertaAceptada && (CONST.ESTADOS_OFERTA['RECHAZADA'] != codigoEstadoNuevo && CONST.ESTADOS_OFERTA['CADUCADA'] != codigoEstadoNuevo)){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.solo.rechazar"));
			return false;
		} else if(!hayOfertaAceptada && CONST.ESTADOS_OFERTA['RECHAZADA'] != codigoEstadoNuevo 
				&& CONST.ESTADOS_OFERTA['ACEPTADA'] != codigoEstadoNuevo && CONST.ESTADOS_OFERTA['CONGELADA'] != codigoEstadoNuevo 
				&& CONST.ESTADOS_OFERTA['CADUCADA'] != codigoEstadoNuevo
				&& (CONST.ESTADOS_OFERTA['PENDIENTE'] != codigoEstadoNuevo && CONST.ESTADOS_OFERTA['PDTE_DEPOSITO'] == codigoEstadoAnterior)){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.solo.aceptar.rechazar"));
			return false;
		} else if ((CONST.ESTADOS_OFERTA['CONGELADA'] == codigoEstadoNuevo || (CONST.ESTADOS_OFERTA['PENDIENTE'] == codigoEstadoNuevo && !$AU.userIsRol("HAYASUPER")))
						&& CONST.ESTADOS_OFERTA['PDTE_DEPOSITO'] == codigoEstadoAnterior){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.pdte.deposito"));
			return false;
		}

		//HREOS-2814 Validacion si estado oferta = rechazada, tipo y motivo obligatorios.
		if(CONST.ESTADOS_OFERTA['RECHAZADA'] == codigoEstadoNuevo){
			if (record.data.tipoRechazoCodigo == null || record.data.motivoRechazoCodigo == null){
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.rechazar.motivos"));
				return false;
			}
		}
		if (CONST.ESTADOS_OFERTA['CADUCADA'] == codigoEstadoNuevo) {
			if (record.data.tipoRechazoCodigo == null || record.data.motivoRechazoCodigo == null){
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.rechazar.motivos"));
				return false;
			}
		}
		if(!me.up('comercialactivo').getBindRecord().data.tramitable && CONST.ESTADOS_OFERTA['ACEPTADA'] == codigoEstadoNuevo){
			me.fireEvent("errorToast", HreRem.i18n("msg.oferta.no.tramitable"));
			return false
		}
		
		return true;			
	},
    saveSuccessFn: function (oferta, operation, c) {
   		var me = this;	

        try {
    		var response = Ext.JSON.decode(operation.getResponse().responseText);
			if(!Ext.isEmpty(response) && !Ext.isEmpty(response.advertencia)) {
	    		me.fireEvent("warnToast", response.advertencia);
	    	}else if(oferta.get('codigoEstadoOferta') == CONST.ESTADOS_OFERTA['ACEPTADA']){
				me.mask(HreRem.i18n("msg.mask.espere"));
	    		Ext.Ajax.request({
					url : $AC.getRemoteUrl('tramitacionofertas/doTramitacionOferta'),
					params : {
						idOferta : oferta.id,
						idActivo : oferta.get('idActivo')
					},
					method : 'POST',
					success : function(response, opts) {
						me.up('activosdetalle').lookupController().refrescarActivo(true);
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
				me.up('activosdetalle').lookupController().refrescarActivo(true);
		        me.getStore().load();
		        me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			}
			
    	}catch(err) {}
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
	
	
   funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
   },
   
   // HREOS-846 Si NO esta dentro del perimetro, ocultamos del grid las
	// opciones de agregar/elminar y las acciones editables por fila
   // HREOS-1001 Si está en el perimetro pero no es comercializable tampoco se
	// puede editar
   // HREOS-1971 Si el usuario no tiene la funcion de editar el listado tampoco
	// se puede editar
   // HREOS-4963 Si el activo es de alquiler o venta y no tiene tipo de
	// alquiler asignado no se podra editar
   evaluarEdicion: function() {

		var me = this;
		var activo = me.lookupController().getViewModel().get('activo');

		if(((activo.get('incluidoEnPerimetro')=="false" || !activo.get('aplicaComercializar') || activo.get('isVendido') || activo.get('isActivoEnTramite')) 
			&& !activo.get('isCarteraBankia'))  || activo.get('pertenceAgrupacionRestringida') || !$AU.userHasFunction('EDITAR_LIST_OFERTAS_ACTIVO')   
			|| (activo.get('situacionComercialCodigo') == CONST.SITUACION_COMERCIAL['ALQUILADO_PARCIALMENTE'] && activo.get('tipoComercializacionCodigo') !=  CONST.TIPOS_COMERCIALIZACION['ALQUILER_VENTA'])) {
			me.setTopBar(false);
			me.rowEditing.clearListeners();
		} else if(activo.get('esHayaHome')=="true"){ 
			me.setTopBar(false);
		} 
		
		if (activo.get('vistaDeConcurrencia') == true){ 
			me.setTopBar(true);
		}
		
   },

	onClickCloneExpedienteButton : function(btn) {

		var me = this;

		var selectionModel = me.getSelectionModel();

		var ofertasData = me.getNavigationModel().store.data.items;
		var ofertaSeleccionadaData = selectionModel.getSelection()[0].data;

		var sePuedeClonarExpediente = ofertaSeleccionadaData.codigoEstadoOferta == CONST.ESTADOS_OFERTA['RECHAZADA'] || ofertaSeleccionadaData.codigoEstadoOferta == CONST.ESTADOS_OFERTA['CADUCADA'];
		
		if (!sePuedeClonarExpediente) {
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.clonar.oferta.no.anulada"));
			return false;
		}
				
		if(!ofertaSeleccionadaData.numExpediente){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.clonar.oferta.sin.expediente"));
			return false;
		}
		
		if (ofertaSeleccionadaData.idAgrupacion) {
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.clonar.oferta.agrupacion"));
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
        var activo = me.lookupController().getViewModel().get('activo'),

		mostrarCloneButtonExpediente = ($AU.userIsRol('HAYASUPER') || $AU.userIsRol('HAYAGESTCOM') || $AU.userIsRol('HAYAGBOINM')
										&& (me.lookupController().getViewModel().data.activo.data.tipoComercializacionCodigo === CONST.TIPOS_COMERCIALIZACION['VENTA']
											|| me.lookupController().getViewModel().data.activo.data.tipoComercializacionCodigo === CONST.TIPOS_COMERCIALIZACION['ALQUILER_VENTA'])
	        							/*
										 * &&
										 * (me.lookupController().getViewModel().get('activo').data.subcarteraCodigo
										 * ===
										 * CONST.SUBCARTERA['APPLEINMOBILIARIO'] ||
										 * me.lookupController().getViewModel().get('activo').data.subcarteraCodigo
										 * === CONST.SUBCARTERA['DIVARIAN'])
										 */
	    								);
	    mostrarCloneButtonExpediente = (activo.get('isCarteraBankia') == true) ? false : mostrarCloneButtonExpediente;
		me.mostrarBotonClonarExpediente(mostrarCloneButtonExpediente);
	},
	
	ofertaActivoEpaAlquilado: function (activo){
		if(activo.get('entidadPropietariaCodigo')==CONST.CARTERA['BBVA']){
			if(activo.get('tipoEstadoAlquiler') == CONST.COMBO_ESTADO_ALQUILER['ALQUILADO'] && activo.get('activoEpa') == true){
				return 3;
			} else if(activo.get('tipoEstadoAlquiler') == CONST.COMBO_ESTADO_ALQUILER['ALQUILADO']){
				return 2;
			}else if(activo.get('activoEpa') == true){
				return 1;
			}
		}else{
			return 0;
		}
	}
	
});
