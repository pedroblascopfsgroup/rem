Ext.define('HreRem.view.administracion.gastos.GestionGastosList', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'gestiongastoslist',
    requires: ['HreRem.view.administracion.gastos.AnyadirNuevoGasto','HreRem.view.common.CheckBoxModelBase', 'HreRem.ux.plugin.PagingSelectionPersistence'],
	bind: {
       	store: '{gastosAdministracion}'
    },
    loadAfterBind: false,    
    plugins: 'pagingselectpersist',
    listeners:{
       rowdblclick: 'onClickAbrirGastoProveedor'
    },

    initComponent: function() {

      var me = this;

      	var configAddBtn = {iconCls:'x-fa fa-plus', itemId:'addButton', handler: 'onClickAdd', scope: this, secFunPermToRender: 'CREAR_GASTO'};
		var configAutorizarBtn = {text: HreRem.i18n('btn.autorizar'), cls:'tbar-grid-button', itemId:'autorizarBtn', handler: 'onClickAutorizar', disabled: true, secFunPermToRender: 'OPERAR_GASTO'};
		var configRechazarButton = {text: HreRem.i18n('btn.rechazar') , cls:'tbar-grid-button', itemId:'rechazarBtn', handler: 'onClickRechazar', disabled: true, secFunPermToRender: 'OPERAR_GASTO'};
		var configAutorizarContaBtn = {text: HreRem.i18n('btn.autorizar.contabilidad'), cls:'tbar-grid-button', itemId:'autorizarContBtn', handler: 'onClickAutorizarContabilidad', disabled: true, secFunPermToRender: 'BOTONES_GASTOS_CONTABILIDAD'};
		var configRechazarContabilidadButton = {text: HreRem.i18n('btn.rechazar.contabilidad') , cls:'tbar-grid-button', disabled: true, itemId:'rechazarContabilidadBtn', handler: 'onClickRechazarContabilidad', secFunPermToRender: 'BOTONES_GASTOS_CONTABILIDAD'};
		var separador = {xtype: 'tbfill'};

		me.tbar = {
    		xtype: 'toolbar',
    		dock: 'top',
    		items: [configAddBtn, separador, configAutorizarBtn, configRechazarButton, configAutorizarContaBtn, configRechazarContabilidadButton]
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
	    	                    	 renderer: Utils.rendererCurrency,
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
	    	                    	 dataIndex: 'destinatarioNombreDoc'
	    	                     },
	    	                     {
	    	                     	text: HreRem.i18n('header.estado'),
	    	                     	flex: 0.4,
	    	                     	dataIndex: 'estadoGastoDescripcion'
	    	                     },
	    	                     {
	    	                     	text: HreRem.i18n('header.sujeto.impuesto.indirecto'),
	    	                     	flex: 0.4,
	    	                     	dataIndex: 'sujetoImpuestoIndirecto'
		    	                 },
		    	                 {
	    	                     	text: HreRem.i18n('header.nombre.gestoria'),
	    	                     	flex: 1,
	    	                     	dataIndex: 'nombreGestoria'
		    	                 },
		    	                 {
	    	                     	text: HreRem.i18n('fieldlabel.cartera'),
	    	                     	flex: 0.5,
	    	                     	dataIndex: 'entidadPropietariaDescripcion'
		    	                 },
		    	                 {
	    	                     	text: HreRem.i18n('fieldlabel.motivo.rechazo'),
	    	                     	flex: 0.5,
	    	                     	dataIndex: 'motivoRechazo'
		    	                 },
		    	                 {
	    	                     	text: HreRem.i18n('fieldlabel.motivo.rechazo.prop'),
	    	                     	flex: 0.5,
	    	                     	dataIndex: 'motivoRechazoProp'
			    	             },{
                             width: 30,
                             menuDisabled: true,
                             hideable: false,
                             dataIndex: 'alertas',
                             renderer: function(alertas) {
                               var css = "";
                               if(alertas) {
                                 css = "x-fa fa-exclamation-circle";
                               }
                               return "<div style='color:#E0840C;'' class='"+css+"'></div>"
                             }
                           },
	    	                     {
	    	                     	width: 30,
	    	                     	menuDisabled: true,
	    	                     	hideable: false,
	    	                     	dataIndex: 'existeDocumento',
	    	                     	renderer: function(existeDocumento) {
	    	                     		var css = "";
	    	                     		if(existeDocumento) {
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
		            },
		            items:[
			            	{
			            		xtype: 'tbfill'
			            	},
			                {
			                	xtype: 'displayfieldbase',
			                	itemId: 'displaySelection',
			                	fieldStyle: 'color:#0c364b; padding-top: 4px'
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
