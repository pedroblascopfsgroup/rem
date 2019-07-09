Ext.define('HreRem.view.administracion.gastos.GastoRefacturadoGridExistentes', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'gastoRefacturadoGridExistentes',
	topBar		: true,
	editOnSelect: false,
	disabledDeleteBtn: false,
	removeButton: true,
	targetGrid	: 'gastoRefacturadoGridExistentes',
	idPrincipal : 'numeroDeGastoRefacturable',
	bind:{
		store:'{storeGastosRefacturablesExistentes}'
	},
	
    initComponent: function () {
 
     	var me = this;
     	
     	
		me.columns = [
		        {
		            dataIndex: 'numeroGastoHaya',
		            reference: 'numeroDeGastoRefacturable',
		            name:'numeroDeGastoRefacturableExistente',
		            text: HreRem.i18n('fieldlabel.gastos.a.refacturar'),
		            flex: 0.7
		           
		        }
		    ];
		    
		 me.selModel = {
		          selType: 'checkboxmodel',
		          mode: 'SINGLE'
		      	}; 
		 
	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'activosPaginationToolbar',
	            inputItemWidth: 60,
	            displayInfo: true,
	            bind: {
	                store: '{storeGastosRefacturablesExistentes}'
	            }
	        }
	    ];


		    me.callParent();
    },
    
	onAddClick: function(btn){
    	
		var me = this;
		var idGasto = me.lookupController().getViewModel().getData().gasto.id;
		
		Ext.create('HreRem.view.gastos.AnyadirNuevoGastoRefacturado',{idGasto: idGasto}).show();
	

        

    }
    
  /*  onDeleteClick: function(btn){
    	var me = this;
    }
    */
    
});
