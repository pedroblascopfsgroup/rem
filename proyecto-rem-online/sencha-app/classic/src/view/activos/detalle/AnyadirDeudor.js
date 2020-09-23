Ext.define('HreRem.view.activos.detalle.AnyadirDeudor', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirDeudor',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 1.2,    
    height	: Ext.Element.getViewportHeight() > 780 ? 780 : Ext.Element.getViewportHeight() - 50 ,

    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    modoEdicion: true,
    
    activo: null,
    
    deudor: null,
    
    listeners: {
    	
		show: function() {			
			var me = this;
			me.resetWindow();			
		},
		boxready: function(window) {
			var me = this;
			me.initWindow();
		}
		
	},
	
	initWindow: function() {
    	var me = this;
    	
    	if(me.modoEdicion) {
			Ext.Array.each(me.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) { 								
					field.fireEvent('edit');
					if(index == 0) field.focus();
				}
			);
    	}
    	
    },

    initComponent: function() {
    	
    	var me = this;
    	
    	me.setTitle("Datos del deudor");
    	
    	//Modificar los handler
    	me.buttons = [ { itemId: 'btnAnyadir', text: HreRem.i18n('itemSelector.btn.add.tooltip'), handler: 'onClickBotonAnyadirPropietario'}, { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarPropietario'}];
    	
    	me.items = [
				{
					xtype: 'formBase', 
					collapsed: false,
				 	scrollable	: 'y',
					cls:'',	    				
					
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
										items: [
			    					        {
			    					        	readOnly: true,
			    					        	fieldLabel: HreRem.i18n('fieldlabel.id.activo.haya'),
			    					        	name: 'idActivo',
			    					        	bind: '{activo.numActivo}'
			    					        	
			    					        },
			    					        {
			    					        	fieldLabel: 'Fecha Alta',
			    					        	name: 'fechaAlta',
//			    					        	maskRe: /[0-9.]/,
                                                readOnly: true
			    					        },
			    					        {
			    					        	fieldLabel:'Gestor Alta',
			    					        	name: 'gestorAlta',
//			    					        	maskRe: /[0-9.]/,
                                                readOnly: true
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
	    		    						//Revisar el tipo de persona
	    		    						{
		    					        		xtype: 'comboboxfieldbase',
		    					        	   fieldLabel: HreRem.i18n('fieldlabel.tipo.persona'),
		    					        	   name: 'tipoPersona',
											   displayField: 'descripcion',
											   valueField: 'codigo',
											   bind:{ 
												   	store: '{comboTiposPersona}'
												   		} 
	    		    						},
											
											{
												fieldLabel: HreRem.i18n('header.nombre.razon.social'),
												xtype: 'textfieldbase',
												name: 'nombre',
                                                readOnly: false
											},
											{
		    					        		xtype: 'comboboxfieldbase',
		    					        	    fieldLabel: HreRem.i18n('fieldlabel.tipo.documento'),
		    					        	    name: 'tipoDoc',
											    displayField: 'descripcion',
											    valueField: 'codigo',
											    bind:{
												   	store: '{comboTipoDocumento}'
												},
                                                readOnly: false
	    		    						},
											{
												fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
												name: 'numDoc',												
                                                readOnly: false
			    					        }
	    		    					]
	    					        }
	    					    ]
							}
						 	,{
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
												name: 'nombreContacto',
												bind: {
			    					        		value: '{propietario.nombreContacto}'			    					        		
			    					        	}
											}	
										]
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
    	//revisar esto
//    	me.getViewModel().set('deudor', me.propietario);
    	me.getViewModel().set('activo', me.activo);
    }
});
    
    