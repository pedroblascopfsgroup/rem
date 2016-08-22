Ext.define('HreRem.view.activos.comercial.visitas.VisitasController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.visitas',
    
    requires: ['HreRem.view.activos.comercial.visitas.VisitasDetalle', 'HreRem.model.Visita'],


    	// Funcion que se ejecuta al hacer click en el botón de añadir visita
        onAddClick: function(btn) {
        	var me = this; 
        	// Abrimos el formulario con una visita vacia
        	me.abrirFormularioEdicionVisita(Ext.create("HreRem.model.Visita", {idActivo: me.getViewModel().get("idActivo")}));       	
        },
        
        // Funcion que se ejecuta al hacer click en el botón de editar visita
        onEditClick: function(btn) {

        	var me = this,
        	seleccion = btn.up('grid').getSelection();
        	
        	if(Ext.isArray(seleccion) && seleccion.length != 1) {
        		Ext.Msg.show({
				    message: 'Es obligatorio seleccionar un único registro.',
				    buttons: Ext.Msg.YES,
				    icon: Ext.Msg.WARNING}); 
        	} else {
        		// Abrimos el formulario con la visita seleccionada
        		me.abrirFormularioEdicionVisita(seleccion[0]);  
        	}        
        },
        
            	// Funcion que se ejecuta al hacer click en el botón de eliminar visita/es
        onDeleteClick: function(btn) {
        	
        	var me = this,
        	seleccionados = btn.up('grid').getSelection(),
        	gridStore = me.lookupReference("visitaslist").getStore();
        	
        	if(Ext.isArray(seleccionados) && seleccionados.length != 0) {
				
				Ext.Msg.show({
				    title:'Eliminar registros',
				    message: '¿Está seguro que desea eliminar los registros seleccionados?',
				    buttons: Ext.Msg.YESNO,
				    icon: Ext.Msg.QUESTION,
				    fn: function(btn) {
				        if (btn === 'yes') {
				        	
				        	// Eliminamos todas las visitas seleccionadas
				        	Ext.Array.each(seleccionados, function(seleccion, index) {
        						gridStore.remove(seleccion);
        					});
				        }
				    }
				});  
        	}
        },
        
        abrirFormularioEdicionVisita: function (visita) {

	        var me = this,
	        winFormVisita = Ext.create(HreRem.view.activos.comercial.visitas.VisitasDetalle,{altaVisita:  Ext.isEmpty(visita.get("id"))});
	        winFormVisita.down('form').loadRecord(visita);
	        winFormVisita.show();
	        me.getView().add(winFormVisita);	        
        },
        
        onSaveClick: function(button) {
        	
        	var me = this,
        	form = me.lookupReference("formVisitasDetalle"),
        	window = me.lookupReference("windowVisitaDetalle"),
        	record;  

        	form.updateRecord();        	
        	record = form.getRecord();
        	if(window.altaVisita) {
        		me.lookupReference("visitaslist").getStore().add(record);
        	}
        	me.getView().remove(window);
        	window.destroy();

        },
        
        onCancelClick: function(button) {
        	
        	var me = this;
        	
        	Ext.Msg.show({
			    title:'Cancelar edición',
			    message: '¿Está seguro que desea cerrar la ventana?',
			    buttons: Ext.Msg.YESNO,
			    icon: Ext.Msg.QUESTION,
			    fn: function(btn) {
			        if (btn === 'yes') {
			            button.up("window").destroy();
			        }
			    }
			});    	
        	
        },     
        
        getFechaActual: function() {
        	
        	var today = new Date();
        	var dd = today.getDate();
        	var mm = today.getMonth()+1; //January is 0!
        	var yyyy = today.getFullYear();

        	if(dd<10) {
        	    dd='0'+dd;
        	} 

        	if(mm<10) {
        	    mm='0'+mm;
        	} 

        	today = dd+'/'+mm+'/'+yyyy;
        	//document.write(today);
        	return today;

        }
    	
});