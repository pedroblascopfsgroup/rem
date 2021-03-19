Ext.define('HreRem.view.publicacion.activos.ActivosPublicacionSearch', {
	extend		: 'HreRem.view.common.FormBase',
    xtype		: 'activospublicacionsearch',
    isSearchFormPublicacion: true,
    cls			: 'panel-base shadow-panel',
	recordName	: "publicacionesSearch",

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.publicaciones.activos.search'));

        me.items = [  
			{
				xtype: 'panel',
				minHeight: 100,
				layout: 'column',
				cls: 'panel-busqueda-directa',
				collapsible: false,
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield'
			    },
			    items: [
			    	{
			    		style: 'width: 15%',
						items: [
				       		{ 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.admision'),
					        	name: 'checkOkAdmision',
					        	value: true,
					        	inputValue: true					        	
					        },
					        { 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.gestion'),
					        	name: 'checkOkGestion',
					        	value: true, 
					        	inputValue: true					
					        },
					        { 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.informe.comercial'),
					        	name: 'checkOkInformeComercial',
					        	inputValue: true					        	
					        }
						]
			    	},
			    	{
			    		style: 'width: 15%',
			    		items: [
					       	{ 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.precios'),
					        	name: 'checkOkPrecio',
					        	inputValue: true					        	
					        },
				       		{ 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.venta'),
					        	name: 'checkOkVenta',
					        	inputValue: true					        	
					        },
					        { 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.alquiler'),
					        	name: 'checkOkAlquiler',
					        	inputValue: true					        	
					        }
						]
			    	},
			    	{
			    		style: 'width: 35%',
			    		items: [
					       	{ 
				       			fieldLabel: HreRem.i18n('fieldlabel.publicaciones.activos.search.numActivoHaya'),
				            	name: 'numActivo',
				            	labelWidth:	150,
					        	width: 		230
					        },
					        { 
					        	xtype: 'comboboxfieldbase',
					        	addUxReadOnlyEditFieldPlugin: false,
					        	fieldLabel: HreRem.i18n('combolabel.publicaciones.combo.activos.cartera'),
					        	name: 'carteraCodigo',
					        	bind: {
				            		store: '{comboEntidadPropietaria}'
				            	}
					        },
					        { 
					        	xtype: 'comboboxfieldbase',
					        	addUxReadOnlyEditFieldPlugin: false,
					        	fieldLabel: HreRem.i18n('combolabel.publicaciones.combo.estado.venta'),
					        	name: 'estadoPublicacionVentaCodigo',
					        	reference: 'estadoPublicacionVenta',
					        	//value: CONST.ESTADO_PUBLICACION_VENTA['NO_PUBLICADO'], // Establecido por defecto.
					        	bind: {
				            		store: '{comboEstadoPublicacion}'
				            	},
								listeners: {
									change: 'hiddenMotivosOcultacionVenta'
								}
					        },
					        { 
					        	xtype: 'comboboxfieldbase',
					        	addUxReadOnlyEditFieldPlugin: false,
					        	fieldLabel: HreRem.i18n('combolabel.publicaciones.combo.motivos.ocultacion'),
					        	name: 'motivosOcultacionVentaCodigo',
					        	hidden: true,
					        	reference: 'motivosOcultacionVenta',
					        	bind: {
				            		store: '{comboMotivoOcultacion}'
				            	}
					        },
					        {
					        	xtype : 'comboboxfieldbase',
								addUxReadOnlyEditFieldPlugin : false,
								fieldLabel : HreRem.i18n('combolabel.publicaciones.combo.estado.alquiler'),
								name : 'estadoPublicacionAlquilerCodigo',
								reference: 'estadoPublicacionAlquiler',
								//value : CONST.ESTADO_PUBLICACION_ALQUILER['NO_PUBLICADO'], // Establecido por defecto.								
								bind : {
									store : '{comboEstadoPublicacionAlquiler}'
								},
								listeners: {
									change: 'hiddenMotivosOcultacionAlquiler'
								}
					        },
					        {
					        	xtype: 'comboboxfieldbase',
					        	addUxReadOnlyEditFieldPlugin: false,
					        	fieldLabel: HreRem.i18n('combolabel.publicaciones.combo.motivos.ocultacion'),
					        	name: 'motivosOcultacionAlquilerCodigo',
					        	hidden: true,
					        	reference: 'motivosOcultacionAlquiler',
					        	bind: {
				            		store: '{comboMotivoOcultacion}'
				            	}
					        }
						]
			    	},
			    	{
			    		style: 'width: 35%',
			    		items: [
					       	{ 
					       		xtype: 'comboboxfieldbase',
					        	addUxReadOnlyEditFieldPlugin: false,
					        	fieldLabel: HreRem.i18n('fieldlabel.publicaciones.activos.search.tipoActivo'),
					        	reference: 'filtroComboTipoActivo',
					        	name: 'tipoActivoCodigo',
					        	bind: {
				            		store: '{comboTipoActivo}'
				            	},
				            	publishes: 'value'
					        },
					        {
					        	xtype: 'comboboxfieldbase',
					        	addUxReadOnlyEditFieldPlugin: false,
					        	fieldLabel: HreRem.i18n('fieldlabel.publicaciones.activos.search.subtipoActivo'),
					        	name: 'subtipoActivoCodigo',
					        	bind: {
				            		store: '{comboSubtipoActivo}',
				            		disabled: '{!filtroComboTipoActivo.value}',
					                filters: {
					                	property: 'codigoTipoActivo',
					                	value: '{filtroComboTipoActivo.value}'
					                }
				            	}
					        },
					        {
					    		xtype: 'comboboxfieldbase',
					    		addUxReadOnlyEditFieldPlugin: false,
					    		fieldLabel: HreRem.i18n('fieldlabel.fase.de.publicacion'),
					    		name: 'fasePublicacionCodigo',
					    		reference: 'comboFasePublicacionSearch',
					    		bind: {
					    			store: '{comboFasePublicacion}'
					    		},
				            	publishes: 'value',
				            	chainedStore: 'comboSubfasePublicacion',
								chainedReference: 'comboSubfasePublicacionSearch',
								listeners: {
									select: 'onChangeChainedCombo'
								}
					    	},
					        {
					    		xtype: 'comboboxfieldbase',
					    		addUxReadOnlyEditFieldPlugin: false,
					    		fieldLabel: HreRem.i18n('fieldlabel.fases.de.publicacion.subfase.de.publicacion'),
					    		name: 'subfasePublicacionCodigo',
					    		reference: 'comboSubfasePublicacionSearch',
					        	bind: {
				            		store: '{comboSubfasePublicacion}',
				            		disabled: '{!comboFasePublicacionSearch.value}'
				            	}
					    	}
						]
			    	}
			    ]
			}
        ];

        me.callParent();
    }
});
