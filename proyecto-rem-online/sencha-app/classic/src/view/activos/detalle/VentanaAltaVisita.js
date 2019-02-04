Ext.define('HreRem.view.activos.detalle.VentanaAltaVisita', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'ventanaaltavisita',
    
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3,
	reference: 'ventanaaltavisitaRef',
    
    /**
     * Parámetro para enviar el id del activo al que pertenece la comunicación de gencat a la que daremos de alta la visita.
     * Debe darse valor al crear/abrir la ventana.
     * @type
     */
    idActivo: null,

    /**
     * Se usa para poder usar los handlers del controlador que tenga asignado parent.
     * @type
     */
    parent: null,

    initComponent: function() {

    	var me = this;

    	me.setTitle(HreRem.i18n("title.alta.visita"));

    	me.buttons = [ 
    		{ 
    			formBind: true, 
    			itemId: 'btnGuardar', 
    			text: 'Guardar', 
    			handler: 'onClickGuardarAltaVisita'
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
	    				url: $AC.getRemoteUrl("gencat/altaVisitaComunicacion"),
	    				reference: 'altaVisitaFormRef',
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		layout: {
	   			 			type: 'vbox'
	   			 		},
	    				cls:'formbase_no_shadow',
	    				items: [
			    			{
			    				xtype: "textfieldbase",
								fieldLabel: HreRem.i18n('fieldlabel.nombre'),
								name: 'nombre',
								allowBlank: false,
			    				addUxReadOnlyEditFieldPlugin : false,
			    				width: '100%'
			    			},
			    			{
                                xtype: "textfieldbase",
                                vtype: 'telefono',
			    				fieldLabel: HreRem.i18n('fieldlabel.telefono'),
								name: 'telefono',
								allowBlank: false,
			    				addUxReadOnlyEditFieldPlugin : false,
			    				width: '100%'
							},
							{
                                xtype: "textfieldbase",
                                vtype: 'email',
			    				fieldLabel: HreRem.i18n('fieldlabel.email'),
								name: 'email',
								allowBlank: false,
                                addUxReadOnlyEditFieldPlugin : false,
			    				width: '100%'
			    			},
			    			{
			    				xtype: "textfieldbase",
								fieldLabel: HreRem.i18n('fieldlabel.observaciones'),
			    				name: 'observaciones',
			    				addUxReadOnlyEditFieldPlugin : false,
			    				width: '100%'
			    			}
    					]
    				}
    	];

    	me.callParent();
    }
    
});