Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoExpediente', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntardocumentowindowExpediente',
    layout	: {
    	type:'fit'
    },
    width: Ext.Element.getViewportWidth() / 1.5,
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
	    				layout: {
							type: 'table',
					        // The total column count must be specified here
					        columns: 2,
					        trAttrs: {height: '30px', width: '100%'},
					        tdAttrs: {width: '50%'},
					        tableAttrs: {
					            style: {
					                width: '100%'
									}
					        }
	    				},
	   			 		cls:'formbase_no_shadow',
	   			 		defaults: {
	   			 			columnWidth: '50%',
	   			 			width: '100%',
	   			 			labelWidth: 100,
	   			 			msgTarget: 'side',
	   			 			addUxReadOnlyEditFieldPlugin: false,
	   			 			labelWidth: 100
	   			 		},
	    				items: [
	    						{

 									xtype: 'filefield',
							        fieldLabel:   HreRem.i18n('fieldlabel.archivo'),
							        name: 'fileUpload',							        
							        allowBlank: false,
							        maxWidth: 400,
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
									xtype: 'comboboxfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
						        	reference: 'filtroComboTipoDocumentoExpediente',
						        	name: 'tipo',
					            	bind: {
					            		store: '{comboTipoDocumento}'
					            	},
									allowBlank: false,
									publishes: 'value'
						        },
						        {
				                	xtype: 'textareafieldbase',
				                	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
				                	name: 'descripcion',
				                	maxLength: 256			                	
			            		},
						        { 
									xtype: 'comboboxfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
						        	name: 'subtipo',
						        	queryMode: 'remote',
						        	editable: false,
						        	forceSelection: true,
						        	bind: {
						        		store: '{comboSubtipoDocumento}',
					                    disabled: '{!filtroComboTipoDocumentoExpediente.value}',
						        		filters: {
					                        property: 'codigoTipoDocExpediente',
					                        value: '{filtroComboTipoDocumentoExpediente.value}'
					                    }
					            	},
									allowBlank: false,
									listeners: {
										select: function(combo, record) {
											if (record.get("vinculable")) {
												me.down("gridBase").setDisabled(false);
												me.down("gridBase").getStore().load();
											} else {
												me.down("gridBase").setDisabled(true);
												me.down("gridBase").getSelectionModel().deselectAll();
											}
										}
									}
						        }
    					]
    				},
    				{
    					
					    xtype		: 'gridBase',
					    title		: HreRem.i18n("title.activos"),
					    selModel : Ext.create('HreRem.view.common.CheckBoxModelBase'),
					    reference: 'listadoactivosexpedienteadjunto',
					    margin: '0 0 120 0',
					    maxHeight: 250,
						cls	: 'panel-base shadow-panel',
						disabled: true,
						bind: {
							store: '{storeActivos}'
						},
						loadAfterBind: false,
						columns: [
							   			{   
				    						text: HreRem.i18n('fieldlabel.numero.activo'),
					        				dataIndex: 'numActivo',
		            						flex     : 1
			       						},
			       						{   
				    						text: HreRem.i18n('fieldlabel.finca.registral'),
					        				dataIndex: 'fincaRegistral',
		            						flex     : 1
			       						},
			       						{
								            text: HreRem.i18n("fieldlabel.tipo.activo"),
								            dataIndex: 'tipoActivo',
								            flex:1
								            
								       	},
									   	{
								            text: HreRem.i18n("fieldlabel.subtipo.activo"),
								            dataIndex: 'subtipoActivo',
								            flex:1
								            
								       	},
								       	{
								            text: HreRem.i18n("fieldlabel.municipio"),
								            dataIndex: 'municipio',
								            flex:1
								            
								       	},
								       	{
								            text: HreRem.i18n("fieldlabel.provincia"),
								            dataIndex: 'provincia',
								            flex:1								            
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
    		var comboSubtipoDocumento = form.down("[name=subtipo]"); 
    		var subtipoDocumento = comboSubtipoDocumento.findRecordByValue(comboSubtipoDocumento.getValue());
    		var activosSeleccionados = [];
    		
    		Ext.Array.each(me.down('gridBase').getSelection(), function(selected, index) {
    		 	activosSeleccionados.push(selected.get("numActivo"));
    		});
    		
    		
			if (subtipoDocumento.get("vinculable") && activosSeleccionados.length == 0) {
				
				me.fireEvent("errorToast", HreRem.i18n("txt.obligado.marcar.activos.documento.seleccionado")); 
				
			} else {
	            
	            form.submit({
	                waitMsg: HreRem.i18n('msg.mask.loading'),
	                params: {idEntidad: me.idEntidad, activos: activosSeleccionados.toString()},
	                success: function(fp, o) {
	                	
	                	if(o.result.success == "false") {
	                		me.fireEvent("errorToast", o.result.errores);
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
    	
    	
    	
    }
});
    