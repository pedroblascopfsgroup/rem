Ext.define('HreRem.view.administracion.gastos.GastoRefacturadoGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'gastoRefacturadoGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,

	
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
		    		reference: 'isGastoRefacturabl2',
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
    }
});
