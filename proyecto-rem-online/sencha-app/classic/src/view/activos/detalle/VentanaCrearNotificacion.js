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
    		},
    		{ 
    			itemId: 'btnAdjuntar', 
    			text: 'Adjuntar', 
    			handler: 'onClickAdjuntarDocumentoNotificaciones'
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
			    				addUxReadOnlyEditFieldPlugin : false,
			    				maxValue: null,
			    				width: '100%'
			    			},
			    			{
			    				xtype: "comboboxfieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.motivo'),
			    				name: 'motivoNotificacion',
			    				addUxReadOnlyEditFieldPlugin : false,
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
			    				maxValue: null,
			    				width: '100%'
			    			},
			    			{
			    				xtype: "datefieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.cierre.notificacion'),
			    				name: 'cierreNotificacion',
			    				addUxReadOnlyEditFieldPlugin : false,
			    				maxValue: null,
			    				width: '100%'
			    			}
    					]
    				}
    	];

    	me.callParent();
    }
    
});