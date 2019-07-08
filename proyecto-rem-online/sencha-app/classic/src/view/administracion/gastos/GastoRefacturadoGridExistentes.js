Ext.define('HreRem.view.administracion.gastos.GastoRefacturadoGridExistentes', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'gastoRefacturadoGridExistentes',
	topBar		: true,
	editOnSelect: false,
	disabledDeleteBtn: true,
	targetGrid	: 'gastoRefacturadoGridExistentes',
	idPrincipal : 'numeroDeGastoRefacturable',
	bind:{
		store:'{storeGastosRefacturablesExistentes}'
	},
	
    initComponent: function () {

     	var me = this;
     	
     	
		me.columns = [
				{ 
		    		xtype: 'checkcolumn', 
		    		dataIndex: 'isGastoRefacturableExistente',
		    		reference: 'isGastoRefacturableExistente',
		    		name:'isGastoRefacturable'		    		
	    		},
		        {
		            dataIndex: 'numeroGastoRefacturableExistente',
		            reference: 'numeroDeGastoRefacturable',
		            name:'numeroDeGastoRefacturableExistente',
		            text: HreRem.i18n('fieldlabel.gastos.a.refacturar'),
		            flex: 0.7
		           
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
	                store: '{storeGastosRefacturablesExistentes}'
	            }
	        }
	    ];


		    me.callParent();
    },
    
	onAddClick: function(btn){
    	
		var me = this;
	
        

    }
    
});
