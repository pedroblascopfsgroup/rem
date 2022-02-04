Ext.define('HreRem.view.common.adjuntos.AdjuntarFotoTrabajo', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntarfototrabajowindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /3,
	closeAction: 'hide',	
	requires: ['HreRem.view.common.adjuntos.AdjuntarFotoController', 'HreRem.view.common.adjuntos.AdjuntarFotoModel'],
	reference: 'adjuntarFotoWindowRef',
    controller: 'adjuntarfoto',
    viewModel: {
        type: 'trabajodetalle'
    },
    
    /**
     * Parámetro para enviar el id de la entidad a la que se adjunta la foto. Debe darse valor al
     * crear/abrir la ventana.
     * @type 
     */
    idEntidad: null,
    /**
     * Párametro para saber que componente abre la ventana, y poder refrescarlo después.
     * @type 
     */
    parent: null,
    
	listeners: {
	
		show: function() {			
			var me = this;
			me.resetWindow();			
		}
		
	},
	
    initComponent: function() {
    	
    	var me = this;

    	me.setTitle(HreRem.i18n("title.adjuntar.foto"));
    	
    	me.buttonAlign = 'left';
    	    	
    	var comboSolicitanteProveedor = new Ext.data.Store({
			data : 
				[
			        {"codigo":"false", "descripcion":"Solicitante"},
			        {"codigo":"true", "descripcion":"Proveedor"}
			    ]
    	});
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Adjuntar', handler: 'onClickBotonAdjuntarFoto'},{ itemId: 'btnCancelar', text: 'Cancelar',  handler: 'closeWindow', scope: this}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				url: $AC.getRemoteUrl("trabajo/uploadFotos"),
	    				reference: 'adjuntarFotoTrabajoFormRef',
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		layout: {
	   			 			type: 'vbox'
	   			 		},
	   			 		cls:'formbase_no_shadow',
	    				items: 
	    					[

					    		{
							        xtype: 'multiplefilefield',
							        fieldLabel:   HreRem.i18n('fieldlabel.archivo'),
							        name: 'multipleFileUpload',							        
							        anchor: '100%',
							        width: '100%',
							        allowBlank: false,
							        msgTarget: 'side',							        
							        buttonConfig: {
							        	iconCls: 'ico-search-white',
							        	text: ''
							        },
							        width: '100%',
							        align: 'right',
							        vtype: 'onlyImages',
							        listeners: {
							        	change: function (filefield, newFileName, oldFileName) {
							        		var me = this,
					                        	fileList = filefield.getFileList(),
					                            fileNames = Ext.Array.pluck(fileList, 'name');
					                        
					                        filefield.setRawValue(fileNames.join(', '));
					                    }
				                    }
					    		},
					    		{ 
									xtype: 'combobox',
						        	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
						        	name: 'solicitanteProveedor',
						        	editable: false,
					            	store: comboSolicitanteProveedor,
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
				                	width: '100%'				                	
				            	}
    					  ]
    				}
    	];
    	
    	me.callParent();
    },
    
    resetWindow: function() {
    	var me = this;
    	
    	me.down("form").reset();
    	    	
    }
});
    