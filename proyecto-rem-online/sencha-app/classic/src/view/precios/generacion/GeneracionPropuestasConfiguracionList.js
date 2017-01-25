Ext.define('HreRem.view.precios.generacion.GeneracionPropuestasConfiguracionList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'generacionpropuestasconfiguracionlist',
    topBar		: true,
    editOnSelect: true,
    idPrincipal : 'id',
	bind		: {
		store: '{configuracionGeneracionPropuestas}'
	},

	listeners: {
		'beforeedit': function(editor) {
			var me = this;

        	//Si ya estamos editando o no estamos creando un registro nuevo ni se permiete la edición.
        	if (editor.editing || (!editor.isNew && !me.editOnSelect)) {
        		return false;
        	}

        	if(!editor.isNew) {
        		// En modo actualización no se permite editar los campos cartera, tipo propuesta e indicador condición.
        		me.up('preciosmain').lookupReference('cbColCartera').setDisabled(true);
        		me.up('preciosmain').lookupReference('cbColTipoPropPrecio').setDisabled(true);
        		me.up('preciosmain').lookupReference('cbColIndicadorCondicion').setDisabled(true);

        		me.up('preciosmain').lookupReference('cbColMenorQue').setDisabled(false);
        		me.up('preciosmain').lookupReference('cbColMayorQue').setDisabled(false);
        		me.up('preciosmain').lookupReference('cbColIgualQue').setDisabled(false);
        	} else {
        		// Si el registro es nuevo habilitar  los campos de nuevo y deshabilitar hasta su uso los campos de condicionantes.
        		me.up('preciosmain').lookupReference('cbColCartera').setDisabled(false);
        		me.up('preciosmain').lookupReference('cbColTipoPropPrecio').setDisabled(false);
        		me.up('preciosmain').lookupReference('cbColIndicadorCondicion').setDisabled(false);

        		me.up('preciosmain').lookupReference('cbColMenorQue').setDisabled(true);
        		me.up('preciosmain').lookupReference('cbColMayorQue').setDisabled(true);
        		me.up('preciosmain').lookupReference('cbColIgualQue').setDisabled(true);
        	}
        }
	},

    initComponent: function () {
     	var me = this;

     	me.setTitle(HreRem.i18n('title.precios.generacion.propuestas.grid'));

	    me.columns = [
	    
	    		{
	    			dataIndex: 'idRegla',
	    			text	 : HreRem.i18n('fieldlabel.proveedores.id'),
	    			flex	 : 0.3,
	    			hidden	 : true
	    		},
	            {
		     		xtype	: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('preciosmain').getViewModel().getStore('comboCartera').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
			        dataIndex: 'carteraCodigo',
			        text	 : HreRem.i18n('header.entidad.propietaria'),
		            flex	 : 0.4,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboCartera}'
			            },
			            reference: 'cbColCartera',
			            chainedStore: '{comboIndicadorCondicionPrecioFiltered}',
						chainedReference: 'cbColIndicadorCondicion',
			            listeners: {
			            	select: 'onChangeCarteraChainedCombo'
			            }
			        }
		 		},
		 		{
		     		xtype	: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('preciosmain').getViewModel().getStore('comboTipoPropuestaPrecio').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
			        dataIndex: 'propuestaPrecioCodigo',
			        text	 : HreRem.i18n('header.propuesta.precio'),
		            flex	 : 0.7,
	            	editor	 : {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboTipoPropuestaPrecio}'
			            },
			            reference: 'cbColTipoPropPrecio'
			        }
		 		},
		 		{
		     		xtype	: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('preciosmain').getViewModel().getStore('comboIndicadorCondicionPrecio').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
			        dataIndex: 'indicadorCondicionCodigo',
			        text	 : HreRem.i18n('header.indicador.condicion'),
		            flex	 : 3.5,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboIndicadorCondicionPrecioFiltered}'
			            },
			            reference: 'cbColIndicadorCondicion',
			            listeners: {
			            	select: 'onChangeIndicadorCondicionPrecio'
			            }
			        }
		 		},
		 		{
		 			dataIndex: 'menorQueText',
		            text: HreRem.i18n('header.menorQue'),
		            flex: 0.9,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 50,
			            reference: 'cbColMenorQue',
			            disabled: true,
			            validator: function(value){
		        			return this.up('preciosmain').getController().validateCamposRellenos(value);
		        	    }
		            }
		 		},
		 		{
		 			dataIndex: 'mayorQueText',
		            text: HreRem.i18n('header.mayorQue'),
		            flex: 0.9,
		            editor: {
		            	xtype: 'textfield',
		            	disabled: true,
		            	maxLength: 50,
			            reference: 'cbColMayorQue',
			            validator: function(value){
		        			return this.up('preciosmain').getController().validateCamposRellenos(value);
		        	    }
		            }
		 		},
		 		{
		 			dataIndex: 'igualQueText',
		            text: HreRem.i18n('header.igualQue'),
		            flex: 0.9,
		            editor: {
		            	xtype: 'textfield',
		            	disabled: true,
		            	maxLength: 50,
			            reference: 'cbColIgualQue',
			            validator: function(value){
		        			return this.up('preciosmain').getController().validateCamposRellenos(value);
		        	    }
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
	                store: '{configuracionGeneracionPropuestas}'
	            }
	        }
	    ];

	    me.callParent();
    }
});