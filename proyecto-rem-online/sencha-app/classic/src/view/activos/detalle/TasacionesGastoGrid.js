Ext.define('HreRem.view.gastos.detalle.TasacionesgastoGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'tasacionesgastogrid',
	topBar		: true,
	targetGrid	: 'tasacionesgasto',
	requires		: ['HreRem.model.TasacionesGasto'],
	editOnSelect: false,

    bind: {
        store: '{storeTasacionesGasto}'
    },
    
    listeners: {
    	boxready: function() {
    		var me = this;
    		me.evaluarEdicion();
    	},
    	rowdblclick: 'onTasacionesDobleClick'
    },

    initComponent: function () {

     	var me = this;
     	
     	me.deleteSuccessFn = function(){
    		this.getStore().load()
    		this.setSelection(0);
    	},
     	
     	me.deleteFailureFn = function(){
    		this.getStore().load()
    	},

		me.columns = [
				{
					text: 'Id Relacion',
					dataIndex: 'id',
					hidden: true,
					hideable: false
				},
				{   text: HreRem.i18n('header.listado.tasacion.id'),
					dataIndex: 'idTasacion',
		        	flex: 1
				},
				{
					text: HreRem.i18n('fieldlabel.gasto.id.gasto.haya'),
					hidden: true,
					dataIndex: 'numGastoHaya'
				},
				{	  
		            text: HreRem.i18n('fieldlabel.id.activo.haya'),
		            dataIndex: 'numActivo',
		            flex: 1
				},
				{   text: HreRem.i18n('header.listado.tasacion.externo.bbva'),
		        	dataIndex: 'idTasacionExt',
		        	flex: 1
				},
				{   text: HreRem.i18n('fieldlabel.codigo.firma.tasacion'),
		        	dataIndex: 'codigoFirmaTasacion',
		        	flex: 1
				},
				{
					text: HreRem.i18n('fieldlabel.fecha.rec.tasacion'),
					dataIndex: 'fechaRecepcionTasacion',
		        	formatter: 'date("d/m/Y")',
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
		                store: '{storeTasacionesGasto}'
		            }
		        }
		    ];
		    
		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('datosgeneralesgasto').funcionRecargar();
		    	return true;
		    },
		    
		    me.saveFailureFn = function() {
		    	var me = this;
		    	me.up('datosgeneralesgasto').funcionRecargar();
		    	return true;
		    },

		    me.callParent();
   },
	
	onAddClick: function(btn){
		
		var me = this;
        var gasto = me.up('{viewModel}').getViewModel().get("gasto");
        Ext.create("HreRem.view.gastos.SeleccionTasacionesGasto",{gasto: gasto, parent: btn.up('formBase')}).show();

   },
  
   evaluarEdicion: function() {
		var me = this;

		if(CONST.TIPO_GASTO['SERVICIOS_PROFESIONALES_INDEPE'] != me.tipoGasto) {
			me.setTopBar(false);
		}
   }

});
