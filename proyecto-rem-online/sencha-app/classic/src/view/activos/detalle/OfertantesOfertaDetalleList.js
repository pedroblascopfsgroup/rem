Ext.define('HreRem.view.activos.detalle.OfertantesOfertaDetalleList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'ofertantesofertadetallelist',
    reference	: 'ofertanteslistdetalleofertaref',
	topBar		: false,
	idPrincipal : 'oferta.id',
	controller : 'activodetalle',
    bind		: {
        store: '{storeOfertantesOfertaDetalle}'
    },

    initComponent: function () {
     	var me = this;
     	var isCarteraBk = me.getController().getViewModel().get('activo').get('isCarteraBankia');
     	
		me.columns = [
		        {
		        	dataIndex: 'id',
		        	text: HreRem.i18n('fieldlabel.proveedores.id'),
		        	flex:0.4,
		        	hidden:true
		        },
		        {
		        	dataIndex: 'tipoDocumento',
		        	text: HreRem.i18n('fieldlabel.tipoDocumento'),
		        	flex:0.5,
		        	renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboTipoDocumento').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
			        editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboTipoDocumento}'
			            },
			            validator: function(value){
		            		var me = this;
		            		return me.lookupController().validateTipoDocumento(value);
		            	},
			            reference: 'cbTipoDocumento'
			        }
		        },
		        {
		        	dataIndex: 'numDocumento',
		        	text: HreRem.i18n('header.numero.documento'),
		        	flex:1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 50,
		            	validator: function(value){
		            		var me = this;
		            		return me.lookupController().validateDocOfertante(value);
		            	}
		            }
		        },
		        {
		        	dataIndex: 'nombre',
		        	text: HreRem.i18n('header.nombre.razon.social'),
		        	flex:2
		        },
		        {
		        	dataIndex: 'tipoPersona',
		        	text: HreRem.i18n('fieldlabel.tipo.persona'),
		        	flex:2
		        },
		        {
		        	dataIndex: 'estadoCivil',
		        	text: HreRem.i18n('fieldlabel.estado.civil'),
		        	flex:2
		        },
		        {
		        	dataIndex: 'regimenMatrimonial',
		        	text: HreRem.i18n('header.regimen.matrimonial'),
		        	flex:2
		        },
		        {
		        	dataIndex: 'aceptacionOferta',
		        	text: HreRem.i18n('header.aceptacion.oferta'),
		        	flex:2
		        },{
					   xtype: 'actioncolumn',
				      flex: 1,
				      hideable: false,
				      text: HreRem.i18n('column.ofertantes.documento.identificativo'),
				        items: [{
				           	iconCls: 'ico-download',
				           	tooltip: "Documento Identificativo",
				            handler: function(grid, rowIndex, colIndex) {
				            	var record = grid.getRecord(rowIndex);
					            var grid = me;
					            var idDocumento = record.get('aDCOMIdDocumentoIdentificativo');			
					            grid.getController().downloadDocumentoAdjuntoOfertasController(grid, record, idDocumento);
		            		},
		            		isDisabled: function(view, rowIndex, colIndex, item, record) {
		                        if (record.get('aDCOMIdDocumentoIdentificativo') != null) {
		                        	return false
		                        }
		                        return true;
		                    }
				        }]
				   },{
					  xtype: 'actioncolumn',
				      flex: 1,
				      hideable: false,
				      text: HreRem.i18n('column.ofertantes.documento.gdpr'),
				        items: [{
				           	iconCls: 'ico-download',
				           	tooltip: "Documento GDPR",
				            handler: function(grid, rowIndex) {
				            	var record = grid.getRecord(rowIndex);
					            var grid = me;			
					            var idDocumento = record.get('aDCOMIdDocumentoGDPR');			
					            grid.getController().downloadDocumentoAdjuntoOfertasController(grid, record, idDocumento);
		            		},
		            		isDisabled: function(view, rowIndex, colIndex, item, record) {
		                        if (record.get('aDCOMIdDocumentoGDPR') != null) {
		                        	return false
		                        }
		                        return true;
		                    }
				        }]        
				   },{
			        	dataIndex: 'ADCOMIdDocumentoIdentificativo',
			        	text: HreRem.i18n('fieldlabel.proveedores.id'),
			        	flex:0.4,
			        	hidden:true
			        },{
			        	dataIndex: 'ADCOMIdDocumentoGDPR',
			        	text: HreRem.i18n('fieldlabel.proveedores.id'),
			        	flex:0.4,
			        	hidden:true
			        },{
			        	dataIndex: 'vinculoCaixaDesc',
			        	text: HreRem.i18n('fieldlabel.vinculo.caixa'),
			        	flex:1,
			        	hidden:!isCarteraBk
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
	                store: '{storeOfertantesOfertaDetalle}'
	            }
	        }
	    ];

	    me.callParent();
   }
});