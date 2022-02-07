Ext.define('HreRem.view.common.adjuntos.AdjuntarFotoAgrupacion', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntarfotoagrupacionwindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /3,
   /* height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50 ,*/
	closeAction: 'hide',	
	requires: ['HreRem.view.common.adjuntos.AdjuntarFotoController', 'HreRem.view.common.adjuntos.AdjuntarFotoModel'],
	reference: 'adjuntarFotoAgrupacionWindowRef',
    controller: 'adjuntarfoto',
    viewModel: {
        type: 'adjuntarfoto'
    },
    
    /**
     * Parámetro para enviar el id de la entidad a la que se adjunta la foto. Debe darse valor al
     * crear/abrir la ventana.
     * @type 
     */
    idEntidad: null,
    codigoSubtipoActivo: CONST.SUBTIPOS_ACTIVO['OBRA_NUEVA'],
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
    	
    	me.getViewModel().set('codigoSubtipoActivo', me.codigoSubtipoActivo);
		me.getViewModel().notify();

    	me.buttons = [ { itemId: 'btnGuardar', text: 'Adjuntar', handler: 'onClickBotonAdjuntarFoto'},{ itemId: 'btnCancelar', text: 'Cancelar',  handler: 'closeWindow', scope: this}];
    	
    	me.getViewModel().set('codigoSubtipoActivo', me.codigoSubtipoActivo);
		me.getViewModel().notify();

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				url: $AC.getRemoteUrl("agrupacion/uploadFotos"),
	    				reference: 'adjuntarFotoAgrupacionFormRef',
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
						        	fieldLabel:  HreRem.i18n('fieldlabel.descripcion'),
						        	name: 'codigoDescripcionFoto',
						        	editable: false,
					            	bind: {
						        		store: '{storeDescripcionAdjuntarFoto}'
						        	},
					            	displayField	: 'descripcion',
								    valueField		: 'codigo', 
									allowBlank: false,
									msgTarget: 'side',
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
    