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
        
        var labelSeleccionados = {xtype: 'displayfieldbase', itemId: 'displaySelection'};
		var configAutorizarBtn = {text: HreRem.i18n('btn.autorizar'), cls:'tbar-grid-button', itemId:'autorizarBtn', handler: 'onClickAutorizarGastosAgrupados', hidden: $AU.userIsRol(CONST.PERFILES['PROVEEDOR']),  disabled: true};
		var configRechazarButton = {text: HreRem.i18n('btn.rechazar') , cls:'tbar-grid-button', itemId:'rechazarBtn', handler: 'onClickRechazarGastosAgrupados', hidden: $AU.userIsRol(CONST.PERFILES['PROVEEDOR']), disabled: true};
		var separador = {xtype: 'tbfill'};
		var espacio = {xtype: 'tbspacer'};
			
		me.tbar = {
    		xtype: 'toolbar',
    		reference: 'tbarprovisiongastoslist',
    		dock: 'top',
    		items: [separador, labelSeleccionados, espacio, configAutorizarBtn, configRechazarButton]
		};
        
        me.listeners = {	    	
    		rowdblclick: 'onClickAbrirGastoProveedor'
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
		            }
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
    }



});

