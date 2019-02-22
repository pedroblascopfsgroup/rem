Ext.define('HreRem.view.common.adjuntos.VentanaCrearNotificacion', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'ventanacrearnotificacion',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3,
	reference: 'ventanacrearnotificacionRef',
    
    /**
     * Parámetro para enviar el id del activo al que pertenece la comunicación de gencat a la añadiremos la notificación.
     * Debe darse valor al crear/abrir la ventana.
     * @type
     */
    idActivo: null,


    /**
     * Párametro para saber que componente abre la ventana, y poder refrescarlo después.
     * @type
     */
    parent: null,

    initComponent: function() {

    	var me = this;

    	me.setTitle(HreRem.i18n("title.crear.notificacion.gencat"));
    	
    	var comboTipoDocumentoComunicacion = new Ext.data.Store({
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'gencat/getTiposDocumentoNotificacion'
			}
    	});

    	me.buttons = [ 
    		{ 
    			formBind: true, 
    			itemId: 'btnGuardar', 
    			text: 'Guardar', 
    			handler: 'onClickGuardarNotificacion'
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
	    				url: $AC.getRemoteUrl("gencat/crearNotificacionComunicacion"),
	    				reference: 'crearNotificacionFormRef',
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		layout: {
	   			 			type: 'vbox'
	   			 		},
	    				cls:'formbase_no_shadow',
	    				items: [
			    			{
			    				xtype: "datefieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.fecha.notificacion'),
			    				name: 'fechaNotificacion',
			    				allowBlank: false,
			    				addUxReadOnlyEditFieldPlugin : false,
			    				maxValue: null,
			    				width: '100%'
			    			},
			    			{
			    				xtype: "comboboxfieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.motivo'),
			    				name: 'motivoNotificacion',
			    				addUxReadOnlyEditFieldPlugin : false,
			    				allowBlank: false,
			    				width: '100%',
			    				bind: {
			    					store: '{comboNotificacionGencat}'
			    				}
			    			},
			    			{
			    				xtype: "datefieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion.notificacion'),
			    				name: 'fechaSancionNotificacion',
			    				addUxReadOnlyEditFieldPlugin : false,
			    				allowBlank: false,
			    				maxValue: null,
			    				width: '100%'
			    			},
			    			{
			    				xtype: "datefieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.cierre.notificacion'),
			    				name: 'cierreNotificacion',
			    				addUxReadOnlyEditFieldPlugin : false,
			    				allowBlank: false,
			    				maxValue: null,
			    				width: '100%'
			    			},
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
					        	allowBlank: false,
					        	msgTarget: 'side',
				            	store: comboTipoDocumentoComunicacion,
				            	displayField: 'descripcion',
							    valueField: 'codigo',
								allowBlank: false,
								width: '100%'
					        },
					        {
			                	xtype: 'textarea',
			                	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
			                	allowBlank: false,
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