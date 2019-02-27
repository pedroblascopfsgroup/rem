Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumento', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntardocumentowindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /3,
   /* height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50 ,*/
	reference: 'adjuntarDocumentoWindowRef',
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
	 * Parámetro para enviar el codigo del tipo de trabajo para realizar un filtrado de los tipos de documento.
	 * si no se envia no se realizará ningun filtrado sobre los tipos de documento
	 * @type
	 */
	tipoTrabajoCodigo: null,

    /**
     * Párametro para saber que componente abre la ventana, y poder refrescarlo después.
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
	    				url: $AC.getRemoteUrl(me.entidad + "/upload"),
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
    }
});
