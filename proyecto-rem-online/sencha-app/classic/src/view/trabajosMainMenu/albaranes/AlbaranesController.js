Ext.define('HreRem.view.trabajosMainMenu.albaranes.AlbaranesController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.albaranes',
	
	//No tocar, acumulador
	data: {
    	acumulador: 0
    },
    
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
			this.lookupReference('albaranGrid').getSelectionModel().deselectAll();
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
		var me = this;
		me.lookupReference('btnExportarPrefactura').setDisabled(true);
		//Limpia los grid
		btn.up("[reference='albaranessearch']").nextSibling().down("[reference='albaranGrid']").getStore().removeAll();
		btn.up("[reference='albaranessearch']").nextSibling().down("[reference='detalleAlbaranGrid']").getStore().removeAll();
		btn.up("[reference='albaranessearch']").nextSibling().down("[reference='detallePrefacturaGrid']").getStore().removeAll();
		
		//Setear los botones a disabled
		btn.up("[reference='albaranessearch']").nextSibling().down("[reference='botonValidarPrefactura']").setDisabled(true);
		btn.up("[reference='albaranessearch']").nextSibling().down("[reference='botonValidarTrabajo']").setDisabled(true);
		me.lookupReference('totalAlbaran').setValue(0);
		me.lookupReference('totalPrefactura').setValue(0);
		me.lookupReference('detallePrefacturaGrid').data = [];
		me.data.acumulador = 0;
		//Limpia la botonera de filtrado.
		btn.up('panel').getForm().reset();
			
	},
	
	onAlbaranClick: function(grid, record){
		var me = this;
		var viewModel = me.getViewModel();
		var gridAlbaran = me.lookupReference('albaranGrid');
		var listaDetalleAlbaran = me.lookupReference('detalleAlbaranGrid');
		var listaTrabajos = me.lookupReference('detallePrefacturaGrid');
		var numPrefactura = me.lookupReference('numPrefacturaSearch').value;
		var fechaPrefactura= Ext.Date.format( me.lookupReference('fechaPrefacturaSearch').value , 'd/m/Y');
		var estadoPrefactura = this.lookupReference('estadoPrefacturaSearch').value;
		var numTrabajo = this.lookupReference('numTrabajoSearch').value;
		var estadoTrabajo = this.lookupReference('estadoTrabajoSearch').value;
		var anyoTrabajo = this.lookupReference('anyoTrabajoSearch').value;
		var codAreaPeticionaria = this.lookupReference('areaPeticionariaSearch').value;
		listaTrabajos.data = [];
		me.data.acumulador = 0;
		var exportarTrabajosPrefacturas = $AU.userHasFunction('EXPORTAR_BUSQUEDA_TRABAJOS_PREFACTURA');
		if (exportarTrabajosPrefacturas) {
			this.lookupReference('btnExportarPrefactura').setDisabled(false);
		}
		if(!Ext.isEmpty(grid.selection)){
			listaDetalleAlbaran.getStore().getProxy().setExtraParams({
                numAlbaran: record.data.numAlbaran,
                numPrefactura: numPrefactura,
                fechaPrefactura: fechaPrefactura,
                estadoAlbaran: estadoPrefactura,
                numTrabajo: numTrabajo,
                estadoTrabajo: estadoTrabajo,
                anyoTrabajo: anyoTrabajo,
                codAreaPeticionaria: codAreaPeticionaria
            });
			listaDetalleAlbaran.getStore().loadPage(1);
			listaTrabajos.getStore().removeAll();
			me.calcularTotal(gridAlbaran,"albaranGrid",record);
			
		} else {
			me.deselectAlbaran(grid);
		}
		
		
	},
	
	deselectAlbaran: function(grid){
		var me = this;
		var gridAlbaran = this.lookupReference('albaranGrid');
		var listaDetalleAlbaran = this.lookupReference('detalleAlbaranGrid');
		var listaTrabajos = this.lookupReference('detallePrefacturaGrid');
		var exportarTrabajosPrefacturas = $AU.userHasFunction('EXPORTAR_BUSQUEDA_TRABAJOS_PREFACTURA');
		if (exportarTrabajosPrefacturas) {
			this.lookupReference('btnExportarPrefactura').setDisabled(true);
		}

		this.lookupReference('botonValidarPrefactura').setDisabled(true);
		this.lookupReference('botonValidarTrabajo').setDisabled(true);
		this.lookupReference('totalAlbaran').setValue(0);
		this.lookupReference('totalPrefactura').setValue(0);
		listaDetalleAlbaran.getStore().getProxy().setExtraParams(null);
		listaTrabajos.getStore().getProxy().setExtraParams(null);
		listaDetalleAlbaran.getStore().removeAll();
		listaTrabajos.getStore().removeAll();
		listaTrabajos.data = [];
		me.data.acumulador = 0;
	},
	
	onPrefacturaClick: function(grid, record){
		var me = this;
		var viewModel = me.getViewModel();
		var gridDetalleAlbaran = this.lookupReference('detalleAlbaranGrid');
		var listaDetallePrefactura = this.lookupReference('detallePrefacturaGrid');
    	
		listaDetallePrefactura.data = [];
		var boton = this.lookupReference('botonValidarPrefactura');
		var numTrabajo = this.lookupReference('numTrabajoSearch').value;
		var estadoTrabajo = this.lookupReference('estadoTrabajoSearch').value;
		var anyoTrabajo = this.lookupReference('anyoTrabajoSearch').value;
		var numPrefactura = this.lookupReference('numPrefacturaSearch').value;
		var fechaPrefactura= Ext.Date.format( me.lookupReference('fechaPrefacturaSearch').value , 'd/m/Y');
		var estadoPrefactura = this.lookupReference('estadoPrefacturaSearch').value;
		
		if(!Ext.isEmpty(grid.selection)){
			listaDetallePrefactura.getStore().getProxy().setExtraParams({
                numPrefactura: record.data.numPrefactura,
                numTrabajo: numTrabajo,
                estadoTrabajo: estadoTrabajo,
                anyoTrabajo: anyoTrabajo
            });
			listaDetallePrefactura.getStore().loadPage(1);
			me.calcularTotal(gridDetalleAlbaran,"detalleAlbaranGrid",record);	

			if((numTrabajo != null && numTrabajo != "") || (estadoTrabajo != null && estadoTrabajo != "") || (anyoTrabajo!= null && anyoTrabajo!= "")){
				me.lookupReference('botonValidarPrefactura').setDisabled(true);
				me.lookupReference('botonValidarTrabajo').setDisabled(true);
			}
			else{
				me.habilitarPrefactura(boton,record);				
			}
			
		} else {
			me.deselectPrefactura(grid);
		}
		
	},
	
	deselectPrefactura: function(grid){
		var me = this;
		var gridDetalle = this.lookupReference('detalleAlbaranGrid');
		var listaTrabajos = this.lookupReference('detallePrefacturaGrid');

		this.lookupReference('botonValidarPrefactura').setDisabled(true);
		this.lookupReference('botonValidarTrabajo').setDisabled(true);
		this.lookupReference('totalPrefactura').setValue(0);
		listaTrabajos.getStore().getProxy().setExtraParams(null);
		listaTrabajos.getStore().removeAll();
		listaTrabajos.data = [];
		me.calcularTotal(this.lookupReference('albaranGrid'),"albaranGrid",this.lookupReference('albaranGrid').selection);
		listaTrabajos.getColumns()[8].setDisabled(false);
	},
	
	calcularTotal: function(grid,descripcion,record){
		var v;
		if(descripcion == "detalleAlbaranGrid"){
			var valor = 0;
			if(record.data.importaTotalPrefacturas != null && record.data.importaTotalPrefacturas != 0){
				valor = record.data.importaTotalPrefacturas;
			}
			var totalPre = this.lookupReference('totalPrefactura');
			v = parseFloat(valor).toFixed(2);
			v = this.millaresConPuntos(v);
			var importeTotal = this.lookupReference('albaranGrid').selection.data.importeTotal;
			if(importeTotal != null && importeTotal != 0){
				this.data.acumulador = this.lookupReference('albaranGrid').selection.data.importeTotal;
			}
			totalPre.setValue(v);
		}
		if(descripcion == "albaranGrid"){
			var valorAlb = 0;
			if(record.data.importeTotal != null && record.data.importeTotal != 0){
				valorAlb = record.data.importeTotal;
			}
			var totalAlb = this.lookupReference('totalAlbaran');
			v = parseFloat(valorAlb).toFixed(2);
			v = this.millaresConPuntos(v);
			totalAlb.setValue(v);
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
			valorAlb = parseFloat(totalAlb.getValue().replace(/[.]/g, '').replace(/[,]/g, '.')) + parseFloat(rowTrabajo.data.importeTotalPrefactura);
			//valorAlbC = parseFloat(totalAlb.getValue().replace(/[.]/g, '').replace(/[,]/g, '.')) + parseFloat(rowTrabajo.data.importeTotalClientePrefactura);
			valor = parseFloat(totalPre.getValue().replace(/[.]/g, '').replace(/[,]/g, '.')) + parseFloat(rowTrabajo.data.importeTotalPrefactura);
			//valorC = parseFloat(totalPre.getValue().replace(/[.]/g, '').replace(/[,]/g, '.')) + parseFloat(rowTrabajo.data.importeTotalClientePrefactura);
			rowTrabajo.data.checkIncluirTrabajo = true;
			if( pos >= 0){
				gridTrabajo.data.splice(pos,1);
			}
			me.lookupReference('detallePrefacturaGrid').getStore().getData().items[rowIndex].data.checkIncluirTrabajo = true;
			me.lookupReference('detallePrefacturaGrid').getView().refresh();
		}else{
			valorAlb = parseFloat(totalAlb.getValue().replace(/[.]/g, '').replace(/[,]/g, '.')) - rowTrabajo.data.importeTotalPrefactura;
			//valorAlbC = parseFloat(totalAlb.getValue().replace(/[.]/g, '').replace(/[,]/g, '.')) - rowTrabajo.data.importeTotalClientePrefactura;
			valor = parseFloat(totalPre.getValue().replace(/[.]/g, '').replace(/[,]/g, '.')) - rowTrabajo.data.importeTotalPrefactura;
			//valorC = parseFloat(totalPre.getValue().replace(/[.]/g, '').replace(/[,]/g, '.')) - rowTrabajo.data.importeTotalClientePrefactura;
			rowTrabajo.data.checkIncluirTrabajo = false;
			gridTrabajo.data.push(rowTrabajo.data.numTrabajo);
			me.lookupReference('detallePrefacturaGrid').getStore().getData().items[rowIndex].data.checkIncluirTrabajo=false;
			me.lookupReference('detallePrefacturaGrid').getView().refresh();
		}
		if(rowTrabajo.data.importeTotalPrefactura > 0 ){
			totalAlb.setValue(me.millaresConPuntos(parseFloat(valorAlb).toFixed(2)));
			me.data.acumulador = parseFloat(valorAlb).toFixed(2);
		}/*else{
			totalAlb.setValue(me.millaresConPuntos(parseFloat(valorAlb).toFixed(2)));
			me.data.acumulador = parseFloat(valorAlbC).toFixed(2);
		}*/
		if(rowTrabajo.data.importeTotalPrefactura > 0){
			totalPre.setValue(me.millaresConPuntos(parseFloat(valor).toFixed(2)));
		}/*else{
			totalPre.setValue(me.millaresConPuntos(parseFloat(valor).toFixed(2)));
		}*/

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
		    				  Ext.MessageBox.alert('Albarán Validado','Se ha validado el albarán de forma correcta');
		    				  gridAlbaran.getStore().load();
		    				  me.lookupReference('botonValidarAlbaran').setDisabled(true);
		    				  me.lookupReference('detalleAlbaranGrid').getStore().removeAll();
		    				  me.lookupReference('detallePrefacturaGrid').getStore().removeAll();
		    				  me.lookupReference('totalAlbaran').setValue(0);
		    				  me.lookupReference('totalPrefactura').setValue(0);
		    			  }
		    			  
		    		    });
		    		}else{
		    			Ext.MessageBox.alert('Error en la validación','Ha habido un error validando el albarán seleccionado');
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
//		var itemTrabajos = this.lookupReference('detallePrefacturaGrid').getStore().getData().items;
		var itemTrabajos = this.lookupReference('detallePrefacturaGrid').getData();
		var lista = [];
//		for(iterador = 0; iterador < itemTrabajos.length; iterador++){
//			lista.push(this.lookupReference('detallePrefacturaGrid').getStore().getData().items[iterador].getData())
//		}
//		var listaString = JSON.stringify(lista);
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
		    				  		lista : itemTrabajos},
		    			  success: function(response,opts){
		    				  Ext.MessageBox.alert('Prefactura Validada','Se ha validado la prefactura de forma correcta');
		    				  win.close();
		    				  gridDetalle.getStore().load();
		    				  me.lookupReference('botonValidarPrefactura').setDisabled(true);
		    				  me.lookupReference('botonValidarTrabajo').setDisabled(true);
		    				  me.lookupReference('albaranGrid').getStore().load();
		    				  me.lookupReference('detallePrefacturaGrid').getStore().removeAll();
		    				  me.lookupReference('totalAlbaran').setValue(me.millaresConPuntos(parseFloat(me.data.acumulador).toFixed(2)));
		    				  me.lookupReference('totalPrefactura').setValue(0);
		    			  }
		    			  
		    		    });
		    		}else{
		    			Ext.MessageBox.alert('Error en la validación','Ha habido un error validando la prefactura seleccionada');
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
//		var itemTrabajos = this.lookupReference('detallePrefacturaGrid').getStore().getData().items;
		var itemTrabajos = this.lookupReference('detallePrefacturaGrid').getData();
		var lista = [];
//		for(iterador = 0; iterador < itemTrabajos.length; iterador++){
//			lista.push(this.lookupReference('detallePrefacturaGrid').getStore().getData().items[iterador].getData())
//		}
		
		//var listaString = JSON.stringify(itemTrabajos);
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
		    				  		lista : itemTrabajos},
		    			  success: function(response,opts){
		    				  Ext.MessageBox.alert('Prefactura Validada','Se ha validado la prefactura de forma correcta');
		    				  win.close();
		    				  gridDetalle.getStore().load();
		    				  me.lookupReference('botonValidarPrefactura').setDisabled(true);
		    				  me.lookupReference('botonValidarTrabajo').setDisabled(true);
		    				  me.lookupReference('albaranGrid').getStore().load();
		    				  me.lookupReference('detallePrefacturaGrid').getStore().removeAll();
//		    				  me.lookupReference('totalAlbaran').setValue(0);
		    				  me.lookupReference('totalAlbaran').setValue(me.millaresConPuntos(parseFloat(me.data.acumulador).toFixed(2)));
		    				  me.lookupReference('totalPrefactura').setValue(0);
		    			  }
		    			  
		    		    });
		    		}else{
		    			Ext.MessageBox.alert('Error en la validación','Ha habido un error validando la prefactura seleccionada');
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
		var habilitar = false;
		if(record.data.estadoAlbaran != CONST.ESTADOS_ALBARANES['VALIDADO']){
			habilitar = true;
		}
		
		boton.setDisabled(!habilitar);
	},
	
	habilitarPrefactura : function(boton,record){
		var me = this;

		var botondos = this.lookupReference('botonValidarTrabajo');
		var gridTrabajos = this.lookupReference('detallePrefacturaGrid');
		if(record.data.estadoAlbaran == CONST.ESTADOS_PREFACTURAS['VALIDADO']){
			boton.setDisabled(true);
			botondos.setDisabled(true);
			gridTrabajos.getColumns()[9].setDisabled(true);
		}else{
			boton.setDisabled(false);
			botondos.setDisabled(false);
			gridTrabajos.getColumns()[9].setDisabled(false);
		}
	},
	
	paginacionAlbaran: function(){
		var me = this;
		me.lookupReference('albaranGrid').getSelectionModel().deselectAll();
		me.lookupReference('detalleAlbaranGrid').getStore().removeAll();
		me.lookupReference('detallePrefacturaGrid').getStore().removeAll();
	},
	
	paginacionPrefactura: function(){
		var me = this;
		me.lookupReference('detalleAlbaranGrid').getSelectionModel().deselectAll();
		me.lookupReference('detallePrefacturaGrid').getStore().removeAll();
	},
	
	millaresConPuntos: function(num){
		var partes = num.toString().split(".");
		partes[0] = partes[0].replace(/\B(?=(\d{3})+(?!\d))/g, ".");
		return partes.join(',');
	},
	
	onRowDblClickListadoDetallePrefactura: function(view, record) {
		var me = this;
		record.set('id', record.get('id'));
		me.getView().fireEvent('abrirDetalleTrabajo', record);
	},
	
	onClickDescargarExcel: function(btn){
		var me = this;

		var numAlbaran = this.lookupReference('albaranGrid').selection.data.numAlbaran;
		var numPrefactura = this.lookupReference('detalleAlbaranGrid').selection
		if (numPrefactura != null) {
			numPrefactura = numPrefactura.data.numPrefactura;
		}
		
		var searchForm = this.lookupReference('albaranessearch');
		var url =  $AC.getRemoteUrl('albaran/generateExcelTrabajosPrefactura');
		
		var config = {};

		var params = Ext.apply(searchForm ? searchForm.getValues() : {});
		
		if (numAlbaran != undefined && params.numAlbaran == "") {
			params.numAlbaran = numAlbaran;
		} 
		
		if (numPrefactura != undefined && params.numPrefactura == "") {
			params.numPrefactura = numPrefactura;
		}

		Ext.Object.each(params, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete params[key];
			}
		});

		config.params = params;
		config.url= url;
		
		me.fireEvent("downloadFile", config);		
	},
	
	mostrarTotalProveedor: function(get){
    	var isGestorActivos = $AU.userIsRol('HAYAGESACT');
    	var isSuper = $AU.userIsRol('HAYASUPER');
    	var isProveedor = $AU.userIsRol('HAYAPROV');
    	return !isGestorActivos && !isSuper && !isProveedor;
    },
    
    mostrarTotalCliente: function(get){
    	var me = this;
    	var isGestorActivos = $AU.userIsRol('HAYAGESACT');
    	var isSuper = $AU.userIsRol('HAYASUPER');
    	var isUsuarioCliente;
    	Ext.Ajax.request({
			  url:$AC.getRemoteUrl('albaran/getEsUsuarioCLiente'),
			  method: 'POST',
			  success: function(response,opts){
				  data = Ext.decode(response.responseText);
				  if(data.success == "true"){
					  isUsuarioCliente = data.data == "true";
					  me.getView().lookupReference('importeTotalCliente').setHidden(!isGestorActivos && !isSuper && !isUsuarioCliente);
					  me.getView().lookupReference('importeTotalClienteDetalle').setHidden(!isGestorActivos && !isSuper && !isUsuarioCliente);
					  me.getView().lookupReference('importeTotalClientePrefactura').setHidden(!isGestorActivos && !isSuper && !isUsuarioCliente);
				  }
			  }
			  
		    });
    }
	
});