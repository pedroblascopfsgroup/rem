Ext.define('HreRem.view.activos.detalle.CalificacionNegativaGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'calificacionnegativagrid',
	topBar		: true,
	targetGrid	: 'calificacionNegativa',
	idPrincipal : 'idMotivo',
	idSecundaria: 'activo.id',
	editOnSelect: true,
	disabledDeleteBtn: false,
    bind: {
        store: '{storeCalifiacionNegativa}' // TODO hay que hacerse un store y en ese store apuntar a los model
    },
    requires: ['HreRem.view.common.CheckBoxModelBase'],

    listeners: {
		containermouseover: function () {
    		var me = this;
    		me.up('tituloinformacionregistralactivo').down('historicotramitaciontitulogrid').evaluarBotonAdd();
		   
    	},
    	itemmouseenter: function () {
    		var me = this;
    		me.up('tituloinformacionregistralactivo').down('historicotramitaciontitulogrid').evaluarBotonAdd();
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
		            dataIndex: 'motivoCalificacionNegativa',
		            reference: 'motivoCalificacionNegativa',
		            text: HreRem.i18n('fieldlabel.calificacion.motivo'),
		            editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'motivosCalificacionNegativa'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
		            flex: 0.5
		           
		        },
		        {
		            dataIndex: 'estadoMotivoCalificacionNegativa',
		            text: HreRem.i18n('fieldlabel.calificacion.estadomotivo.calificacion'),
		            editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'estadoMotivoCalificacionNegativa'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
		            flex: 0.5
		            
		        },
		        {
		            dataIndex: 'responsableSubsanar',
		            text: HreRem.i18n('fieldlabel.calificacion.responsablesubsanar'),
		            editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'responsableSubsanar'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
		            flex: 0.5
		        },
		        {
		            dataIndex: 'fechaSubsanacion',
		            text: HreRem.i18n('fieldlabel.calificacion.fechaSubsanacion'),
		            editor: {
		        		xtype: 'datefield',
		        		cls: 'grid-no-seleccionable-field-editor'
		        	},
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'descripcionCalificacionNegativa',
		            text: HreRem.i18n('fieldlabel.calificacion.descripcion'),
		            editor: {
		        		xtype: 'textareafield'
		        	},
		            flex: 1
		         
		        },
		        {
		            dataIndex: 'fechaPresentacionRegistroCN',
		            text: HreRem.i18n('fieldlabel.calificacion.fechaPresentacionRegistro'),
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'fechaCalificacionNegativa',
		            text: HreRem.i18n('fieldlabel.calificacion.fechaCalificacionNegativa'),
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
		                store: '{storeCalifiacionNegativa}'
		            }
		        }
		    ];
		    
		    me.selModel = Ext.create('HreRem.view.common.CheckBoxModelBase');

		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('tituloinformacionregistralactivo').funcionRecargar();
		    	return true;
		    };

		    me.callParent();

   },

   editFuncion: function(editor, context){
 		var me= this;
		me.mask(HreRem.i18n("msg.mask.espere"));
		

			if (me.isValidRecord(context.record)) {		
				
				var motivo = context.record.data.motivoCalificacionNegativa;
				var estado = context.record.data.estadoMotivoCalificacionNegativa;

				 if(estado != CONST.COMBO_ESTADO_CALIFICACION_NEGATIVA["SUBSANADO"] && estado != CONST.COMBO_ESTADO_CALIFICACION_NEGATIVA["COD_SUBSANADO"] ){
					 context.record.data.fechaSubsanacion = "";
				 }
      		context.record.save({
      				
                  params: {
                      id: Ext.isEmpty(me.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(me.idPrincipal),
                    		  idEntidadPk: Ext.isEmpty(me.idSecundaria) ? "" : me.lookupController().getViewModel().data.activo.id	
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
                  	
                  	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msgError)) {
                  		me.fireEvent("errorToast", response.msgError);
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
