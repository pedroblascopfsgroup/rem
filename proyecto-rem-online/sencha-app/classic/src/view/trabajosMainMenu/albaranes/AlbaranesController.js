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

			this.lookupReference('detalleAlbaranGrid').getStore().removeAll();
			this.lookupReference('detallePrefacturaGrid').getStore().removeAll();
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
		this.lookupReference('totalAlbaran').setValue(0);
		this.lookupReference('totalPrefactura').setValue(0);
		this.lookupReference('detallePrefacturaGrid').data = [];
		//Limpia la botonera de filtrado.
		btn.up('panel').getForm().reset();
			
	},
	
	onAlbaranClick: function(grid, record){
		var me = this;
		var viewModel = me.getViewModel();
		var gridAlbaran = this.lookupReference('albaranGrid');
		var listaDetalleAlbaran = this.lookupReference('detalleAlbaranGrid');
		var listaTrabajos = this.lookupReference('detallePrefacturaGrid');
		listaTrabajos.data = [];
		var boton = me.lookupReference('botonValidarAlbaran');
		
		if(!Ext.isEmpty(grid.selection)){
//			viewModel.set("albaran", record);
//			viewModel.notify();
			listaDetalleAlbaran.getStore().getProxy().setExtraParams({
                numAlbaran: record.data.numAlbaran
            });
			listaDetalleAlbaran.getStore().load();
			listaTrabajos.getStore().removeAll();
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
		listaTrabajos.data = [];
	},
	
	onPrefacturaClick: function(grid, record){
		var me = this;
		var viewModel = me.getViewModel();
		var gridDetalleAlbaran = this.lookupReference('detalleAlbaranGrid');
		var listaDetallePrefactura = this.lookupReference('detallePrefacturaGrid');
		listaDetallePrefactura.data = [];
		var boton = this.lookupReference('botonValidarPrefactura');
		
		if(!Ext.isEmpty(grid.selection)){
//			viewModel.set("prefactura", record);
//			viewModel.notify();
			listaDetallePrefactura.getStore().getProxy().setExtraParams({
                numPrefactura: record.data.numPrefactura
            });
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
		listaTrabajos.data = [];
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
			totalPre.setValue(parseFloat(valor).toFixed(2));
		}
		if(descripcion == "albaranGrid"){
			var valorAlb = 0;
			if(record.data.importeTotalCliente > 0){
				valorAlb = record.data.importeTotalCliente;
			}else{
				valorAlb = record.data.importeTotal;
			}
			var totalAlb = this.lookupReference('totalAlbaran');
			totalAlb.setValue(parseFloat(valorAlb).toFixed(2));
		}
	},
	
	onCheckChangeIncluirTrabajo: function(columna,rowIndex,checked,record){
		var me = this;
		var valorAlb = 0;
		var valor = 0;
		var valorAlbC = 0;
		var valorC = 0;
		var totalAlb = this.lookupReference('totalAlbaran');
		var totalPre = this.lookupReference('totalPrefactura');
		var gridTrabajo = this.lookupReference('detallePrefacturaGrid');
		var rowTrabajo = me.lookupReference('detallePrefacturaGrid').getStore().getData().items[rowIndex];
		var pos = gridTrabajo.data.indexOf(rowTrabajo.data.numTrabajo);
		if(checked){
			valorAlb = parseFloat(totalAlb.getValue()) + parseFloat(rowTrabajo.data.importeTotalPrefactura);
			valorAlbC = parseFloat(totalAlb.getValue()) + parseFloat(rowTrabajo.data.importeTotalClientePrefactura);
			valor = parseFloat(totalPre.getValue()) + parseFloat(rowTrabajo.data.importeTotalPrefactura);
			valorC = parseFloat(totalPre.getValue()) + parseFloat(rowTrabajo.data.importeTotalClientePrefactura);
			rowTrabajo.data.checkIncluirTrabajo = true;
			if( pos >= 0){
				gridTrabajo.data.splice(pos,1);
			}
			me.lookupReference('detallePrefacturaGrid').getStore().getData().items[rowIndex].data.checkIncluirTrabajo = true;
			me.lookupReference('detallePrefacturaGrid').getView().refresh();
		}else{
			valorAlb = totalAlb.getValue() - rowTrabajo.data.importeTotalPrefactura;
			valorAlbC = totalAlb.getValue() - rowTrabajo.data.importeTotalClientePrefactura;
			valor = totalPre.getValue() - rowTrabajo.data.importeTotalPrefactura;
			valorC = totalPre.getValue() - rowTrabajo.data.importeTotalClientePrefactura;
			rowTrabajo.data.checkIncluirTrabajo = false;
			gridTrabajo.data.push(rowTrabajo.data.numTrabajo);
			me.lookupReference('detallePrefacturaGrid').getStore().getData().items[rowIndex].data.checkIncluirTrabajo=false;
			me.lookupReference('detallePrefacturaGrid').getView().refresh();
		}
		if(rowTrabajo.data.importeTotalPrefactura > 0 ){
			totalAlb.setValue(parseFloat(valorAlb).toFixed(2));
		}else{
			totalAlb.setValue(parseFloat(valorAlbC).toFixed(2));
		}
		if(rowTrabajo.data.importeTotalPrefactura > 0){
			totalPre.setValue(parseFloat(valor).toFixed(2));
		}else{
			totalPre.setValue(parseFloat(valorC).toFixed(2));
		}

	},
	
	changeCheckbox: function(grid){
		var gridTrabajo = this.lookupReference('detallePrefacturaGrid');
		var store = gridTrabajo.getStore().getData().items;
		var refrescar = false;
		for(var i = 0 ; i< store.length; i++){
			if(gridTrabajo.data.indexOf(store[i].data.numTrabajo) >= 0){
				store[i].data.checkIncluirTrabajo = false;
				refrescar = true;
			}
		}
		if(refrescar){
			gridTrabajo.getView().refresh();
		}
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
		    				  me.lookupReference('detalleAlbaranGrid').getStore().removeAll();
		    				  me.lookupReference('detallePrefacturaGrid').getStore().removeAll();
		    				  me.lookupReference('totalAlbaran').setValue(0);
		    				  me.lookupReference('totalPrefactura').setValue(0);
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
		var gridDetalle = me.lookupReference('detalleAlbaranGrid');
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
		    				  me.lookupReference('albaranGrid').getStore().load();
		    				  me.lookupReference('detallePrefacturaGrid').getStore().removeAll();
		    				  me.lookupReference('totalAlbaran').setValue(0);
		    				  me.lookupReference('totalPrefactura').setValue(0);
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
		var iterador = 0;
		var gridDetalle = me.lookupReference('detalleAlbaranGrid');
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
		    			  params:  {id : numPrefactura,
		    				  		lista : listaString},
		    			  success: function(response,opts){
		    				  Ext.MessageBox.alert('Prefactura Validada','Se ha validado la prefactura de forma correcta');
		    				  win.close();
		    				  gridDetalle.getStore().load();
		    				  me.lookupReference('albaranGrid').getStore().load();
		    				  me.lookupReference('detallePrefacturaGrid').getStore().removeAll();
		    				  me.lookupReference('totalAlbaran').setValue(0);
		    				  me.lookupReference('totalPrefactura').setValue(0);
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