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

    	me.buttons = [ { itemId: 'btnGuardar', text: 'Adjuntar', handler: 'onClickBotonAdjuntarFoto'},{ itemId: 'btnCancelar', text: 'Cancelar',  handler: 'closeWindow', scope: this}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				url: $AC.getRemoteUrl("agrupacion/uploadFoto"),
	    				reference: 'adjuntarFotoAgrupacionFormRef',
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		layout: {
	   			 			type: 'vbox'
	   			 		},
	    				cls:'',
	    				items: 
	    					[

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
							        width: '100%',
							        align: 'right',
							        vtype: 'onlyImages',
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
    