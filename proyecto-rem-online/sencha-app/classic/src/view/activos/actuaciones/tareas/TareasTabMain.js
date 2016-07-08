//Ext.define('HreRem.view.activos.actuaciones.tareas.TareasTabMain', {
//    extend		: 'Ext.panel.Panel',
//    xtype		: 'tareastabmain',
//	layout : {
//		type : 'vbox',
//		align : 'stretch'
//	},   
//	scrollable	: 'y',
//    closable	: false,/*        
//    requires: [    
//        'HreRem.view.activos.actuaciones.tareasActivas.TareasActivasList',
//        'HreRem.view.activos.actuaciones.tareasActivas.TareasController',
//        'HreRem.view.activos.actuaciones.tareasActivas.TareasActivasModel'
//    ],*/
//    
//    
//   	controller: 'actuacion',
//    /*viewModel: {
//        type: 'tareas'
//    },*/
//    
//    isHistorico: false,
//   	
//    initComponent: function () {
//    	
//        var me = this;
//        
//        if(me.isHistorico) {
//        	
//        	me.items = [
//
//					{
//						xtype: "historicotareaslist"
//					}
//        	      
//        	] 
//        	
//        	
//        } else {
//        	
//        	me.items = [
//
//					{
//						xtype: "tareaslist"
//					}
//        	      
//        	] 
//        	
//        	
//        	
//        }
//        
//        
//
//        
//        me.callParent();
//        
//    }
//});