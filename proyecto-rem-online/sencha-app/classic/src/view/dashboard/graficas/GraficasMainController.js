Ext.define('HreRem.view.dashboard.graficas.GraficasMainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.graficasmaincontroller',
   
	    
	init : function() {
		this.control({
		
			'graficasmainwidget combobox' : {
				change : this.onChangeGraphic
			},
			
			'graficasmainwidgetgestor combobox' : {
				change : this.onChangeGraphic
			}
		});
		this.getView().down('combobox');
	},
	
	
	
	onChangeGraphic: function( cmp, newValue, oldValue ) {
	        var view = this.getView();
	        view.getLayout().setActiveItem(newValue);
    }

});