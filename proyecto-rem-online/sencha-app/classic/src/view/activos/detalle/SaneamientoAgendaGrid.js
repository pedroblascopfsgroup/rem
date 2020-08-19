Ext.define('HreRem.view.activos.detalle.SaneamientoAgendaGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'saneamientoagendagrid',
	topBar		: true,
	propagationButton: false,
	targetGrid	: 'saneamientoagenda',
	idPrincipal : 'id',
	idSecundaria : 'activo.id',
	//editable: true,
	editOnSelect: true,
	//disabledDeleteBtn: true,

    bind: {
        store: '{storeSaneamientoAgendaGrid}'
    },
    
    listeners: {
    	boxready: function() {
    		var me = this;
    		me.evaluarEdicion();
    	}
    },

    initComponent: function () {

     	var me = this;
     	
     	me.deleteSuccessFn = function(){
    		this.getStore().load()
    		this.setSelection(0);
    	};
     	
     	me.deleteFailureFn = function(){
    		this.getStore().load()
    	};

		me.columns = [
				{
					text: 'Id Agenda',
					dataIndex: 'idSan',
					hidden: true,
					hideable: false
				},
				{
					text: 'Id Activo',
					dataIndex: 'idActivo',
					hidden: true,
					hideable: false
				},
				{	  
		            text: HreRem.i18n('header.patrimonio.contrato.tipologia'),				            
		            dataIndex: 'tipologiaDesc',
		            flex: 1
				},
				{	  
		            text: HreRem.i18n('fieldlabel.agenda.revision.titulo.subtipologia'),				            
		            dataIndex: 'subtipologiaDesc',
		            flex: 1
				},
				{   text: HreRem.i18n('fieldlabel.agenda.revision.titulo.observaciones'),
					dataIndex: 'observaciones',
					editor: {
						xtype: 'textarea'
					},
		        	flex: 1
				},
				{   text: HreRem.i18n('fieldlabel.agenda.revision.titulo.gestor.alta'),
		        	dataIndex: 'usuariocrear', 
		        	flex: 1
				},
				{   text: HreRem.i18n('fieldlabel.agenda.revision.titulo.fecha.alta'),
		        	dataIndex: 'fechaCrear',
		        	formatter: 'date("d/m/Y")',
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
		                store: '{storeSaneamientoAgendaGrid}'
		            }
		        }
		    ];
		    
		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('admisionactivo').funcionRecargar();
		    	return true;
		    };
		    
		    me.saveFailureFn = function() {
		    	var me = this;
		    	me.up('admisionactivo').funcionRecargar();
		    	return true;
		    };

		    me.callParent();
   },
	
	onAddClick: function(btn){
		
		var me = this;
		me.mask(HreRem.i18n("msg.mask.loading"));
 		var activo = me.lookupController().getViewModel().get('activo'),
 		idActivo= activo.get('id');
 		
 		var ventana = Ext.create("HreRem.view.activos.detalle.AnyadirAgendaSaneamiento", {idActivo: idActivo});
 		me.up('activosdetallemain').add(ventana);
		ventana.show();
		me.unmask();

   },
   
   editFuncion: function(editor, context){
  		var me= this;
		me.mask(HreRem.i18n("msg.mask.espere"));

			if (me.isValidRecord(context.record)) {				
			
       		context.record.save({
       				
                   params: {
                       idSan: context.record.data.idSan
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
       
   },
   
   onDeleteClick : function() {
		var me = this;
		var grid = me;

		var idSan = me.getSelection()[0].getData().idSan;
		var idActivo = me.getSelection()[0].getData().idActivo;
		Ext.Msg.show({
			title : HreRem.i18n('title.mensaje.confirmacion'),
			msg : HreRem.i18n('msg.desea.eliminar'),
			buttons : Ext.MessageBox.YESNO,
			fn : function(buttonId) {
				if (buttonId == 'yes') {
					grid.mask(HreRem.i18n("msg.mask.loading"));
					var url = $AC.getRemoteUrl('activo/deleteSaneamientoAgenda');
					Ext.Ajax.request({
						url : url,
						method : 'POST',
						params : {
							idSan: idSan, idActivo: idActivo
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

		if($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION'])) {
			me.setTopBar(true);
		}else{
			me.setTopBar(false);
			me.rowEditing.clearListeners();
		}
   }

});
