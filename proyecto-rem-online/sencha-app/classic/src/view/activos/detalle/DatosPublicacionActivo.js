Ext.define('HreRem.view.activos.detalle.DatosPublicacionActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datospublicacionactivo',   
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable	: 'y',
    saveMultiple: true,
    disableValidation: true,
    records: ['activoCondicionantesDisponibilidad'], 
    recordsClass: ['HreRem.model.ActivoCondicionantesDisponibilidad'],    
    requires: ['HreRem.model.ActivoCondicionantesDisponibilidad','HreRem.model.CondicionEspecifica', 'HreRem.view.activos.detalle.HistoricoCondicionesList','HreRem.model.EstadoPublicacion', 'HreRem.view.activos.detalle.HistoricoEstadosList'],
    
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
				                	id: 'fieldEstadoDisponibilidadComercial',
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
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.otro')+'</div>',
								    		style : 'background: transparent; border: none;',
								    		bind: {
					                			iconCls: '{getIconClsCondicionantesOtro}'
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
					                	}
									  ]
							 },
							 
							{xtype: "historicocondicioneslist", reference: "historicocondicioneslist"}
								
							 //Grid del histórico de condiciones específicas
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
								 id: 'seccionPublicacionForzada',
								 items:[
								        {
								        	xtype:'checkboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.ocultar')
								        },
								        {
								        	xtype:'textfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.motivo')
								        }
								        ]
							 },
							 {
								 xtype:'fieldsettable',
								 defaultType:'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.estados.ocultacionprecio'),
								 id: 'seccionOcultacionPrecio',
								 items:[
								        {
								        	xtype:'checkboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.ocultarprecio')
								        },
								        {
								        	xtype:'textfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.motivo')
								        },
								        {
								        	xtype:'textareafieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.observaciones')
								        }
								        ]
							 },
							 {
								 xtype:'fieldsettable',
								 defaultType:'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.estados.despublicacionforzada'),
								 id: 'seccionDespublicacionForzada',
								 items:[
								        {
								        	xtype:'checkboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.despublicar')
								        },
								        {
								        	xtype:'textfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.motivo')
								        }
								        ]
							 },
							 {
								 xtype:'fieldsettable',
								 defaultType:'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.estados.ocultacionforzada'),
								 id: 'seccionOcultacionForzada',
								 items:[
								        {
								        	xtype:'checkboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.ocultar')
								        },
								        {
								        	xtype:'textfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.motivo')
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
								{xtype: "historicoestadoslist", reference: "historicoestadoslist"}
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
//		me.lookupController().cargarTabData(me);
//		Ext.Array.each(me.query('grid'), function(grid) {
//  			grid.getStore().load();
//  		});
    }
    
});