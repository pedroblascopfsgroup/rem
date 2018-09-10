Ext.define('HreRem.view.activos.detalle.DatosPublicacionActivo', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'datospublicacionactivo',   
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    scrollable	: 'y',
    saveMultiple: true,
    refreshAfterSave: true,
    disableValidation: false,
    records		: ['activohistoricoestadopublicacion', 'activoCondicionantesDisponibilidad', 'datosPublicacion'], 
    recordsClass: ['HreRem.model.ActivoHistoricoEstadoPublicacion', 'HreRem.model.ActivoCondicionantesDisponibilidad', 'HreRem.model.DatosPublicacion'],
    requires	: ['HreRem.model.ActivoCondicionantesDisponibilidad','HreRem.model.ActivoHistoricoEstadoPublicacion' ,'HreRem.model.CondicionEspecifica', 
               		'HreRem.view.activos.detalle.HistoricoCondicionesList','HreRem.model.EstadoPublicacion', 'HreRem.view.activos.detalle.HistoricoEstadosList',
               		'HreRem.model.DatosPublicacion'],
    listeners	: {
    	boxready:'cargarTabData'
    },

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.datos.publicacion.activo'));
        
        var isCarteraLiberbank = me.lookupViewModel().get('activo.isCarteraLiberbank');

        me.items = [
// Resumen estado publicación.
        			{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						items :
							[
			                    {
				                	xtype: 'textfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.perimetro.destino.comercial'),
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
				                	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('title.publicaciones.estadoDisponibilidadComercial'),
				                	reference: 'fieldEstadoDisponibilidadComercial',
				                	bind: {
				                		store: '{storeEstadoDisponibilidadComercial}',
				                		value: '{activoCondicionantesDisponibilidad.estadoCondicionadoCodigo}'
				                	},
				                	readOnly: true
			                    }
							]
					},
// Circunstancias concretas.
			        {
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.publicaciones.circunstancias'),
					    layout: {
					        type: 'table',
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
							 // Condicionantes a la disponibilidad.
								{
								 xtype:'fieldsettable',
								 defaultType: 'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.condicionantes'),
					        	 border: false,
								 collapsible: false,
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
					                		xtype: 'button',
					                		cls: 'no-pointer',
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.conCargas')+'</div>',
								    		style : 'background: transparent; border: none;',
					                		bind: {
					                			iconCls: '{getIconClsCondicionantesConCargas}'
					                		},
					                		iconAlign: 'left'
					                	},
					                    {
					                		xtype: 'button',
					                		cls: 'no-pointer',
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.sinInformeAprobado')+'</div>',
								    		style : 'background: transparent; border: none;',
					                		bind: {
					                			iconCls: '{getIconClsCondicionantesSinInformeAprobado}'
					                		},
					                		iconAlign: 'left'
					                	},
					                	 {
					                		xtype: 'button',
					                		cls: 'no-pointer',
					                		hidden: !isCarteraLiberbank,
								    		html : '<div style="color: #000;">'+HreRem.i18n('title.publicaciones.condicion.sinAcceso')+'</div>',
								    		style : 'background: transparent; border: none;',
					                		bind: {
					                			iconCls: '{getIconClsCondicionantesSinAcceso}'
					                		},
					                		iconAlign: 'left'
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
						// Condiciones específicas.
							 {
								 xtype:'fieldsettable',
								 defaultType: 'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.condiciones.especificas'),
					        	 border: false,
								 collapsible: false,
								 collapsed: false,
								 items:
									 [
										 {
											 xtype: "historicocondicioneslist",
											 reference: "historicocondicioneslist",
											 secFunToEdit: 'EDITAR_GRID_PUBLICACION_CONDICIONES_ESPECIFICAS'
										 }
									 ]
							 }
							]
					},
