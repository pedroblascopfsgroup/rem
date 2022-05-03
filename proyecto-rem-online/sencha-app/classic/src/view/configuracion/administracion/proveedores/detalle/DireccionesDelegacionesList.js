Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.DireccionesDelegacionesList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'direccionesdelegacioneslist',
    reference	: 'direccionesdelegacioneslistref',
	topBar		: true,
	idPrincipal : 'proveedor.id',

    bind		: {
        store: '{direccionesDelegaciones}'
    },

    initComponent: function () {
     	var me = this;

     	me.listeners = {
     			rowclick: 'onDireccionesDelegacionesGridClick',
     			deselect: 'onDireccionesDelegacionesGridDeselect',
     			beforeedit: function(editor, gridNfo) {
     				var grid = this;
				    var gridColumns = grid.headerCt.getGridColumns();

				    for (var i = 0; i < gridColumns.length; i++) {
					    if (gridColumns[i].dataIndex == 'localidadCodigo') {
					    	var comboEditor = this.columns && this.columns[i].getEditor ? this.columns[i].getEditor() : this.getEditor ? this.getEditor():null;
		     				if(!Ext.isEmpty(comboEditor)){
		     					comboEditor.setDisabled(true);
		     				}
					    }
				    }
     			}
     	};

		me.columns = [
		        {
		        	dataIndex: 'id',
		        	text: HreRem.i18n('fieldlabel.proveedores.id'),
		        	collapsible: true,
		        	colspan: 3, 
		        	hidden:false
		        },
		        {
		        	xtype: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
			            var store =  this.up('proveedoresdetallemain').getViewModel().getStore('comboTipoDireccionProveedor');
			        	if(store.isLoading()) {
			        		store.on('load', function(store, items){
			        			var grid = me.up('proveedoresdetallemain').lookupReference('direccionesdelegacioneslistref');
			        			if(Ext.isEmpty(grid)){
			        				grid = me;
			        			}
            		       		grid = grid.getView();
            		       		grid.refreshNode(rowIndex);
            		       	});
			        	}
			            var foundedRecord = store.findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
		        	dataIndex: 'tipoDireccion',
		            text: HreRem.i18n('fieldlabel.tipo'),
		            flex: 1,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            allowBlank: false,
			            bind: {
			            	store: '{comboTipoDireccionProveedor}'
			            },
			            reference: 'cbDDColTipoDireccion'
			        }
		        },
		        {
		        	xtype: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
			            var foundedRecord = this.up('proveedoresdetallemain').getViewModel().getStore('comboSiNoRem').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
		            dataIndex: 'localAbiertoPublicoCodigo',
		            text: HreRem.i18n('header.direccion.delegacion.local.abierto'),
		            flex: 1,
		            bind: {
			        	hidden: '{!proveedor.isMediador}'
			        },
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboSiNoRem}'
			            },
			            reference: 'cbDDColLocalAbiertoPublico'
			        }
		        },
		        {
		            dataIndex: 'referencia',
		            text: HreRem.i18n('header.direccion.delegacion.referencia'),
		            flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maskRe: /[0-9]/,
		            	stripCharsRe: /[^0-9]/,
		            	maxLength: 50
		            }
		        },
		        {
		        	xtype: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
			        	var store =  this.up('proveedoresdetallemain').getViewModel().getStore('comboTipoVia');
			        	if(store.isLoading()) {
			        		store.on('load', function(store, items){
			        			var grid = me.up('proveedoresdetallemain').lookupReference('direccionesdelegacioneslistref');
			        			if(Ext.isEmpty(grid)){
			        				grid = me;
			        			}
            		       		grid = grid.getView();
            		       		grid.refreshNode(rowIndex);
            		       	});
			        	}
			            var foundedRecord = store.findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
		        	dataIndex: 'tipoViaCodigo',
		            text: HreRem.i18n('fieldlabel.tipo.via'),
		            flex: 1,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            allowBlank: false,
			            bind: {
			            	store: '{comboTipoVia}'
			            },
			            reference: 'cbDDColTipoVia'
			        }
		        },
		        {
		            dataIndex: 'nombreVia',
		            text: HreRem.i18n('fieldlabel.nombre.via'),
		            flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	allowBlank: false,
		            	maxLength: 100
		            }
		        },
		        {
		            dataIndex: 'numeroVia',
		            text: HreRem.i18n('header.numero'),
		            flex: 0.5,
		            editor: {
		            	xtype: 'textfield',
		            	maskRe: /[0-9]/,
		            	stripCharsRe: /[^0-9]/,
		            	maxLength: 5
		            }
		        },
		        {
		        	dataIndex: 'piso',
		        	text: HreRem.i18n('fieldlabel.proveedores.piso'),
		        	flex:0.5,
		        	editor: {
		            	xtype: 'textfield',
		            	maskRe: /[0-9]/,
		            	stripCharsRe: /[^0-9]/,
		            	maxLength: 5
		            }
		        },
		        {
		            dataIndex: 'puerta',
		            text: HreRem.i18n('fieldlabel.puerta'),
		            flex: 0.5,
		            editor: {
		            	xtype: 'textfield',
		            	maskRe: /[0-9]/,
		            	stripCharsRe: /[^0-9]/,
		            	maxLength: 5
		            }
		        },
		        {
		        	xtype: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
			            var foundedRecord = this.up('proveedoresdetallemain').getViewModel().getStore('comboFiltroProvincias').findRecord('codigo', value);
			            var me = this;
        		       	var comboEditor = me.columns && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor():null;
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        		if(Ext.isEmpty(metaData.lastValue)) {
			        			metaData.lastValue = value;
			        			comboEditor.setValue(foundedRecord.getData().codigo);
			        		}
			        	}
			            return descripcion;
			        },
		        	dataIndex: 'provincia',
		            text: HreRem.i18n('fieldlabel.proveedores.provincia'),
		            flex: 1,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboFiltroProvincias}'
			            },
			            reference: 'cbDDColProvincia',
			            chainedStore: me.storeMunicipios,
						chainedReference: 'cbDDColMunicipio',
						editable: false,
						allowBlank: false,
						queryMode: 'local',
						enableKeyEvents:true,
						listeners: {
					        keyup: 'onChangeProvinciaChainedCombo'
						},
						listConfig: {
					        listeners: {
					            itemclick: 'onChangeProvinciaChainedCombo'
					        }
					    }
			        }
		        },
		        {
		        	xtype: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
			        	var me = this;

        		       	var store = me.up('proveedoresdetallemain').getViewModel().getStore('comboFiltroMunicipios');
        		       	if(!Ext.isEmpty(store)) {
            		       	if(store.isLoaded()) {
            		       		store.clearFilter();
            		       		var record = store.findRecord("codigo", value);
	            		       	if(!Ext.isEmpty(record)) {
	            		       		if(!(metaData.lastValue instanceof Array)) {
	            		       			metaData.lastValue = Ext.Array;
	            		       		}
	            		       		metaData.lastValue[rowIndex] = record.getData().descripcion;
	            		       		return record.getData().descripcion;
	            		       	} else {
	            		       		if(Ext.isDefined(metaData.lastValue) && (metaData.lastValue instanceof Array)) {
	            		       			return metaData.lastValue[rowIndex] ? metaData.lastValue[rowIndex] : null;
	            		       		} else {
	            		       			return value;
	            		       		}
	            		       	}
            		       	} else {
            		       		if(!store.isLoading()){
            		       			store.load();
            		       		}
            		       		store.on('load', function(store, items){
	            		       		var grid = me.up('proveedoresdetallemain').lookupReference('direccionesdelegacioneslistref');
				        			if(Ext.isEmpty(grid)){
				        				grid = me;
				        			}
	            		       		grid = grid.getView();
	            		       		grid.refreshNode(rowIndex);
	            		       	});
            		       	}
        		       	}
			        	return value;
			        },
		        	dataIndex: 'localidadCodigo',
		            text: HreRem.i18n('header.direcciones.delegaciones.localidad'),
		            flex: 1,
		            editor: {
			            xtype: 'comboboxfieldbase',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboFiltroMunicipios}'
			            },
			            allowBlank: false,
			            editable: false,
			            addUxReadOnlyEditFieldPlugin: false,
			            reference: 'cbDDColMunicipio'
			        }
		        },
		        {
		            dataIndex: 'codigoPostal',
		            text: HreRem.i18n('fieldlabel.proveedores.cp'),
		            flex: 0.5,
		            editor: {
		            	xtype: 'textfield',
		            	maskRe: /[0-9]/,
		            	stripCharsRe: /[^0-9]/,
		            	maxLength: 5
		            }
		        },
		        {
		            dataIndex: 'telefono',
		            text: HreRem.i18n('header.telefono'),
		            flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 20
		            }
		        },
		        {
		            dataIndex: 'email',
		            text: HreRem.i18n('header.email'),
		            flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	vtype: 'email',
		            	maxLength: 50
		            }
		        },
		        {
		            dataIndex: 'otros',
		            text: HreRem.i18n('fieldlabel.proveedores.otros'),
		            flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	allowBlank: false,
		            	maxLength: 100
		            }
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
		                store: '{direccionesDelegaciones}'
		            }
		        }
		    ];
		    
		    me.callParent();
   }

});