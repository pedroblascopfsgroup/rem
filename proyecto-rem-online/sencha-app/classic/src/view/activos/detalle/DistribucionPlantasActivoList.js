Ext.define('HreRem.view.activos.detalle.DistribucionPlantasActivoList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'distribucionplantasactivolist',
	topBar		: false,
	editOnSelect: false,
	idPrincipal : 'activo.id',
	
	features: [{
        ftype: 'grouping',
        groupHeaderTpl: 'Planta {[values.rows[0].data.numPlanta]} ({rows.length} estancia{[values.rows.length > 1 ? "s" : ""]})',
        hideGroupedHeader: true,
        startCollapsed: true,
        enableGroupingMenu: false,
        id: 'distribucionGrouping'
    }],			
	
    bind: {
        store: '{storeDistribuciones}'
    },
    
    initComponent: function () {
        
        var me = this; 
        
        
        me.columns= [
        
				{   
					width: 150
				},
				{   text: HreRem.i18n('header.estancia'),
					dataIndex: 'tipoHabitaculoDescripcion',
					flex:2
				},
				{   text: HreRem.i18n('header.cantidad'),
					dataIndex: 'cantidad',
					flex:1 
				},	
				{   text: HreRem.i18n('header.superficie'), 
					renderer: Ext.util.Format.numberRenderer('0,000.00'),														        	
					dataIndex: 'superficie',
					flex:1
				}       
		        
        ]; 
		
        me.callParent(); 
        
    }

});