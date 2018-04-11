Ext.define('HreRem.view.administracion.gastos.GestionProvisionGastosList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'gestionprovisiongastoslist',
    bind: {
        store: '{provisionGastos}'
    },
    plugins: 'pagingselectpersist',
    loadAfterBind: false,

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.listado.gastos.provision'));

		var configAutorizarBtn = {text: HreRem.i18n('btn.autorizar'), reference: 'btnAutorizarGastos', cls:'tbar-grid-button', itemId:'autorizarBtn', handler: 'onClickAutorizarGastosAgrupados', disabled: true, secFunPermToRender: 'OPERAR_GASTO_AGRUPACION'};
		var configRechazarButton = {text: HreRem.i18n('btn.rechazar'), reference: 'btnRechazarGastos' , cls:'tbar-grid-button', itemId:'rechazarBtn', handler: 'onClickRechazarGastosAgrupados', disabled: true, secFunPermToRender: 'OPERAR_GASTO_AGRUPACION'};
		var descargarExcelGastosAgrupacion = {text: HreRem.i18n('btn.exportar'), reference: 'btnExportarGastosAgrupacion', cls:'tbar-grid-button', handler: 'onClickDescargarExcelGastosAgrupacion', disabled: true};
		var separador = {xtype: 'tbfill'};

		me.tbar = {
    		xtype: 'toolbar',
    		reference: 'tbarprovisiongastoslist',
    		dock: 'top',
    		items: [separador, descargarExcelGastosAgrupacion, configAutorizarBtn, configRechazarButton]
		};

        me.listeners = {	    	
    		rowdblclick: 'onClickAbrirGastoProveedor',
    		afterrender: function(grid) {

    		 }
    	};

        me.columns= [
	       				{   
				        	dataIndex: 'id',
				        	flex: 1,
				        	hidden: true,
				        	hideable: false
				       	},
				       	{   
				       		text: HreRem.i18n('header.num.gasto'),
				        	dataIndex: 'numGastoHaya',
				        	flex: 0.4
				       	},
	                    {
							text: HreRem.i18n('header.num.factura.liquidacion'),
							dataIndex: 'numFactura',
							flex: 0.4
					   	},
	                     
	                     {
	                    	text: HreRem.i18n('header.tipo.gasto'),
	                    	flex: 1,
	                    	hidden: true,
	                    	dataIndex: 'tipoDescripcion'
	                     },
	                     {
	                    	text: HreRem.i18n('header.subtipo.gasto'),
	                    	flex: 1,
	                    	dataIndex: 'subtipoDescripcion'
	                     },
	                     {
	                    	text: HreRem.i18n('header.concepto.gasto'),
	                    	flex: 1,
	                    	dataIndex: 'concepto',
	                    	hidden: true
	                     },
	                     {
	                     	text: HreRem.i18n('header.numero.proveedor'),
	                     	flex: 0.4,
	                     	dataIndex: 'codigoProveedorRem',
	                     	hidden: true
	                     },
	                     {
	                    	text: HreRem.i18n('header.proveedor.gasto'),
	                    	flex: 1,
	                    	dataIndex: 'nombreProveedor'
	                     },
	                     {
	                     	text: HreRem.i18n('header.fecha.emision.gasto'),
	                     	flex: 0.4,
	                    	dataIndex: 'fechaEmision',
   	                    	formatter: 'date("d/m/Y")'	
	                     },
	                     {
	                    	text: HreRem.i18n('header.importe.gasto'),
	                    	flex: 0.4,
	                    	dataIndex: 'importeTotal',
	                    	hidden: true
	                     },
	                     {
	                     	text: HreRem.i18n('header.fecha.tope.pago.gasto'),
	                     	flex: 0.4,
	                    	dataIndex: 'fechaTopePago',
	                    	formatter: 'date("d/m/Y")',
	                    	hidden: true
	                     },
	                     {
	                     	text: HreRem.i18n('header.fecha.pago.gasto'),
	                     	flex: 0.4,
	                    	dataIndex: 'fechaPago',
	                    	formatter: 'date("d/m/Y")',
	                    	hidden: true
	                     },
	                     {
	                    	text: HreRem.i18n('header.periodicidad.gasto'),
	                    	flex: 0.4,
	                    	dataIndex: 'periodicidadDescripcion',
	                    	hidden: true
	                     },
	                     {
	                    	text: HreRem.i18n('header.destinatario.gasto'),
	                    	flex: 1,
	                    	dataIndex: 'destinatarioDescripcion',
	                    	hidden: true
	                     },
	                     {
	                     	text: HreRem.i18n('header.estado'),
	                     	flex: 0.4,
	                     	dataIndex: 'estadoGastoDescripcion'
	                     },
	                     {
	                     	text: HreRem.i18n('header.estado.autorizacion.propietario'),
	                     	flex: 0.4,
	                     	dataIndex: 'estadoAutorizacionPropietarioDescripcion'
	                     },
	                     {
	    	                text: HreRem.i18n('fieldlabel.motivo.rechazo'),
	    	                flex: 0.5,
	    	                dataIndex: 'motivoRechazo'
		    	         }
        ];

        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{provisionGastos}'
		            },
		            items:[
			            	{
			            		xtype: 'tbfill'
			            	},
			                {
			                	xtype: 'displayfieldbase',
			                	itemId: 'displaySelection',
			                	fieldStyle: 'color:#0c364b; padding-top: 4px'
			                },
			                {
			                	xtype: 'displayfieldbase',
			                	itemId: 'labelImporteTotal',
			                	fieldStyle: 'color:#ff0000; padding-top: 4px; text-align:right;;padding-left: 30px',
			                	value: HreRem.i18n('footer.listado.gastos.sumatorio'),
			                	hidden: true
			                },
			                {
			                	xtype: 'displayfieldbase',
			                	itemId: 'displayImporteTotal',
			                	fieldStyle: 'color:#ff0000; padding-top: 4px;font-weight: bold;',
			                	hidden: true
			                }
	            	]
		        }
		];

		me.selModel = Ext.create('HreRem.view.common.CheckBoxModelBase');

    	me.callParent();

    	me.getSelectionModel().on({
        	'selectionchange': function(sm,record,e) {
        		me.fireEvent('persistedsselectionchange', sm, record, e, me, me.getPersistedSelection());
        	},
        	
        	'selectall': function(sm) {
        		me.getPlugin('pagingselectpersist').selectAll();
        	},
        	   	
        	'deselectall': function(sm) {
        		me.getPlugin('pagingselectpersist').deselectAll();
        	}
        });
    },

    getPersistedSelection: function() {
    	var me = this;
    	return me.getPlugin('pagingselectpersist').getPersistedSelection();     	
    },

    deselectAll: function() {
    	var me = this;
    	return me.getPlugin('pagingselectpersist').deselectAll();     		
    },

    mostrarEdicionGastos: function() {
    	var me = this;
    	me.up('administraciongastosmain').lookupReference('btnAutorizarGastos').setDisabled(false);
    	me.up('administraciongastosmain').lookupReference('btnRechazarGastos').setDisabled(false);
    },

    ocultarEdicionGastos: function() {
    	var me = this;
    	me.up('administraciongastosmain').lookupReference('btnAutorizarGastos').setDisabled(true);
    	me.up('administraciongastosmain').lookupReference('btnRechazarGastos').setDisabled(true);
    },

    mostrarExportarGastos: function() {
    	var me = this;
    	me.up('administraciongastosmain').lookupReference('btnExportarGastosAgrupacion').setDisabled(false);
    }
});