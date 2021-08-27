Ext.define('HreRem.view.expedientes.gestores.ComboGestoresExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'combogestoresexpediente',
    isSearchForm: false,
    reference: 'combogestoresexpedienteform',
    layout: 'column', 
    
    defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'textfield'
        //,style: 'width: 50%'
    },
    
	initComponent: function() {
	
		var me = this;
		me.setTitle(HreRem.i18n('title.anyadir.gestor'));
    	me.buttonAlign = 'left';
    	
    	me.items = [
                   	 {
		                	xtype:'container',
							collapsible: false,
							defaultType: 'textfield',
							margin: '0 0 20 0',
							layout: 'hbox',							
							items :
								[											
											
								{
						        	xtype: 'combo',
						        	fieldLabel: 'Tipo de gestor:',
						        	bind: {
					            		store: '{comboTipoGestorFilteredExpediente}'
					            	},
									reference: 'tipoGestor',
									name: 'tipoGestor',
		        					chainedStore: 'comboUsuarios',
									chainedReference: 'usuarioGestor',
					            	displayField: 'descripcion',
		    						valueField: 'id',
		    						emptyText: 'Introduzca un gestor',
									listeners: {
										select: 'onChangeChainedCombo'
									}
								}
				                ]
		                },	
		                {
		                	xtype:'container',
							collapsible: false,
							defaultType: 'textfield',
							margin: '0 0 20 0',
							layout: 'hbox',							
							items :	[
							  {
						        	xtype: 'combo',
						        	fieldLabel: 'Usuario:',
						        	reference: 'usuarioGestor',
						        	name: 'usuarioGestor',
									queryMode: 'local',
						        	bind: {
					            		store: '{comboUsuarios}',
					            		disabled: '{!tipoGestor.selection}'
					            	},
					            	displayField: 'apellidoNombre',
		    						valueField: 'id',
		    						emptyText: 'Introduzca un usuario',
		    						filtradoEspecial: true
							  }
				          ]
		                }
    	            ];
	    me.buttons = [
	    	{ 
	    		itemId: 'botonAgregarGestorExpediente',
				text: 'Agregar', 
				handler: 'onAgregarGestoresClick', 
				bind: { disabled: '{!usuarioGestor.selection}'} 
	    	}
	    ];

	    me.callParent();
	}
});