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
     recordName: "fechaArras",
     bind: {
         store: '{storeFechaArras}'
     },
     listeners: {
     	beforeedit: function(editor,e){
     		var me = this;
     		var codEstadoReserva = me.lookupController().getViewModel().getData().expediente.getData().estadoReservaCod;
     		var codValidacionBC = me.lookupController().getViewModel().getData().storeFechaArras.getData().items[0].getData().validacionBCcodigo;
			var record = e.record;
			var columnas = me.getColumns();
			var motivoAnulacion;
     		
     		for (var i = 0; i <= columnas.length; i++) {
				if (columnas[i].dataIndex == 'motivoAnulacion') {
					motivoAnulacion = columnas[i];
					break;
				}
			}
     		var columnaMotivoAnulacion = motivoAnulacion.getEditor();
     		
     		if (codValidacionBC != null && (codValidacionBC == CONST.ESTADO_VALIDACION_BC['CODIGO_NO_ENVIADA'] || codValidacionBC == CONST.ESTADO_VALIDACION_BC['CODIGO_APROBADA_BC'])) {								
				columnaMotivoAnulacion.setDisabled(false);
    		}else{    			
    			columnaMotivoAnulacion.setDisabled(true);
    		}
     		
     		return e.rowIdx == 0 && codEstadoReserva == CONST.ESTADOS_RESERVA['CODIGO_PENDIENTE_FIRMA'];
     	}
     },

      initComponent: function () {

          	var me = this;
          	var codEstadoReserva = me.lookupController().getViewModel().getData().expediente.getData().estadoReservaCod;
         	me.topBar = codEstadoReserva == CONST.ESTADOS_RESERVA['CODIGO_PENDIENTE_FIRMA'];
         	
          	me.deleteSuccessFn = function(){
         		this.getStore().load()
         		this.setSelection(0);
         	}

          	me.deleteFailureFn = function(){
         		this.getStore().load()
         	}
 			var coloredRender = function(value, meta, record) {
				var codigo = record.get('validacionBCcodigo');
				
				if (!value) {
					value = '-';
				}

				if (CONST.ESTADOS_RESERVA['CODIGO_PENDIENTE_FIRMA'] && (codigo == CONST.ESTADO_VALIDACION_BC['CODIGO_ANULADA'] 
						|| codigo == CONST.ESTADO_VALIDACION_BC['CODIGO_APLAZADA']
       					|| codigo == CONST.ESTADO_VALIDACION_BC['CODIGO_RECHAZADA_BC'])) {
						return '<span style="color: #DF0101;">' + value + '</span>';
				}
				else{
					return value;
				}				
			};
		
			var dateColoredRender = function(value, meta, record) {
				var valor = dateRenderer(value);
				return coloredRender(valor, meta, record);
			};
		
			var dateRenderer = function(value, rec) {
				if (!Ext.isEmpty(value)) {
					var newDate = new Date(value);
					var formattedDate = Ext.Date.format(newDate, 'd/m/Y');
					return formattedDate;
				} else {
					return value;
				}
			};
         	
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
                        //formatter: 'date("d/m/Y")',
                        flex: 1,
     		        	renderer : dateColoredRender
                    },
                    {
     		            text: HreRem.i18n('title.column.fecha.envio'),
     		            dataIndex: 'fechaEnvio',
     		            //formatter: 'date("d/m/Y")',
     		            flex: 1,
     		        	renderer : dateColoredRender
     				},
     				{   text: HreRem.i18n('title.column.fecha.propuesta'),
     					dataIndex: 'fechaPropuesta',
     					reference: 'fechaPropuestaRef',
     		        	//formatter: 'date("d/m/Y")',
     		        	editor: {
     		        		xtype: 'datefield',
     		        		allowBlank: true,
     		        		cls: 'grid-no-seleccionable-field-editor'
     		        	},
     		        	flex: 1,
     		        	renderer : dateColoredRender
     				},
     				{   text: HreRem.i18n('title.column.fecha.respuesta.bc'),
     		        	dataIndex: 'fechaBC',
     		        	//formatter: 'date("d/m/Y")',
     		        	flex: 1,
     		        	renderer : dateColoredRender
     				},
     				{   text: HreRem.i18n('title.column.validacion.bc'),
     		        	dataIndex: 'validacionBC',
     		        	flex: 1,
     		        	renderer : coloredRender
     				},
     				{
                        text: HreRem.i18n('fieldlabel.fecha.aviso'),
                        dataIndex: 'fechaAviso',
                        //formatter: 'date("d/m/Y")',
                        flex: 1,
     		        	renderer : dateColoredRender
                    },
     				{
     					text: HreRem.i18n('title.column.comentarios.bc'),
     					dataIndex: 'comentariosBC',
     					flex: 1,
     		        	renderer : coloredRender
     				},
                    {
                        text: HreRem.i18n('fieldlabel.observaciones'),
                        dataIndex: 'observaciones',
                        editor: {
                            xtype: 'textarea',
                            cls: 'grid-no-seleccionable-field-editor'
                        },
                        flex: 2,
     		        	renderer : coloredRender
                    },
                    {
                        text: HreRem.i18n('fieldlabel.posicionamiento.motivo'),
                        dataIndex: 'motivoAnulacion',
                        reference: 'motivoAnulacionRef',
                        editor: {
                            xtype: 'textarea'
                        },                        
                        flex: 2,
     		        	renderer : coloredRender
                    }
     		    ];


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
            var codEstadoReserva = me.lookupController().getViewModel().getData().expediente.getData().estadoReservaCod;
            var listaReg = me.getStore().getData().items;
			var reg = listaReg[0];
			
			if(!Ext.isEmpty(reg)){
				if (!me.comprobarEstadoValidacionAndEstadoExpediente(reg,codEstadoReserva)) {
					me.fireEvent("errorToast", HreRem.i18n("msg.fallo.insertar.registro.fae"));
					return;
				}
			}
			
			me.getStore().sorters.clear();
            me.editPosition = 0;
            rec.setId(null);
            me.getStore().insert(me.editPosition, rec);
            me.rowEditing.isNew = true;
	        me.rowEditing.startEdit(me.editPosition, 0);
            me.disableAddButton(true);
            me.disablePagingToolBar(true);
            me.disableRemoveButton(true);
	
            
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

       },
       comprobarEstadoValidacionAndEstadoExpediente: function(registroCero,codEstadoReserva){
       	var me = this;       	
       	var validacionBCcodigo = registroCero.getData().validacionBCcodigo; 
       	return codEstadoReserva == CONST.ESTADOS_RESERVA['CODIGO_PENDIENTE_FIRMA'] 
       		&& (validacionBCcodigo == CONST.ESTADO_VALIDACION_BC['CODIGO_ANULADA'] 
       			|| validacionBCcodigo == CONST.ESTADO_VALIDACION_BC['CODIGO_APLAZADA']
       			|| validacionBCcodigo == CONST.ESTADO_VALIDACION_BC['CODIGO_RECHAZADA_BC']);
       }
});