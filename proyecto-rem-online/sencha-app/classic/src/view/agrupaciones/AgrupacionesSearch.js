Ext.define('HreRem.view.agrupaciones.AgrupacionesSearch', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'agrupacionessearch',
    isSearchForm: true,
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
        
   /* defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'textfield'
        //,style: 'width: 50%'
    },
    */
   
	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('title.filtro.agrupaciones'));
	    me.items= [
	    
	   		 {
    			xtype: 'panel',
    			minHeight: 100,
    			layout: 'column',
    			cls: 'panel-busqueda-directa',
    			//title: HreRem.i18n('title.busqueda.directa'),
    			collapsible: false,
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield',
			        style: 'width: 25%'
			    },
	    		
			        items: [
			        
			        /*
			         * {
			    			items:[
						        { 
						        	fieldLabel: HreRem.i18n('fieldlabel.id.activo.haya'),
						        	name: 'numActivo'
		
						        },
						        { 
						        	fieldLabel: HreRem.i18n('fieldlabel.propietario'),
						        	name: 'propietario'
						        }
							]
						},
			         */
			        	{
			        			items: [
			        				{ 
						            	fieldLabel: HreRem.i18n('fieldlabel.numero.agrupacion'),
						            	name: 'numAgrupacionRem'
						            },
						       		{ 
							        	xtype: 'combo',
							        	fieldLabel: HreRem.i18n('fieldlabel.tipo'),
							        	reference: 'prueba',
							        	name: 'tipoAgrupacion',
							        	bind: {
						            		store: '{comboTipoAgrupacion}'
						            	},
						            	displayField: 'descripcion',
						            	valueField: 'codigo',
						            	listeners: {
											select: 'onChangeTipoAgrupacion'
										}
							        },
							        { 
							        	xtype: 'combo',
							        	fieldLabel: HreRem.i18n('fieldlabel.tipo.alquiler'),
							        	name: 'tipoAlquiler',
							        	hidden: true,
							        	bind: {
						            		store: '{comboTipoAlquilerAgrupaciones}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
			    						reference: 'comboTipoAlquiler'
							        },
							        { 
										xtype: 'combo',
							        	fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
							        	name: 'codCartera',
							        	displayField: 'descripcion',
			    						valueField: 'codigo',
							        	bind: {
						            		store: '{comboEntidadPropietaria}'
						            	},
						            	reference: 'comboCarteraActivoSearch',
						            	chainedStore: 'comboSubcarteraFiltered',
										chainedReference: 'comboSubcarteraActivoSearch',
										listeners: {
											select: 'onChangeChainedCombo'
										}
							        },
							        { 
										xtype: 'combo',
							        	fieldLabel: HreRem.i18n('fieldlabel.subcartera'),
							        	name: 'subcarteraCodigo',
							        	bind: {
						            		store: '{comboSubcarteraFiltered}'
						            	},
						            	reference: 'comboSubcarteraActivoSearch',
						            	valueField: 'codigo',
			    						displayField: 'descripcion'
							        },
							        {
							        	fieldLabel: HreRem.i18n('fieldlabel.numero.agrupacion.uvem'),
							        	name: 'numAgrUVEM'
							        }
							        
			        			]
			        	},
			        	{
			        		items: [
			        	
						        { 
					            	fieldLabel: HreRem.i18n('fieldlabel.nombre'),
					            	name: 'nombre',
					            	labelWidth:	150,
						        	width: 		230
					            },
					            { 
						        	xtype: 'combo',
						        	//hidden: true,
						        	editable: false,
						        	disabled: true,
						        	fieldLabel:  HreRem.i18n('fieldlabel.publicada.web'),
						        	labelWidth:	150,
						        	width: 		230,
						        	name: 'publicado',
						        	bind: {
					            		store: '{comboSiNoRem}'
					            	},
					            	displayField: 'descripcion',
									valueField: 'codigo'
						        },
						        {
						        	fieldLabel: HreRem.i18n('fieldlabel.nif.propietario'),
						        	name: 'nif'
						        },
						        {
						        	xtype: 'combo',
						        	fieldLabel: HreRem.i18n('fieldlabel.provincia'),
						        	name: 'codProvincia',
						        	bind: {
						        		store: '{comboFiltroProvincias}'
						        	},
						        	displayField: 'descripcion',
						        	valueField: 'codigo'
						        	
						        },
						        {
						        	fieldLabel: HreRem.i18n('fieldlabel.municipio'),
						        	name: 'localidadDescripcion',
						        	valueField: 'descripcion'
						        }
						     ]
						},
							{
			        			items: [
			        				{
							        	fieldLabel: HreRem.i18n('fieldlabel.id.activo.haya'),
							        	name: 'numActHaya'
							        },
							        {
							        	fieldLabel: HreRem.i18n('fieldlabel.id.activo.prinex'),
							        	name: 'numActPrinex'
							        },
							        {
							        	fieldLabel: HreRem.i18n('fieldlabel.id.activo.sareb'),
							        	name: 'numActSareb'
							        },
							        {
							        	fieldLabel: HreRem.i18n('fieldlabel.id.activo.uvem'),
							        	name: 'numActUVEM'
							        },
							        {
										fieldLabel: HreRem.i18n('fieldlabel.id.activo.recovery'),
							        	name: 'numActReco'
									}
								]
							},
							{
								items: [
									 { 
						                	xtype:'datefield',
									 		fieldLabel: HreRem.i18n('fieldlabel.fecha.creacion.desde'),
									 		width: 		275,
									 		name: 		'fechaCreacionDesde',
							            	bind:		'{fechaCreacionDesde}',
							            	formatter: 'date("d/m/Y")',
							            	listeners : {
								            	change: function () {
								            		//Eliminar la fechaHasta e instaurar
								            		//como minValue a su campo el velor de fechaDesde
								            		var me = this;
								            		me.next().reset();
								            		me.next().setMinValue(me.getValue());
								                }
							            	}
										},
										{ 
						                	xtype:'datefield',
									 		fieldLabel: HreRem.i18n('fieldlabel.fecha.creacion.hasta'),
									 		width: 		275,
									 		name: 'fechaCreacionHasta',
							            	bind:		'{fechaCreacionHasta}'
										},
										{
											xtype:'datefield',
									 		fieldLabel: HreRem.i18n('header.fecha.inicio.vigencia.desde'),
									 		width: 		275,
									 		name: 'fechaInicioVigenciaDesde',
							            	bind:		'{fechaInicioVigenciaDesde}',
							            	listeners: {
							            		change: function () {
							            			var me = this;
							            			me.next().reset();
							            			me.next().setMinValue(me.getValue());
							            		}
							            	}
										},
										{
											xtype:'datefield',
									 		fieldLabel: HreRem.i18n('header.fecha.inicio.vigencia.hasta'),
									 		width: 		275,
									 		name: 'fechaInicioVigenciaHasta',
							            	bind:		'{fechaInicioVigenciaHasta}'
										},
										{
											xtype:'datefield',
									 		fieldLabel: HreRem.i18n('header.fecha.fin.vigencia.desde'),
									 		width: 		275,
									 		name: 'fechaFinVigenciaDesde',
							            	bind:		'{fechaFinVigenciaDesde}',
							            	listeners: {
							            		change: function () {
							            			var me = this;
							            			me.next().reset();
							            			me.next().setMinValue(me.getValue());
							            		}
							            	}
										},
										{
											xtype:'datefield',
									 		fieldLabel: HreRem.i18n('header.fecha.fin.vigencia.hasta'),
									 		width: 		275,
									 		name: 'fechaFinVigenciaHasta',
							            	bind:		'{fechaFinVigenciaHasta}'
										}
								]
							}
			        ]
	            }
	    ];
	   	
	    me.callParent();
	}
});