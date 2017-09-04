Ext.define('HreRem.view.activos.detalle.HonorariosOfertaDetalleList', {
    extend		: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype		: 'honorariosofertadetallelist',
    reference	: 'honorarioslistdetalleofertaref',
	topBar		: false,
	idPrincipal : 'oferta.id',
    bind		: {
        store: '{storeHonorariosOfertaDetalle}'
    },

    initComponent: function () {

     	var me = this;

     	me.features = [{
            id: 'summary',
            ftype: 'summary',
            hideGroupedHeader: true,
            enableGroupingMenu: false,
            dock: 'bottom'
		}];
		
		me.columns = [
		        {
		        	dataIndex: 'id',
		        	text: HreRem.i18n('fieldlabel.proveedores.id'),
		        	flex:0.4,
		        	hidden:true
		        },
		        {
		        	dataIndex: 'descripcionTipoComision',
		        	text: HreRem.i18n('fieldlabel.tipoComision'),
		        	flex:1
		        },
		        {
		        	dataIndex: 'tipoProveedor',
		        	text: HreRem.i18n('fieldlabel.tipo.proveedor'),
		        	flex:1,
		        	renderer: function(value, cell, record){
		        		if(!Ext.isEmpty(value) && value.length != 0){
		        			return value;
		        		}
		        		return '-';
		        	}
		        },
		        {
		        	dataIndex: 'proveedor',
		        	text: HreRem.i18n('header.personas.contacto.nombre'),
		        	flex:2,
		        	renderer: function(value, cell, record){
		        		if(!Ext.isEmpty(value) && value.length != 0){
		        			return value;
		        		}
		        		return '-';
		        	}
		        },
		        {
		        	dataIndex: 'tipoCalculo',
		        	text: HreRem.i18n('header.oferta.detalle.tipo.calculo'),
		        	flex:1
		        },
		        {
		        	xtype: 'numbercolumn',
		        	dataIndex: 'importeCalculo',
		        	text: HreRem.i18n('header.oferta.detalle.importe.calculo'),
		        	flex:1,
		        	renderer: function(value, cell, record) {
		        		var codigoTipoCalculo = record.get("codigoTipoCalculo");
		        		if(!Ext.isEmpty(value)){
			        		if(!Ext.isEmpty(codigoTipoCalculo)){
			        			if(codigoTipoCalculo=='01'){
			        				return value+' %';
			        			}
			        			else{
			        				return value;
			        			}
			        		}
		        		}
		        		else{
		        			if(!Ext.isEmpty(codigoTipoCalculo)){
			        			if(codigoTipoCalculo=='01'){
			        				return '0.0 %';
			        			}
			        			else{
			        				return '0';
			        			}
			        		}
		        		}
		        		
		        	}
		        },
		        {
		        	dataIndex: 'honorarios',
		        	text: HreRem.i18n('title.horonarios'),
		        	flex:1,
		        	renderer: function(value, cell, record) {
		        		if(!Ext.isEmpty(value) && value != '0.0'){
		        			return Utils.rendererCurrency(value);
		        		}
		        		else{
		        			return '0.00'+' \u20AC';
		        		}
		        	},
		            summaryType: 'sum',
	            	summaryRenderer: function(value, summaryData, dataIndex) {
		            	var suma = 0;
		            	var store = this.up('honorariosofertadetallelist').store;
		            	for(var i=0; i< store.data.length; i++){	            		
		            		if(store.data.items[i].data.honorarios != null){
		            			suma += parseFloat(store.data.items[i].data.honorarios);
		            		}
		            	}
		            	suma = Ext.util.Format.number(suma, '0.00');
		            	var msg = HreRem.i18n("grid.honorarios.total.honorarios") + " " + suma + " \u20AC";		
		            	return msg;
		            }
		        }
	    ];

	    /*me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'activosPaginationToolbar',
	            inputItemWidth: 60,
	            displayInfo: true,
	            bind: {
	                store: '{storeHonorariosOfertaDetalle}'
	            }
	        }
	    ];*/

	    me.callParent();
   }
});