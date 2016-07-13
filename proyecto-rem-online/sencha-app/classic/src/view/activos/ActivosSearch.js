Ext.define('HreRem.view.activos.ActivosSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'activossearch',
    isSearchFormActivos : true,
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
    layout: {
        type: 'accordion',
        titleCollapse: false,
        animate: true,
        vertical: true
        //multi: true
    },
    
    initComponent: function() {
    	
    	var me = this;   	
    	me.setTitle(HreRem.i18n('title.filtro.activos'));
    	me.items = [
    
    		{
    			xtype: 'panel',
    			layout: 'column',
    			cls: 'panel-busqueda-directa',
    			title: HreRem.i18n('title.busqueda.directa'),
    			collapsible: true,
    			collapsed: false,
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield',
			        style: 'width: 25%'
			    },
			    items: [   
			    	{items:[
				        { 
				        	fieldLabel: HreRem.i18n('fieldlabel.numero.activo.haya'),
				        	name: 'numActivo'
				        },
				        { 
							xtype: 'comboboxfieldbase',
						    addUxReadOnlyEditFieldPlugin: false,
				        	fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
				        	name: 'entidadPropietariaCodigo',
				        	bind: {
			            		store: '{comboEntidadPropietaria}'
			            	}
				        }
				    ]},
			    	{items:[
					        { 
					        	fieldLabel: HreRem.i18n('fieldlabel.poblacion'),
					        	name: 'localidadDescripcion'

					        },
					        { 
					        	xtype: 'combo',
					        	fieldLabel: HreRem.i18n('fieldlabel.provincia'),
					        	name: 'provinciaCodigo',
					        	bind: {
				            		store: '{comboFiltroProvincias}'
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo'
					        }
					    ]},
				    {items:[
				        {
				        	xtype: 'combo',
				        	fieldLabel: HreRem.i18n('fieldlabel.origen'),
				        	name: 'tipoTituloActivoCodigo',
							//store: { type: 'diccionario', tipo: 'tiposTitulo'},
				        	bind: {
				            	store: '{comboTipoTitulo}'
				            },
			            	displayField: 'descripcion',
    						valueField: 'codigo',
    						matchFieldWidth: false
				        },
				        { 
				        	xtype: 'combo',
				        	fieldLabel: HreRem.i18n('fieldlabel.subtipo.activo'),
				        	name: 'subtipoActivoCodigo',
				        	bind: {
			            		store: '{comboFiltroSubtipoActivo}'
			            	},
			            	displayField: 'descripcion',
    						valueField: 'codigo',
				        	matchFieldWidth: false

				        }
				        
				    ]},
				    {	
				    items:[
				        { 
				        	fieldLabel: HreRem.i18n('fieldlabel.finca.registral'),
				        	name: 'finca'
				        },
				        { 
				        	fieldLabel: HreRem.i18n('fieldlabel.referencia.catastral'),
				        	name: 'refCatastral'
				        }
				    ]}
			    ]
    		},
    		{
    			xtype: 'panel',
    			collapsed: true,
    			layout: 'column',
    			reference: 'busquedaAvanzadaActivos',
    			title: HreRem.i18n('title.busqueda.avanzada'),
    			cls: 'panel-busqueda-avanzada',
    			items: [
    				{
    				columnWidth: 1,
    				items:[    			

						{    			                
							xtype:'fieldsettable',
							cls	 :  'fieldsetCabecera',
							title: HreRem.i18n('title.identificacion'),
							collapsible: true,
							defaultType: 'textfield',
							/*defaults: {
								anchor: '100%', style: 'width: 25%'},
							layout: 'column',
							*/items :
								 [
									 { 
							        	fieldLabel: HreRem.i18n('fieldlabel.numero.activo'),
										labelWidth:	150,
							        	name: 'numActivoRem'
							         },
									 {
										fieldLabel: HreRem.i18n('fieldlabel.id.activo.prinex'),
										labelWidth:	150,
						            	name:		'idProp'
									 },
									 {
										fieldLabel: HreRem.i18n('fieldlabel.id.activo.uvem'),
						                name:		'idUvem'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.id.activo.recovery'),
										labelWidth:	150,
						                name:		'idRecovery'
									},
									{
							        	xtype: 'combo',
							        	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
							        	labelWidth:	150,
							        	name: 'estadoActivoCodigo',
							        	bind: {
						            		store: '{comboEstadoActivo}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo'				
							        }	

								]
			                
			            	}
		            	]
		            },
		            
		            {
    					columnWidth: 1,
    					items:[    			

						{    			                
							xtype:'fieldsettable',
							cls	 :  'fieldsetCabecera',
							title: HreRem.i18n('title.direccion'),
							collapsible: true,
							collapsed: true,
							defaultType: 'textfield',
							items :
								[
									{ 
							        	xtype: 'combo',
										fieldLabel: HreRem.i18n('fieldlabel.tipo.via'),
						            	name:	'tipoViaCodigo',
							        	bind: {
						            		store: '{comboTipoVia}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo'
							        },
									{
										fieldLabel: HreRem.i18n('fieldlabel.nombre.via'),
						                name:		'nombreVia'
						                
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
						                name:		'codPostal'
									},
									{ 
							        	xtype: 'combo',
							        	fieldLabel: HreRem.i18n('fieldlabel.provincia'),
							        	name: 'provinciaAvanzada',
							        	bind: {
						            		store: '{comboFiltroProvincias}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo'
							        },
									{
										fieldLabel: HreRem.i18n('fieldlabel.municipio'),
						            	name:		'municipio'
									}, 
									{ 
							        	xtype: 'combo',
										fieldLabel: HreRem.i18n('fieldlabel.pais'),
							        	name: 'paisCodigo',
							        	bind: {
						            		store: '{comboPais}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo'
							        }

								]
			                
			            }
		            	]
		            },
    				
    				{
    				columnWidth: 1,
    				items:[    			

						{    
							xtype:'fieldsettable',
							cls	 :  'fieldsetCabecera',
							title: HreRem.i18n('title.informacion.registral'),
							collapsible: true,
							collapsed: true,
							defaultType: 'textfield',
							items :
								[
								{
									fieldLabel: HreRem.i18n('fieldlabel.poblacion.registro'),
									labelWidth:	150,
					            	name:		'localidadRegistroDescripcion'
								 },
								{
									fieldLabel: HreRem.i18n('fieldlabel.numero.registro'),
					            	name:		'numRegistro'
								 }, {
									fieldLabel: HreRem.i18n('fieldlabel.finca.registral'),
					                name:		'fincaAvanzada'
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.idufir'),
					                name:		'idufir'
								}
							]

			            }
		            ]},
		            {
    				columnWidth: 1,
    				items:[    			

						{    
							xtype:'fieldsettable',
							cls	 :  'fieldsetCabecera',
							title: HreRem.i18n('title.situacion.posesoria'),
							collapsible: true,
							collapsed: true,
							defaultType: 'textfield',
							items :
								[
									{ 
							        	xtype: 'combo',
							        	editable: false,
										fieldLabel: HreRem.i18n('fieldlabel.ocupado'),
							        	labelWidth:	150,
							        	width: 		230,
						            	name:	'ocupado',
							        	bind: {
						            		store: '{comboSiNoRem}'
						            	},
						            	displayField: 'descripcion',
										valueField: 'codigo'
							        },
							        { 
							        	xtype: 'combo',
							        	editable: false,
										fieldLabel: HreRem.i18n('fieldlabel.con.titulo'),
							        	labelWidth:	150,
							        	width: 		230,
						            	name:		'conTitulo',
							        	bind: {
						            		store: '{comboSiNoRem}'
						            	},
						            	displayField: 'descripcion',
										valueField: 'codigo'
							        }
								
								]
			                
			            }
		            ]}
		            
    			]
    		}
	    ],
		
		me.callParent();
		
	}
});