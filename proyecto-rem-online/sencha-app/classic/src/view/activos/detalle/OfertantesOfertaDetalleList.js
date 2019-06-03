Ext.define('HreRem.view.activos.detalle.OfertantesOfertaDetalleList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'ofertantesofertadetallelist',
    reference	: 'ofertanteslistdetalleofertaref',
	topBar		: false,
	idPrincipal : 'oferta.id',
    bind		: {
        store: '{storeOfertantesOfertaDetalle}'
    },

    initComponent: function () {

     	var me = this;

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