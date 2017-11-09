Ext.define('HreRem.view.activos.detalle.AnyadirPropietario', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'editarpropietariowindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 1.2,    
    height	: Ext.Element.getViewportHeight() > 780 ? 780 : Ext.Element.getViewportHeight() - 50 ,

    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    modoEdicion: true,
    
    activo: null,
    
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
    	
    	me.setTitle("Datos del propietario");
    	
    	me.buttons = [ { itemId: 'btnAnyadir', text: 'Añadir', handler: 'onClickBotonAnyadirPropietario'}, { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarPropietario'}];
    	
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
			    					        	fieldLabel: HreRem.i18n('fieldlabel.porcentaje.propiedad'),
			    					        	name: 'porcPropiedad',
			    					        	maskRe: /[0-9.]/,
			    					        	allowBlank: false
			    					        },
			    					        {
			    					        		xtype: 'comboboxfieldbase',
			    					        	   fieldLabel: HreRem.i18n('fieldlabel.grado.propiedad'),
			    					        	   name: 'tipoGradoPropiedad',
												   displayField: 'descripcion',
												   valueField: 'codigo',
												   allowBlank: false,
												   bind:{ 
													   	store: '{comboGradoPropiedad}'
													   		} 
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
												name: 'nombre',
												allowBlank: false
											},
											{
		    					        		xtype: 'comboboxfieldbase',
		    					        	   fieldLabel: HreRem.i18n('fieldlabel.tipo.documento'),
		    					        	   name: 'tipoDoc',
											   displayField: 'descripcion',
											   valueField: 'codigo',
											   bind:{ 
												   	store: '{comboTipoDocumento}'
												   		} 
	    		    						},
											{
												fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
												name: 'numDoc'
			    					        },
			    					        {
			    					        	fieldLabel: HreRem.i18n('fieldlabel.direccion'),
			    					        	name: 'direccion'
			    					        },
			    					        
			    					        {
												   xtype: 'comboboxfieldbase',
												   fieldLabel: HreRem.i18n('fieldlabel.provincia'),
												   reference: 'provincia',
												   name: 'provincia',
												   displayField: 'descripcion',
												   valueField: 'codigo',
												   chainedStore: 'comboPoblacion',
												   chainedReference: 'localidad',
												   listeners: {
														select: 'onChangeChainedCombo'
						    						},
												   bind:{ 
													   	value: '{propietario.provinciaCodigo}',
													   	store: '{comboProvincias}'													   	
													   		} 
											},
											
			    					        {
												   xtype: 'comboboxfieldbase',
			    					        	   fieldLabel: HreRem.i18n('fieldlabel.poblacion'),
			    					        	   reference: 'localidad',
			    					        	   name: 'localidad',
												   displayField: 'descripcion',
												   valueField: 'codigo',
												   bind:{ 
													   	value: '{propietario.localidadCodigo}',
													   	store: '{comboPoblacion}'													   	
													   		} 
											},
			    					       
											
			    					        {
			    					        	fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
			    					        	name: 'codigoPostal'
			    					        },
			    					        {
			    					        	fieldLabel: HreRem.i18n('fieldlabel.telefono'),
			    					        	name: 'telefono'
			    					        },
			    					        {
			    					        	vtype: 'email',
			    					        	fieldLabel: HreRem.i18n('fieldlabel.email'),
			    					        	name: 'email'
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
    	
    },
    
    resetWindow: function() {
    	var me = this;
    	me.getViewModel().set('propietario', me.propietario);
    	me.getViewModel().set('activo', me.activo);
    }
});
    
    