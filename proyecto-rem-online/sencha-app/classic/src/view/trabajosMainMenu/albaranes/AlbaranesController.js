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
		var gridAlbaran = this.lookupReference('albaranGrid');
		var listaDetalleAlbaran = this.lookupReference('detalleAlbaranGrid');
		var boton = me.lookupReference('botonValidarAlbaran');
		
		if(!Ext.isEmpty(grid.selection)){
			listaDetalleAlbaran.getStore().getProxy().setExtraParams({'numAlbaran':record.data.numAlbaran});
			listaDetalleAlbaran.getStore().load();
			me.calcularTotal(gridAlbaran,"albaranGrid",record);
			me.habilitarAlbaran(listaDetalleAlbaran,boton,record);
		} else {
			me.deselectAlbaran(grid);
		}
		
	},
	
	deselectAlbaran: function(grid){
		var me = this;
		var gridAlbaran = this.lookupReference('albaranGrid');
		var listaDetalleAlbaran = this.lookupReference('detalleAlbaranGrid');
		var listaTrabajos = this.lookupReference('detallePrefacturaGrid');
		
		this.lookupReference('botonValidarAlbaran').setDisabled(true);
		this.lookupReference('botonValidarPrefactura').setDisabled(true);
		this.lookupReference('botonValidarTrabajo').setDisabled(true);
		this.lookupReference('totalAlbaran').setValue(0);
		this.lookupReference('totalPrefactura').setValue(0);
		listaDetalleAlbaran.getStore().getProxy().setExtraParams(null);
		listaTrabajos.getStore().getProxy().setExtraParams(null);
		listaDetalleAlbaran.getStore().removeAll();
		listaTrabajos.getStore().removeAll();
	},
	
	onPrefacturaClick: function(grid, record){
		var me = this;
		var gridDetalleAlbaran = this.lookupReference('detalleAlbaranGrid');
		var listaDetallePrefactura = this.lookupReference('detallePrefacturaGrid');
		var boton = this.lookupReference('botonValidarPrefactura');
		
		if(!Ext.isEmpty(grid.selection)){
			listaDetallePrefactura.getStore().getProxy().setExtraParams({'numPrefactura':record.data.numPrefactura});
			listaDetallePrefactura.getStore().load();
			me.calcularTotal(gridDetalleAlbaran,"detalleAlbaranGrid",record)
			me.habilitarPrefactura(boton,record);
		} else {
			me.deselectPrefactura(grid);
		}
		
	},
	
	deselectPrefactura: function(grid){
		var me = this;
		var gridDetalle = this.lookupReference('detalleAlbaranGrid');
		var listaTrabajos = this.lookupReference('detallePrefacturaGrid');
		this.lookupReference('botonValidarPrefactura').setDisabled(false);
		this.lookupReference('botonValidarTrabajo').setDisabled(true);
		this.lookupReference('totalPrefactura').setValue(0);
		listaTrabajos.getStore().getProxy().setExtraParams(null);
		listaTrabajos.getStore().removeAll();
	},
	
	calcularTotal: function(grid,descripcion,record){
		if(descripcion == "detalleAlbaranGrid"){
			var valor = 0;
			if(record.data.importeTotalClienteDetalle > 0){
				valor = record.data.importeTotalClienteDetalle;
			}else{
				valor = record.data.importeTotalDetalle;
			}
			var totalPre = this.lookupReference('totalPrefactura');
			totalPre.setValue(valor);
		}
		if(descripcion == "albaranGrid"){
			var valorAlb = 0;
			if(record.data.importeTotalCliente > 0){
				valorAlb = record.data.importeTotalCliente;
			}else{
				valorAlb = record.data.importeTotal;
			}
			var totalAlb = this.lookupReference('totalAlbaran');
			totalAlb.setValue(valorAlb);
		}
	},
	
	onCheckChangeIncluirTrabajo: function(columna,rowIndex,checked,record){
		var me = this;
		var valorAlb = 0;
		var valor = 0;
		//Se puede modificar el check sin seleccionar la fila , para eso es este codigo
		if(this.lookupReference('detallePrefacturaGrid').selection == null){
			this.lookupReference('detallePrefacturaGrid').setSelection(me.lookupReference('detallePrefacturaGrid').getStore().getData().items[rowIndex]);
		}
		var rowTrabajo = this.lookupReference('detallePrefacturaGrid').selection;
		var rowDetalleAlbaran = this.lookupReference('detalleAlbaranGrid').selection;
		var rowAlbaran = this.lookupReference('albaranGrid').selection;
		if(checked){
			rowAlbaran.data.importeTotal = parseFloat(rowAlbaran.data.importeTotal) + parseFloat(rowTrabajo.data.importeTotalPrefactura);
			rowAlbaran.data.importeTotalCliente = parseFloat(rowAlbaran.data.importeTotalCliente) + parseFloat(rowTrabajo.data.importeTotalClientePrefactura);
			rowDetalleAlbaran.data.importeTotalDetalle = parseFloat(rowDetalleAlbaran.data.importeTotalDetalle) + parseFloat(rowTrabajo.data.importeTotalPrefactura);
			rowDetalleAlbaran.data.importeTotalClienteDetalle = parseFloat(rowDetalleAlbaran.data.importeTotalClienteDetalle) + parseFloat(rowTrabajo.data.importeTotalClientePrefactura);
			rowTrabajo.data.checkIncluirTrabajo = false;
			me.lookupReference('detallePrefacturaGrid').getStore().getData().items[rowIndex].data.checkIncluirTrabajo = false;
		}else{
			rowAlbaran.data.importeTotal = rowAlbaran.data.importeTotal - rowTrabajo.data.importeTotalPrefactura;
			rowAlbaran.data.importeTotalCliente = rowAlbaran.data.importeTotalCliente - rowTrabajo.data.importeTotalClientePrefactura;
			rowDetalleAlbaran.data.importeTotalDetalle = rowDetalleAlbaran.data.importeTotalDetalle - rowTrabajo.data.importeTotalPrefactura;
			rowDetalleAlbaran.data.importeTotalClienteDetalle = rowDetalleAlbaran.data.importeTotalClienteDetalle - rowTrabajo.data.importeTotalClientePrefactura;
			rowTrabajo.data.checkIncluirTrabajo = true;
			me.lookupReference('detallePrefacturaGrid').getStore().getData().items[rowIndex].data.checkIncluirTrabajo=true;
		}
		if(rowAlbaran.data.importeTotalCliente > 0){
			valorAlb = rowAlbaran.data.importeTotalCliente;
		}else{
			valorAlb = rowAlbaran.data.importeTotal;
		}
		var totalAlb = this.lookupReference('totalAlbaran');
		totalAlb.setValue(valorAlb);
		this.lookupReference('albaranGrid').getView().refresh();
		if(rowDetalleAlbaran.data.importeTotalClienteDetalle > 0){
			valor = rowDetalleAlbaran.data.importeTotalClienteDetalle;
		}else{
			valor = rowDetalleAlbaran.data.importeTotalDetalle;
		}
		var totalPre = this.lookupReference('totalPrefactura');
		totalPre.setValue(valor);
		this.lookupReference('detalleAlbaranGrid').getView().refresh();
		
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
		             text: '¡ Atención ! Una vez validado un albarán, no se podrá excluir ningún trabajo de ninguna prefactura incluido en él',
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
		    			Ext.MessageBox.alert('Error en la validacion','Ha habido un error validando el albarán seleccionado');
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
		var iterador = 0;
		var gridDetalle = button.previousSibling("[reference='detalleAlbaranGrid']");
		var numPrefactura = gridDetalle.selection.data.numPrefactura;
		var itemTrabajos = this.lookupReference('detallePrefacturaGrid').getStore().getData().items;
		var lista = [];
		for(iterador = 0; iterador < itemTrabajos.length; iterador++){
			lista.push(this.lookupReference('detallePrefacturaGrid').getStore().getData().items[iterador].getData())
		}
		var listaString = JSON.stringify(lista);
		var win = new Ext.window.Window({
			 border: true,
			 closable: false,
			 width: 400,
		     title: 'Advertencia',
		     layout: 'hbox',
		     items: [
		    	 {
		             xtype: 'label',
		             text: '¡ Atención ! Una vez validada una prefactura no se podrá editar dicha prefactura',
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
		    			  params:  {id : numPrefactura,
		    				  		lista : listaString},
		    			  success: function(response,opts){
		    				  Ext.MessageBox.alert('Prefactura Validada','Se ha validado la prefactura de forma correcta');
		    				  win.close();
		    				  gridDetalle.getStore().load();
		    				  this.lookupReference('albaranGrid').getStore().load();
		    				  this.lookupReference('detallePrefacturaGrid').getStore().removeAll();
		    			  }
		    			  
		    		    });
		    		}else{
		    			Ext.MessageBox.alert('Error en la validacion','Ha habido un error validando la prefactura seleccionada');
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
		             text: '!Atención! Una vez validada una prefactura, se excluirán de la misma todos aquellos trabajos sin incluir y no se podrá editar dicha prefactura',
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
		    			Ext.MessageBox.alert('Error en la validacion','Ha habido un error validando la prefactura seleccionada');
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
   
	habilitarAlbaran : function(grid,boton,record){
		var me = this; 
		
		if(record.data.estadoAlbaran == "Validado"){
			boton.setDisabled(true);
		}else{
			var store = grid.getStore();
			if(store == null || store.getData().length < 1){
				boton.setDisabled(true);
			}else{
				for(var i =0 ; i< store.getData().items.length; i++){
					if(store.getData().items[i].data.estadoAlbaran != CONST.ESTADOS_PREFACTURAS['VALIDADO']){
						boton.setDisabled(true);
						break;
					}
				}
				boton.setDisabled(false);
			}
		}
	},
	
	habilitarPrefactura : function(boton,record){
		var me = this;
		var botondos = this.lookupReference('botonValidarTrabajo');
		if(record.data.estadoAlbaran == CONST.ESTADOS_PREFACTURAS['VALIDADO']){
			boton.setDisabled(true);
			botondos.setDisabled(true);
		}else{botondos
			boton.setDisabled(false);
			botondos.setDisabled(false);
		}
	}

});