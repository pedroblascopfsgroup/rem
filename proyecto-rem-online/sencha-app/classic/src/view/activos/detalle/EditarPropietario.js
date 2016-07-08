Ext.define('HreRem.view.activos.detalle.EditarPropietario', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'editarpropietariowindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 1.2,    
    height	: Ext.Element.getViewportHeight() > 780 ? 780 : Ext.Element.getViewportHeight() - 50 ,

    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    propietario: null,
    
    listeners: {
    	
		show: function() {			
			var me = this;
			me.resetWindow();			
		}
		
	},

    initComponent: function() {
    	
    	var me = this;

    	me.setTitle("Datos del propietario");
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Editar'}, { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarPropietario'}];
    	
    	me.items = [
				{
					xtype: 'formBase', 
					collapsed: false,
				 	scrollable	: 'y',
					cls:'',	    				
					/*
					recordName: "propietario",
					
					recordClass: "HreRem.model.ActivoPropietario",*/
					
					items: [
					
	    				{
	    					xtype:'fieldset',
	    					layout: {
	    						type: 'hbox'
				        	},
	    					defaultType: 'textfieldbase',
		    				collapsed: false,
		   			 		scrollable	: 'y',
		    				cls:'',	    				
						    
	    					items: [
							{
									xtype: 'container',
									width: '50%',
									margin: '0 0 0 2',
									
									items: [
									{
										xtype:'fieldset',
										layout: {
									        type: 'table',
											trAttrs: {height: '45px', width: '90%'},
											columns: 1,
											tableAttrs: {
									            style: { width: '90%' }
									        }
										},
										defaultType: 'textfieldbase',
										title: 'Relaci&oacute;n propietario-activo',
										collapsed: false,
											scrollable	: 'y',
										cls:'',	    		
										items: [
			    					        {
			    					        	fieldLabel: 'N&ordm; de activo propietario',
			    					        	width: 300,
			    					        	bind: '{propietario.idActivo}'
			    					        },
			    					        {
			    					        	fieldLabel: 'Porcentaje de propiedad',
			    					        	width: 300,
			    					        	bind: '{propietario.porcPropiedad}'
			    					        },
			    					        {
			    					        	fieldLabel: 'Grado de propiedad',
			    					        	width: 300,
			    					        	bind: '{propietario.tipoGradoPropiedadDescripcion}'
			    					        }
			    					    ]
									},
	    					        {
	    					        	xtype:'fieldset',
	    		    					layout: {
	    							        type: 'table',
	    					        		trAttrs: {height: '45px', width: '90%'},
	    					        		columns: 1,
	    					        		tableAttrs: {
	    							            style: { width: '90%' }
	    							        }
	    					        	},
	    		    					defaultType: 'textfieldbase',
	    		    					title: 'Datos de identificaci&oacute;n',
	    			    				collapsed: false,
	    			   			 		scrollable	: 'y',
	    			    				cls:'',	    		
	    		    					items: [
											{
												fieldLabel: 'Tipo de persona',
												width: 300,
			    					        	bind: '{propietario.tipoPersonaDescripcion}'
											},
											{
												fieldLabel: 'Nombre o raz&oacute;n social',
												width: 300,
			    					        	bind: '{propietario.nombreCompleto}'
											},
											{
												fieldLabel: 'Tipo de documento',
												width: 300,
			    					        	bind: '{propietario.tipoDocIdentificativoDesc}'
											},
											{
			    					        	fieldLabel: 'N&ordm; de documento',
			    					        	width: 300,
			    					        	bind: '{propietario.docIdentificativo}'
			    					        },
			    					        {
			    					        	fieldLabel: 'Direcci&oacute;n',
			    					        	width: 300,
			    					        	bind: '{propietario.direccion}'
			    					        },
			    					        {
			    					        	fieldLabel: 'Poblaci&oacute;n',
			    					        	width: 300,
			    					        	bind: '{propietario.localidadDescripcion}'
			    					        },
			    					        {
			    					        	fieldLabel: 'Provincia',
			    					        	width: 300,
			    					        	bind: '{propietario.provinciaDescripcion}'
			    					        },
			    					        {
			    					        	fieldLabel: 'CP',
			    					        	width: 300,
			    					        	bind: '{propietario.codigoPostal}'
			    					        },
			    					        {
			    					        	fieldLabel: 'Tel&eacute;fono',
			    					        	width: 300,
			    					        	bind: '{propietario.telefono}'
			    					        },
			    					        {
			    					        	fieldLabel: 'E-mail',
			    					        	width: 300,
			    					        	bind: '{propietario.email}'
			    					        }
	    		    					]
	    					        }
	    					    ]
							},
						 	{
						 		xtype: 'container',
						 		width: '50%',
						 		layout: {
					        	      type: 'vbox',
					        	      align: 'stretch'
					        	},
						 		
						 		items: [
							
	    					        {
	    					        	xtype:'fieldset',
	    					        	rowspan: 5,
	    		    					layout: {
	    							        type: 'table',
	    					        		trAttrs: {height: '45px', width: '90%'},
	    					        		columns: 1,
	    					        		tableAttrs: {
	    							            style: { width: '90%' }
	    							        }
	    					        	},
	    		    					defaultType: 'textfieldbase',
	    		    					title: 'Representante del propietario',
	    			    				collapsed: false,
	    			   			 		scrollable	: 'y',
	    			    				cls:'',	    		
	    		    					items: [
											{
												fieldLabel: 'Nombre y apellidos',
												width: 300,
			    					        	bind: '{propietario.nombreContacto}'
											},
											{
												fieldLabel: 'Tel&eacute;fono 1',
												width: 300,
			    					        	bind: '{propietario.telefono1Contacto}'
											},
											{
												fieldLabel: 'Tel&eacute;fono 2',
												width: 300,
			    					        	bind: '{propietario.telefono2Contacto}'
											},	
											{
												fieldLabel: 'E-mail',
												width: 300,
			    					        	bind: '{propietario.emailContacto}'
											},
											{
												fieldLabel: 'Direcci&oacute;n',
												width: 300,
			    					        	bind: '{propietario.direccionContacto}'
											},	
											{
												fieldLabel: 'Poblaci&oacute;n',
												width: 300,
			    					        	bind: '{propietario.localidadContactoDescripcion}'
											},
											{
												fieldLabel: 'Provincia',
												width: 300,
			    					        	bind: '{propietario.provinciaContactoDescripcion}'
											},	
											{
												fieldLabel: 'CP',
												width: 300,
			    					        	bind: '{propietario.codigoPostalContacto}'
											}	
										]
	    					        },
	    					        
	    					        {
	    				                	xtype: 'textareafieldbase',
	    				                	//rowspan: 4,
	    				                	fieldLabel: HreRem.i18n('fieldlabel.observaciones'),
		    					        	bind: '{propietario.observaciones}'
	    					        }
		    					]
		    				}
		    			]
					}
		    	  ]
		}];
    	
    	me.callParent();
    	
    },
    
    resetWindow: function() {
    	var me = this;
    	me.getViewModel().set('propietario', me.propietario);
    }
});
    