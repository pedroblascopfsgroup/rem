Ext.define('HreRem.view.dashboard.activosCalientes.ActivosCalientesController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.activoscalientescontroller',
    
    
	onEnlaceActivosClick: function( cmp, record, item, index, e ) {

    	var me = this;

    	var view = me.getView();
    	
    	view.fireEvent("abriractivo", record);
    }
	    


});