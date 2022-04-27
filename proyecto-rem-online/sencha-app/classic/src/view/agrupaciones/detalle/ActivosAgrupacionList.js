Ext.define('HreRem.view.agrupaciones.detalle.ActivosAgrupacionList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'activosagrupacionlist',
    topBar		: false,
    cls			: 'panel-base shadow-panel',
    allowDeselect: true,
	allowBlank	: true,
    idPrincipal	: 'agrupacionficha.id',
    bind		: {
		store: '{storeActivos}'
	},
	requires	: ['HreRem.view.common.CheckBoxModelBase', 'HreRem.ux.plugin.PagingSelectionPersistence'],
	secFunToEdit: 'EDITAR_AGRUPACION',
	secButtons	: {
		secFunPermToEnable: 'EDITAR_AGRUPACION'
	},

	listeners	: {
		rowdblclick: 'onActivosAgrupacionListDobleClick',
		rowclick: function(grid, record, tr, rowIndex, event, eOpts) {
			var me = this;

			if(Ext.isEmpty(grid.getSelection())){
				me.submenuItemsDisabled(true);
			} else {
				me.submenuItemsDisabled(false);
			}
		},
		boxready: function() {
			var me = this;
		},
		edit: function(editor, context, eOpts) {
			var me = this;
			me.editFuncion(editor, context);
	    },
	    beforeedit: function(editor) {
	    	var me = this;
        	//Si ya estamos editando o no estamos creando un registro nuevo ni se permite la edición
        	if (editor.editing || (!editor.isNew && !me.editOnSelect)) {
        		return false;
        	}
	    },
	    canceledit: function(editor){
	    	var me = this;
			me.disableAddButton(false);
			me.disablePagingToolBar(false);
        	me.getSelectionModel().deselectAll();
        	if(editor.isNew) {
        		me.getStore().remove(me.getStore().getAt(me.editPosition));
        		editor.isNew = false;
        	}
	    }
    },

    initComponent: function () {
        var me = this;
        var estadoRenderer =  function(condicionado) {
        	var src = '',
        	alt = '',
        	ret = '';
        	
        	if (condicionado == '0') {
        		src = 'icono_KO.svg';
        		alt = 'KO';
        		ret = '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="15px"></div>';
        	} else if(condicionado == '1'){ 
        		src = 'icono_OK.svg';
        		alt = 'OK';
        		ret = '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="15px"></div>';
        	} else if(condicionado == '2'){
        		src = 'icono_OKN.svg';
        		alt = 'OKN';
        		ret = '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="15px"></div>';
        	} else ret= '<div>-</div>';
        	
        	return ret;
        }; 

        // Plugin edicion.
        me.rowEditing = new Ext.grid.plugin.RowEditing({
			pluginId: 'rowEditingPlugin',
			// Puesto para cancelar el save con el onEnterKey
			config: {
	            buttonFocus: ''
	        },  
	        onEnterKey: function (){},
			saveBtnText  : HreRem.i18n('btn.saveBtnText'),
			cancelBtnText: HreRem.i18n('btn.cancelBtnText'),
			errorsText: HreRem.i18n('btn.errorsText'),
			dirtyText: HreRem.i18n('btn.dirtyText'),
            clicksToMoveEditor: 1,
       	 	autoCancel: false,
       	 	errorSummary: false
        });

        // Plugin checkboxes.
        me.pagingSelectPersist = new HreRem.ux.plugin.PagingSelectionPersistence({
        	pluginId: 'pagingselectpersist'
        });

        // Preparar plugins.
        var addRowPluginFunction = function() {
			Ext.apply(me, {
				plugins: [me.rowEditing,  me.pagingSelectPersist],
				editable: true
				});	
				
		};
		
		// Aplicar plugins segun permisos.
		if(Ext.isEmpty(me.rowPluginSecurity) && Ext.isEmpty(me.secFunToEdit)) {		
			addRowPluginFunction();
		} else if (!Ext.isEmpty(me.secFunToEdit)) {
			$AU.confirmFunToFunctionExecution(addRowPluginFunction, me.secFunToEdit);
		} else {
			$AU.confirmRolesToFunctionExecution(addRowPluginFunction, me.rowPluginSecurity);
		}

        // Botones genéricos de la barra del grid.
        var configAddBtn = {iconCls:'x-fa fa-plus', itemId:'addButton', bind: {hidden: '{esAgrupacionCaixaOrPromocionAlquilerOrONDnd}'}, handler: 'onAddClick', scope: this}; 
		var configRemoveBtn = {iconCls:'x-fa fa-minus', itemId:'removeButton', bind: {hidden: '{esAgrupacionEditableCaixaOrONDnd}'},  handler: 'onDeleteClick', scope: this, disabled: true};
		

		// Se configura manualmente la Top-Bar mostrándola si se dispone de alguno de los siguientes permisos.
		if($AU.userHasFunction(['EDITAR_TAB_LISTA_ACTIVOS_AGRUPACION', 'EDITAR_TAB_PUBLICACION_LISTA_ACTIVOS_AGRUPACION'])) {
			me.tbar = {
	    		xtype: 'toolbar',
	    		dock: 'top'
			};
					
			// Insertar elementos a la Top-Bar según permisos y tipos de agrupación.
			me.tbar.items = [];
			
			var agrupacionPromocionAlquiler = false;
			var tipoAgrupacion =  this.lookupController().getViewModel().get('agrupacionficha.tipoAgrupacionCodigo');
			
			if ((tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROMOCION_ALQUILER'])) {
	     		agrupacionPromocionAlquiler = true;
	     	}
			
			if($AU.userHasFunction(['EDITAR_TAB_LISTA_ACTIVOS_AGRUPACION'])) {
				if(agrupacionPromocionAlquiler){
					if($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_COMERCIAL']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_COMERCIAL'])){
						me.tbar.items.push(configAddBtn);
						me.tbar.items.push(configRemoveBtn);
					}
				}else{
					me.tbar.items.push(configAddBtn);
					me.tbar.items.push(configRemoveBtn);
				}	
		    }
			
			/*var tipoAgrupacion = me.up('agrupacionesdetallemain').getViewModel().get('agrupacionficha').get('tipoAgrupacionCodigo');
			if($AU.userHasFunction(['EDITAR_TAB_PUBLICACION_LISTA_ACTIVOS_AGRUPACION']) &&
					(tipoAgrupacion==CONST.TIPOS_AGRUPACION['OBRA_NUEVA'] || tipoAgrupacion==CONST.TIPOS_AGRUPACION['ASISTIDA'])) {
				// Submenu del Grid.
		        me.menu = Ext.create("Ext.menu.Menu", {
				    cls: 'menu-favoritos',
				    plain: true,
				    floating: true,
			    	items: [
			    		{
			    			text: HreRem.i18n('grid.submenu.msg.publicar.agrupacion'),
			    			handler: 'onClickPublicarAgrupacionSubmenuGrid',
			    			disabled: true
			    		},
			    		{
			    			text: HreRem.i18n('grid.submenu.msg.publicar.activos.seleccionados'),
			    			handler: 'onClickPublicarActivosSeleccionadosSubmenuGrid',
			    			reference: 'submenugridpublicaractivosbtn',
			    			disabled: true
			    		},
			    		{
			    			text: HreRem.i18n('grid.menu.msg.publicar.subdivisiones.activos.seleccionados'),
			    			handler: 'onClickPublicarSubdivisionesActivosSeleccioandosSubmenuGrid',
			    			reference: 'submenugridpublicarsubdivisionesbtn',
			    			disabled: true
			    		}
			    	]
			    	
			    });
		     // Botones de submenú de la barra del grid.
		        var configGridMenu = {iconCls:'x-fa fa-bars', cls:'boton-cabecera', itemId:'menuGridBtn', arrowVisible: false, menuAlign: 'tr-br', menu: me.menu};
		        var separador = {xtype: 'tbfill'};
				
				me.tbar.items.push(separador);
				me.tbar.items.push(configGridMenu);
			}*/
		}
        
        var coloredRender = function (value, meta, record) {
    		var borrado = record.get('borrado');
    		var tipoAgrupacion = me.up('agrupacionesdetallemain').getViewModel().get('agrupacionficha').get('tipoAgrupacionCodigo');
    		
    		if (borrado == 1 && tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROMOCION_ALQUILER']) {
    			return '<span style="color: #DF0101;">'+value+'</span>';
    		} else {
    			return value; 
    		}
    	};
 
        me.columns= [
        	{
		        xtype: 'actioncolumn',
		        reference: 'activoPrincipal',
		        bind: {
		        	hidden: '{!esAgrupacionRestringida}'
		        },
		        width: 30,
		        text: HreRem.i18n('header.principal'),
				hideable: false,
				items: [
				        	{
					            getClass: function(v, meta, rec) {
					                if (rec.get('activoPrincipal') != 1) {
					                	this.items[0].handler = 'onMarcarPrincipalClick';
					                    return 'fa fa-check';
					                } else {
			            				this.items[0].handler = 'onMarcarPrincipalClick';
					                    return 'fa fa-check green-color';
					                }
					            }
				        	}
				 ]
    		},
    		{
	            dataIndex: 'numActivo',
	            text: HreRem.i18n('header.numero.activo.haya'),
	            flex: 0.6,
				editor: {
					xtype:'textfield',
					maskRe: /[0-9]/
				},
				renderer: coloredRender

	        },
	        {
	        	dataIndex: 'idPrinexHPM',
	        	text: HreRem.i18n('header.id.prinex.hpm'),
	        	bind: {
	        		hidden: '{!esAgrupacionPromocionAlquiler}'
	        	},
	        	flex: 1
	        },
	        {   
            	text	 : HreRem.i18n('header.fecha.alta'),
                dataIndex: 'fechaInclusion',
		        formatter: 'date("d/m/Y")',
		        flex: 0.7,
		        width: 130 
		    },
	        {
	            dataIndex: 'tipoActivoDescripcion',
	            text: HreRem.i18n('header.tipo'),
	            flex: 1
	        },
	        {
	            dataIndex: 'subtipoActivoDescripcion',
	            text: HreRem.i18n('header.subtipo'),
	            flex: 0.5
	        },
	        {
	            dataIndex: 'subdivision',
	            text: HreRem.i18n('header.subdivision'),
	            hideable: false,
	            bind: {
		        	hidden: '{!esAgrupacionObraNuevaOrAsistidaOrPromocionAlquiler}'
		        },
	            flex: 2
	        },
	        {
	            dataIndex: 'direccion',
	            text: HreRem.i18n('header.direccion'),
	            hideable: false,
	            bind: {
		        	hidden: '{esAgrupacionObraNuevaOrAsistidaOrPromocionAlquiler}'
		        },
	            flex: 1
	        },
	        {
	            dataIndex: 'numFinca',
	            text: HreRem.i18n('header.finca.registral'),
	            hideable: false,
	            bind: {
		        	hidden: '{!esAgrupacionObraNuevaOrAsistidaOrPromocionAlquiler}'
		        },
	            flex: 0.5
	        },
	        {
	        	 text: HreRem.i18n('title.publicaciones.estadoPublicacion'),
	        	 dataIndex: 'publicado',
	        	 bind: {
	        		 hidden: '{!esAgrupacionObraNuevaOrAsistidaOrPromocionAlquiler}'
	        	 },
	        	 hideable:  false,
	        	 flex: 1
	       },
	       {
	            dataIndex: 'condPublVenta',
	            text: HreRem.i18n('header.condicionantes.publicacion.venta'),
	            flex: 1,
	            hideable: false,
	            bind:{
	            	hidden: '{!esAgrupacionObraNuevaOrAsistida}'
	            },
	            renderer: estadoRenderer
	            
	        },
	        {
	            dataIndex: 'condPublAlquiler',
	            text: HreRem.i18n('header.condicionantes.publicacion.alquiler'),
	            hideable: false,
	            flex: 1,
	            bind:{
	            	hidden: '{!esAgrupacionObraNuevaOrAsistidaOrPromocionAlquiler}'
	            },
	            renderer: estadoRenderer
	            
	        },
	        {
	            dataIndex: 'puerta',
	            text: HreRem.i18n('header.puerta'),
	            hideable: false,
	            bind: {
		        	hidden: '{!esAgrupacionObraNuevaOrAsistidaOrPromocionAlquiler}'
		        },
	            flex: 0.5
	        },
	        {
	            dataIndex: 'situacionComercial',
	            text: HreRem.i18n('header.disponibilidad.comercial'),
	            flex: 1
	        },
	        {
	            dataIndex: 'importeMinimoAutorizado',
	            text: HreRem.i18n('header.valor.web'),
	            flex: 1,
	            bind: {
	        		hidden: '{esAgrupacionPromocionAlquiler}'
	        	},
	            renderer: function(value) {
	        		return Ext.util.Format.currency(value);
	        	},
	            sortable: false
	        },
	        {
	            dataIndex: 'importeAprobadoVenta',
	            text: HreRem.i18n('header.valor.aprobado.venta'),
	            flex: 1,
	            bind: {
	        		hidden: '{esAgrupacionPromocionAlquiler}'
	        	},
	            renderer: function(value) {
	        		return Ext.util.Format.currency(value);
	        	},
	            sortable: false
	        },
	        {
	            dataIndex: 'importeAprobadoRenta',
	            text: HreRem.i18n('header.valor.aprobado.alquiler'),
	            flex: 1,
	            bind: {
	        		hidden: '{!esAgrupacionPromocionAlquiler}'
	        	},
	            renderer: function(value) {
	        		return Ext.util.Format.currency(value);
	        	},
	            sortable: false
	        },
	        {
	            dataIndex: 'importeDescuentoPublicado',
	            text: HreRem.i18n('header.valor.descuento.publicado'),
	            flex: 1,
	            bind: {
	        		hidden: '{esAgrupacionPromocionAlquiler}'
	        	},
	            renderer: function(value) {
	        		return Ext.util.Format.currency(value);
	        	},
	            sortable: false
	        },
	        {
	            dataIndex: 'superficieConstruida',
	            hideable: false,
	            bind: {
		        	hidden: '{esAgrupacionObraNuevaOrAsistidaOrPromocionAlquiler}'
		        },
	            text: HreRem.i18n('header.superficie.construida'),
	            flex: 1,
	            renderer: Ext.util.Format.numberRenderer('0,000.00'),
	            sortable: false
	        },
	        {
	        	 dataIndex: 'activoGencat',
		            hideable: false,
		            bind: {
			        	hidden: '{esAgrupacionLoteComercialOrRestringidaOrNotGencat}'
			        },
		            renderer: function(value) {
		            	return Ext.isEmpty(value) ? "No" : value=='1' ? "Si"  : "No";
		            },
		            text: HreRem.i18n('header.listaActivos.GENCAT'),
		            flex: 0.5,
		            sortable: false
	        },{
		        xtype: 'actioncolumn',
		        reference: 'esPisoPiloto',
		        bind: {
		        	hidden: '{!esAgrupacionThirdpartiesYubaiObraNueva}' // Agrupación Third Party - Yubai
		        },
		        flex: 1,
		        width: 30,
		        text: HreRem.i18n('header.pisoPiloto'),
				hideable: false,
				items: [
				        	{ // Check si es piso piloto
					            getClass: function(v, meta, rec) {
					            	if (rec.get('esPisoPiloto') != 1) {
					                	this.items[0].handler = 'onMarcarPrincipalClick';
					                    return 'fa fa-check';
					                } else {
			            				this.items[0].handler = 'onMarcarPrincipalClick';
					                    return 'fa fa-check green-color';
					                }
					            }
				        	}
				 ]
    		}
        ];

        me.saveSuccessFn = function() {
	    	if (Ext.isFunction(me.lookupController().refrescarAgrupacion)) {
	    		me.lookupController().onClickBotonRefrescar();
	    	}
	    };

	    me.deleteSuccessFn = function() {
	    	if (Ext.isFunction(me.lookupController().refrescarAgrupacion)) {
	    		me.lookupController().onClickBotonRefrescar();
	    	}
	    };

	    me.deleteFailureFn = function() {
	    	if (Ext.isFunction(me.lookupController().refrescarAgrupacion)) {
	    		me.lookupController().onClickBotonRefrescar();
	    	}
	    };
	    
		

        me.dockedItems = [
        	{
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            displayInfo: true,
	            bind: {
	                store: '{storeActivos}'
	            },
	            items:[
	            	{
	            		xtype: 'tbfill'
	            	},
	                {
	                	xtype: 'displayfieldbase',
	                	itemId: 'displaySelection',
	                	fieldStyle: 'color:#0c364b; padding-top: 4px'
	                }
	            ]
	        }
		];

        me.selModel = Ext.create('HreRem.view.common.CheckBoxModelBase');
    	me.callParent();

    	me.getSelectionModel().on({
        	'selectionchange': function(sm,record,e) {
        		var displaySelection = me.down('displayfield[itemId=displaySelection]');
    			var persistedSelection = me.getPersistedSelection();
    			var disabled = Ext.isEmpty(persistedSelection);

    			if(disabled) {
    				displaySelection.setValue("No seleccionados");
    				me.disableRemoveButton(true);
    			} else if (persistedSelection.length > 1) {
    				displaySelection.setValue(persistedSelection.length +  " elementos seleccionados");
    				me.disableRemoveButton(true); // Solo permitir eliminar un único elemento a la vez.
    			} else {
    				displaySelection.setValue("1 elemento seleccionado"); 
    			}
        	},

        	'selectall': function(sm) {
        		me.pagingSelectPersist.selectAll();
        		me.submenuItemsDisabled(false);
        	},

        	'deselectall': function(sm) {
        		me.pagingSelectPersist.deselectAll();
        		me.submenuItemsDisabled(true);
        	}
        });
    },

    getActivoIDPersistedSelection: function() {
    	var me = this;
    	var arraySelection = me.getPlugin('pagingselectpersist').getPersistedSelection();
		var activoSelection = [];

		Ext.Array.each(arraySelection, function(rec) {
			activoSelection.push(rec.getData().activoId);
        });

    	return activoSelection;
    },

    deselectAll: function() {
    	var me = this;
    	return me.pagingSelectPersist.deselectAll();     		
    },

    onAddClick: function(btn){
	  var me = this;
      var isFormalizacion = me.up('agrupacionesdetallemain').lookupReference('comboFormalizacion').value;
      var isComercialVenta = me.up('agrupacionesdetallemain').getViewModel().get("agrupacionficha.isComercialVenta");
      var provincia = me.up('agrupacionesdetallemain').getViewModel().get("agrupacionficha.provinciaCodigo");
      var cartera = me.up('agrupacionesdetallemain').getViewModel().get("agrupacionficha.codigoCartera");
      var tipoAgrupacion = me.up('agrupacionesdetallemain').getViewModel().get('agrupacionficha').get('tipoAgrupacionCodigo');
      if (isComercialVenta && isFormalizacion==null) {
          Ext.Msg.show({ message: 'No se ha definido el perímetro de formalización.', buttons: Ext.Msg.YES});
      } else if ((tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROYECTO']) && (provincia == null || cartera == null)){
    	  Ext.Msg.show({ message: 'No se ha cumplimentado el campo Provincia o Cartera.', buttons: Ext.Msg.YES});
      } else {
          var rec = Ext.create(me.getStore().config.model);
          me.getStore().sorters.clear();
          me.editPosition = 0;
          me.getStore().insert(me.editPosition, rec);
          me.rowEditing.isNew = true;
          me.rowEditing.startEdit(me.editPosition, 0);
          me.disableAddButton(true);
          me.disablePagingToolBar(true);
          me.disableRemoveButton(true);
      }

    },

    onDeleteClick: function(btn){
    	var me = this;
    	var sePuedeBorrar;
    	var tipoAgrupacion = me.up('agrupacionesdetallemain').getViewModel().get('agrupacionficha').get('tipoAgrupacionCodigo');
    	var ua = false;
    	
    	
    	if((tipoAgrupacion != CONST.TIPOS_AGRUPACION['RESTRINGIDA'])
    			|| (tipoAgrupacion != CONST.TIPOS_AGRUPACION['RESTRINGIDA_ALQUILER'])
    			|| (tipoAgrupacion != CONST.TIPOS_AGRUPACION['RESTRINGIDA_OBREM'])){
    		sePuedeBorrar = true;
    	}else if(me.selection.data.activoPrincipal != 1){
    		sePuedeBorrar = true;
    	}else{
    		sePuedeBorrar = false;
    	}
    	
    	//Si el activo es PA
    	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROMOCION_ALQUILER'])) {
    		//Validaciones RUFU-016
        	if(me.selection.data.borrado == 1) { //Comprobamos si el activo ha sido previamente dado de baja
        		sePuedeBorrar = false;
        		ua = true;
        	}	
    	}
    		    	
    	if(sePuedeBorrar){
    	
	        Ext.Msg.show({
				   title: HreRem.i18n('title.confirmar.eliminacion'),
				   msg: HreRem.i18n('msg.desea.eliminar'),
				   buttons: Ext.MessageBox.YESNO,
				   fn: function(buttonId) {
				        if (buttonId == 'yes') {
				        	me.mask(HreRem.i18n("msg.mask.espere"));
				    		me.rowEditing.cancelEdit();
				            var sm = me.getSelectionModel();
	
							// Se borra 1 activo de la agrupacion
							me.selection.erase({
								params: {agrId: me.selection.data.agrId, activoId: me.selection.data.activoId},
				            	success: function (a, operation, c) {
	                                me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
									me.unmask();
									me.deleteSuccessFn();
	                            },
	                            
	                            failure: function (a, operation) {
	                            	var data = {};
	                            	try {
	                            		data = Ext.decode(operation._response.responseText);
	                            	}
	                            	catch (e){ };
	                            	if (!Ext.isEmpty(data.msg)) {
	                            		me.fireEvent("errorToast", data.msg);
	                            	} else {
	                            		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	                            	}
									me.unmask();
									me.deleteFailureFn()
	                            }
	                        });
							
				            if (me.getStore().getCount() > 0) {
				                sm.select(0);
				            }
				        }
				   }
			});
    	}else{
    		if(ua) {
    			me.fireEvent("errorToast", HreRem.i18n("msg.operation.ko.activoDadoDeBaja"));
        		me.deleteFailureFn();
        	} else {
        		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.activoPrincipal"));
        		me.deleteFailureFn();
        	}

    	}
    },
    
    setTopBar: function(topBar) {
    	var me = this;
    	me.topBar = topBar;
    	//if(!me.topBar) {
    		var toolbarDockItem = me.dockedItems.filterBy(
	    		function (item, key) {
	    			return item.tipo == "toolbaredicion";
	    		}
	    	);
    		if(!Ext.isEmpty(toolbarDockItem) && toolbarDockItem.items.length > 0 ) {
    			toolbarDockItem.items[0].setVisible(topBar);
    		}
    	//}
    },

    disablePagingToolBar: function(disabled) {
    	var me = this,
    	paginToolBar = me.down('pagingtoolbar');

    	if(!Ext.isEmpty(paginToolBar)) {
    		paginToolBar.setDisabled(disabled);
    	}
    },

    disableAddButton: function(disabled) {
    	var me = this;

    	if (!Ext.isEmpty(me.down('#addButton'))) {
    		me.down('#addButton').setDisabled(disabled);    		
    	}
    },

    disableRemoveButton: function(disabled) {
    	var me = this;

    	if (!Ext.isEmpty(me.down('#removeButton')) && !me.disabledDeleteBtn) {
    		me.down('#removeButton').setDisabled(disabled);    		
    	}
    },

    submenuItemsDisabled: function(disabled) {
    	var me = this;

		var menuItemPublicarActivos = me.up('agrupacionesdetallemain').lookupReference('submenugridpublicaractivosbtn');
		var menuItemPublicarSubdivisionesActivos = me.up('agrupacionesdetallemain').lookupReference('submenugridpublicarsubdivisionesbtn');

		if(!Ext.isEmpty(menuItemPublicarActivos) && !Ext.isEmpty(menuItemPublicarSubdivisionesActivos)) {
			if(disabled){
				menuItemPublicarActivos.setDisabled(true);
				menuItemPublicarSubdivisionesActivos.setDisabled(true);
			} else {
				menuItemPublicarActivos.setDisabled(false);
				menuItemPublicarSubdivisionesActivos.setDisabled(false);
			}
		}
    },

    isValidRecord: function(record) {    	
    	return true;    	
    },

    editFuncion: function(editor, context){
   		var me= this;
		me.mask(HreRem.i18n("msg.mask.espere"));
			if (me.isValidRecord(context.record)) {			
        		context.record.save({
                    params: {
                        idEntidad: Ext.isEmpty(me.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(me.idPrincipal)
                    },

                    success: function (a, operation, c) {
                        context.store.load();
                        me.unmask();
                        me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));																			
						me.saveSuccessFn();											
						
                    },

					failure: function (a, operation) {
                    	context.store.load();
                    	try {
                    		var response = Ext.JSON.decode(operation.getResponse().responseText)
                    		
                    	}catch(err) {}
                    	
                    	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msg)) {
                    		me.fireEvent("errorToast", response.msg);
                    	} else {
                    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                    	}                        	
						me.unmask();
                    }
                });	                            
        		me.disableAddButton(false);
        		me.disablePagingToolBar(false);
        		me.getSelectionModel().deselectAll();
        		editor.isNew = false;
			}
   }
});
