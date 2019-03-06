Ext.define('HreRem.view.activos.detalle.OfertasComercialActivoList', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'ofertascomercialactivolist',
    bind		: {
        store: '{storeOfertasActivo}'
    },
    requires	: ['HreRem.view.activos.detalle.AnyadirNuevaOfertaActivo', 'HreRem.view.activos.detalle.MotivoRechazoOfertaForm'],
    topBar		: true,
	removeButton: false,
    listeners	: {
    	focusenter: function() {
    		var me = this;
    		me.evaluarEdicion();
    	},
    	boxReady: function() {
    		var me = this;
    		me.evaluarEdicion();
    	},
    	rowclick: 'onOfertaListClick'    		
    },

    initComponent: function () {
        var me = this;

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
			            	if (Ext.isEmpty(record.get("idAgrupacion"))) {
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
		            align: 'right',
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
		            flex: 1
		        },
		        {
		            dataIndex: 'precioPublicado',
		            text: HreRem.i18n('header.oferta.precioPublicado'),
		            flex: 1
		        },
		        {
		        	xtype: 'numbercolumn',
		            dataIndex: 'importeOferta',
		            text: HreRem.i18n('header.oferta.importeOferta'),
		            flex: 1,                	
			        decimalPrecision: 2,
			        decimalSeparation: ',',
			        thousandSeparation: '.'
		        },
		        {
		        	xtype: 'numbercolumn',
		            dataIndex: 'importeContraoferta',
		            text: HreRem.i18n('header.oferta.importeContraoferta'),
		            flex: 1,
		            decimalPrecision: 2,
			        decimalSeparation: ',',
			        thousandSeparation: '.'
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
							autoLoad: true,
							bind: {
								disabled: '{activo.aplicaComercializar}'
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
				        			comboEditor.setValue(value);								        			
				        		}
			        		}
			        },
		            flex: 1
		        },
		        /*{
		            dataIndex: 'numExpediente',
		            text: HreRem.i18n('header.oferta.expediente'),
		            flex: 1
		        },*/
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
						
				}
		        
        ];
        
        me.addListener ('beforeedit', function(editor, context) {
            var estado = context.record.get("codigoEstadoOferta");
            var numAgrupacion = context.record.get("numAgrupacionRem");  
            var allowEdit = estado != '01' && estado != '02' && Ext.isEmpty(numAgrupacion);

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
				    
					reference: 'chkbxPerimetroAdmision',
					addUxReadOnlyEditFieldPlugin: false,
					listeners: {
						change: 'onChkbxOfertasAnuladas'
					}
						
	        	}
		        
		];
		
        me.callParent(); 
        
    },
	
    
	onAddClick: function (btn) {
		
		var me = this;
		var activo = me.lookupController().getViewModel().get('activo'),
		idActivo= activo.get('id'),
		numActivo= activo.get('numActivo');
		 
		// Aquí metemos la funcion del fondo
		
		var noContieneTipoAlquiler = false;
		 
		if (activo.get('incluyeDestinoComercialAlquiler')) {
			var codigoTipoAlquiler = activo.get('tipoAlquilerCodigo');
			if (codigoTipoAlquiler == null || codigoTipoAlquiler == '' || codigoTipoAlquiler == '05') {
				noContieneTipoAlquiler = true;
			}
		}
		
		// HREOS-4963 Comprueba que exista un campo de tipo alquiler antes de anyadir  una oferta
		if (!noContieneTipoAlquiler) {
			var parent= me.up('ofertascomercialactivo'),
			oferta = Ext.create('HreRem.model.OfertaComercialActivo', {idActivo: idActivo, numActivo: numActivo});
			
			// HREOS-2930 Permitir acceso menú lateral con ventana Alta de oferta abierta
			var ventana = Ext.create('HreRem.view.activos.detalle.AnyadirNuevaOfertaActivo',{oferta: oferta, parent: parent});
			me.up('activosdetallemain').add(ventana);
			ventana.show();
		} else {
			me.fireEvent("errorToast", HreRem.i18n("msg.comercialAnyadirTipoAlquiler.error"));
		}
				    	
	},
	
	editFuncion: function(editor, context){
		
		var me= this;
		var estado = context.record.get("codigoEstadoOferta");
		var gencat = context.record.get("gencat");
		var msg = HreRem.i18n('msg.desea.aceptar.oferta');
		
		if(CONST.ESTADOS_OFERTA['ACEPTADA'] == estado){
			if (gencat == "true") {
				msg = HreRem.i18n('msg.desea.aceptar.oferta.activos.gencat');
			}
			Ext.Msg.show({
			   title: HreRem.i18n('title.confirmar.oferta.aceptacion'),
			   msg: msg,
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			        	me.saveFn(editor, me, context);
					} else{
			    		me.getStore().load(); 	
			    	}
				}
			});
		} else {
			// HREOS-2814 El cambio a anulada/denegada (rechazada) abre el formulario de motivos de rechazo
			if (CONST.ESTADOS_OFERTA['RECHAZADA'] == estado){
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
					me.saveSuccessFn();
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
//    	me.up('formBase').fireEvent('openModalWindow',"HreRem.view.activos.detalle.MotivoRechazoOfertaForm", {oferta: record.data});
  	    	
    },
    
	isValidRecord: function (record, context) {
		
		var me = this;
		var hayOfertaAceptada=false;
		for (i=0; !hayOfertaAceptada && i<me.getStore().getData().items.length;i++){
			
			if(me.getStore().getData().items[i].data.idOferta != record.data.idOferta){
				var codigoEstadoOferta=  me.getStore().getData().items[i].data.codigoEstadoOferta;
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
		} else if(!hayOfertaAceptada && CONST.ESTADOS_OFERTA['RECHAZADA'] != codigoEstadoNuevo && CONST.ESTADOS_OFERTA['ACEPTADA'] != codigoEstadoNuevo && CONST.ESTADOS_OFERTA['CONGELADA'] != codigoEstadoNuevo){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.solo.aceptar.rechazar"));
			return false;
		}
		
		//HREOS-2814 Validacion si estado oferta = rechazada, tipo y motivo obligatorios.
		if(CONST.ESTADOS_OFERTA['RECHAZADA'] == codigoEstadoNuevo){
			if (record.data.tipoRechazoCodigo == null || record.data.motivoRechazoCodigo == null){
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.rechazar.motivos"));
				return false;
			}
		}
		
		return true;			
	},
    saveSuccessFn: function () {
   		var me = this;
        me.unmask();			                        
        me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
        me.up('activosdetalle').lookupController().refrescarActivo(true);
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
   
   //HREOS-846 Si NO esta dentro del perimetro, ocultamos del grid las opciones de agregar/elminar y las acciones editables por fila
   //HREOS-1001 Si está en el perimetro pero no es comercializable tampoco se puede editar
   //HREOS-1971 Si el usuario no tiene la funcion de editar el listado tampoco se puede editar
   //HREOS-4963 Si el activo es de alquiler o venta y no tiene tipo de alquiler asignado no se podra editar
   evaluarEdicion: function() {
	    
		var me = this;
		var activo = me.lookupController().getViewModel().get('activo');
		
		if(activo.get('incluidoEnPerimetro')=="false" || !activo.get('aplicaComercializar') || activo.get('pertenceAgrupacionRestringida')
			|| activo.get('isVendido') || !$AU.userHasFunction('EDITAR_LIST_OFERTAS_ACTIVO')  || activo.get('isActivoEnTramite')) {
			me.setTopBar(false);
			me.rowEditing.clearListeners();
		}
		
   }


});