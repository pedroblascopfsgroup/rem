Ext.define('HreRem.view.activos.detalle.ActivoBbvaUicGrid', {
    extend: 'HreRem.view.common.GridBaseEditableRow',
    xtype: 'activobbvauicgrid',
    topBar: true,
	bind: {
		store: '{storeActivoBbvaUic}'
	},
	requires: ['HreRem.model.ActivoBbvaUicGridModel'],
	recordName : "activoBbvaUic",
	reference: 'activobbvauicgridref',

	initComponent: function() {

		var me = this;
		me.topBar = ($AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']));

		me.columns = [ 
		    {               
                text	 : HreRem.i18n('fieldlabel.activo.bbva.uic'),
                flex	 : 1,
                dataIndex: 'uicBbva',
		        editor: {
        			xtype:'textfield',
        			allowBlank: false
        	     }
            },{               
                text	 : HreRem.i18n('fieldlabel.activo.bbva.id.activo'),
                flex	 : 1,
                hidden: true,
                dataIndex: 'idActivo'
            },{               
                text	 : HreRem.i18n('fieldlabel.activo.bbva.id.uic'),
                flex	 : 1,
                hidden: true,
                dataIndex: 'id'
            },{               
                text	 : HreRem.i18n('fieldlabel.activo.epa'),
                flex	 : 0.5,
                dataIndex: 'activoEpa',
                readOnly : '{esUA}',
                renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
					var foundedRecord = this.up('datosbasicosactivo').lookupController().getStore('comboSiNoBoolean').findRecord('codigo', value);
					var descripcion;
					if(!Ext.isEmpty(foundedRecord)) {
						descripcion = foundedRecord.getData().descripcion;
					};
					return descripcion;
				},
                editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboSiNoBoolean}'
					},
					displayField: 'descripcion',
					valueField: 'codigo'
				},
				listeners: {
                	change:  'onActivoEpa'
            	}
            },{               
                text	 : HreRem.i18n('fieldlabel.activobbva.cexperBbva'),
                flex	 : 0.5,
                dataIndex: 'cexperBbva',
                readOnly : '{esUA}',
                editor: {
        			xtype:'textfield'
        	     }
            },{               
                text	 : HreRem.i18n('fieldlabel.activobbva.contrapartida'),
                flex	 : 0.5,
                dataIndex: 'contrapartida',
                readOnly : '{esUA}',
                editor: {
        			xtype:'textfield'
        	     },
				listeners: {
                	change:  'onActivoEpa'
            	}
            },{               
                text	 : HreRem.i18n('fieldlabel.activobbva.folio'),
                flex	 : 0.5,
                dataIndex: 'folio',
                readOnly : '{esUA}',
                editor: {
        			xtype:'textfield'
        	     },
				listeners: {
                	change:  'onActivoEpa'
            	}
            },{               
                text	 : HreRem.i18n('fieldlabel.activobbva.cdpen'),
                flex	 : 0.5,
                dataIndex: 'cdpen',
                readOnly : '{esUA}',
                editor: {
        			xtype:'textfield'
        	     },
				listeners: {
                	change:  'onActivoEpa'
            	}
            },{               
                text	 : HreRem.i18n('fieldlabel.activobbva.oficina'),
                flex	 : 0.5,
                dataIndex: 'oficina',
                readOnly : '{esUA}',
                editor: {
        			xtype:'textfield'
        	     },
				listeners: {
                	change:  'onActivoEpa'
            	}
            },{               
                text	 : HreRem.i18n('fieldlabel.activobbva.empresa'),
                flex	 : 0.5,
                dataIndex: 'empresa',
                readOnly : '{esUA}',
                editor: {
        			xtype:'textfield'
        	     },
				listeners: {
                	change:  'onActivoEpa'
            	}
            }
		];

		me.dockedItems = [
			{
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'activoBbvaUicToolbar',
	            displayInfo: true,
				bind: {
					store: '{storeActivoBbvaUic}'
				}
	
	        }	
		];

		me.callParent();

	},
	 onDeleteClick: function(btn, context){
	   	var me = this;
		var uicBbva = me.getSelection()[0].getData().uicBbva;
		var idActivo = me.lookupController().getView().getViewModel().get('activo.id');
	       Ext.Msg.show({
				   title: HreRem.i18n('title.confirmar.eliminacion'),
				   msg: HreRem.i18n('msg.desea.eliminar'),
				   buttons: Ext.MessageBox.YESNO,
				   fn: function(buttonId) {
				        if (buttonId == 'yes') {
				        	me.mask(HreRem.i18n("msg.mask.espere"));
				        	
				    		me.rowEditing.cancelEdit();
				        	var sm = me.getSelectionModel();
				        	
					   		url = $AC.getRemoteUrl('activo/destroyActivoBbvaUic');
							Ext.Ajax.request({
								url : url,
								method : 'POST',
								params : {
										idActivo: idActivo, 
										uicBbva: uicBbva
								},
								success : function(response, opts) {
									me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
									me.up('datosbasicosactivo').funcionRecargar();
								    me.unmask();
								    me.deleteSuccessFn();
								},
								failure : function(record, operation) {
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
										me.deleteFailureFn();
								},
								callback : function(record, operation) {
									
								}
							});  	
				            if (me.getStore().getCount() > 0) {
				                sm.select(0);
				            }
				        }
				   }
			});
   },
   editFuncion: function(btn, context){
	   	var me = this;
	   	if (me.isValidRecord(context.record)) {
	   		me.mask(HreRem.i18n("msg.mask.espere"));
	   		var uicBbva = context.record.get('uicBbva');
	   		var id = context.record.get('id');
	   		var activoEpa = context.record.get('activoEpa');
	   		var cexperBbva = context.record.get('cexperBbva');
	   		var contrapartida = context.record.get('contrapartida');
	   		var folio = context.record.get('folio');
	   		var cdpen = context.record.get('cdpen');
	   		var oficina = context.record.get('oficina');
	   		var empresa = context.record.get('empresa');
	   		if(!me.isNumeric(id)){
	   			id = null;
	   		}
	   		var idActivo = me.lookupController().getView().getViewModel().get('activo.id');
	   		url = $AC.getRemoteUrl('activo/createActivoBbvaUic');
			Ext.Ajax.request({
				url : url,
				method : 'POST',
				params : {
						idActivo: idActivo, 
						uicBbva: uicBbva,
						id: id,
						activoEpa: activoEpa,
						cexperBbva: cexperBbva,
						contrapartida: contrapartida,
						folio: folio,
						cdpen: cdpen,
						oficina: oficina,
						empresa: empresa
				},
				success : function(response, opts) {
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				},
				failure : function(record, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				},
				callback : function(record, operation) {
					me.recargarGrid();
					me.unmask();
				}
			});  		
		}       
   },
   recargarGrid: function() {
	   	var me = this; 
 		me.getStore().load();	
   },
   
   isNumeric: function(val) {
	    return /^-?\d+$/.test(val);
	}
});