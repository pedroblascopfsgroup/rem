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
    
    modoEdicion: true,
    
    propietario: null,
    isUnidadAlquilable: null,
    
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
	
	isPrincipal: function(){
		var me = this;
		if (me.propietario.data.tipoPropietario == "Principal"){
			return true;
		}else {
			return false;
		}
	},
	
	initWindow: function() {
    	var me = this;
    	if (me.up().getViewModel().get('activo.unidadAlquilable') != undefined && me.up().getViewModel().get('activo.unidadAlquilable') != null)
    		isUnidadAlquilable = me.up().getViewModel().get('activo.unidadAlquilable');
    	else 
    		isUnidadAlquilable = false;
    	if(me.modoEdicion) {
			Ext.Array.each(me.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) { 						
					if  (isUnidadAlquilable){
						field.setReadOnly(true);
					}else{
						field.fireEvent('edit');
						if(index == 0) field.focus();	
					}
					
				}
			);
    	}
    	
    },

    initComponent: function() {
    	
    	var me = this;
    	
    	me.setTitle("Datos del propietario");
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Guardar', handler: 'onClickBotonGuardarPropietario'}, { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarPropietario'}];
    	if (me.activo.data.unidadAlquilable)
    		me.buttons[0].hidden = true;
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
			    					        	fieldLabel: HreRem.i18n('fieldlabel.tipo.propietario'),
												name: 'tipoPropietario',
			    					        	bind: '{propietario.tipoPropietario}'
			    					        	
			    					        },
			    					        {
			    					        	readOnly: true,
			    					        	fieldLabel: HreRem.i18n('fieldlabel.numero.activo.propietario'),
			    					        	name: 'id',
			    					        	bind: '{propietario.idActivo}'
			    					        	
			    					        },
			    					        {
			    					        	fieldLabel: HreRem.i18n('fieldlabel.porcentaje.propiedad'),
			    					        	name: 'porcPropiedad',
			    					        	maskRe: /[0-9.]/,
			    					        	bind: '{propietario.porcPropiedad}'
			    					        },
			    					        {
			    					        		xtype: 'comboboxfieldbase',
			    					        	   fieldLabel: HreRem.i18n('fieldlabel.grado.propiedad'),
			    					        	   name: 'tipoGradoPropiedad',
			    					        	   allowBlank: false,
												   displayField: 'descripcion',
												   valueField: 'codigo',
												   bind:{ 
													   	value: '{propietario.tipoGradoPropiedadCodigo}',
													   	store: '{comboGradoPropiedad}'
													   		} 
											},
											{
												readOnly: true,
												fieldLabel: HreRem.i18n('fieldlabel.anyo.concesion'),
												name: 'anyoConcesion',
												bind: '{propietario.anyoConcesion}'
											},
											{
												readOnly: true,
												fieldLabel: HreRem.i18n('fiedlabel.fecha.fin.concesion'),
												name: 'fechaFinConcesion',
												bind: '{propietario.fechaFinConcesion}'
                                                
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
											   readOnly: me.isPrincipal(),
											   bind:{ 
												   	value: '{propietario.tipoPersonaCodigo}',
												   	store: '{comboTiposPersona}'
												   		} 
	    		    						},
											
											{
												fieldLabel: HreRem.i18n('header.nombre.razon.social'),
												name: 'nombre',
												readOnly: me.isPrincipal(),
												allowBlank: false,
			    					        	bind: {
			    					        		value: '{propietario.nombreCompleto}'
			    					        	}
											},
											{
		    					        		xtype: 'comboboxfieldbase',
		    					        	   fieldLabel: HreRem.i18n('fieldlabel.tipo.documento'),
		    					        	   name: 'tipoDoc',
											   displayField: 'descripcion',
											   valueField: 'codigo',
												readOnly: me.isPrincipal(),
											   bind:{ 
												   	value: '{propietario.tipoDocIdentificativoCodigo}',
												   	store: '{comboTipoDocumento}'
												   		} 
	    		    						},
											{
												fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
												name: 'numDoc',
												readOnly: me.isPrincipal(),
			    					        	bind: {
			    					        		value: '{propietario.docIdentificativo}'			    					        		
			    					        	}
			    					        },
			    					        {
			    					        	fieldLabel: HreRem.i18n('fieldlabel.direccion'),
			    					        	name: 'direccion',
			    					        	readOnly: me.isPrincipal(),
			    					        	bind: {
			    					        		value: '{propietario.direccion}'			    					        		
			    					        	}
			    					        },
			    					        
			    					        {
												   xtype: 'comboboxfieldbase',
												   fieldLabel: HreRem.i18n('fieldlabel.provincia'),
												   reference: 'provincia',
												   name: 'provincia',
												   displayField: 'descripcion',
												   valueField: 'codigo',
												   readOnly: me.isPrincipal(),
												   chainedStore: 'comboPoblacionContacto',
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
												   readOnly: me.isPrincipal(),
												   bind:{ 
													   	value: '{propietario.localidadCodigo}',
													   	store: '{comboPoblacion}'													   	
													   		} 
											},
			    					       
											
			    					        {
			    					        	fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
			    					        	name: 'codigoPostal',
			    					        	readOnly: me.isPrincipal(),
			    					        	bind: {
			    					        		value: '{propietario.codigoPostal}'			    					        		
			    					        	}
			    					        },
			    					        {
			    					        	fieldLabel: HreRem.i18n('fieldlabel.telefono'),
			    					        	name: 'telefono',
			    					        	readOnly: me.isPrincipal(),
			    					        	bind: {
			    					        		value: '{propietario.telefono}'			    					        		
			    					        	}
			    					        },
			    					        {
			    					        	vtype: 'email',
			    					        	fieldLabel: HreRem.i18n('fieldlabel.email'),
			    					        	name: 'email',
			    					        	readOnly: me.isPrincipal(),
			    					        	bind: {
			    					        		value: '{propietario.email}'			    					        		
			    					        	}
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
												readOnly: me.isPrincipal(),
												name: 'nombreContacto',
												bind: {
			    					        		value: '{propietario.nombreContacto}'			    					        		
			    					        	}
											},
											{
												fieldLabel: 'Tel&eacute;fono 1',
												readOnly: me.isPrincipal(),
												name: 'telefonoContacto1',
												bind: {
			    					        		value: '{propietario.telefono1Contacto}'			    					        		
			    					        	}
											},
											{
												fieldLabel: 'Tel&eacute;fono 2',
												readOnly: me.isPrincipal(),
												name: 'telefonoContacto2',
												bind: {
			    					        		value: '{propietario.telefono2Contacto}'			    					        		
			    					        	}
											},	
											{
									        	vtype: 'email',
									        	fieldLabel: HreRem.i18n('fieldlabel.email'),
									        	readOnly: me.isPrincipal(),
									        	name: 'emailContacto',
									        	bind: {
			    					        		value: '{propietario.emailContacto}'			    					        		
			    					        	}
									        },
											 {
									        	fieldLabel: HreRem.i18n('fieldlabel.direccion'),
									        	readOnly: me.isPrincipal(),
									        	name: 'direccionContacto',
									        	bind: {
			    					        		value: '{propietario.direccionContacto}'			    					        		
			    					        	}
									        },	
											{
												   xtype: 'comboboxfieldbase',
												   fieldLabel: HreRem.i18n('fieldlabel.provincia'),
												   readOnly: me.isPrincipal(),
												   reference: 'provinciaContacto',
												   name: 'provinciaContacto',
												   displayField: 'descripcion',
												   valueField: 'codigo',
												   chainedStore: 'comboPoblacionContacto',
												   chainedReference: 'localidadContacto',
												   listeners: {
														select: 'onChangeChainedCombo'
						    						},
												   bind:{ 
													   	value: '{propietario.provinciaContactoCodigo}',
													   	store: '{comboProvinciasContacto}'													   	
													   		} 
											},
											
									        {
												   xtype: 'comboboxfieldbase',
									        	   fieldLabel: HreRem.i18n('fieldlabel.poblacion'),
									        	   readOnly: me.isPrincipal(),
									        	   reference: 'localidadContacto',
									        	   name: 'localidadContacto',
												   displayField: 'descripcion',
												   valueField: 'codigo',
												   bind:{ 
													   	value: '{propietario.localidadContactoCodigo}',
													   	store: '{comboPoblacionContacto}'													   	
													   		} 
											},
											{
									        	fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
									        	readOnly: me.isPrincipal(),
									        	name: 'codigoPostalContacto',
									        	bind: {
			    					        		value: '{propietario.codigoPostalContacto}'			    					        		
			    					        	}
									        }	
										]
							        },
							        
							        {
						                	xtype: 'textareafieldbase',
						                	rowspan: 6,
						                	name: 'observacionesContacto',
						                	readOnly: me.isPrincipal(),
						                	fieldLabel: HreRem.i18n('fieldlabel.observaciones'),
						                	bind: {
		    					        		value: '{propietario.observaciones}'			    					        		
		    					        	}
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
    