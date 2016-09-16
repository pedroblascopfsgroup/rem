Ext.define('HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedoresFiltros', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'configuracionproveedoresfiltros',
    reference: 'configuracionProveedoresFiltros',
    isSearchForm: true,
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
											items :	[
												{ 
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.id'),
													name: 'id',
													colspan: 2
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
													valueField: 'codigo',
													colspan: 2
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
													disabled: true,
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
													xtype: 'combo',
													fieldLabel: HreRem.i18n('fieldlabel.proveedores.propietario'),
													name: 'propietario',
													disabled: true,
													bind: {
														store: '{comboPropietario}'			            		
													},
									            	displayField: 'descripcion',
													valueField: 'codigo'
												},
												// Fila 4
												{ 
													xtype: 'combo',
													fieldLabel: HreRem.i18n('fieldlabel.proveedores.subcartera'),
													disabled: true,
													name: 'subcartera',
													bind: {
														store: '{comboSubcartera}'			            		
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
												 		xtype: 'combo',
												 		name: 'provinciaCodigo',
												 		reference: 'provinciaCombo',
												 		fieldLabel:	HreRem.i18n('fieldlabel.proveedores.provincia'),
											        	bind: {
										            		store: '{comboProvincia}'
										            	},
										            	displayField: 'descripcion',
														valueField: 'codigo',
														published: 'value'
												 	},
												 	{
												 		xtype: 'combo',
												 		name: 'municipioCodigo',
												 		reference: 'municipioCombo',
												 		fieldLabel:	HreRem.i18n('fieldlabel.proveedores.municipio'),
												 		queryMode: 'remote',
												 		forceSelection: true,
											        	bind: {
										            		store: '{comboMunicipio}',
										            		disabled: '{!provinciaCombo.value}',
										            		filters: {
										            			property: 'codigo',
										            			value: '{provinciaCombo.value}'
										            		}
										            	},
										            	displayField: 'descripcion',
														valueField: 'codigo'
												 	},
												 	{
														fieldLabel:  HreRem.i18n('fieldlabel.proveedores.cp'),
														name: 'codigoPostal',
									                	bind:		'{proveedor.cp}'
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
									                	name:		'nifProveedor'
											        },
													{ 
														xtype: 'combo',
											        	fieldLabel:  HreRem.i18n('fieldlabel.proveedores.nombre'),
											        	disabled: true,
											        	name: 'nombrePersContacto',
											        	bind: {
										            		store: '{comboContacto}'
										            	},
														colspan: 2,
										            	displayField: 'descripcion',
														valueField: 'codigo'
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