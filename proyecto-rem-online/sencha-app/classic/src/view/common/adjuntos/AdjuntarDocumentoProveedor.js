Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoProveedor', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntardocumentoproveedorwindow',
    layout	: 'fit',
    width: Ext.Element.getViewportWidth() / 3,
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
	bloque: null,
    initComponent: function() {
    	
    	var me = this;
		var url = me.bloque == '02' ? $AC.getRemoteUrl(me.entidad + "/uploadConducta") : $AC.getRemoteUrl(me.entidad + "/upload");

    	me.setTitle(HreRem.i18n("title.adjuntar.documento"));
    	
    	me.buttonAlign = 'left';
    	
    	me.buttons = [ { formBind: true, itemId: 'btnGuardar', text: 'Adjuntar', handler: 'onClickBotonAdjuntarDocumento', scope: this},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'closeWindow', scope: this}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				url: url,
	    				reference: 'adjuntarDocumentoFormRef',
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		layout: {
	   			 			type: 'vbox'
	   			 		},
	   			 		cls:'formbase_no_shadow',
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
						        		store: {
											model: 'HreRem.model.ComboBase',
											proxy: {
												type: 'uxproxy',
												remoteUrl: 'generic/getDocumentosProveedor',
												extraParams: {codBloque: me.bloque}
											}
										}
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
    }
});
    