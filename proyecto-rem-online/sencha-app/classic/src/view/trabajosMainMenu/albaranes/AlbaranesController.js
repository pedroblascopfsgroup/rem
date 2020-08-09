Ext.define('HreRem.view.trabajosMainMenu.albaranes.AlbaranesController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.albaranes',
    
  //Funcion que se ejecuta al hacer click en el botón buscar
	onSearchClick: function(btn) {
		
		var initialData = {};

		var searchForm = btn.up('formBase');
		
		if (searchForm.isValid()) {
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});

			this.lookupReference('albaraneslist').down("[reference='albaranGrid']").getStore().loadPage(1);
        }
	},
	
	
	paramLoading: function(store, operation, opts) {
		
		var initialData = {};
		
		var searchForm = this.lookupReference('albaranessearch');
		if (searchForm.isValid()) {
			
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});	
		
			store.getProxy().extraParams = criteria;
			
			return true;
		}
	},	
	
	// Funcion que se ejecuta al hacer click en el botón limpiar
	onCleanFiltersClick: function(btn) {
		//Limpia los grid
		btn.up("[reference='albaranessearch']").nextSibling().down("[reference='albaranGrid']").getStore().removeAll();
		btn.up("[reference='albaranessearch']").nextSibling().down("[reference='detalleAlbaranGrid']").getStore().removeAll();
		btn.up("[reference='albaranessearch']").nextSibling().down("[reference='detallePrefacturaGrid']").getStore().removeAll();
		
		//Setear los botones a disabled
		btn.up("[reference='albaranessearch']").nextSibling().down("[reference='botonValidarAlbaran']").setDisabled(true);
		btn.up("[reference='albaranessearch']").nextSibling().down("[reference='botonValidarPrefactura']").setDisabled(true);
		btn.up("[reference='albaranessearch']").nextSibling().down("[reference='botonValidarTrabajo']").setDisabled(true);
		
		//Limpia la botonera de filtrado.
		btn.up('panel').getForm().reset();
			
	},
	
	onAlbaranClick: function(grid, record){
		var me = this;
		var gridAlbaran = grid.up("[reference='albaranGrid']");
		var listaDetalleAlbaran = gridAlbaran.nextSibling().nextSibling("[reference='detalleAlbaranGrid']");
		gridAlbaran.nextSibling("[reference='botonValidarAlbaran']").setDisabled(false);
		
		if(!Ext.isEmpty(grid.selection)){
			var totalAlb = listaDetalleAlbaran.nextSibling().nextSibling().nextSibling();
			listaDetalleAlbaran.getStore().getProxy().setExtraParams({'numAlbaran':record.data.numAlbaran});
			listaDetalleAlbaran.getStore().load();
			if(!Ext.isEmpty(record.data.numAlbaran)){
    		    var url = $AC.getRemoteUrl('albaran/getTotalAlbaran');
    		    Ext.Ajax.request({
    			  url:url,
    			  params:  {numAlbaran : record.data.numAlbaran},
    			  success: function(response,opts){
    				  totalAlb.setValue(null);
    				  var split = response.responseText.split(',');
  				  	  var valor = split[2].split(':');
  				  	  var total = valor[1].replace(/[&\/\\#+()$~%'":*?<>{}]/g, '');
    				  totalAlb.setValue(total);
    			  }
    			  
    		    });
			}
		} else {
			me.deselectAlbaran(grid);
		}
		
	},
	
	deselectAlbaran: function(grid){
		var me = this;
		var gridAlbaran = grid.view.up("[reference='albaranGrid']");
		var listaDetalleAlbaran = gridAlbaran.nextSibling().nextSibling("[reference='detalleAlbaranGrid']");
		var listaTrabajos = listaDetalleAlbaran.nextSibling().nextSibling("[reference='detallePrefacturaGrid']");
		
		gridAlbaran.nextSibling().setDisabled(true);
		listaDetalleAlbaran.nextSibling().setDisabled(true);
		listaTrabajos.nextSibling().nextSibling().nextSibling().setDisabled(true);
		listaDetalleAlbaran.getStore().getProxy().setExtraParams(null);
		listaTrabajos.getStore().getProxy().setExtraParams(null);
		listaDetalleAlbaran.getStore().removeAll();
		listaTrabajos.getStore().removeAll();
	},
	
	onPrefacturaClick: function(grid, record){
		var me = this;
		var gridAlbaran = grid.up("[reference='detalleAlbaranGrid']");
		var listaDetallePrefactura = gridAlbaran.nextSibling().nextSibling("[reference='detallePrefacturaGrid']");
		gridAlbaran.nextSibling("[reference='botonValidarPrefactura']").setDisabled(false);
		
		if(!Ext.isEmpty(grid.selection)){
			var totalPre = listaDetallePrefactura.nextSibling().nextSibling();
			listaDetallePrefactura.getStore().getProxy().setExtraParams({'numPrefactura':record.data.numPrefactura});
			listaDetallePrefactura.getStore().load();
			if(!Ext.isEmpty(record.data.numPrefactura)){
    		    var url = $AC.getRemoteUrl('albaran/getTotalPrefactura');
    		    Ext.Ajax.request({
    			  url:url,
    			  params:  {numPrefactura : record.data.numPrefactura},
    			  success: function(response,opts){
    				  	totalPre.setValue(null);
    				  	var split = response.responseText.split(',');
    				  	var valor = split[1].split(':');
    				  	var total = valor[1].replace(/[&\/\\#+()$~%'":*?<>{}]/g, '');
//    				  	totalPre.getStore().getProxy().setExtraParams({'numPrefactura':record.data.numPrefactura});
//    					totalPre.getStore().load();
    					totalPre.setValue(total);
    			  }
    			  
    		    });
			}
//			totalPre.getStore().removeAll();
//			totalPre.getStore().getProxy().setExtraParams({'numPrefactura':record.data.numPrefactura});
//			totalPre.getStore().load();
//			totalPre.setValue(totalPre.getStore().getData().items[0].data.totalPrefactura);
		} else {
			me.deselectPrefactura(grid);
		}
		
	},
	
	deselectPrefactura: function(grid){
		var me = this;
		var gridDetalle = grid.view.up("[reference='detalleAlbaranGrid']");
		var listaTrabajos = gridDetalle.nextSibling().nextSibling("[reference='detallePrefacturaGrid']");
		gridDetalle.nextSibling("[reference='botonValidarPrefactura']").setDisabled(false);
		listaTrabajos.nextSibling().nextSibling().nextSibling().setDisabled(true);
		listaTrabajos.getStore().getProxy().setExtraParams(null);
		listaTrabajos.getStore().removeAll();
	},
	
	validaAlbaranes: function(button) {

		var me = this;
		var gridAlbaran = button.previousSibling("[reference='albaranGrid']");
		var numAlbaran = gridAlbaran.selection.data.numAlbaran;
		
		var win = new Ext.window.Window({
			 border: true,
			 closable: false,
			 width: 400,
		     title: 'Advertencia',
		     layout: 'hbox',
		     items: [
		    	 {
		             xtype: 'label',
		             text: '! Atención ! Una vez validado un albarán, no se podrá excluir ningún trabajo de ninguna prefactura incluido en él',
		             labelStyle: 'font-weight:bold;',
		             style: 'margin: 15px 25px 20px 25px'
		         }
		 
		     ],
		     buttons: [{
		        xtype: 'button',
		        name: 'aceptarBoton',
		        text: 'Aceptar',
		        handler: function() {
		        	if(!Ext.isEmpty(numAlbaran)){
		    		    var url = $AC.getRemoteUrl('albaran/comprobarValidarAlbaran');
		    		    Ext.Ajax.request({
		    			  url:url,
		    			  params:  {id : numAlbaran},
		    			  success: function(response,opts){
		    				  Ext.MessageBox.alert('Albaran Validado','Se ha validado el albaran de forma correcta');
		    				  gridAlbaran.getStore().load();
		    			  }
		    			  
		    		    });
		    		}else{
		    			Ext.MessageBox.alert('Error en la validacion','Ha habido un error validando el albaran seleccionado');
		    		}
		        	win.close();
		        }			
		    },{
		        xtype: 'button',
		        name: 'cancelarBoton',
		        text: 'Cancelar',
		        handler: function() {
		            win.close();
		        }
		    }]
		});
		win.show();
		
	},
	
	validaPrefacturas: function(button) {

		var me = this;
		var gridDetalle = button.previousSibling("[reference='detalleAlbaranGrid']");
		var numPrefactura = gridDetalle.selection.data.numPrefactura;

		var win = new Ext.window.Window({
			 border: true,
			 closable: false,
			 width: 400,
		     title: 'Advertencia',
		     layout: 'hbox',
		     items: [
		    	 {
		             xtype: 'label',
		             text: '! Atención ! Una vez validada una prefactura no se podrá editar dicha prefactura',
		             labelStyle: 'font-weight:bold;',
		             style: 'margin: 15px 25px 20px 25px'
		         }
		 
		     ],
		     buttons: [{
		        xtype: 'button',
		        name: 'aceptarBotonPrefactura',
		        text: 'Aceptar',
		        handler: function() {
		        	if(!Ext.isEmpty(numPrefactura)){
		    		    var url = $AC.getRemoteUrl('albaran/comprobarValidarPrefactura');
		    		    Ext.Ajax.request({
		    			  url:url,
		    			  params:  {id : numPrefactura},
		    			  success: function(response,opts){
		    				  Ext.MessageBox.alert('Prefactura Validada','Se ha validado la prefactura de forma correcta');
		    				  gridDetalle.getStore().load();
		    				  gridDetalle.previousSibling().previousSibling().getStore().load();
		    				  var listaTrabajos = gridDetalle.nextSibling().nextSibling("[reference='detallePrefacturaGrid']").getStore().removeAll();
		    				  win.close();
		    			  }
		    			  
		    		    });
		    		}else{
		    			Ext.MessageBox.alert('Error en la validacion','Ha habido un error validando el albaran seleccionado');
		    		}
		        }			
		    },{
		        xtype: 'button',
		        name: 'cancelarBoton',
		        text: 'Cancelar',
		        handler: function() {
		            win.close();
		        }
		    }]
		});
		win.show();
		
	},
	
	validaTrabajos: function(button) {

		var me = this;
		
		var gridAlbaran = me.up().previousSibling("[reference='albaranGrid']");
		
		if(Ext.isEmpty(idActivo)){
		    var url = $AC.getRemoteUrl('albaran/getIdActivoTarea');
		    Ext.Ajax.request({
			  url:url,
			  params:  {numAlbaran : me.getView().idTarea},
			  success: function(response,opts){
				  
				  idActivo = Ext.JSON.decode(response.responseText).idActivoTarea;
				  
				  me.getView().fireEvent('abrirDetalleActivoPrincipal', idActivo, button.reflinks);

			  }
			  
		    });
		}else{
			  me.getView().fireEvent('abrirDetalleActivoPrincipal', idActivo, button.reflinks);
			  button.up('window').unmask();
		}
	}
   

});