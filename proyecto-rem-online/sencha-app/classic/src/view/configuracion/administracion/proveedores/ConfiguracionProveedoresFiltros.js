Ext.define('HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedoresFiltros', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'configuracionproveedoresfiltros',
    reference: 'configuracionProveedoresFiltros',
    isSearchProveedoresForm: true,
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,    
    layout: {
        type: 'accordion',
        titleCollapse: false,
        animate: true,
        vertical: true,
        multi: true
    },    

	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('title.configuracion.proveedores.filtro'));
	    me.items= [
	         {
    			xtype: 'panel',
    			collapsible: false,
    			layout: 'column',
    			title: HreRem.i18n('title.configuracion.proveedores.filtro'),
    			cls: 'panel-busqueda-avanzada',
    			defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield'
			    },
				items: [
							{
								columnWidth: 1,
								items:[    			

										{    			                
											xtype:'fieldsettable',
											defaultType: 'textfield',
											title:HreRem.i18n('title.configuracion.proveedores.datosgenerales'),
											colspan: 3,
								    		defaults: {							        
												addUxReadOnlyEditFieldPlugin: false						    
											},
											items :	[
												{ 
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.codigo'),
													name: 'codigo'
												},
												{ 
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.nombre'),
													name: 'nombre'
												},
												{ 
													xtype: 'combo',
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.estado'),
													name: 'estadoProveedorCodigo',
													bind: {
														store: '{comboEstadoProveedor}'
													},
									            	displayField: 'descripcion',
													valueField: 'codigo'
												},
												// fila 1
												{							
													xtype: 'combo',
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.tipo'),
													name: 'tipoProveedorCodigo',
													reference: 'cbTipoProveedorFilter',
													chainedStore: 'comboSubtipoProveedor',
													chainedReference: 'cbSubtipoProveedorFilter',
													bind: {
														store: '{comboTipoProveedor}',
														value: '{proveedor.tipoProveedorCodigo}'
													},
									            	displayField: 'descripcion',
													valueField: 'codigo',
													listeners: {
										                select: 'onChangeChainedCombo'
										            }
												},
												{ 
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.nombrecomercial'),
													name:		'nombreComercialProveedor'
												},
												{ 
													xtype: 'datefield',
													fieldLabel: HreRem.i18n('fieldlabel.proveedores.fechadesde'),
													name:		'fechaAlta'
												},
												// fila 2
												{							
													xtype: 'combo',
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.subtipo'),
													name: 'subtipoProveedorCodigo',
													reference: 'cbSubtipoProveedorFilter',
													bind: {
														store: '{comboSubtipoProveedor}',
														disabled: '{!proveedor.tipoProveedorCodigo}'
													},
									            	displayField: 'descripcion',
													valueField: 'codigo'
												},
												{
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.nif'),
													name: 'nifProveedor'
												},
												{ 
													xtype: 'datefield',
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.fechahasta'),
													name:		'fechaBaja'
												},
												// fila 3
												{
													xtype: 'combo',
													fieldLabel: HreRem.i18n('fieldlabel.proveedores.tipopersona'),
													name: 'tipoPersonaCodigo',
													bind: {
														store: '{comboTipoPersona}'			            		
													},
									            	displayField: 'descripcion',
													valueField: 'codigo'
												},
												{
													xtype: 'combo',
													fieldLabel: HreRem.i18n('fieldlabel.proveedores.cartera'),
													name: 'cartera',
													bind: {
														store: '{comboCartera}'		            		
													},
									            	displayField: 'descripcion',
													valueField: 'codigo'
												},
												{
													fieldLabel: HreRem.i18n('fieldlabel.proveedores.propietario'),
													name: 'propietario'
												},
												{
													xtype: 'combo',
													fieldLabel: HreRem.i18n('fieldlabel.proveedor.especialidad'),
													name: 'especialidadCodigo',
													bind: {
														store: '{comboEspecialidad}'		            		
													},
									            	displayField: 'descripcion',
													valueField: 'codigo',
													multiSelect: true
												},
												{
													xtype: 'combo',
													fieldLabel: HreRem.i18n('fieldlabel.proveedor.linea.negocio'),
													name: 'lineaNegocioCodigo',
													bind: {
														store: '{comboLineaDeNegocio}'		            		
													},
									            	displayField: 'descripcion',
													valueField: 'codigo'
												}
												
												
											]
							                
							            },
							            {    			                
											xtype:'fieldsettable',
											defaultType: 'textfield',
											title:HreRem.i18n('title.configuracion.proveedores.direccion'),
											colspan: 3,
											collapsed: true,
											items :	[
											       	 // fila 0
												 	{ 
											        	xtype: 'comboboxfieldbasedd',
											        	name: 'provinciaCodigo',
											        	reference: 'provinciaCombo',
												    	addUxReadOnlyEditFieldPlugin: false,
											        	fieldLabel: HreRem.i18n('fieldlabel.provincia'),
											        	bind: {
										            		store: '{comboFiltroProvincias}'
										            	},
										            	listeners: {
										                    'select': function(combo, records, opts) {
										                    	var chainedCombo = me.up('configuracionmain').lookupReference('municipioCombo');
										                    	var store = chainedCombo.getStore();
										                    	chainedCombo.setDisabled(false);
										                    	chainedCombo.clearValue();
										                    	store.clearFilter();
										                    	store.filter([{
										                            filterFn: function(rec){
										                                if (rec.getData().codigoProvincia == records.getData().codigo){
										                                    return true;
										                                }
										                                return false;
										                            }
										                        }]);
										                    }
										                }
											        },
											        { 
											        	xtype: 'comboboxfieldbasedd',
											        	name: 'municipioCodigo',
											        	reference: 'municipioCombo',
												    	addUxReadOnlyEditFieldPlugin: false,
											        	fieldLabel: HreRem.i18n('fieldlabel.proveedores.municipio'),
											        	disabled: true,
											        	bind: {
											        		store: '{comboFiltroMunicipios}'
										            	}
											        },
												 	{
														fieldLabel: HreRem.i18n('fieldlabel.proveedores.cp'),
														name: 'codigoPostal',
									                	bind: '{proveedor.cp}'
												 	}
											]
							                
							            },
							            {    			                
											xtype:'fieldsettable',
											defaultType: 'textfield',
											title:HreRem.i18n('title.configuracion.proveedores.persona'),
											colspan: 3,
											collapsed: true,
											items :	[
											       	 // fila 0
													{ 
														fieldLabel:  HreRem.i18n('fieldlabel.proveedores.nif'),
									                	name:		'nifPersonaContacto'
											        },
													{ 
											        	fieldLabel:  HreRem.i18n('fieldlabel.proveedores.nombre'),
											        	name: 'nombrePersonaContacto',
														colspan: 2
											        }
											]
							                
							            },
							            {    			                
											xtype:'fieldsettable',
											defaultType: 'textfield',
											title:HreRem.i18n('title.configuracion.proveedores.mediadores'),
											colspan: 3,
											collapsed: true,
											items :	[
											       	 // fila 0
													{ 
														xtype: 'combo',
											        	fieldLabel:  HreRem.i18n('fieldlabel.proveedores.homologado'),
											        	name: 'homologadoCodigo',
											        	bind: {
										            		store: '{comboSiNoNSRem}'
										            	},
										            	displayField: 'descripcion',
														valueField: 'codigo'
											        },
													{ 
														xtype: 'combo',
											        	fieldLabel:  HreRem.i18n('fieldlabel.proveedores.calificacion'),
											        	name: 'calificacionCodigo',
											        	bind: {
										            		store: '{comboCalificacionProveedor}'
										            	},
										            	displayField: 'descripcion',
														valueField: 'codigo'
											        },			       
													{ 
														xtype: 'combo',
											        	fieldLabel:  HreRem.i18n('fieldlabel.proveedores.top'),
											        	name: 'topCodigo',
											        	bind: {
										            		store: '{comboSiNoNSRem}'
										            	},
										            	displayField: 'descripcion',
														valueField: 'codigo'	
											        }
											]
							                
							            }
							            
	            				]
	            			
	            			}
				]
    		}
	    ];
	   	
	    me.callParent();
	}
});