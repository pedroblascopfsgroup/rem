Ext.define('HreRem.view.activos.detalle.HistoricoMediadorGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'historicomediadorgrid',
	topBar		: true,
	editOnSelect: false,
	disabledDeleteBtn: true,
	confirmBeforeSave: true,
	confirmSaveTxt: null,
	confirmSaveTit: null,

    bind: {
        store: '{storeHistoricoMediador}'
    },
    
    listeners: {
    	boxready: function() {
    		var me = this;
    		me.evaluarEdicion();
    	}
    },
    
    initComponent: function () {

     	var me = this;
     	
     	if(Ext.isEmpty(me.confirmSaveTit)){
     		me.confirmSaveTit = HreRem.i18n('title.comfirmar.nuevo.api');
     	}

		me.columns = [
		        {
		            dataIndex: 'fechaDesde',
		            text: HreRem.i18n('title.publicaciones.mediador.fechaDesde'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'fechaHasta',
		            text: HreRem.i18n('title.publicaciones.mediador.fechaHasta'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'codigo',
		            text: HreRem.i18n('title.publicaciones.mediador.codigo'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'mediador',
		            text: HreRem.i18n('title.publicaciones.mediador.mediador'),
		            editor: {
		            	xtype: 'combobox',
		            	allowBlank: false,
		            	reference: 'comboMediador',
		            	store: new Ext.data.Store({
							model: 'HreRem.model.ComboProveedorHistoricoMediadorModel',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'proveedores/getMediadoresActivos'
							},
							autoLoad: true
						}),
						displayField: 'nombre',
    					valueField: 'codigoProveedorRem',
    					enableKeyEvents: true,
    					minChars: 0,
						emptyText: 'Introduzca nombre mediador',
						listeners: {
							'keyup': function() {
								if(this.getRawValue().length >= 3){
							 		this.getStore().clearFilter();
							 		this.getStore().filter({
							 		    property: 'nombre',
							 		    value: this.getRawValue(),
							 		    anyMatch: true,
							 		    caseSensitive: false
							 		});
								}else if (this.getRawValue().length == 0) {
									this.getStore().clearFilter();
									this.getStore().load(); 												
								}
							},
							'beforequery': function(queryEvent) {
						 		queryEvent.combo.onLoad();
						 	},
						 	'focusleave': function(){
						 		this.getStore().clearFilter();
								this.getStore().load(); 
						 	}
						}
		            },
		            flex: 1
		        },
		        {
		            dataIndex: 'telefono',
		            text: HreRem.i18n('title.publicaciones.mediador.telefono'),
		            flex: 1
		        },
		        {
		        	dataIndex: 'email',
		            text: HreRem.i18n('title.publicaciones.mediador.email'),
		            flex: 1
		        },
		        {
		        	dataIndex: 'responsableCambio',
		            text: HreRem.i18n('header.responsable.cambio'),
		            flex: 1
		        },
		        {
		            dataIndex: 'rol',
		            text: HreRem.i18n('titulo.grid.mediador.rol'),
		            editor: {
		            	xtype: 'combobox',
		            	allowBlank: false,
		            	store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionarioRolesMediador'
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo',
			            listeners: {
			            	'change': function(){
			            		var me = this;
			            		var tipoApi;
				   				if(me.getValue() == "01"){
				   					tipoApi = " Primario ";
				   				} else if(me.getValue() == "02"){
				   					tipoApi = " Espejo ";
				   				}
			            		me.up().up().confirmSaveTxt = HreRem.i18n('cuerpo.confirmar.nuevo.api') + 
   									tipoApi + HreRem.i18n('cuerpo.confirmar.nuevo.api.dos');
			            	}
			            }
		            },
		            flex: 1
		        }
		    ];

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{storeHistoricoMediador}'
		            }
		        }
		    ];

		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('informecomercialactivo').funcionRecargar();
		    	return true;
		    },

		    me.callParent();
    },
    
    evaluarEdicion: function() {    	
 		var me = this;
 		if(me.lookupController().getViewModel().get('activo').get('unidadAlquilable')) {
 			me.setTopBar(false);
 		}
    }
});
