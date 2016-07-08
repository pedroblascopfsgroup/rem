Ext.define('HreRem.view.dashboard.taskMeter.TaskMeterController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.taskmetercontroller',
   
    
    onButtonTareasClick: function( cmp, record, item, index, e ) {
    	
    	var me = this;

    	var view = me.getView();
    	
    	view.fireEvent("abriragenda", record);
    }
	    

});