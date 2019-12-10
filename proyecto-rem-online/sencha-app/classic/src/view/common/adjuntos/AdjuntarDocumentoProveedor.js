Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoProveedor', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntardocumentoproveedorwindow',
    layout	: 'fit',
    width: Ext.Element.getViewportWidth() / 3,
    //width: Ext.Element.getViewportWidth() / 2.5,
   /* height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50 ,*/
    requires: ['HreRem.view.common.adjuntos.AdjuntarDocumentoProveedorModel'],
	reference: 'adjuntarDocumentoProveedorWindowRef',
	viewModel: {
        type: 'adjuntardocumentoproveedor'
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
	/*listeners: {
		boxready: function (grid){
			var combobox = grid.down('[name="cartera"]');
			var check = grid.down('[name="checkboxTodasCarteras"]');
			var idProveedor = grid.getViewModel().get('proveedor.id');
			var checkHaya = grid.down('[name="checkboxHaya"]');
			
			var url =  $AC.getRemoteUrl('proveedores/getCountCarteraPorProveedor');
    		Ext.Ajax.request({
    			
				url: url,
				params: {idProveedor : idProveedor},
				
				success: function (response,opts) {
					var respuesta = Ext.decode(response.responseText);
					
					if(respuesta.data == 0){
						combobox.disable();
						check.disable();
						checkHaya.setValue(true);
					}else{
						combobox.enable();
						check.enable();
						checkHaya.setValue(false);
						checkHaya.setDisabled(true);
					}
					
				}
    		});
			
			
		}
    },*/
	
    initComponent: function() {
    	
    	var me = this;

    	me.setTitle(HreRem.i18n("title.adjuntar.documento"));
    	
    	me.buttonAlign = 'left';
    	
    	me.buttons = [ { formBind: true, itemId: 'btnGuardar', text: 'Adjuntar', handler: 'onClickBotonAdjuntarDocumento', scope: this},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'closeWindow', scope: this}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				url: $AC.getRemoteUrl(me.entidad + "/upload"),
	    				reference: 'adjuntarDocumentoFormRef',
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		layout: {
	   			 			type: 'vbox'
	   			 			/*type: 'table',
	   			 			columns: 2,
	   			 			trAttrs: {height: '30px', width: '100%'},
					        tdAttrs: {width: '50%'},
					        tableAttrs: {
					            style: {
					                width: '100%'
									}
					        }*/
	   			 		},
	   			 		cls:'formbase_no_shadow',
	   			 		/*defaults: {
	   			 			columnWidth: '100%',
	   			 			width: '100%',
	   			 			labelWidth: 100,
	   			 			msgTarget: 'side',
	   			 			addUxReadOnlyEditFieldPlugin: false,
	   			 			labelWidth: 100
	   			 		},*/
	    				items: [
	    						{

 									xtype: 'filefield',
							        fieldLabel:   HreRem.i18n('fieldlabel.archivo'),
							        name: 'fileUpload',							        
							        anchor: '100%',
							        allowBlank: false,
							        msgTarget: 'side',
							        width: '100%',
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
					    		/*{ 
									xtype: 'comboboxfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.entidad.propietaria'),
						        	reference: 'cartera',
						        	name: 'cartera',
						        	chainedStore: 'comboSubcarteraPorProveedor',
									chainedReference: 'subcartera',
						        	width: '100%',
						        	msgTarget: 'side',
						        	publishes: 'value',
						        	disabled: true,
						        	bind: {
						        		store: '{comboCarteraPorProveedor}'
						        	},
									allowBlank: true,
									listeners: {
										select: 'onChangeChainedCombo'
									}
						        },*/
					    		{ 
									xtype: 'combobox',
						        	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
						        	reference: 'tipo',
						        	name: 'tipo',
						        	editable: true,
						        	msgTarget: 'side',
						        	publishes: 'value',
						        	width: '100%',
						        	bind: {
						        		store: '{comboTipoDocumento}'
						        	},
					            	//chainedStore: 'comboSubTipoDocumento',
									//chainedReference: 'subtipo',
					            	displayField	: 'descripcion',    							
								    valueField		: 'codigo',
									allowBlank: false,
									width: '100%',
									enableKeyEvents:true,
								    listeners: {
								    	'keyup': function() {
								    		this.getStore().clearFilter();
								    	   	this.getStore().filter({
								        	    property: 'descripcion',
								        	    value: this.getRawValue(),
								        	    anyMatch: true,
								        	    caseSensitive: false
								        	})
								    	},
								    	'beforequery': function(queryEvent) {
								         	queryEvent.combo.onLoad();
								    	},			
										//select: 'onChangeChainedCombo'
								    }
						        },
						        /*{
						        	xtype: 'comboboxfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.proveedores.subcartera'),
						        	reference: 'subcartera',
						        	name: 'subcartera',
						        	width: '100%',
						        	msgTarget: 'side',
						        	disabled: true,
						        	bind: {
						        		store: '{comboSubcarteraPorProveedor}'
						        	},
									allowBlank: true
						        },
						        { 
									xtype: 'combobox',
						        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
						        	reference: 'subtipo',
						        	name: 'subtipo',
						        	editable: true,
						        	msgTarget: 'side',
						        	publishes: 'value',
						        	width: '100%',
						        	bind: {
						        		store: '{comboSubTipoDocumento}'
						        	},
					            	displayField	: 'descripcion',	    							
								    valueField		: 'codigo',
									allowBlank: false,
									enableKeyEvents:true,
								    listeners: {
								    	'keyup': function() {
								    		this.getStore().clearFilter();
								    	   	this.getStore().filter({
								        	    property: 'descripcion',
								        	    value: this.getRawValue(),
								        	    anyMatch: true,
								        	    caseSensitive: false
								        	})
								    	},
								    	'beforequery': function(queryEvent) {
								         	queryEvent.combo.onLoad();
								    	}
								    }
						        },
						        {
								   	xtype:'checkboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.todas.carteras'),
									reference: 'checkboxTodasCarteras',
									name: 'checkboxTodasCarteras',		
									disabled: true,
									width: '100%',
									bind: {
								  		value: '{todasCarteras}'
								   	},
								   	listeners: {
								   		change: 'onChangeCheckboxTodasCarteras'	
								   	}
								},*/
						        {
				                	xtype: 'textarea',
				                	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
				                	name: 'descripcion',
				                	maxLength: 256,
				                	msgTarget: 'side',
				                	width: '100%'
				                	
			            		},
			            		/*{
								   	xtype:'checkboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.sin.carteras'),
									reference: 'checkboxHaya',
									name: 'checkboxHaya',		
									readOnly: true,
									width: '100%'
								}*/
    					]
    				}
    	];
    	
    	me.callParent();
    }
});
    