Ext.define('HreRem.view.activos.gestores.ComboGestores', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'combogestores',
    isSearchForm: false,
    reference: 'combogestoresform',
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
			            	defaultType: 'toolfieldset',
			            	margin: '5 0 0 0',
			            	layout: 'hbox',
			            	items: [
			            		{			
					            	xtype: 'toolfieldset',
					            	border: false,
					            	style: 'background: none; margin-left: -13px',
					            	bind:{
					            		hidden: '{!activo.isCarteraBankia}',
					            		title: 'Gestoría de Recovery: {activo.acbCoreaeTexto}'
					            	}
					            }
			            	]
			            },
			            {
			                	xtype:'container',
								collapsible: false,
								defaultType: 'textfield',
								margin: '0 0 0 0',
								layout: 'hbox',							
								items :
									[											
												
									{
								        	xtype: 'combo',
								        	fieldLabel: 'Tipo de gestor:',
								        	bind: {
							            		store: '{comboTipoGestor}'
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
								margin: '0 0 0 0',
								layout: 'hbox',							
								items :	[
								  {
							        	xtype: 'combo',
							        	fieldLabel: 'Usuario:',
							        	reference: 'usuarioGestor',
							        	name: 'usuarioGestor',
							        	bind: {
						            		store: '{comboUsuarios}',
						            		disabled: '{!tipoGestor.selection}'
						            	},
						            	displayField: 'apellidoNombre',
			    						valueField: 'id',
			    						mode: 'local',
			    						emptyText: 'Introduzca un usuario',
			    						enableKeyEvents:true,
		    						    listeners: {
		    						     'keyup': function() {
		    						    	   this.getStore().clearFilter();
		    						    	   this.getStore().filter({
		    						        	    property: 'apellidoNombre',
		    						        	    value: this.getRawValue(),
		    						        	    anyMatch: true,
		    						        	    caseSensitive: false
		    						        	})
		    						     },
		    						     'beforequery': function(queryEvent) {
		    						           queryEvent.combo.onLoad();
		    						     }
		    						    }
								  }
					          ]
			                }			                
    	            ];
    	
    	me.buttons = [
	    	{ 
	    		text: 'Agregar',
	    		handler: 'onAgregarGestoresClick',
	    		bind: { disabled: '{!usuarioGestor.selection}'}
	    	}
	    ];
    	
	    

	    me.callParent();
	}
});