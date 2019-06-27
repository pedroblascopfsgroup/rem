Ext.define('HreRem.view.administracion.gastos.GastoRefacturadoGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'gastoRefacturadoGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,

	  bind: {
	        store: '{storeGastosRefacturables}'
	    },
 
    initComponent: function () {

     	var me = this;

		me.columns = [
				{
					dataIndex: 'idCombo',
		            hidden: true
				},
		        {
		            dataIndex: 'idGasto',
		            //text: HreRem.i18n('title.publicaciones.mediador.fechaDesde'),
		            flex: 0.7         
		        },{ 
		    		xtype: 'checkcolumn', 
		    		dataIndex: 'gastoRefacturable' 
	    		}
		    ];

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true
		         
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
