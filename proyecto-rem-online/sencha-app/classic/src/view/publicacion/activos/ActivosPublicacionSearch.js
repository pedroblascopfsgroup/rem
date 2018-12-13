Ext.define('HreRem.view.publicacion.activos.ActivosPublicacionSearch', {
	extend		: 'HreRem.view.common.FormBase',
    xtype		: 'activospublicacionsearch',
    isSearchForm: true,
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
					        	name: 'admision',
					        	value: true, // Establecido por defecto.
					        	inputValue: true					        	
					        },
					        { 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.gestion'),
					        	name: 'gestion',
					        	value: true, // Establecido por defecto.
					        	inputValue: true					
					        },
					        { 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.informe.comercial'),
					        	name: 'informeComercial',
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
					        	name: 'precio',
					        	inputValue: true					        	
					        },
				       		{ 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.publicacion'),
					        	name: 'publicacion',
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
					        	name: 'cartera',
					        	bind: {
				            		store: '{comboEntidadPropietaria}'
				            	}
					        },
					        { 
					        	xtype: 'comboboxfieldbase',
					        	addUxReadOnlyEditFieldPlugin: false,
					        	fieldLabel: HreRem.i18n('combolabel.publicaciones.combo.estado.venta'),
					        	name: 'estadoPublicacionCodigo',
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
					        	name: 'motivosOcultacionCodigo',
					        	hidden: true,
					        	reference: 'motivosOcultacionVenta',
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
					        	name: 'tipoActivo',
					        	bind: {
				            		store: '{comboTipoActivo}'
				            	},
				            	publishes: 'value'
					        },
					        {
					        	xtype: 'comboboxfieldbase',
					        	addUxReadOnlyEditFieldPlugin: false,
					        	fieldLabel: HreRem.i18n('fieldlabel.publicaciones.activos.search.subtipoActivo'),
					        	name: 'subtipoActivo',
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
			    	}
			    ]
			}
        ];

        me.callParent();
    }
});
