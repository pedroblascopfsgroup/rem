Ext.define('HreRem.view.activos.detalle.HistoricoSolicitudesPrecioGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'historicosolicitudespreciosgrid',
	topBar		: true,
	targetGrid	: 'historicoSolicitudesPrecios',
	editOnSelect: true,
	removeButton: false,
	sortableColumns: false,
	idPrincipal : 'id',
	requires	: ['HreRem.model.HistoricoTramtitacionTituloModel'],
    bind: {
        store: '{storeHistoricoSolicitudesPrecios}'
    },
    listeners:{
    	boxready: function() {
    		var me = this;
    		me.evaluarEdicion();
    	},
    	beforeEdit: 'validarEdicionHistoricoSolicitudesPrecios'
    },

    initComponent: function () {
     	var me = this;
		me.columns = [
				{
					text: 'Id Activo',
					dataIndex: 'idActivo',
					hidden: true,
					hideable: false
				},
				{
					dataIndex: 'idPeticion',
					text: HreRem.i18n('header.propuestas.precios.codigo.peticion'),
					flex: 1
				},
		        {
		            dataIndex: 'tipoFecha',
		            text: HreRem.i18n('header.propuestas.precios.tipo.fecha'),
		            editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'tipoPeticionPrecio'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
		            flex: 1
		        },
		        {	
		            dataIndex: 'fechaSolicitud',
		            text: HreRem.i18n('header.propuestas.precios.fecha.solicitud'), 
		            editor: {
		        		xtype: 'datefield',
		        		reference: 'fechaSolicitud',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		maxValue: new Date() 
		        		
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'fechaSancion',
		            text: HreRem.i18n('header.propuestas.precios.fecha.sancion'),
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		reference: 'fechaSancon',
		        		maxValue: new Date()
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },		        
		        {
		            dataIndex: 'observaciones',
		            text: HreRem.i18n('fieldlabel.historico.tramitacion.titulo.observaciones'), 
		            editor: {
		        		xtype: 'textareafield'
		        	},
		            flex: 1
		         
		        },		        
		        {
		            dataIndex: 'usuarioModificar',
		            text: HreRem.i18n('header.propuestas.precios.usuario.modificador'), 
		            flex: 1
		            
		        }
		    ];
		

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{storeHistoricoSolicitudesPrecios}'
		            }
		        }
		    ];
		    
		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('preciosactivo').funcionRecargar();
		    	return true;
		    };
		    
		     me.saveFailureFn = function() {
		    	var me = this;
		    	me.up('preciosactivo').funcionRecargar();
		    	return true;
		    };

		    me.callParent();
	        
	        
   },
   
   onAddClick: function(btn){
		
		var me = this;
		var rec = Ext.create(me.getStore().config.model);
		me.getStore().sorters.clear();
		me.editPosition = 0;
		rec.setId(null);
		rec.data.esEditable = true;
	    me.getStore().insert(me.editPosition, rec);
	    me.rowEditing.isNew = true;
	    me.rowEditing.startEdit(me.editPosition, 0);
	    me.disableAddButton(true);
	    me.disablePagingToolBar(true);

   },
   
   editFuncion: function(editor, context){
 		var me= this;
		me.mask(HreRem.i18n("msg.mask.espere"));
		
		if (me.isValidRecord(context.record) ) {		

      		context.record.save({
      				
                  params: {
                  	idPeticion: context.record.data.idPeticion,
                    idActivo: me.lookupController().getViewModel().data.activo.id  
                  },
                  success: function (a, operation, c) {
                      if (context.store.load) {
                      	context.store.load();
                      }
                      me.unmask();
                      me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));																			
						me.saveSuccessFn();											
                  },
                  
				failure: function (a, operation) {
                  	try {
                  		
                  		var response = Ext.JSON.decode(operation.getResponse().responseText)
                  		
                  	}catch(err) {}
                  	
                  	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msgError)) {
                  		me.fireEvent("errorToast", response.msgError);
                  	} else {
                  		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                  	}     
                  		me.up('preciosactivo').funcionRecargar();
						me.unmask();
                  }
               });                            
      		me.disablePagingToolBar(false);
      		me.getSelectionModel().deselectAll();
      		editor.isNew = false;
			}
      
   },
   
   evaluarEdicion: function() {
		var me = this;
		
		if($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_PRECIOS']) || $AU.userIsRol(CONST.PERFILES['GESTOR_PUBLICACION'])) {
			me.setTopBar(true);
		}else{
			me.setTopBar(false);
		}
   }
   
});
