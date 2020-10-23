Ext.define('HreRem.view.activos.detalle.ReqFaseVentaGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'reqfaseventagrid',
	topBar		: true,
	targetGrid	: 'reqfaseventa',
	editOnSelect: false,
	removeButton: true,
	sortableColumns: false,
	idPrincipal : 'id',
	requires	: ['HreRem.model.ReqFaseVentaModel'],
    bind: {
        store: '{storeReqFaseVenta}'
    },
    listeners:{
    	boxready: function() {
    		var me = this;
    		me.evaluarEdicion();
    	}
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
					dataIndex: 'fechapreciomaximo',
					text: HreRem.i18n('fieldlabel.fecha.sol.precio.max'),
					editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		reference: 'fechapreciomaximo',
		        		allowBlank: false
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
				},
		        {
		            dataIndex: 'fecharespuestaorg',
		            text: HreRem.i18n('fieldlabel.fecha.respuesta.organismo'),
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		reference: 'fecharespuestaorg'
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {	
		            dataIndex: 'preciomaximo',
		            text: HreRem.i18n('fieldlabel.precio.maximo'),
		            editor: {
		        		xtype:'textfield',
		        		maskRe: /[0-9.]/,
		        		allowNegative: false,
		        		minValue: 0,
		        		hideTrigger: true,
		        		keyNavEnable: false,
		        		mouseWheelEnable: false
		        	},
		        	renderer: function(value) {
   				        return Ext.util.Format.currency(value);
   				    },
		            flex: 1
		        },
		        {
		            dataIndex: 'fechavencimiento',
		            text: HreRem.i18n('fieldlabel.fecha.vencimiento'),
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor',
		        		reference: 'fechavencimiento'
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },	
		        {
		            dataIndex: 'usuariocrear',
		            text: HreRem.i18n('fieldlabel.usuario'),
		            flex: 1
		            
		        },
		        {
		            dataIndex: 'fechacrear',
		            text: HreRem.i18n('fieldlabel.fecha.creacion'),
		            flex: 1,
   				    formatter: 'date("d/m/Y")'
		         
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
		                store: '{storeReqFaseVenta}'
		            }
		        }
		    ];
		    
		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('informacionadministrativaactivo').funcionRecargar();
		    	return true;
		    };
		    
		     me.saveFailureFn = function() {
		    	var me = this;
		    	me.up('informacionadministrativaactivo').funcionRecargar();
		    	return true;
		    };
		    
		    me.deleteSuccessFn = function(){
	    		me.saveSuccessFn();
	    		this.setSelection(0);
	    	};
	     	
	     	me.deleteFailureFn = function(){
	    		me.saveFailureFn();
	    	};


		    me.callParent();
	        
	        
   },
   
   onAddClick: function(btn){
		
		var me = this;
		var idActivo = me.lookupController().getViewModel().getData().activo.id;
		me.getStore().sorters.clear();
		me.editPosition = 0;
	    me.getStore().insert(me.editPosition,  new HreRem.model.ReqFaseVentaModel({idActivo: idActivo}));
	    me.rowEditing.isNew = true;
	    me.rowEditing.startEdit(me.editPosition, 0);
	    me.disableAddButton(true);
	    me.disablePagingToolBar(true);

   },
   
   onDeleteClick : function() {
		var me = this;
		var grid = me;

		var idReq = me.getSelection()[0].getData().idReq;
		var idActivo = me.getSelection()[0].getData().idActivo;
		Ext.Msg.show({
			title : HreRem.i18n('title.mensaje.confirmacion'),
			msg : HreRem.i18n('msg.desea.eliminar'),
			buttons : Ext.MessageBox.YESNO,
			fn : function(buttonId) {
				if (buttonId == 'yes') {
					grid.mask(HreRem.i18n("msg.mask.loading"));
					var url = $AC.getRemoteUrl('activo/deleteReqFaseVenta');
					Ext.Ajax.request({
						url : url,
						method : 'POST',
						params : {
							idReq: idReq, idActivo: idActivo
						},

						success : function(response, opts) {
							grid.getStore().load();
							me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
							grid.unmask();
						},
						failure : function(record, operation) {
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
							grid.unmask();
						},
						callback : function(record, operation) {
							grid.unmask();
						}
					});
				}
			}
		});

	},
   
   evaluarEdicion: function() {
		var me = this;
		
		if($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION'])) {
			me.setTopBar(true);
		}else{
			me.setTopBar(false);
		}
   }
   
});
