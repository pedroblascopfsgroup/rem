Ext.define('HreRem.view.expedientes.FechaArrasGrid', {
     extend		: 'HreRem.view.common.GridBaseEditableRow',
     xtype		: 'fechaArrasGrid',
     topBar		: true,
     propagationButton: false,
     targetGrid	: 'fechaArras',
     idPrincipal : 'id',
     idSecundaria: 'expediente.id',
     editOnSelect: true,
     removeButton: false,
     requires : [ 'HreRem.model.FechaArrasModel'],	
     bind: {
         store: '{storeFechaArras}'
     },

      initComponent: function () {

          	var me = this;

          	me.deleteSuccessFn = function(){
         		this.getStore().load()
         		this.setSelection(0);
         	}

          	me.deleteFailureFn = function(){
         		this.getStore().load()
         	},

         	/*var coloredRender = function(value, meta, record) {
                var borrado = record.get('fechaFinPosicionamiento');
                if (value) {
                    if (borrado) {
                        return '<span style="color: #DF0101;">' + value + '</span>';
                    } else {
                        return value;
                    }
                } else {
                    return '-';
                }
            };*/

     		me.columns = [
     				{
     					text: 'Id',
     					dataIndex: 'id',
     					hidden: true,
     					hideable: false
     				},
                    {
                        text: HreRem.i18n('header.fecha.alta'),
                        dataIndex: 'fechaAlta',
                        formatter: 'date("d/m/Y")',
                        flex: 1
                    },
                    {
     		            text: HreRem.i18n('title.column.fecha.envio'),
     		            dataIndex: 'fechaEnvio',
     		            formatter: 'date("d/m/Y")',
     		            flex: 1
     				},
     				{   text: HreRem.i18n('title.column.fecha.propuesta'),
     					dataIndex: 'fechaPropuesta',
     					reference: 'fechaPropuestaRef',
     		        	formatter: 'date("d/m/Y")',
     		        	editor: {
     		        		xtype: 'datefield',
     		        		allowBlank: true,
     		        		cls: 'grid-no-seleccionable-field-editor'
     		        	},
     		        	flex: 1
     				},
     				{   text: HreRem.i18n('title.column.fecha.respuesta.bc'),
     		        	dataIndex: 'fechaBC',
     		        	formatter: 'date("d/m/Y")',
     		        	flex: 1
     				},
     				{   text: HreRem.i18n('title.column.validacion.bc'),
     		        	dataIndex: 'validacionBC',
     		        	flex: 1
     				},
     				{
                        text: HreRem.i18n('fieldlabel.fecha.aviso'),
                        dataIndex: 'fechaAviso',
                        formatter: 'date("d/m/Y")',
                        flex: 1
                    },
     				{
     					text: HreRem.i18n('title.column.comentarios.bc'),
     					dataIndex: 'comentariosBC',
     					flex: 1
     				},
                    {
                        text: HreRem.i18n('fieldlabel.observaciones'),
                        dataIndex: 'observaciones',
                        editor: {
                            xtype: 'textarea',
                            cls: 'grid-no-seleccionable-field-editor'
                        },
                        flex: 2
                    }
     		    ];
/*
     		    me.dockedItems = [
     		        {
     		            xtype: 'pagingtoolbar',
     		            dock: 'bottom',
     		            itemId: 'fechaArrasPaginationToolbar',
     		            inputItemWidth: 60,
     		            displayInfo: true,
     		            bind: {
     		                store: '{storeFechaArras}'
     		            }
     		        }
     		    ];*/

     		    me.saveSuccessFn = function() {
     		    	var me = this;
     		    	me.up('reservaexpediente').funcionRecargar();
     		    	return true;
     		    },

     		    me.saveFailureFn = function() {
     		    	var me = this;
     		    	me.up('reservaexpediente').funcionRecargar();
     		    	return true;
     		    },

     		    me.callParent();
        },

        onAddClick: function(btn){

            var me = this;
            var rec = Ext.create(me.getStore().config.model);
            
            var listaReg = me.getStore().getData().items;
            listaReg.sort(function(a, b) {
			  if (a.data.fechaAlta.getTime() > b.data.fechaAlta.getTime()) {
			    return -1;
			  }
			  if (a.data.fechaAlta.getTime() < b.data.fechaAlta.getTime()) {
			    return 1;
			  }
			  return 0;
			});
			
			var reg = listaReg[0];
			
			if(reg == null || me.comprobarFechaEnviada(reg)){
				me.getStore().sorters.clear();
	            me.editPosition = 0;
	            rec.setId(null);
	            me.getStore().insert(me.editPosition, rec);
	            me.rowEditing.isNew = true;
	            me.rowEditing.startEdit(me.editPosition, 0);
	            me.disableAddButton(true);
	            me.disablePagingToolBar(true);
	            me.disableRemoveButton(true);
	
	            me.comprobarEdicionGrid();
			}else{
				me.fireEvent("errorToast", HreRem.i18n("msg.existe.fecha.validada"));
			}
            
       },
       
       comprobarFechaEnviada: function(reg){
       		if(reg.data != null){
       			if(reg.data.fechaEnvio == null){
       				return true;
       			}else if(reg.data.fechaEnvio != null && reg.data.validacionBC == 'Deniega'){
       				return true;
       			}else{
       				return false;
       			}
       		}
       		
       		return true;
       },

       comprobarEdicionGrid: function(){
            var me = this;
            me.down('[reference=fechaPropuestaRef]').getEditor().allowBlank = false;
       },

       editFuncion: function(editor, context){
            var me= this;
            me.mask(HreRem.i18n("msg.mask.espere"));

            if (me.isValidRecord(context.record)) {
            	
            	var date = context.record.data.fechaPropuesta
            	
            	var day = date.getDate();
            	var month = date.getMonth() +1;
            	var year = date.getFullYear();
	            
	            context.record.save({
	
	                   params: {
	                       id: Ext.isEmpty(me.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(me.idPrincipal),
	                       idExpediente: Ext.isEmpty(me.idSecundaria) ? "" : me.lookupController().getViewModel().data.expediente.id,
	                       fechaPropuestaString: year + '-' + month + '-' + day
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

       }
});