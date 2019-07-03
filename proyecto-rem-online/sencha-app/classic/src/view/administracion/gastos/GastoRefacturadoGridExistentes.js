Ext.define('HreRem.view.administracion.gastos.GastoRefacturadoGridExistentes', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'gastoRefacturadoGridExistentes',
	topBar		: true,
	editOnSelect: false,
	disabledDeleteBtn: true,
	bind:{
		store:'gastosRefacturablesExistentes'
	},
	
    initComponent: function () {

     	var me = this;
     	
     	
		me.columns = [
				{
					dataIndex: 'idCombo',
					reference: 'idComboGastosRefacturados',
		            hidden: true
				},
				{ 
		    		xtype: 'checkcolumn', 
		    		dataIndex: 'gastoRefacturable',
		    		reference: 'isGastoRefacturable',
		    		name:'isGastoRefacturable'

		    		
	    		},
		        {
		            dataIndex: 'idGasto',
		            reference: 'numeroDeGastoRefacturable',
		            name:'numeroDeGastoRefacturable',
		            text: HreRem.i18n('fieldlabel.gastos.a.refacturar'),
		            flex: 0.7,
		            
		    			value: '{gastoNuevo.numeroDeGastoRefacturable}'
		    		
		        }
		    ];


		/*    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('informecomercialactivo').funcionRecargar();
		    	return true;
		    },*/

		    me.callParent();
    },
    
	onAddClick: function(btn){
    	
		var me = this;
	
        

    }
    
});
