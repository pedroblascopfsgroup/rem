Ext.define('HreRem.view.activos.detalle.DatosPublicacionActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datospublicacionactivo',   
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable	: 'y',
    saveMultiple: true,
    refreshAfterSave: true,
    disableValidation: true,
    records: ['activohistoricoestadopublicacion', 'activoCondicionantesDisponibilidad', 'datosPublicacion'], 
    recordsClass: ['HreRem.model.ActivoHistoricoEstadoPublicacion', 'HreRem.model.ActivoCondicionantesDisponibilidad', 'HreRem.model.DatosPublicacion'],
    requires: ['HreRem.model.ActivoCondicionantesDisponibilidad','HreRem.model.ActivoHistoricoEstadoPublicacion' ,'HreRem.model.CondicionEspecifica', 
               'HreRem.view.activos.detalle.HistoricoCondicionesList','HreRem.model.EstadoPublicacion', 'HreRem.view.activos.detalle.HistoricoEstadosList',
               'HreRem.model.DatosPublicacion'],
    listeners: {
    	boxready:'cargarTabData'
    },

    
    initComponent: function () {

        var me = this;

        var items = [
			        {
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						items :
							[
			                    {
				                	xtype: 'textfieldbase',
				                	fieldLabel:  HreRem.i18n('title.publicaciones.tipoComercializacion'),
				                	bind: '{activo.tipoComercializacionDescripcion}',
				                	readOnly: true
			                    },
			                    {
				                	xtype: 'textfieldbase',
				                	fieldLabel:  HreRem.i18n('title.publicaciones.estadoPublicacion'),
				                	bind: '{activo.estadoPublicacionDescripcion}',
				                	listeners: {
				                		change: 'onChangeEstadoPublicacion'
				                	},
				                	readOnly: true
			                    },
			                    {
				                	xtype: 'textfieldbase',
				                	fieldLabel:  HreRem.i18n('title.publicaciones.estadoDisponibilidadComercial'),
				                	reference: 'fieldEstadoDisponibilidadComercial',
				                	bind: '{activoCondicionantesDisponibilidad.estadoDisponibilidadComercial}',
				                	listeners: {
				                		change: 'onChangeEstadoDisponibilidadComercial'
				                	},
				                	readOnly: true
			                    }
							]
						
					},
			        {
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.publicaciones.circunstancias'),
					    layout: {
					        type: 'table',
					        // The total column count must be specified here
					        columns: 1,
					        trAttrs: {height: '30px', width: '100%'},
					        tdAttrs: {width: '100%'},
					        tableAttrs: {
					            style: {
					                width: '100%'
									}
					        }
						},
						items :
							[
							 {
								 xtype:'fieldsettable',
								 defaultType: 'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.condicionantes'),
					        	 border: false,
								 collapsible: true,
								 collapsed: false,
								 
								 items:
									 [
								    	{
								    		xtype: 'button',						
								    		cls: 'no-pointer',
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.ruina')+'</div>',
											style : 'background: transparent; border: none;',
						                    bind: {
						                    	iconCls:'{getIconClsCondicionantesRuina}'
						                    },
						                    iconAlign:'left'
					                	},
					                	{
					                		xtype: 'button',
					                		cls: 'no-pointer',
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.pendiente')+'</div>',
								    		style : 'background: transparent; border: none;',
					                		bind: {
					                			iconCls:'{getIconClsCondicionantesPendiente}'
					                		},
					                		iconAlign:'left'
					                	},
					                	{
					                		xtype: 'button',
					                		cls: 'no-pointer',
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.obraterminada')+'</div>',
								    		style : 'background: transparent; border: none;',
					                		bind: {
					                			iconCls: '{getIconClsCondicionantesObraTerminada}'
					                		},
					                		iconAlign: 'left'
					                	},
					                	{
					                		xtype: 'button',
					                		cls: 'no-pointer',
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.sinposesion')+'</div>',
								    		style : 'background: transparent; border: none;',
					                		bind: {
					                			iconCls: '{getIconClsCondicionantesSinPosesion}'
					                		},
					                		iconAlign: 'left'
					                	},
					                	{
					                		xtype: 'button',
					                		cls: 'no-pointer',
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.proindiviso')+'</div>',
								    		style : 'background: transparent; border: none;',
					                		bind: {
					                			iconCls: '{getIconClsCondicionantesProindiviso}'
					                		},
					                		iconAlign: 'left'
					                	},
					                	{
					                		xtype: 'button',
					                		cls: 'no-pointer',
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.obranueva')+'</div>',
								    		style : 'background: transparent; border: none;',
					                		bind: {
					                			iconCls: '{getIconClsCondicionantesObraNueva}'
					                		},
					                		iconAlign: 'left'
					                	},
					                	{
					                		xtype: 'button',
					                		cls: 'no-pointer',
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.ocupadocontitulo')+'</div>',
								    		style : 'background: transparent; border: none;',
					                		bind: {
					                			iconCls: '{getIconClsCondicionantesOcupadoConTitulo}'
					                		},
					                		iconAlign: 'left'
					                	},
					                	{
					                		xtype: 'button',
					                		cls: 'no-pointer',
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.tapiado')+'</div>',
								    		style : 'background: transparent; border: none;',
					                		bind: {
					                			iconCls: '{getIconClsCondicionantesTapiado}'
					                		},
					                		iconAlign: 'left'
					                	},
					                	{
					                		xtype: 'button',
					                		cls: 'no-pointer',
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.ocupadosintitulo')+'</div>',
								    		style : 'background: transparent; border: none;',
					                		bind: {
					                			iconCls: '{getIconClsCondicionantesOcupadoSinTitulo}'
					                		},
					                		iconAlign: 'left'
					                	},
					                	{
					                		xtype: 'button',
					                		cls: 'no-pointer',
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.activodivhorizontal')+'</div>',
								    		style : 'background: transparent; border: none;',
					                		bind: {
					                			iconCls: '{getIconClsCondicionantesDivHorizontal}'
					                		},
					                		iconAlign: 'left'
					                	},
					                	{
								        	// Label vacia para generar un espacio por cuestión de estética.
								        	xtype: 'label',
								        	colspan: 1
								        },
					                	{
						                	xtype: 'comboboxfieldbase',
						                	fieldLabel:  HreRem.i18n('title.publicaciones.condicion.otro'),
						                	reference: 'comboCondicionanteOtro',
						                	bind: {
						                		store: '{comboSiNoRem}',
						                		value: '{getSiNoFromOtro}'
						                	},
						                	listeners: {
					                			change: 'onChangeComboOtro'
					                		}
					                    },
					                    {
								        	// Label vacia para generar un espacio por cuestión de estética.
								        	xtype: 'label',
								        	reference: 'textareaCondicionantesSpan',
								        	colspan: 2
								        },
					                	{
						                	xtype: 'textareafieldbase',
						                	reference: 'fieldtextCondicionanteOtro',
						                	bind: {
						                		value: '{activoCondicionantesDisponibilidad.otro}',
						                		hidden: '{!activoCondicionantesDisponibilidad.otro}'
						                	},
						                	maxLength: '255'
					                    }
									  ]
							 },
							 // Grid del histórico de condiciones específicas.
							{xtype: "historicocondicioneslist", reference: "historicocondicioneslist"}
							]
					},
					{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.publicaciones.estados'),
						items :
							[
							 {
								 xtype:'fieldsettable',
								 defaultType:'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.publicacionforzada'),
								 reference: 'seccionPublicacionForzada',
								 items:[
								        {
								        	xtype:'checkboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.forzada'),
								        	reference: 'chkbxpublicacionforzada',
								        	colspan: 3,
								        	bind: '{activohistoricoestadopublicacion.publicacionForzada}',
								        	listeners:{
								        		change: 'onchkbxEstadoPublicacionChange'
								        	}
								        },
								        {
								        	xtype:'checkboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.ordinaria'),
								        	reference: 'chkbxpublicacionordinaria',
								        	colspan: 3,
								        	bind: '{activohistoricoestadopublicacion.publicacionOrdinaria}',
								        	readOnly: true
								        },
								        {
								        	xtype: 'comboboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.motivo'),
								        	reference: 'comboboxpublicacionpublicar',
								        	colspan: 3,
								        	bind: {
								        		// TODO: store: '{comboEstadoPublicacionMotivos}',
							            		value: '{activohistoricoestadopublicacion.motivoPublicacion}'
							            	}
								        }
								        ]
							 },
							 {
								 xtype:'fieldsettable',
								 defaultType:'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.estados.ocultacionprecio'),
								 reference: 'seccionOcultacionPrecio',
								 hidden: true,
								 items:[
								        {
								        	xtype:'checkboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.ocultarprecio'),
								        	reference: 'chkbxpublicacionocultarprecio',
								        	colspan: 3,
								        	bind: '{activohistoricoestadopublicacion.ocultacionPrecio}',
								        	listeners:{
								        		change: 'onchkbxEstadoPublicacionChange'
								        	}
								        },
								        {
								        	xtype: 'comboboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.motivo'),
								        	reference: 'comboboxpublicacionocultacionprecio',
								        	bind: {
								        		// TODO: store: '{comboEstadoPublicacionMotivos}',
							            		value: '{activohistoricoestadopublicacion.motivoOcultacionPrecio}'			            		
							            	},
							            	colspan: 3
								        	
								        },
								        {
								        	xtype:'textareafieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.observaciones'),
								        	reference: 'textareapublicacionocultacionprecio',
								        	colspan: 3,
								        	bind: '{activohistoricoestadopublicacion.observaciones}'
								        }
								        ]
							 },
							 {
								 xtype:'fieldsettable',
								 defaultType:'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.estados.despublicacionforzada'),
								 reference: 'seccionDespublicacionForzada',
								 hidden: true,
								 items:[
								        {
								        	xtype:'checkboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.despublicar'),
								        	reference: 'chkbxpublicaciondespublicar',
								        	colspan: 3,
								        	bind: '{activohistoricoestadopublicacion.despublicacionForzada}',
								        	listeners:{
								        		change: 'onchkbxEstadoPublicacionChange'
								        	}
								        },
								        {
								        	xtype: 'comboboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.motivo'),
								        	reference: 'comboboxpublicaciondespublicar',
								        	colspan: 3,
								        	bind: {
								        		// TODO: store: '{comboEstadoPublicacionMotivos}',
							            		value: '{activohistoricoestadopublicacion.motivoDespublicacionForzada}'			            		
							            	}
								        },
								        {
								        	// Label vacia para generar una línea por cuestión de estética.
								        	xtype: 'label',
								        	colspan: 3
								        }
								        ]
							 },
							 {
								 xtype:'fieldsettable',
								 defaultType:'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.estados.ocultacionforzada'),
								 reference: 'seccionOcultacionForzada',
								 hidden: true,
								 items:[
								        {
								        	xtype:'checkboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.ocultar'),
								        	reference: 'chkbxpublicacionocultacionforzada',
								        	colspan: 3,
								        	bind: '{activohistoricoestadopublicacion.ocultacionForzada}',
								        	listeners:{
								        		change: 'onchkbxEstadoPublicacionChange'
								        	}
								        },
								        {
								        	xtype: 'comboboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.motivo'),
								        	reference: 'comboboxpublicacionocultacionforzada',
								        	colspan: 3,
								        	bind: {
								        		// TODO: store: '{comboEstadoPublicacionMotivos}',
							            		value: '{activohistoricoestadopublicacion.motivoOcultacionForzada}'			            		
							            	}
								        },
								        {
								        	// Label vacia para generar una línea por cuestion de estética.
								        	xtype: 'label',
								        	colspan: 3
								        }
								        ]
							 }
							 ]
					},
					{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.publicaciones.historico'),
						items :
							[							 
								{xtype: "historicoestadoslist", reference: "historicoestadoslist", colspan: 3},
								{
									xtype:'textfieldbase',
						        	fieldLabel: HreRem.i18n('title.publicaciones.estados.totalDiasPublicado'),
						        	reference: 'textfielddiastotalespublicado',
						        	bind:{
						        		value: '{datosPublicacion.totalDiasPublicado}'
						        	},
				                	readOnly: true
								},
								{
									xtype:'textfieldbase',
						        	fieldLabel: HreRem.i18n('title.publicaciones.estado.portalesExternos'),
						        	reference: 'textfieldportalesexternos',
						        	bind:{
						        		value: '{datosPublicacion.portalesExternos}'
						        	},
				                	readOnly: true
								}
							 ]
					}
		];
		
        me.addPlugin({ptype: 'lazyitems', items: items });
    	me.setTitle(HreRem.i18n('title.datos.publicacion.activo'));
   	 	me.callParent();
   		
   },
   
   getIconClsCondicionantes: function(get,condicion) {
    	if(condicion) {
    		return 'app-tbfiedset-ico icono-ok'
    	} else {
    		return 'app-tbfiedset-ico icono-ko'
    	}
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
    
});