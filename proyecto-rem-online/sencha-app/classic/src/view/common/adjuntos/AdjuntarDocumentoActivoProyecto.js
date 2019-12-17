Ext.define('HreRem.view.common.adjuntos.AdjuntarDocumentoActivoProyecto', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntardocumentowindowactivoproyecto',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /3,
   /* height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50 ,*/
	reference: 'adjuntarDocumentoActivoProyectoWindowRef',
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
     * Párametro para saber que componente abre la ventana, y poder refrescarlo después.
     * @type
     */
    parent: null,
    
    /**
     * Párametro para definir el nombre de la ventana.
     * @type
     */
    title: null,
    
    /**
     * Párametro para definir el diccionario del combo de tipos de documentos.
     * @type
     */
    diccionario: null,

    initComponent: function() {
    	var me = this;

    	me.setTitle(me.title != null ? me.title : HreRem.i18n("title.adjuntar.documento.promocion"));

    	me.buttonAlign = 'left';

    	var comboTipoDocPromo = new Ext.data.Store({
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: me.diccionario != null ? me.diccionario : 'tiposDocumentoPromocion'}
			}
    	});

    	me.buttons = [ { formBind: true, itemId: 'btnGuardar', text: 'Adjuntar', handler: 'onClickBotonAdjuntarDocumento', scope: this},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'closeWindow', scope: this}];

    	me.items = [
    				{
	    				xtype: 'formBase',
	    				url: $AC.getRemoteUrl(me.entidad + "/upload"),
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
						        	editable: true,
						        	msgTarget: 'side',
					            	store: comboTipoDocPromo,
					            	displayField	: 'descripcion',

								    valueField		: 'codigo',
									allowBlank: false,
									width: '100%',
									enableKeyEvents:true,
								    listeners: {
								    	'keyup': function() {
								    		this.getStore().clearFilter();
								    	   	this.getStore().filter({
								        	    property: 'descripcion',
								        	    value: this.getRawValue(),
								        	    anyMatch: true,
								        	    caseSensitive: false
								        	})
								    	},
								    	'beforequery': function(queryEvent) {
								         	queryEvent.combo.onLoad();
								    	}
								    }
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
