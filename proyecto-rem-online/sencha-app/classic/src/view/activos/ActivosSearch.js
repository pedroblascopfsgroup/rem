Ext.define('HreRem.view.activos.ActivosSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'activossearch',
    isSearchForm : true,
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
			        defaultType: 'textfieldbase',
			        style: 'width: 25%'
			    },
			    items: [   
			    	{
			    	defaults: {
			    		addUxReadOnlyEditFieldPlugin: false
			    	},
			    	items:[
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
			    	{
			    	defaults: {
			    		addUxReadOnlyEditFieldPlugin: false
			    	},
			    	items:[
					        { 
					        	fieldLabel: HreRem.i18n('fieldlabel.poblacion'),
					        	name: 'localidadDescripcion'

					        },
					        { 
					        	xtype: 'comboboxfieldbase',
						    	addUxReadOnlyEditFieldPlugin: false,
					        	fieldLabel: HreRem.i18n('fieldlabel.provincia'),
					        	name: 'provinciaCodigo',
					        	bind: {
				            		store: '{comboFiltroProvincias}'
				            	}
					        }
					    ]},
				    {
				   	defaults: {
			    		addUxReadOnlyEditFieldPlugin: false
			    	},
				    items:[
				        {
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.origen'),
				        	name: 'tipoTituloActivoCodigo',
							//store: { type: 'diccionario', tipo: 'tiposTitulo'},
				        	bind: {
				            	store: '{comboTipoTitulo}'
				            },
    						matchFieldWidth: false
				        },
				        { 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.subtipo.activo'),
				        	name: 'subtipoActivoCodigo',
				        	bind: {
			            		store: '{comboFiltroSubtipoActivo}'
			            	},
				        	matchFieldWidth: false

				        }
				        
				    ]},
				    {	
				    defaults: {
			    		addUxReadOnlyEditFieldPlugin: false
			    	},
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
							defaultType: 'textfieldbase',
		    				defaults: {
					    		addUxReadOnlyEditFieldPlugin: false
					    	},							
							items :
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
							        	xtype: 'comboboxfieldbase',
							        	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
							        	labelWidth:	150,
							        	name: 'estadoActivoCodigo',
							        	bind: {
						            		store: '{comboEstadoActivo}'
						            	}			
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
							defaultType: 'textfieldbase',
							defaults: {
			    				addUxReadOnlyEditFieldPlugin: false
			    			},
							items :
								[
									{ 
							        	xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.tipo.via'),
						            	name:	'tipoViaCodigo',
							        	bind: {
						            		store: '{comboTipoVia}'
						            	}
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
							        	xtype: 'comboboxfieldbase',
							        	fieldLabel: HreRem.i18n('fieldlabel.provincia'),
							        	name: 'provinciaAvanzada',
							        	bind: {
						            		store: '{comboFiltroProvincias}'
						            	}
							        },
									{
										fieldLabel: HreRem.i18n('fieldlabel.municipio'),
						            	name:		'municipio'
									}, 
									{ 
							        	xtype: 'comboboxfieldbase',						    			
										fieldLabel: HreRem.i18n('fieldlabel.pais'),
							        	name: 'paisCodigo',
							        	bind: {
						            		store: '{comboPais}'
						            	}
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
							defaultType: 'textfieldbase',
							defaults: {
			    				addUxReadOnlyEditFieldPlugin: false
			    			},
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
							defaults: {
			    				addUxReadOnlyEditFieldPlugin: false
			    			},
							items :
								[
									{ 
							        	xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.ocupado'),
						            	name:	'ocupado',
							        	bind: {
						            		store: '{comboSiNoRem}'
						            	}
							        },
							        { 
							        	xtype: 'comboboxfieldbase',
							        	editable: false,
										fieldLabel: HreRem.i18n('fieldlabel.con.titulo'),
						            	name:		'conTitulo',
							        	bind: {
						            		store: '{comboSiNoRem}'
						            	}
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