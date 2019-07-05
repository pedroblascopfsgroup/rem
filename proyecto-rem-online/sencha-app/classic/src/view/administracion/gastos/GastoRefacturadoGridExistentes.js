Ext.define('HreRem.view.administracion.gastos.GastoRefacturadoGridExistentes', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'gastoRefacturadoGridExistentes',
	topBar		: true,
	editOnSelect: false,
	disabledDeleteBtn: true,
	targetGrid	: 'gastoRefacturadoGridExistentes',
	idPrincipal : 'idGasto',
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
		            dataIndex: 'idGastoRefacturable',
		            reference: 'numeroDeGastoRefacturable',
		            name:'numeroDeGastoRefacturable',
		            text: HreRem.i18n('fieldlabel.gastos.a.refacturar'),
		            editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'gastosproveedor/getGastosRefacturablesGastoCreado',
								extraParams: {idGasto : 'detalleeconomico.idGasto'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
		            flex: 0.7
		            
		    		//value: '{gastoNuevo.numeroDeGastoRefacturable}'
		    		
		        }
		    ];
		    
		   


		    me.callParent();
    },
    
	onAddClick: function(btn){
    	
		var me = this;
	
        

    }
    
});
