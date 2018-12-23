Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoNotificacionGencat', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntardocumentonotificaciongencat',
    
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3,
   /* height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50 ,*/
	reference: 'adjuntardocumentonotificaciongencatRef',
	
    /**
     * Parámetro para construir la url que subirá el documento
     * @type
     */
    entidad: null,
    
    /**
     * Parámetro para enviar el id del activo al que pertenece la comunicación de gencat a la que se adjunta el documento. 
     * Debe darse valor al crear/abrir la ventana.
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

    	me.setTitle(HreRem.i18n("title.adjuntar.documento.comunicacion.gencat"));

    	me.buttonAlign = 'left';
    	
    	var comboTipoDocumento = new Ext.data.Store({
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionarioTiposDocumento',
				extraParams: {diccionario: 'tiposDocumento'}
			}
    	});

		comboTipoDocumento.filter([
			{
		    fn: function(record) {
					return me.tipoTrabajoCodigo == null || record.get('tipoTrabajoCodigos').indexOf(me.tipoTrabajoCodigo) != -1;
		    },
		    scope: this
		  }
		]);

    	me.buttons = [ 
    		{ 
    			formBind: true, 
    			itemId: 'btnGuardar', 
    			text: 'Adjuntar', 
    			handler: 'onClickBotonAdjuntarDocComunicacion', 
    			scope: this
    		},
    		{ 
    			itemId: 'btnCancelar', 
    			text: 'Cancelar', 
    			handler: 'closeWindow', 
    			scope: this
    		}
    	];

    	me.items = [
    				{
	    				xtype: 'formBase',
	    				url: $AC.getRemoteUrl(me.entidad + "/uploadAdjuntoComunicacion"),
	    				reference: 'adjuntarDocPromoFormRef',
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
						        	name: 'tipo',
						        	editable: false,
						        	msgTarget: 'side',
					            	store: comboTipoDocumento,
					            	displayField: 'descripcion',
								    valueField: 'codigo',
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

    onClickBotonAdjuntarDocComunicacion: function(btn) {

    	var me = this;
    	form = me.down("form");
    	
    	if(form.isValid()){
    		
            form.submit({
                waitMsg: HreRem.i18n('msg.mask.loading'),
                params: {
                	idEntidad: me.idEntidad
                },
                success: function(fp, o) {

                	if(o.result.success == "false") {
                		me.fireEvent("errorToast", o.result.errorMessage);
                	}
                	else {
                		me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
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