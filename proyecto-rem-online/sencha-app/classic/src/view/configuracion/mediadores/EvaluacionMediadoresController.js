Ext.define('HreRem.view.configuracion.mediadores.EvaluacionMediadoresController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.evaluacionmediadores',
    
		paramLoading: function(store, operation, opts) {
			var initialData = {};
			var searchForm = this.getReferences().evaluacionMediadoresFiltros;
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});	
		
			store.getProxy().extraParams = criteria;
			
			return true;
		},
		
		// Función que se ejecuta al hacer click en el botón Buscar.
		onSearchClick: function(btn) {
			var me = this;
			me.getViewModel().getData().listaMediadoresEvaluar.load(1);
		},
		
		// Función que se ejecuta al hacer click en el botón de Limpiar.
		onCleanFiltersClick: function(btn) {
		
			btn.up('panel').getForm().reset();
		},
		
		// Funcion que se ejecuta al hacer click en el botón limpiar del formulario.
		onCleanFiltersClick: function(btn) {			
			btn.up('form').getForm().reset();				
		},
		
		onRowClickMediador: function(gridView,record) {
			
			var me = this;    		
			me.getViewModel().set("mediadorSelected", record);
			
			me.lookupReference('carteraMediadorStats').expand();	
			me.lookupReference('carteraMediadorStats').getStore().loadPage(1);
			
			me.lookupReference('ofertasVivasList').expand();	
			me.lookupReference('ofertasVivasList').getStore().loadPage(1);
		},
		
		onClickEvaluar: function() {
		//*************************************************************************************
		// IMPORTANTE: Esta forma de evaluar los mediadores ha sido desarrollada deliveradamente
		//   En lugar de ir actualizando los datos de calificaciones y top en el modelo que utiliza
		//   la lista de mediadores, los cambios se realizan masivamente con unas pocas consultas.
		//   La intencion es que esta pantalla pueda utilizarse para actualizar datos MASIVAMENTE 
		//   y de esta forma se evita lanzar una o 2 consultas para actualizar los datos de cada
		//   mediador (las listas de mediadores pueden contener mas de 4000 registros)
		//   De esta forma todo el proceso de actualizacion lo asume la BBDD mediante 4 o 5 consultas
		//   independientemente de los mediadores que tengan que actualizar datos.
		//   El proceso se optimiza a algo mas eficiente para esta tarea.
		//************************************************************************************* 
			var me = this;
			Ext.Msg.confirm(
				HreRem.i18n("title.evaluacion.mediadores"),
				HreRem.i18n("msg.operacion.evaluacion.mediadores.cuestion.procesar"),
				function(btn){
					if (btn == "no"){
						me.fireEvent("infoToast", HreRem.i18n("msg.operacion.evaluacion.mediadores.evaluar.ok"));              
					}
					if (btn == "yes"){

						var controlador = {};
						controlador.url= $AC.getRemoteUrl("proveedores/setVigentesConPropuestas");		
			
						me.lookupReference('evaluacionMediadoresList').mask();
						
						Ext.Ajax.request({
							url: controlador.url ,
							success: function(response,opts){
								me.lookupReference('evaluacionMediadoresList').getStore().loadPage(1);
								me.fireEvent("infoToast", HreRem.i18n("msg.operacion.evaluacion.mediadores.evaluar.ok"));
							},
							failure: function(options, success, response){
								me.fireEvent("errorToast", HreRem.i18n("msg.operacion.evaluacion.mediadores.evaluar.ko"));
							},
							callback: function(options, success, response){
								me.lookupReference('evaluacionMediadoresList').unmask();
							}
						});
					}
				}
			);			
		}
});