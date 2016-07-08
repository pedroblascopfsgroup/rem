Ext.define('HreRem.ux.window.geolocalizacion.GeolocalizacionController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.geolocalizacion',
    
    onClickGuardarCoordenadas: function(btn) {
    	
    	var me =this,
    	longitud = me.getViewModel().get("longitud"),
    	latitud = me.getViewModel().get("latitud");
    	
    	me.getView().fireEvent("actualizarCoordenadas", me.getView().parent, latitud, longitud);
    	
    	btn.up("window").destroy();    	
    }
	
});