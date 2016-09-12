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
													name:		'idProveedor',
													colspan: 2
												},
												{ 
													xtype: 'combo',
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.estado'),
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
													bind: {
														store: '{comboTipoProveedor}',
														value: '{proveedor.tipoProveedorCodigo}'			            		
													},
									            	displayField: 'descripcion',
													valueField: 'codigo'
												},
												{ 
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.nombrecomercial'),
													name:		'nombreComercial'
												},
												{ 
													xtype: 'datefield',
													fieldLabel: HreRem.i18n('fieldlabel.proveedores.fechadesde'),
													name:		'fechaDesde'
												},
												// fila 2
												{							
													xtype: 'combo',
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.subtipo'),
													bind: {
														store: '{comboSubtipoProveedor}',
														value: '{proveedor.subtipoProveedorCodigo}'			            		
													},
									            	displayField: 'descripcion',
													valueField: 'codigo',
													colspan: 2
												},
												{ 
													xtype: 'datefield',
													fieldLabel:  HreRem.i18n('fieldlabel.proveedores.fechahasta'),
													name:		'fechaHasta'
												},
												// fila 3
												{
													xtype: 'combo',
													fieldLabel: HreRem.i18n('fieldlabel.proveedores.tipopersona'),
													bind: {
														store: '{comboTipoPersona}',
														value: '{proveedor.tipoPersonaCodigo}'			            		
													},
									            	displayField: 'descripcion',
													valueField: 'codigo'
												},
												{
													xtype: 'combo',
													fieldLabel: HreRem.i18n('fieldlabel.proveedores.cartera'),
													bind: {
														store: '{comboCartera}',
														value: '{proveedor.carteraCodigo}'			            		
													},
									            	displayField: 'descripcion',
													valueField: 'codigo'
												},
												{
													xtype: 'combo',
													fieldLabel: HreRem.i18n('fieldlabel.proveedores.propietario'),
													bind: {
														store: '{comboPropietario}',
														value: '{proveedor.propietarioCodigo}'			            		
													},
									            	displayField: 'descripcion',
													valueField: 'codigo'
												},
												// Fila 4
												{ 
													xtype: 'combo',
													fieldLabel: HreRem.i18n('fieldlabel.proveedores.ambito'),
													bind: {
														store: '{comboAmbito}',
														value: '{proveedor.ambitoCodigo}'			            		
													},
									            	displayField: 'descripcion',
													valueField: 'codigo'
												},
												{ 
													xtype: 'combo',
													fieldLabel: HreRem.i18n('fieldlabel.proveedores.subcartera'),
													bind: {
														store: '{comboSubcartera}',
														value: '{proveedor.subcarteraCodigo}'			            		
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
									                	bind:		'{proveedor.cp}'
												 	}
											]
							                
							            },
							            {    			                
											xtype:'fieldsettable',
											defaultType: 'textfield',
											title:HreRem.i18n('title.configuracion.proveedores.persona'),
											colspan: 3,
											items :	[
											       	 // fila 0
													{ 
														fieldLabel:  HreRem.i18n('fieldlabel.proveedores.nif'),
									                	name:		'nif'
											        },
													{ 
														xtype: 'combo',
											        	fieldLabel:  HreRem.i18n('fieldlabel.proveedores.nombre'),
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
											items :	[
											       	 // fila 0
													{ 
														xtype: 'combo',
											        	fieldLabel:  HreRem.i18n('fieldlabel.proveedores.homologado'),
											        	bind: {
										            		store: '{comboSiNoNSRem}'
										            	},
										            	displayField: 'descripcion',
														valueField: 'codigo'
											        },
													{ 
														xtype: 'combo',
											        	fieldLabel:  HreRem.i18n('fieldlabel.proveedores.calificacion'),
											        	bind: {
										            		store: '{comboCalificacion}'
										            	},
										            	displayField: 'descripcion',
														valueField: 'codigo'
											        },			       
													{ 
														xtype: 'combo',
											        	fieldLabel:  HreRem.i18n('fieldlabel.proveedores.top'),
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