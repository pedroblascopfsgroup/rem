Ext.define('HreRem.view.activos.tramites.ReasignarTarea', {
	extend : 'HreRem.view.common.WindowBase',
	xtype : 'reasignarTarea',
	reference : 'windowReasignarTarea',
	viewModel : {
		type : 'reasignartarea'
	},
	title : "Reasignar Tarea",
	width : 700,

	listeners: {    		
		show: function() {			
			var me = this;
			me.resetWindow();			
		}
	},
	
	initComponent : function() {
		var me = this;

		me.buttons = [ {
			itemId : 'btnReasignarTarea',
			text : HreRem.i18n('btn.reasignar.tarea'),
			handler : 'generarReasignacionTarea'
		}, {
			itemId : 'btnCancelarReasignarTarea',
			text : 'Cerrar',
			handler : 'cancelarReasignacionTarea'
		} ];

		me.items = [

		{
			xtype : 'form',
			reference : 'formReasignarTarea',
			scrollable	: 'y',
			defaults	: {
		        layout: 'column',
		        defaultType: 'displayfield'
		    },

			items : [
					{

						xtype : 'fieldset',
						collapsible : true,
						defaultType : 'textfield',
						layout : 'column',
						title : 'Instrucciones',

						items : [ {
							xtype : 'label',
							cls : 'info-tarea',
							html : HreRem.i18n('txt.reasignar.tarea'),
							tipo : 'info'
						} ]

					},

					{
						xtype : 'fieldset',
						title : 'Nuevo Gestor',
						reference: 'formNuevoGestor',
						defaults:{
				    		layout:'column',
				    		width: '50%',
				    		padding: '0 0 10 0'
				    	},

						items : [ 
									{
								        	xtype: 'combo',
								        	fieldLabel: 'Tipo de gestor:',
								        	bind: {
							            		store: '{comboTipoGestor}'
							            	},
											reference: 'tipoGestor',
											name: 'tipoGestor',
				        					chainedStore: 'comboUsuariosReasignacion',
											chainedReference: 'usuarioGestor',
							            	displayField: 'descripcion',
				    						valueField: 'id',
				    						emptyText: 'Introduzca un gestor',
											filtradoEspecial: true,
											listeners: {
												select: 'onChangeChainedComboGestores'
											}
									},
									{
							        	xtype: 'combo',
							        	fieldLabel: 'Usuario:',
							        	reference: 'usuarioGestor',
							        	name: 'usuarioGestor',
							        	bind: {
						            		store: '{comboUsuariosReasignacion}'
						            	},
						            	displayField: 'apellidoNombre',
			    						valueField: 'id',
										filtradoEspecial: true,
			    						emptyText: 'Introduzca un usuario'
								  },
									  {
											xtype: 'displayfieldbase',
											fieldLabel: 'Usuario',
											reference: 'usuarioGestorText',
											flex: 1,
											bind: me.nombreUsuarioGestor
									}
									
						 ]
					},
					
					{
						xtype : 'fieldset',
						title : 'Nuevo Supervisor',
						defaults:{
				    		layout:'column',
				    		width: '50%',
				    		padding: '0 0 10 0'
				    	},

						items : [ 
									{
								        	xtype: 'combo',
								        	fieldLabel: 'Tipo de gestor:',
								        	bind: {
							            		store: '{comboTipoGestor}'
							            	},
											reference: 'tipoGestorSupervisor',
											name: 'tipoGestorSupervisor',
				        					chainedStore: 'comboSupervisorReasignacion',
											chainedReference: 'usuarioSupervisor',
							            	displayField: 'descripcion',
				    						valueField: 'id',
				    						//allowBlank: true,
				    						emptyText: 'Introduzca un gestor',
											filtradoEspecial: true,
											listeners: {
												select: 'onChangeChainedComboGestores'
											}
									},
									{
							        	xtype: 'combo',
							        	fieldLabel: 'Usuario:',
							        	reference: 'usuarioSupervisor',
							        	name: 'usuarioSupervisor',
							        	bind: {
						            		store: '{comboSupervisorReasignacion}'
						            	},
						            	displayField: 'apellidoNombre',
			    						valueField: 'id',
			    						valueNotFoundText: me.nombreUsuarioSupervisor,
										filtradoEspecial: true
								  },
								  {
										xtype: 'displayfieldbase',
										fieldLabel: 'Usuario',
										reference: 'usuarioSupervisorText',
										flex: 1,
										bind: me.nombreUsuarioSupervisor
								}
								
						 ]
					}

			]

		} ];

		me.callParent();

	},
	
	resetWindow: function() {
		var me = this,    	
    	form = me.down("[reference=formReasignarTarea]");
		
		me.down("[reference=usuarioSupervisor]").setHidden(true);
		me.down("[reference=usuarioSupervisorText]").setHidden(false);
		me.down("[reference=usuarioGestor]").setHidden(true);
		me.down("[reference=usuarioGestorText]").setHidden(false);

	}
	
});