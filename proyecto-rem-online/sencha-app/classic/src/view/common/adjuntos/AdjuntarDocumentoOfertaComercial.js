Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoOfertacomercial', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntardocumentowindowofertacomercial',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /3,
   /* height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50 ,*/
	reference: 'adjuntarDocumentoWindowOfertacomercialRef',
    /**
     * ParÃ¡metro para construir la url que sibirÃ¡ el documento
     * @type
     */
    entidad: null,
    /**
     * ParÃ¡metro para enviar el id de la entidad a la que se adjunta el documento. Debe darse valor al
     * crear/abrir la ventana.
     * @type
     */
    idEntidad: null,
    
    docCliente: null,

	/**
	 * ParÃ¡metro para enviar el codigo del tipo de trabajo para realizar un filtrado de los tipos de documento.
	 * si no se envia no se realizarÃ¡ ningun filtrado sobre los tipos de documento
	 * @type
	 */
	tipoTrabajoCodigo: null,

    /**
     * PÃ¡rametro para saber que componente abre la ventana, y poder refrescarlo despuÃ©s.
     * @type
     */
    parent: null,

    initComponent: function() {

    	var me = this;

    	me.setTitle(HreRem.i18n("title.adjuntar.documento"));

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
		
    	me.buttons = [ { formBind: true, itemId: 'btnGuardar', text: 'Adjuntar', handler: 'onClickBotonAdjuntarDocumento', scope: this},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'closeWindow', scope: this}];

    	me.items = [
    				{
	    				xtype: 'formBase',
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
					            	displayField	: 'descripcion',
								    valueField		: 'codigo',
									allowBlank: true,
									width: '100%',
									hidden: true
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
    	var url = $AC.getRemoteUrl("expedientecomercial/saveDocumentoComprador");
    	if(btn.up('anyadirnuevaofertaactivoadjuntardocumento').up().xtype.indexOf('oferta') >= 0) {
    		url = $AC.getRemoteUrl("activooferta/saveDocumentoAdjuntoOferta");
    	}
    		if(form.isValid()){
    			form.submit({
					url: url,
	                waitMsg: HreRem.i18n('msg.mask.loading'),
	                params: {docCliente : me.docCliente, idEntidad: me.idEntidad},
	                success: function(fp, o) {
	                	if(o.result.success == "false") {
	                	me.fireEvent("errorToast", o.result.errorMessage);
	                	}else{
	                		var url = null, ventanaWizard = null;
	                		if(btn.up('anyadirnuevaofertaactivoadjuntardocumento').up().xtype.indexOf('oferta') >= 0) {
	                			url = $AC.getRemoteUrl('activooferta/getListAdjuntos');
	                			ventanaWizard = btn.up('wizardaltaoferta');
	                		} else {
	                			url = $AC.getRemoteUrl('expedientecomercial/getListAdjuntosComprador');
	                			ventanaWizard = btn.up('wizardaltacomprador');
	                		}
	                		
	                		Ext.Ajax.request({
	                			 waitMsg: HreRem.i18n('msg.mask.loading'),
	                		     url: url,
	                			 method : 'GET',
	                		     params: {docCliente : me.docCliente},
	                		
	                		     success: function(response, opts) {
	                		    	 data = Ext.decode(response.responseText);
	                		    	 if(!Ext.isEmpty(data.data[0])){
	                		    	 	ventanaWizard.down('anyadirnuevaofertaactivoadjuntardocumento').getForm().findField('docOfertaComercial').setValue(data.data[0].nombre);
	                		    	 	ventanaWizard.down('anyadirnuevaofertaactivoadjuntardocumento').down().down('panel').down('button').show();
	                		    	 	ventanaWizard.down('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnFinalizar]').enable();
	                		    	 	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	                		    	 }
	                		     },

	                			 failure: function(record, operation) {
	                				 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	                			 }
	                		});
	                	}
	                	if(!Ext.isEmpty(me.parent)) {
	                		me.parent.fireEvent("afterupload", me.parent);
	                	}
	                    me.close();
	                },
	                failure: function(fp, o) {
	                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.subir.unico.documento"));
	                	me.close();
	                }
	            });
			}
        }
});
