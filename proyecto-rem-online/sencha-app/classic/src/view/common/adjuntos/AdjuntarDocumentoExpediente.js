Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoExpediente', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntardocumentowindowExpediente',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /3,
	reference: 'adjuntarDocumentoExpedienteWindowRef',
	requires: ['HreRem.view.common.adjuntos.AdjuntarDocumentoExpedienteModel'],
	viewModel: {
        type: 'adjuntardocumentoexpediente'
    },
    /**
     * Parámetro para construir la url que sibirá el documento
     * @type 
     */
    entidad: null,
    /**
     * Parámetro para enviar el id de la entidad a la que se adjunta el documento. Debe darse valor al
     * crear/abrir la ventana.
     * @type 
     */
    idEntidad: null,
    /**
     * Párametro para saber que componente abre la ventana, y poder refrescarlo después.
     * @type 
     */
    parent: null,
	
    initComponent: function() {
    	
    	var me = this;

    	me.setTitle(HreRem.i18n("title.adjuntar.documento"));
    	
    	me.buttonAlign = 'left';
    	
    	me.buttons = [ { formBind: true, itemId: 'btnGuardar', text: 'Adjuntar', handler: 'onClickBotonAdjuntarDocumento', scope: this},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'closeWindow', scope: this}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				url: $AC.getRemoteUrl(me.entidad + "/upload"),
	    				reference: 'adjuntarDocumentoExpedienteFormRef',
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		layout: {
	   			 			type: 'vbox'
	   			 		},
	    				cls:'',
	    				items: [
	    						{

 									xtype: 'filefield',
							        fieldLabel:   HreRem.i18n('fieldlabel.archivo'),
							        name: 'fileUpload',							        
							        anchor: '100%',
							        width: '100%',
							        allowBlank: false,
							        msgTarget: 'side',
							        buttonConfig: {
							        	iconCls: 'ico-search-white',
							        	text: ''
							        },
							        align: 'right',
							        listeners: {
				                        change: function(fld, value) {
				                        	var lastIndex = null,
				                        	fileName = null;
				                        	if(!Ext.isEmpty(value)) {
					                        	lastIndex = value.lastIndexOf('\\');
										        if (lastIndex == -1) return;
										        fileName = value.substring(lastIndex + 1);
					                            fld.setRawValue(fileName);
				                        	}
				                        }
				                    }
					    		},
					    		{ 
									xtype: 'combobox',
						        	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
						        	reference: 'filtroComboTipoDocumentoExpediente',
						        	name: 'tipo',
						        	editable: false,
						        	msgTarget: 'side',
					            	bind: {
					            		store: '{comboTipoDocumento}'
					            	},
					            	displayField	: 'descripcion',							
								    valueField		: 'codigo',
									allowBlank: false,
									width: '100%',
									publishes: 'value'
						        },
						        { 
									xtype: 'combobox',
						        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
						        	name: 'subtipo',
						        	queryMode: 'remote',
						        	editable: false,
						        	msgTarget: 'side',
						        	forceSelection: true,
						        	bind: {
						        		store: '{comboSubtipoDocumento}',
					                    disabled: '{!filtroComboTipoDocumentoExpediente.value}',
						        		filters: {
					                        property: 'codigoTipoDocExpediente',
					                        value: '{filtroComboTipoDocumentoExpediente.value}'
					                    }
					            	},
					            	displayField	: 'descripcion',						
								    valueField		: 'codigo',
									allowBlank: false,
									width: '100%'
						        },
						        {
				                	xtype: 'textarea',
				                	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
				                	name: 'descripcion',
				                	maxLength: 256,
				                	msgTarget: 'side',
				                	width: '100%'				                	
			            		}
    					]
    				}
    	];
    	
    	me.callParent();
    },
    
    onClickBotonAdjuntarDocumento: function(btn) {
    	
    	var me = this,
    	form = me.down("form");
    	if(form.isValid()){
            
            form.submit({
                waitMsg: HreRem.i18n('msg.mask.loading'),
                params: {idEntidad: me.idEntidad},
                success: function(fp, o) {
                	
                	if(o.result.success == "false") {
                		me.fireEvent("errorToast", o.result.errorMessage);
                	}else{
                		me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                	}
                	if(!Ext.isEmpty(me.parent)) {
                		me.parent.fireEvent("afterupload", me.parent);
                	}
                    me.close();
                }, 
                failure: function(fp, o) {
                	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                }
            });
        }
    	
    	
    	
    }
});
    