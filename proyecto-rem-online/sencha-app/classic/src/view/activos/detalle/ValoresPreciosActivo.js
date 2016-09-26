Ext.define('HreRem.view.activos.detalle.ValoresPreciosActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'valorespreciosactivo',    
    scrollable	: 'y',
    
    listeners: {
    	boxready: function() {
    		me = this;
    		me.lookupController().cargarTabData(me);
    		me.evaluarEdicion();
    	}
    },
    
    refreshAfterSave: true,
    
    requires: ['HreRem.model.ActivoValoraciones'],

    recordName: "valoraciones",

	recordClass: "HreRem.model.ActivoValoraciones",

    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.valoraciones.precios'));
        var items= [
            {
				xtype:'fieldsettable',
				cls: 'fieldset-precios-vigentes',
				title: HreRem.i18n('title.precios.vigentes'),
				items :	[
					{
						
							xtype		: 'gridBaseEditableRow',
							reference	: 'gridPreciosVigentes',
							cls			: 'grid-no-seleccionable',
							loadAfterBind	: false,
							colspan		: 3,
							minHeight	: 200,
							bind		: {
											store: '{storePreciosVigentes}'
							},
							/*viewConfig: { 
								getRowClass: function(record) { 
									
									var fechaFin = record.get("fechaFin");
									var cssClass = Ext.isEmpty(fechaFin) || record.get("fechaFin") >= $AC.getCurrentDate()? '' : 'grid-warning-row';
						            return cssClass; 
						        }
							},*/
							columns		: {
											defaults: {
							    				menuDisabled: true,
							    				sortable: false
							    			},
											items:[
											
												/*{
									    			xtype: 'actioncolumn',
									    			cls: 'grid-no-seleccionable-primera-col',
											        handler: 'onPasarPrecioHistoricoClick',
											        items: [{
											            tooltip: 'Pasar a historico',
											            iconCls: 'x-fa fa-history'
											        }],
										            flex     : 0.3,            
										            align: 'center',
										            hideable: false
										       },*/
											   {
												dataIndex: 'descripcionTipoPrecio',
												cls: 'grid-no-seleccionable-primera-col',
								        		tdCls: 'grid-no-seleccionable-td',
												flex: 1.5
											   },
											   {
												text: HreRem.i18n('header.importe'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',
												dataIndex: 'importe',
												renderer: Utils.rendererCurrency,
									        	editor: {
									        		xtype:'numberfield', 
									        		hideTrigger: true,
									        		keyNavEnable: false,
									        		mouseWheelEnable: false,
									        		allowBlank: false
									        		},
												flex: 1
											   },
											   {
												text: HreRem.i18n('header.fecha.aprobacion'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',
												dataIndex: 'fechaAprobacion',
												formatter: 'date("d/m/Y")',
												flex: 1,
												hidden: true
											   },
											   {
												text: HreRem.i18n('header.fecha.carga'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',												
												dataIndex: 'fechaCarga',
												formatter: 'date("d/m/Y")',
												flex: 1
											   },
											   {
												text: HreRem.i18n('header.fecha.inicio'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',												
												dataIndex: 'fechaInicio',
												formatter: 'date("d/m/Y")',
									        	editor: {
									        		xtype: 'datefield'
									        	},
												flex: 1
											   },
											   {
												text: HreRem.i18n('header.fecha.fin'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',												
												dataIndex: 'fechaFin',
												formatter: 'date("d/m/Y")',
									        	editor: {
									        		xtype: 'datefield'
									        	},
												flex: 1
											   },
											   {
												text: HreRem.i18n('header.gestor'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',												
												dataIndex: 'gestor',
												flex: 1,
												hidden: true
											   },
											   {
												text: HreRem.i18n('header.observaciones'),
												cls: 'grid-no-seleccionable-col',
								        		tdCls: 'grid-no-seleccionable-td',												
												dataIndex: 'observaciones',
												editor: {xtype:'textarea'},
												flex: 1
											   }
						    				]
							},
							saveSuccessFn: function() {
								me.down("[reference=gridHistoricoPrecios]").getStore().load();								
							}
					},
					{
						xtype: 'container',
						//colspan: 3,
						style: {
							backgroundColor: '#E5F6FE'
						},
						padding: 10,
						margin: '5 8 10 8',
						layout: {
							type: 'hbox'
						},
						items: [
								{
									xtype: 'checkboxfieldbase',						
									bind:		'{valoraciones.bloqueoPrecio}',
									listeners: {
										change: 'onChangeBloqueo'
									},
									width: 40
								},
								{
									xtype: 'label',
									cls: 'label-read-only-formulario-completo',
									html: '<span style="font-weight: bold;">' + HreRem.i18n('fieldlabel.bloqueo') + ': </span>' + '<span>' + HreRem.i18n('fieldlabel.txt.precios.bloqueado') + '&nbsp;</span>',
									bind: {
										hidden: '{!valoraciones.bloqueoPrecioFechaIni}'
									}
									
								},
								{
									xtype: 'label',
									cls: 'label-read-only-formulario-completo',
									html: '<span style="font-weight: bold;">' + HreRem.i18n('fieldlabel.bloqueo') + ': </span>' + '<span>' + HreRem.i18n('fieldlabel.txt.precios.bloquear') + '&nbsp;</span>',
									bind: {
										hidden: '{valoraciones.bloqueoPrecioFechaIni}'
									}
								},
							
								{
									xtype: 'datefieldbase',
									readOnly: true,
									reference: 'bloqueoPrecioFechaIni',
									bind:  '{valoraciones.bloqueoPrecioFechaIni}',
									width: 65
								},
								{
									xtype: 'label',
									cls: 'label-read-only-formulario-completo',
									html: HreRem.i18n('fieldlabel.por.gestor') + '&nbsp;',
									bind: {
										hidden: '{!valoraciones.gestorBloqueoPrecio}'
									}
								},
								{
									xtype: 'textfieldbase',
									readOnly: true,
									reference: 'gestorBloqueoPrecio',
									bind: '{valoraciones.gestorBloqueoPrecio}'
								}
						]
					}
				]
            },
            {
				xtype:'fieldsettable',
				title: HreRem.i18n('title.valores.invariables'),
				items :	[
				   {
					   xtype: 'currencyfieldbase',
					   readOnly: true,
					   fieldLabel: HreRem.i18n('fieldlabel.valor.adquisicion.no.judicial'),
					   bind:  '{valoraciones.valorAdquisicion}',
					   margin: '0 0 0 8'
				   },
				   {
				   		xtype: 'displayfield'
				   		// como separador				   		
				   },
				   {
					   xtype: 'currencyfieldbase',
					   readOnly: true,
					   fieldLabel: HreRem.i18n('fieldlabel.valor.adquisicion.judicial'),
					   bind: '{valoraciones.importeAdjudicacion}'
					   
				   }
				]
            },
            {
				xtype:'fieldsettable',
				title: HreRem.i18n('title.valores.variables.vigentes'),
				items :	[
					{
						xtype:'fieldset',
						height: 200,
						margin: '0 10 10 0',
						layout: {
					        type: 'table',
							columns: 1
						},
						defaultType: 'textfieldbase',
						title: HreRem.i18n("title.del.propietario"),
						items :
							[
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.valor.neto.contable'),
							   bind:  '{valoraciones.vnc}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.valor.de.referencia'),
							   bind:  '{valoraciones.valorReferencia}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.valor.asesoramiento.liquidativo'),
							   bind:  '{valoraciones.valorAsesoramientoLiquidativo}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.vacbe'),
							   bind:  '{valoraciones.vacbe}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.coste.adquisicion'),
							   bind:  '{valoraciones.costeAdquisicion}'
							 }						 
							 
							]
					},
					{
						xtype:'fieldset',
						height: 200,
						margin: '0 10 10 0',
						layout: {
					        type: 'table',
							columns: 1
						},
						defaultType: 'textfieldbase',
						title: HreRem.i18n("title.internos.haya"),
						items :
							[
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.fsv.venta'),
							   bind:  '{valoraciones.fsvVenta}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.fsv.renta'),
							   bind:  '{valoraciones.fsvRenta}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.estimado.venta'),
							   bind:  '{valoraciones.valorEstimadoVenta}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.estimado.renta'),
							   bind:  '{valoraciones.valorEstimadoRenta}'
							 }
							 
							]
					},
					{
						xtype:'fieldset',
						height: 200,
						margin: '0 10 10 0',
						layout: {
					        type: 'table',
							columns: 1
						},
						defaultType: 'textfieldbase',
						title: HreRem.i18n("title.legales"),
						items :
							[
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.vpo'),
							   bind:  '{valoraciones.valorLegalVpo}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.catastral.suelo'),
							   bind:  '{valoraciones.valorCatastralSuelo}'
							 },
							 {
							   xtype: 'currencyfieldbase',
							   readOnly: true,
							   fieldLabel: HreRem.i18n('fieldlabel.catastral.construccion'),
							   bind:  '{valoraciones.valorCatastralConstruccion}'
							 }
							 
							]
					}				
				]
            },
            {
				xtype:'fieldsettable',
				title: HreRem.i18n('title.historico.valores.precios'),
				items :	[
							{
								xtype		: 'gridBase',
								reference	: 'gridHistoricoPrecios',
								loadAfterBind: false,
								flex		: 1,
								bind		: {
												store: '{storeHistoricoValoresPrecios}'
								},
								features: [{
						            ftype: 'grouping',
						            groupHeaderTpl: '{name}'
						        }],
								columns		: {
								items:[
								   {   
									   text: HreRem.i18n('header.descripcion'),
									   //dataIndex: 'descripcionTipoPrecio',
									   //sortable: true,
									   flex: 0.4
							       },
								   {
									text: HreRem.i18n('header.importe'),
									dataIndex: 'importe',
									renderer: Utils.rendererCurrency,						        		
									flex: 1
								   },
								   {
									text: HreRem.i18n('header.fecha.aprobacion'),
									dataIndex: 'fechaAprobacion',
									formatter: 'date("d/m/Y")',
									flex: 1
								   },
								   {
									text: HreRem.i18n('header.fecha.carga'),										
									dataIndex: 'fechaCarga',
									formatter: 'date("d/m/Y")',
									flex: 1
								   },
								   {
									text: HreRem.i18n('header.fecha.inicio'),									
									dataIndex: 'fechaInicio',
									formatter: 'date("d/m/Y")',
									flex: 1
								   },
								   {
									text: HreRem.i18n('header.fecha.fin'),										
									dataIndex: 'fechaFin',
									formatter: 'date("d/m/Y")',
									flex: 1
								   },
								   {
									text: HreRem.i18n('header.gestor'),											
									dataIndex: 'gestor',
									flex: 1
								   },
								   {
									text: HreRem.i18n('header.observaciones'),										
									dataIndex: 'observaciones',
									flex: 1
								   }
			    				]

							}/* HREOS-627 Paginación eliminada
							,
							dockedItems : [
						        {
						            xtype: 'pagingtoolbar',
						            dock: 'bottom',
						            itemId: 'historicoPreciosToolbar',
						            inputItemWidth: 100,
						            displayInfo: true,
						            bind: {
						                store: '{storeHistoricoValoresPrecios}'
						            }
						        }
							]	*/					 
						}
				]
            }
        ];
        
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
   }, 
   
   	afterLoad: function() {
		var me = this;
		me.lookupController().getViewModel().get("storePreciosVigentes").load();
		me.lookupController().getViewModel().get("storeHistoricoValoresPrecios").load();
	},
   
   funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
   },
   
 //HREOS-846 Si NO esta dentro del perimetro, ocultamos del grid las opciones de agregar/elminar
   evaluarEdicion: function() {    	
		var me = this;
	
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false") {
			me.down('[reference=gridPreciosVigentes]').rowEditing.clearListeners()
		}
   }
    
});