// Estados de Publicación.
					{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.publicaciones.estados'),
						items :
							[
							 { // Publicación.
								 xtype:'fieldsettable',
								 defaultType:'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.publicacion'),
								 reference: 'seccionPublicacionForzada',
								 margin: '5 8 10 8',
								 minHeight	: 150,
								 collapsible: false,
								 items:[
								        {
								        	xtype:'checkboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.forzada'),
								        	reference: 'chkbxpublicacionforzada',
								        	colspan: 3,
								        	bind: {
								        		value	: '{activohistoricoestadopublicacion.publicacionForzada}'
								        	},
								        	listeners:{
								        		change: 'onchkbxEstadoPublicacionChange'
								        	}
								        },
								        {
								        	xtype:'checkboxfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.ordinaria'),
								        	reference: 'chkbxpublicacionordinaria',
								        	colspan: 3,
								        	bind: {
								        		value	: '{activohistoricoestadopublicacion.publicacionOrdinaria}'
								        	},
								        	listeners:{
								        		change: 	'onchkbxEstadoPublicacionChange',
								        		boxready:	'ocultarChkPublicacionOrdinaria'
								        	}
								        },
								        {
								        	xtype: 'textfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.motivo'),
								        	reference: 'textfieldpublicacionpublicar',
								        	colspan: 3,
								        	bind: {
							            		disabled: '{activohistoricoestadopublicacion.publicacionOrdinaria}',
							            		value	: '{activohistoricoestadopublicacion.motivoPublicacion}'
							            	},
							            	maxLength: '100'
								        }
								        ]
							 },
							 { // Ocultación Precio.
								 xtype:'fieldsettable',
								 defaultType:'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.estados.ocultacionprecio'),
								 reference: 'seccionOcultacionPrecio',
								 margin: '5 8 10 8',
								 minHeight	: 150,
								 collapsible: false,
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
								        	xtype: 'textfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.motivo'),
								        	reference: 'textfieldpublicacionocultacionprecio',
								        	bind: {
							            		value: '{activohistoricoestadopublicacion.motivoOcultacionPrecio}'			            		
							            	},
							            	colspan: 3,
							            	maxLength: '100'
								        	
								        },
								        {
								        	xtype:'textareafieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.observaciones'),
								        	reference: 'textareapublicacionocultacionprecio',
								        	colspan: 3,
								        	bind: '{activohistoricoestadopublicacion.observaciones}',
								        	disabled: true
								        }
								        ]
							 },
							 { // Despublicación Forzada.
								 xtype:'fieldsettable',
								 defaultType:'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.estados.despublicacionforzada'),
								 reference: 'seccionDespublicacionForzada',
								 margin: '5 8 10 8',
								 minHeight	: 150,
								 collapsible: false,
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
								        	xtype: 'textfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.motivo'),
								        	reference: 'textfieldpublicaciondespublicar',
								        	colspan: 3,
								        	bind: {
							            		value: '{activohistoricoestadopublicacion.motivoDespublicacionForzada}'
							            	},
							            	maxLength: '100'
								        },
								        {
								        	// Label vacia para generar una línea por cuestión de estética.
								        	xtype: 'label',
								        	colspan: 3
								        }
								        ]
							 },
							 { // Ocultación Forzada.
								 xtype:'fieldsettable',
								 defaultType:'textfieldbase',
								 title: HreRem.i18n('title.publicaciones.estados.ocultacionforzada'),
								 reference: 'seccionOcultacionForzada',
								 margin: '5 8 10 8',
								 minHeight	: 150,
								 collapsible: false,
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
								        	xtype: 'textfieldbase',
								        	fieldLabel: HreRem.i18n('title.publicaciones.estados.motivo'),
								        	reference: 'textfieldpublicacionocultacionforzada',
								        	colspan: 3,
								        	bind: {
							            		value: '{activohistoricoestadopublicacion.motivoOcultacionForzada}'
							            	},
							            	maxLength: '100'
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
// Historico de estados de publicación.
					{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.publicaciones.historico'),
						items :
							[							 
								// Historico de estados de publicación.
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
						        		value: '{activoCondicionantesDisponibilidad.portalesExternosDescripcion}'
						        	},
				                	readOnly: true
								}
							 ]
					}
		];

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