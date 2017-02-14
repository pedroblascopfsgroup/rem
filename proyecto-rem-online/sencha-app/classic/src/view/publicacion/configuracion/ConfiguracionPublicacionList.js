Ext.define('HreRem.view.publicacion.configuracion.ConfiguracionPublicacionList', {
    extend: 'HreRem.view.common.GridBaseEditableRow',
    xtype: 'configuracionpublicacionlist',
    topBar: true,
    editOnSelect: false,
    idPrincipal : 'id',

	bind: {
		store: '{configuracionpublicacion}'
	},

    initComponent: function () {

     	var me = this;

     	me.setTitle(HreRem.i18n('title.configuracion.publicacion.grid'));

	    me.columns = [
	    
	    		{
	    			dataIndex: 'idRegla',
	    			text	 : HreRem.i18n('fieldlabel.proveedores.id'),
	    			flex	 : 0.4,
	    			hidden	 : true
	    		},
	            {
		     		xtype	: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('publicacionmain').getViewModel().getStore('comboCartera').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
			        dataIndex: 'carteraCodigo',
			        text	 : HreRem.i18n('header.entidad.propietaria'),
		            flex	 : 0.8,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboCartera}'
			            },
			            reference: 'cbColCartera'
			        }
		 		},
		 		{
		     		xtype	: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('publicacionmain').getViewModel().getStore('comboSiNoRem').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
			        dataIndex: 'incluidoAgrupacionAsistida',
			        text	 : HreRem.i18n('fieldlabel.agrupacion.asistida'),
		            flex	 : 1,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboSiNoRem}'
			            },
			            reference: 'cbColAgrupacionAsistida'
			        }
		 		},
		 		{
		     		xtype	: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('publicacionmain').getViewModel().getStore('comboTipoActivo').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
			        dataIndex: 'tipoActivoCodigo',
			        text	 : HreRem.i18n('header.activos.publicacion.tipo'),
		            flex	 : 1,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboTipoActivo}'
			            },
			            reference: 'cbColTipoActivo',
		            	publishes: 'value'
			        }
		 		},
		 		{
		     		xtype	: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('publicacionmain').getViewModel().getStore('comboSubtipoActivo').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
			        dataIndex: 'subtipoActivoCodigo',
			        text	 : HreRem.i18n('header.activos.publicacion.subtipo'),
		            flex	 : 1.5,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboSubtipoActivo}',
			            	disabled: '{!cbColTipoActivo.value}',
			                filters: {
			                	property: 'codigoTipoActivo',
			                	value: '{cbColTipoActivo.value}'
			                }
			            },
			            reference: 'cbColSubtipoActivo'
			        }
		 		}
	        ];
	        
	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'activosPaginationToolbar',
	            displayInfo: true,
	            bind: {
	                store: '{configuracionpublicacion}'
	            }
	        }
	    ];

	    me.callParent();
    }
});