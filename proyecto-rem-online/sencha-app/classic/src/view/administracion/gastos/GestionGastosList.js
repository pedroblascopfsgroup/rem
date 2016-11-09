Ext.define('HreRem.view.administracion.gastos.GestionGastosList', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'gestiongastoslist',
    requires: ['HreRem.view.administracion.gastos.AnyadirNuevoGasto','HreRem.view.common.CheckBoxModelBase', 'HreRem.ux.plugin.PagingSelectionPersistence'],
	bind: {
       	store: '{gastosAdministracion}'
    },
    plugins: 'pagingselectpersist',
    listeners:{
       rowdblclick: 'onClickAbrirGastoProveedor'
    },
    
    initComponent: function() {
    	
    	var me = this;
    	      	
      	var configAddBtn = {iconCls:'x-fa fa-plus', itemId:'addButton', handler: 'onClickAdd', scope: this};
      	var labelSeleccionados = {xtype: 'displayfieldbase', itemId: 'displaySelection'/*, cls: 'logo-headerbar'*/};
		var configAutorizarBtn = {text: HreRem.i18n('btn.autorizar'), cls:'tbar-grid-button', itemId:'autorizarBtn', handler: 'onClickAutorizar', disabled: true};
		var configRechazarButton = {text: HreRem.i18n('btn.rechazar') , cls:'tbar-grid-button', itemId:'rechazarBtn', handler: 'onClickRechazar', disabled: true};
		var separador = {xtype: 'tbfill'};
		var espacio = {xtype: 'tbspacer'};
			
		me.tbar = {
    		xtype: 'toolbar',
    		dock: 'top',
    		items: [configAddBtn, separador, labelSeleccionados, espacio, configAutorizarBtn, configRechazarButton]
		};
      	
    	me.columns = [
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
	    	                    	 dataIndex: 'importeTotal'
	    	                     },
	    	                     {
	    	                     	text: HreRem.i18n('header.fecha.tope.pago.gasto'),
	    	                     	flex: 0.4,
	    	                    	dataIndex: 'fechaTopePago',
	    	                    	formatter: 'date("d/m/Y")'	
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
	    	                    	 dataIndex: 'destinatarioDescripcion'
	    	                     },
	    	                     {
	    	                     	text: HreRem.i18n('header.estado'),
	    	                     	flex: 0.4,
	    	                     	dataIndex: 'estadoGastoDescripcion'
	    	                     },
	    	                     {
	    	                     	
	    	                     	width: 30,
	    	                     	menuDisabled: true,
	    	                     	hideable: false,
	    	                     	dataIndex: 'tieneDocAdjuntos',
	    	                     	renderer: function(tieneDocAdjuntos) {
	    	                     		var css = "";
	    	                     		if(tieneDocAdjuntos) {
	    	                     			css = "x-fa fa-paperclip";
	    	                     		}
	    	                     		
	    	                     		return "<div class='"+css+"'></div>"
	    	                     	}
	    	                     	
	    	                     }
		];
		
		me.dockedItems= [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            displayInfo: true,
		            bind: {
		                store: '{gastosAdministracion}'
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
    
    onClickAdd: function (btn) {
		var me = this;
		me.fireEvent("onClickAddGasto", me);
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