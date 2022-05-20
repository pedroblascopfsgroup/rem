Ext.define('HreRem.view.activos.detalle.AdministracionActivo', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'administracionactivo',   
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'administracionactivoref',
	scrollable	: 'y',	
	listeners: {
    	boxready: function() {
    		var me = this;
    		me.lookupController().cargarTabData(me);
    	
    		if (!$AU.userIsRol(CONST.PERFILES['GESTOR_ADMINISTRACION']) && !$AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMINISTRACION']) && !$AU.userIsRol(CONST.PERFILES['HAYASUPER'])){
    			if(!Ext.isEmpty(me.lookupController().lookupReference('tributosGrid'))){
	    			me.lookupController().lookupReference('tributosGrid').setEditOnSelect(false);
	    			me.lookupController().lookupReference('tributosGrid').setTopBar(false);
    			}
    		}
    	}
    },
	
	requires: ['HreRem.model.ActivoAdministracion', 'HreRem.view.activos.detalle.ImpuestosActivoGrid'],

    recordName: "administracion",

	recordClass: "HreRem.model.ActivoAdministracion",

    initComponent: function () {
        var me = this;

        me.setTitle(HreRem.i18n('title.administracion.activo'));

        var items= [
			{
				xtype: 'container',
				style: {
					backgroundColor: '#E5F6FE'
				},
				padding: 10,
				margin: '5 0 10 0',
				layout: {
					type: 'hbox'
				},
				items: [
					{
						xtype: 'checkboxfieldbase',
						bind:		'{administracion.ibiExento}',
						width: 40,
						disabled: '{administracion.isUnidadAlquilable}'
					},
					{
						xtype: 'label',
						cls: 'label-read-only-formulario-completo',
						html: HreRem.i18n('fieldlabel.activo.administracion.ibi.exento')						
					}
				]
			},
			{
    			xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				collapsible: false,
				reference: 'informacionBCAdministracion',
				title: HreRem.i18n('title.informacion.BC'),
				colspan:3,
				bind:{
					hidden: '{!isCarteraBankia}'
				},
				items :
					[
						{
							xtype:'comboboxfieldbasedd',
							fieldLabel: HreRem.i18n('fieldlabel.activocaixa.segmentacion.cartera'),
							bind: {											
								store: '{comboSegmentacionCartera}',
								value: '{administracion.segmentacionCarteraCodigo}',
								rawValue: '{administracion.segmentacionCarteraDescripcion}',
								readOnly: true
							}
						}
					]
			},
         {
			xtype:'fieldsettable',
			title: HreRem.i18n('title.administracion.activo.proveedores'),
			collapsible: false,
			items :	[
				{
				    xtype		: 'gridBase',
				    idPrincipal : 'id',
				    colspan: 3,
				    reference: 'listadoproveedoresref',
					cls	: 'panel-base shadow-panel',
					bind: {
						store: '{storeProveedores}'
					},
					listeners : {
					    	rowclick: 'onProveedoresListClick'
					},
					viewConfig: { 
				        getRowClass: function(record) { 
				        	if(!Ext.isEmpty(record.get('fechaExclusion'))){
				        		return 'red-row-grid';
				        	}
				        } 
				    },
					columns: [
						{    text: HreRem.i18n('title.activo.administracion.numActivo'),
				        	dataIndex: 'numActivo',
				        	hidden: false,
				        	hideable: false,
				        	flex: 1
				       },
						{
				        	xtype: 'actioncolumn',
				            dataIndex: 'codigoProveedorRem',
				            text: HreRem.i18n('title.activo.administracion.numProveedor'),
				            flex: 1,
				            items: [{
					            tooltip: HreRem.i18n('tooltip.ver.proveedor'),
					            getClass: function(v, metadata, record ) {
					            		return 'fa-user blue-medium-color'
					            },
					            handler: 'abrirPestanyaProveedor'
					        }],
					        renderer: function(value, metadata, record) {
					        	return '<div style="float:left; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>';
					        },
				            flex     : 1,            
				            align: 'right',
				            hideable: false,
				            sortable: true
				       },
					   {    text: HreRem.i18n('title.activo.administracion.numProveedor'),
				        	dataIndex: 'codigoProveedor',
				        	hidden: true,
				        	hideable: false,
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.tipo'),
				        	dataIndex: 'tipoProveedorDescripcion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.subtipo'),
				        	dataIndex: 'subtipo',
				        	hidden: true,
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.nif'),
				        	dataIndex: 'numDocumentoProveedor',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.nombre'),
				        	dataIndex: 'nombreProveedor',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.estado'),
				        	dataIndex: 'estadoProveedorDescripcion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.fecha.exclusion'),
				        	dataIndex: 'fechaExclusion',
				        	formatter: 'date("d/m/Y")',
				        	flex: 1
				       }
				    ],

				    dockedItems : [
				        {
				            xtype: 'pagingtoolbar',
				            dock: 'bottom',
				            displayInfo: true,
				            bind: {
				                store: '{storeProveedores}'
				            }
				        }
				    ]
				},
				{
					xtype: 'displayfieldbase',
					value: HreRem.i18n('title.activo.administracion.mensaje.proveedor.excluido'),
				    flex: 1
				}
			]
		},
		{
			xtype:'fieldsettable',
			title: HreRem.i18n('title.administracion.activo.listado.gastos'),
			collapsible: false,
			items :	[
				{
				    xtype		: 'gridBase',
				    idPrincipal : 'idGasto',
				    colspan: 3,
				    reference: 'listadogastosref',
					cls	: 'panel-base shadow-panel',
					bind: {
						store: '{storeGastosProveedor}',
						disabled: '{administracion.isUnidadAlquilable}'
					},
					listeners: {
						rowdblclick: 'onClickAbrirGastoProveedor'	
					},
					columns: [
						{	  
				            text: HreRem.i18n('title.activo.administracion.numGasto'),				            
				            dataIndex: 'numGasto',
				            flex: 1,				            
				            hideable: false
					   },
					   {    text: HreRem.i18n('title.activo.administracion.numFactura'),
				        	dataIndex: 'numFactura',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.tipo'),
				        	dataIndex: 'tipoGastoDescripcion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.subtipo'),
				        	dataIndex: 'subtipoGastoDescripcion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.concepto'),
				        	dataIndex: 'conceptoGasto',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.fecha.emision'),
				        	formatter: 'date("d/m/Y")',
				        	dataIndex: 'fechaEmisionGasto',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.periodicidad'),
				        	dataIndex: 'periodicidadGastoDescripcion',
				        	flex: 1
				       },
				        {    text: HreRem.i18n('title.activo.administracion.porcentajeParticipacion'),
				        	dataIndex: 'participacion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.importe.total'),
				        	dataIndex: 'importeTotalGasto',
				        	renderer: Utils.rendererCurrency,
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.estado'),
				        	dataIndex: 'estadoGastoDescripcion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.fecha.pago'),
				        	formatter: 'date("d/m/Y")',
				        	dataIndex: 'fechaPagoGasto',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.afecta.otros.activos'),
				        	renderer: function(val, meta, record){
							    if(!Ext.isEmpty(record.data.participacion) && record.data.participacion!="100.0"){
							    	return "SI";
							    }
							    return "NO";
							},
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.observaciones'),
				        	dataIndex: 'observacionesGastos',
				        	flex: 1
				       }
				    ],
	
				    dockedItems: [
				        {
				            xtype: 'pagingtoolbar',
				            dock: 'bottom',
				            displayInfo: true,
				            bind: {
				                store: '{storeGastosProveedor}'
				            }
				        }
				   ]
				}
			]
	},
		{
			xtype:'fieldsettable',
			title:HreRem.i18n('title.administracion.activo.tipo.impuesto'),
			defaultType: 'textfieldbase',
			colspan: 3,
			items :
				[
					{
						xtype: "impuestosactivogrid", reference: "impuestosactivogrid",
						bind:{
							disabled: '{administracion.isUnidadAlquilable}'
						}
					}
				]
		}

								
    ];

		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    },

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
		me.lookupController().cargarTabData(me);
    }
});