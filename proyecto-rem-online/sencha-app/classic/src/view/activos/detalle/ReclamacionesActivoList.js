Ext.define('HreRem.view.activos.detalle.ReclamacionesActivoList', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'reclamacionesactivolist',
    bind: {
        store: '{storeReclamacionesActivo}'
    },
    listeners:{
        beforeedit: 'onBeforeEditReclamacionesActivo'
    },
    initComponent: function () {
        
        var me = this;  
        
        me.columns= [
		        {
		            dataIndex: 'fechaAviso',
		            text: HreRem.i18n('header.fecha.aviso'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		        	dataIndex: 'fechaReclamacion',
		            text: HreRem.i18n('header.fecha.reclamacion'),
		            formatter: 'date("d/m/Y")',
		            editor: {
		           	 xtype:'datefield',
		           	 allowBlank: false		         
		           	},		           	
		            flex: 1
		        }
        ];   
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'reclamacionesactivolistPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeReclamacionesActivo}'
		            }
		        }
		];
        
	    me.callParent();
	        
        
    }

});