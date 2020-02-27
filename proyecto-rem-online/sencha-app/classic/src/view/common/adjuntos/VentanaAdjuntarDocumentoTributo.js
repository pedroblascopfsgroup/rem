Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoTributo', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntardocumentowindowTributo',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /1.5,
    resizable: false,
	reference: 'adjuntarDocumentoWindowRef',
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
	 * Parámetro para enviar el codigo del tipo de trabajo para realizar un filtrado de los tipos de documento.
	 * si no se envia no se realizará ningun filtrado sobre los tipos de documento
	 * @type
	 */
	tipoTrabajoCodigo: null,

    /**
     * Párametro para saber que componente abre la ventana, y poder refrescarlo después.
     * @type
     */
    parent: null,
    
    idTributo: null, 

    initComponent: function() {
    	
    	var me = this;
    	
    	me.setTitle(HreRem.i18n("title.adjuntar.documento"));

    	me.buttonAlign = 'left';

    	var comboTipoDocumentoTributo = new Ext.data.Store({
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionarioTiposDocumentoTributo'
			}
    	});
		
    	var idTributo = me.idTributo;
    	
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
			        tdAttrs: {width: '20%'},
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
						items: [{
		                	xtype: 'textarea',
		                	name: 'idTributo',
		                	hidden:true,
		                	value: idTributo
		        		},
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
				        	fieldLabel:   HreRem.i18n('fieldlabel.tipo'),
				        	reference: 'tipoDocumentoTributo',
				        	name: 'tipo',
				        	displayField	: 'descripcion',
						    valueField		: 'codigo',	
				        	store: comboTipoDocumentoTributo,
							allowBlank: false,
							filtradoEspecial: true,
							listeners: {
								select: function(combo, record) {
									if (record.getData().vinculable == "true") {
										
											me.down("gridBase").setDisabled(false);
											me.down("gridBase").getSelectionModel().deselectAll();
											if(!me.down("gridBase").getStore().isLoaded()) {
												me.down("gridBase").getStore().load();
											
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
				xtype: 'listaActivoGrid',
				width: '100%',
				name: 'listaActivos',
				margin: '0 0 120 0',
				maxHeight: 250
    		}
			
];

    	me.callParent();
    }
});



	
   	

