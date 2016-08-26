Ext.define('HreRem.view.expedientes.CondicionesExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'condicionesexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'condicionesExpediente',
    scrollable	: 'y',

	recordName: "condiciones",
	
	recordClass: "HreRem.model.CondicionesExpediente",
    
    requires: ['HreRem.model.CondicionesExpediente'],
    
    listeners: {
			boxready:'cargarTabData'
	},
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.condiciones'));
        var items= [

			{   
				xtype:'fieldset',
				collapsible: true,
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.economicas'),
				items : [	
					{   
						xtype:'fieldsettable',
						defaultType: 'displayfieldbase',				
						title: HreRem.i18n('title.financiacion'),
						items : [
							{ 
								xtype: 'comboboxfieldbase',
								reference: 'comboSolicitaFinanciacion',
			                	fieldLabel:  HreRem.i18n('fieldlabel.solicita.financiacion'),
					        	bind: {
				            		store: '{comboSiNoRem}',
				            		value: '{condiciones.solicitaFinanciacion}'
				            	}
					        },
					        {
					        	xtype: 'datefiedlbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.inicio.expediente'),
					        	bind: '{condiciones.inicioExpediente}'					        						        	
					        },
					        {
					        	xtype: 'datefiedlbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.inicio.financiacion'),
					        	bind: '{condiciones.inicioFinanciacion}'				        						        	
					        },
					        { 
								xtype: 'comboboxfieldbase',
								reference: 'comboEntidadFinanciera',
			                	fieldLabel:  HreRem.i18n('fieldlabel.entidad.financiera'),
					        	bind: {
				            		//store: '{comboEntidadesFinancieras}',
				            		value: '{condiciones.entidadFinancieraCodigo}'
				            	}
					        },
					        { 
								xtype: 'comboboxfieldbase',
								reference: 'comboEstadoExpediente',
			                	fieldLabel:  HreRem.i18n('fieldlabel.estado.expediente'),
					        	bind: {
				            		store: '{comboEstadoExpediente}',
				            		value: '{condiciones.estadoExpedienteCodigo}'
				            	}
					        }
					        
					        
				        ]
					}
		        ]
			},
			{   
				xtype:'fieldset',
				collapsible: true,
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.juridicas'),
				items : [
		        ]
			},
			{   
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.administrativas'),
				items : [	               
		        ]
			}
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);		
    }
});