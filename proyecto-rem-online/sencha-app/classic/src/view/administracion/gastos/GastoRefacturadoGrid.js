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
		    		reference: 'isGastoRefacturable'
	    		},
		        {
		            dataIndex: 'idGasto',
		            reference: 'numeroDeGastoRefacturable',
		            //text: HreRem.i18n('title.publicaciones.mediador.fechaDesde'),
		            flex: 0.7         
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
