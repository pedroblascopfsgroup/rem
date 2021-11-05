Ext.define('HreRem.view.common.adjuntos.AdjuntarFoto', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntarfotowindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /3,
   /* height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50 ,*/
	closeAction: 'hide',	
	requires: ['HreRem.view.common.adjuntos.AdjuntarFotoController', 'HreRem.view.common.adjuntos.AdjuntarFotoModel'],
	reference: 'adjuntarFotoWindowRef',
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
    codigoSubtipoActivo: null,
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
    	    	
    	var comboTipoFoto = new Ext.data.Store({
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tiposFoto'}
			}
    	});
    	
    	me.getViewModel().set('codigoSubtipoActivo', me.codigoSubtipoActivo);
		me.getViewModel().notify();
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Adjuntar', handler: 'onClickBotonAdjuntarFoto'},{ itemId: 'btnCancelar', text: 'Cancelar',  handler: 'closeWindow', scope: this}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				url: $AC.getRemoteUrl("activo/uploadFoto"),
	    				reference: 'adjuntarFotoFormRef',
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		layout: {
	   			 			type: 'vbox'
	   			 		},
	   			 		cls:'formbase_no_shadow',
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
									xtype: 'combobox',
						        	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
						        	name: 'tipo',
						        	editable: false,
					            	store: comboTipoFoto,
					            	displayField	: 'descripcion',			
								    valueField		: 'codigo',
									allowBlank: false,
									msgTarget: 'side',
									width: '100%',
									listeners: {
			                			change: function(cmp, newValue, oldValue, eOpts ) {
			                				if (newValue != '01') {
			                					this.up('form').down('[name=principal]').hide();
			                					this.up('form').down('[name=principal]').disable();	
			                					this.up('form').down('fieldcontainer[reference=radioInterior]').hide();
			                					this.up('form').down('fieldcontainer[reference=radioInterior]').disable();
			                					this.up('form').down('[name=suelos]').hide();
			                					this.up('form').down('[name=suelos]').disable();	
			                					this.up('form').down('[name=plano]').hide();
			                					this.up('form').down('[name=plano]').disable();	
			                				} else {
			                					this.up('form').down('[name=principal]').show();
			                					this.up('form').down('[name=principal]').enable();	
			                					this.up('form').down('fieldcontainer[reference=radioInterior]').show();
			                					this.up('form').down('fieldcontainer[reference=radioInterior]').enable();
			                					this.up('form').down('[name=suelos]').show();
			                					this.up('form').down('[name=suelos]').enable();	
			                					this.up('form').down('[name=plano]').show();
			                					this.up('form').down('[name=plano]').enable();	
			                				}
			                			}
			                		}
						        },
						        /*{
				                	xtype: 'textfield',
				                	fieldLabel: HreRem.i18n('fieldlabel.nombre'),
				                	name: 'nombre',
				                	maxLength: 256,
				                	width: '100%'				                	
			            		},*/
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
								},
				            	{ 
			                		xtype : 'checkboxfield',
			                		fieldLabel:  HreRem.i18n('fieldlabel.principal'),
			                		name: 'principal',
			                		inputValue : true,
			                		listeners: {
			                			change: function(cmp, newValue, oldValue, eOpts ) {
			                				if (newValue == true || newValue == 'true') {
			                					this.up('form').down('fieldcontainer[reference=radioInterior]').show();
			                				} else {
			                					this.up('form').down('fieldcontainer[reference=radioInterior]').hide();
			                				}
			                			}
			                		}
				                },
				                {
				                	hidden	   : true,
				              		xtype      : 'fieldcontainer',
				              		reference	: 'radioInterior',
						            //fieldLabel : 'Size',
						            defaultType: 'radiofield',
						            defaults: {
						                flex: 1
						            },
						            layout: 'hbox',
						            items: [
						                {
						                    boxLabel  : 'Interior',
						                    name      : 'interiorExterior',
						                    inputValue: true
						                }, 
						                {
						                    boxLabel  : 'Exterior',
						                    name      : 'interiorExterior',
						                    inputValue: false
						                }
						            ]
						        },
						    	{ 
			                		xtype : 'checkboxfield',
			                		fieldLabel:  HreRem.i18n('fieldlabel.suelos'),
			                		name: 'suelos',
			                		displayField: 'suelos',
			                		inputValue : true,
			                	    valueField: 'suelos'
						    	},
			                	{ 
				                	xtype : 'checkboxfield',
				                	fieldLabel:  HreRem.i18n('fieldlabel.plano'),
				                	name: 'plano',
				                	displayField: 'plano',
				                	inputValue : true,
				                    valueField: 'plano'
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
    