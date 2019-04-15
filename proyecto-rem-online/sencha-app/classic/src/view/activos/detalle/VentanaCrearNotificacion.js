Ext.define('HreRem.view.activos.detalle.VentanaCrearNotificacion', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'ventanacrearnotificacion',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3,
	reference: 'ventanacrearnotificacionRef',
    
    /**
     * Parámetro para enviar el id del activo al que pertenece la comunicación de gencat a la que añadiremos la notificación.
     * Debe darse valor al crear/abrir la ventana.
     * @type
     */
    idActivo: null,


    /**
     * Párametro para saber que componente abre la ventana, y poder refrescarlo después.
	 * También se usa para poder usar los handlers del controlador que tenga asignado parent.
     * @type
     */
    parent: null,
    record: null,
    idNotificacion: null,
    
    initComponent: function() {
    	var me = this,
    		deshabilitarCamposDespuesAlCrear = true,
    		habilitarCamposAlCrear = false,
    		allowBlankAlCrear = false,
    		idNotificacion = null;

    	if(!Ext.isEmpty(me.record)){
    		var notificacionGencat = me.record,
	    		fechaNotificacion = notificacionGencat.fechaNotificacion,
	    		nombreDocumento = notificacionGencat.nombre,
	    		fechaSancion = notificacionGencat.fechaSancionNotificacion,
	    		cierreNotificacion = notificacionGencat.cierreNotificacion;
    		
    		allowBlankAlCrear = true,
    		deshabilitarCamposDespuesAlCrear = false;
    		habilitarCamposAlCrear = true;
    		idNotificacion = notificacionGencat.id;
    	}
    	
    	me.setTitle(HreRem.i18n("title.crear.notificacion.gencat"));
    	var comboTipoDocumentoComunicacion = new Ext.data.Store({
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'gencat/getTiposDocumentoNotificacion',
				extraParams:{
					idNotificacion: idNotificacion
				}
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
			    				disabled: habilitarCamposAlCrear,
			    				addUxReadOnlyEditFieldPlugin : false,
			    				maxValue: null,
			    				width: '100%',
			    				value:fechaNotificacion
			    				
			    			},
			    			{
			    				xtype: "comboboxfieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.motivo'),
			    				name: 'motivoNotificacion',
			    				addUxReadOnlyEditFieldPlugin : false,
			    				allowBlank: false,
			    				width: '100%',
			    				disabled: habilitarCamposAlCrear,
			    				bind: {
			    					store: '{comboNotificacionGencat}'
			    				}
			    			},
			    			{
			    				xtype: "datefieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion.notificacion'),
			    				name: 'fechaSancionNotificacion',
			    				reference: 'fechaSancionNotificacion',
			    				value: fechaSancion,
			    				addUxReadOnlyEditFieldPlugin : false,
			    				maxValue: null,
			    				width: '100%',
			    				disabled: deshabilitarCamposDespuesAlCrear,
			    				allowBlank:allowBlankAlCrear,
			    				listeners: {
			                        change: function(fld, value) {
			                        	me = this;
						        		var fileUpload = me.lookupController().lookupReference('fileUpload');
						        		var tipoDocumento = me.lookupController().lookupReference('tipoDocumento');
			                        	if(!Ext.isEmpty(value)) {
			                        		tipoDocumento.allowBlank = false;
			                        		tipoDocumento.validate();
			                        		fileUpload.allowBlank = false;
			                        		fileUpload.validate();
			                        	}
			                        }
			                    }
			    			},
			    			{
			    				xtype: "datefieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.cierre.notificacion'),
			    				name: 'cierreNotificacion',
			    				value: cierreNotificacion,
			    				addUxReadOnlyEditFieldPlugin : false,
			    				maxValue: null,
			    				width: '100%',
			    				disabled: deshabilitarCamposDespuesAlCrear
			    			},
			    			{
								xtype: 'filefield',
						        fieldLabel:   HreRem.i18n('fieldlabel.archivo'),
						        name: 'fileUpload',
						        reference:'fileUpload',
						        anchor: '100%',
						        width: '100%',
						        allowBlank: allowBlankAlCrear,
						        msgTarget: 'side',
						        buttonConfig: {
						        	iconCls: 'ico-search-white',
						        	text: ''
						        },
						        align: 'right',
						        listeners: {
			                        change: function(fld, value) {
			                        	var lastIndex = null,
			                        	fileName = null,
			                        	me = this;
						        		var campoFechaSancion = me.lookupController().lookupReference('fechaSancionNotificacion');
						        		var tipoDocumento = me.lookupController().lookupReference('tipoDocumento');
			                        	if(!Ext.isEmpty(value)) {
				                        	lastIndex = value.lastIndexOf('\\');
									        if (lastIndex == -1) return;
									        fileName = value.substring(lastIndex + 1);
				                            fld.setRawValue(fileName);
				                            campoFechaSancion.allowBlank = false;
				                            campoFechaSancion.validate();
				                            tipoDocumento.allowBlank = false;
			                        		tipoDocumento.validate();
			                        	}
			                        }
			                    }
				    		},
				    		{
								xtype: 'combobox',
					        	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
					        	name: 'tipo',
					        	reference: 'tipoDocumento',
					        	editable: false,
					        	allowBlank: false,
					        	msgTarget: 'side',
				            	store: comboTipoDocumentoComunicacion,				            	
				            	displayField: 'descripcion',
							    valueField: 'codigo',
								allowBlank: allowBlankAlCrear,
								width: '100%',
								listeners: {
			                        change: function(fld, value) {
			                        	me = this;
						        		var fileUpload = me.lookupController().lookupReference('fileUpload');
						        		var campoFechaSancion = me.lookupController().lookupReference('fechaSancionNotificacion');
			                        	if(!Ext.isEmpty(value)) {
			                        		campoFechaSancion.allowBlank = false;
			                        		campoFechaSancion.validate();
			                        		fileUpload.allowBlank = false;
			                        		fileUpload.validate();
			                        	}
			                        }
			                    }
					        },
					        {
			                	xtype: 'textarea',
			                	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
			                	allowBlank: true,
			                	name: 'descripcion',
			                	maxLength: 256,
			                	msgTarget: 'side',
			                	width: '100%'
		            		}
    					]
    				}
    	];

    	me.callParent();
    	
    	if(!Ext.isEmpty(me.record)){
    		var comboMotivoNotificacion = me.down('[reference="crearNotificacionFormRef"]').getForm().findField('motivoNotificacion'),
    			store = me.lookupController().getViewModel().get('comboNotificacionGencat'),
    			record = store.findRecord('descripcion', me.record.motivoNotificacion);
    		
				comboMotivoNotificacion.setValue(record.get('codigo'));
    	}
    }
    
});