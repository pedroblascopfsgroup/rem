Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoJuntas', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntardocumentowindowJuntas',
    
    // VISTA VENTANA ADJUNTAR DOCUMENTO --> PESTA�A DOCUMENTOS (JUNTAS)
    
    layout	: {
    	type:'fit'
    },
    width: Ext.Element.getViewportWidth() / 1.5,
    resizable: false,
	reference: 'adjuntarDocumentoJuntasWindowRef',
	requires: ['HreRem.view.common.adjuntos.AdjuntarDocumentoExpedienteModel','HreRem.view.administracion.AdministracionModel'],
	controller: 'administracion',
	viewModel: {
        type: 'administracion'
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
	    				reference: 'adjuntarDocumentoFormRef',
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
									xtype: 'combobox',
						        	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
						        	reference: 'filtroComboTipoDocumentoJunta',
						        	name: 'tipo',
						        	msgTarget: 'side',
						        	bind: {
					            		store: '{comboTipoDocumento}'
					            	},
					            	displayField	: 'descripcion',								    							
								    valueField		: 'codigo',
									allowBlank: false,
									filtradoEspecial: true,
									listeners: {
										select: function(combo, record) {
											if (record.getData().vinculable == 1) {
												if(combo.value == CONST.TIPO_DOCUMENTO_JUNTAS ['RECEPCION_CONVOCATORIA']){
												
													me.down("gridBase").setDisabled(true);
													me.down("gridBase").getStore().load(function (){
														me.down("gridBase").getSelectionModel().selectAll();
													});		
													
												
												}else{
													me.down("gridBase").setDisabled(false);
													me.down("gridBase").getSelectionModel().deselectAll();
													if(!me.down("gridBase").getStore().isLoaded()) {
														me.down("gridBase").getStore().load();
													}
												}
												
											} else {
												me.down("gridBase").setDisabled(true);
												me.down("gridBase").getSelectionModel().deselectAll();
											}
										}
									}
									
									
					    		},
						        {
				                	xtype: 'textareafieldbase',
				                	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),				                	
				                	name: 'descripcion',
				                	maxLength: 256			                	
			            		}
						        
									
						        
    					]
    				},
    				{
    					
					    xtype		: 'gridBase',					    
					    selModel : Ext.create('HreRem.view.common.CheckBoxModelBase', {
					    
					    	listeners: {
					    		selectionchange: function(selModel, selected, eOpts ) {
					    			if(selected.length === 1) {
					    				me.down("gridBase").setTitle(selected.length + " " + HreRem.i18n("title.activo.seleccionado"));
					    			} else {
					    				me.down("gridBase").setTitle(selected.length + " " + HreRem.i18n("title.activos.seleccionados"));
					    			}
					    		}
					    	}
					    }),
					    reference: 'listadoactivosjuntasadjunto',
					    title: "0 " + HreRem.i18n("title.activos.seleccionados"),
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
    }
});
    