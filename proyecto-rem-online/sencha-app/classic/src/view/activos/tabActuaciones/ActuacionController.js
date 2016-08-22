Ext.define('HreRem.view.activos.actuaciones.ActuacionController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.actuacion',

    
	// Funcion que abre la ventana de resolver tarea
	abrirFormularioEdicionTarea: function (tarea) {
		 
	        var me = this;
	        var window;
	        if(tarea.get("idTipoTarea") == "sp300"){
	        	window = Ext.create('HreRem.view.activos.actuacion.tareas.forms.VerificarOferta');

	        }else if(tarea.get("idTipoTarea") == "sp303"){
	        	window = Ext.create('HreRem.view.activos.actuacion.tareas.forms.PropuestaComite');
	        	
	        }else if(tarea.get("idTipoTarea") == "sp304"){
	        	window = Ext.create('HreRem.view.activos.actuacion.tareas.forms.ResolucionComite');
	        
	        }else if(tarea.get("idTipoTarea") == "sp306"){
	        	window = Ext.create('HreRem.view.activos.actuacion.tareas.forms.ContraofertarCliente');
	        
	        }else{
	        	Ext.Msg.show({
				    message: 'Tarea no implementada.',
				    buttons: Ext.Msg.YES,
				    icon: Ext.Msg.WARNING}); 
	        }

	        if(window){
		        window.down('form').loadRecord(tarea);
		        window.show();
		        me.getView().add(window);	    
	        }
     },
	
    
     
	// Funcion que se ejecuta al hacer doble click sobre una tarea del hostorico de tareas  
	onEditDblClick: function(btn) {

    	var me = this,
    	seleccion = btn.up('grid').getSelection();
    	
    	if(Ext.isArray(seleccion) && seleccion.length != 1) {
    		Ext.Msg.show({
			    message: 'Es obligatorio seleccionar un único registro.',
			    buttons: Ext.Msg.YES,
			    icon: Ext.Msg.WARNING}); 
    	} else {
    		// Abrimos el formulario con la visita seleccionada
    		me.abrirFormularioEdicionTarea(seleccion[0]);  
    	}        
    },   
    
	onClickBotonFavoritos: function(btn) {
		var me = this,			
		tabpanel = btn.up('tabpanel');
		
		tabpanel.fireEvent('marcarfavorito', tabpanel, btn)
		
		
	}
   
    
});