Ext.define('HreRem.view.activos.detalle.AnyadirPropietario', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirpropietariowindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /1.2,    
    height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50 ,

    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },

    initComponent: function() {
    	
    	var me = this;

    	me.setTitle("Datos del propietario");
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'A&ntilde;adir'}, { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarPropietario'}];
    	
    	me.items = [
				{
					xtype: 'formBase', 
					collapsed: false,
				 	scrollable	: 'y',
					cls:'',	    				
					
					recordName: "datosRegistrales",
					
					recordClass: "HreRem.model.ActivoDatosRegistrales",
					
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
	    					        	fieldLabel: 'Nº de activo propietario',
	    					        	width: 300
	    					        },
	    					        {
	    					        	fieldLabel: 'Porcentaje de propiedad',
	    					        	width: 300
	    					        },
	    					        {
	    					        	fieldLabel: 'Grado de propiedad',
	    					        	width: 300
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
												width: 300
											},
											{
												fieldLabel: 'Nombre o raz&oacute;n social',
												width: 300
											},
											{
												fieldLabel: 'Tipo de documento',
												width: 300
											},
											{
			    					        	fieldLabel: 'N&ordm; de documento',
			    					        	width: 300
			    					        },
			    					        {
			    					        	fieldLabel: 'Direcci&oacute;n',
			    					        	width: 300
			    					        },
			    					        {
			    					        	fieldLabel: 'Poblaci&oacute;n',
			    					        	width: 300
			    					        },
			    					        {
			    					        	fieldLabel: 'Provincia',
			    					        	width: 300
			    					        },
			    					        {
			    					        	fieldLabel: 'CP',
			    					        	width: 300
			    					        },
			    					        {
			    					        	fieldLabel: 'Tel&eacute;fono',
			    					        	width: 300
			    					        },
			    					        {
			    					        	fieldLabel: 'E-mail',
			    					        	width: 300
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
	    		    					title: 'Representante',
	    			    				collapsed: false,
	    			   			 		scrollable	: 'y',
	    			    				cls:'',	    		
	    		    					items: [
											{
												fieldLabel: 'Nombre y apellidos',
												width: 300
											},	
											{
												fieldLabel: 'Tipo de documento',
												width: 300
											},
											{
												fieldLabel: 'N&ordm; de documento',
												width: 300
											},	
											{
												fieldLabel: 'Tel&eacute;fono 1',
												width: 300
											},
											{
												fieldLabel: 'Tel&eacute;fono 2',
												width: 300
											},	
											{
												fieldLabel: 'E-mail',
												width: 300
											},
											{
												fieldLabel: 'Direcci&oacute;n',
												width: 300
											},	
											{
												fieldLabel: 'Poblaci&oacute;n',
												width: 300
											},
											{
												fieldLabel: 'Provincia',
												width: 300
											},	
											{
												fieldLabel: 'CP',
												width: 300
											}	
										]
	    					        },
	    					        
	    					        {
	    				                	xtype: 'textareafieldbase',
	    				                	//rowspan: 4,
	    				                	fieldLabel: HreRem.i18n('fieldlabel.observaciones')
	    					        }
		    					]
		    				}
		    			]
					}
		    	  ]
		}];
    	
    	me.callParent();
    }
});
    