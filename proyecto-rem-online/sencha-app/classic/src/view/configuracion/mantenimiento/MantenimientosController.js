Ext.define('HreRem.view.configuracion.mantenimiento.MantenimientosController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.mantenimientoscontroller',
    
    requires: ['HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipalFiltros'],
    
		paramLoading: function(store, operation, opts) {
			var initialData = {};
			var searchForm = this.getReferences().mantenimientoprincipalfiltrosref;
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
			me.getViewModel().getData().listaMantenimiento.loadPage(1);
		},
		
		// Funcion que se ejecuta al hacer click en el botón limpiar del formulario.
		onCleanFiltersClick: function(btn) {
			btn.up('form').getForm().reset();				
		},
		
		onRowClickMediador: function(gridView,record) {
			
			var me = this;    		
			me.getViewModel().set("mediadorSelected", record);
			me.getViewModel().notify();
			
			me.lookupReference('carteraMediadorStats').expand();	
			me.lookupReference('carteraMediadorStats').getStore().loadPage(1);
			
			me.lookupReference('ofertasVivasList').expand();	
			me.lookupReference('ofertasVivasList').getStore().loadPage(1);
		},
		
		onExportarExcelMantenimiento:function(){
			var me = this;

			var url =  $AC.getRemoteUrl('configuracion/generateExcelMantenimientoReport');
			
			var form = me.getView().down('form');  
			var config = {};

			var initialData = me.rellenarDtoMantenimiento(form);
			
			var params = Ext.apply(initialData);
			
			Ext.Ajax.request({		    			
                url: url,
                params: initialData,
                method: 'GET',
                success: function(response, opts) {
                    form.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));                    	
                	config.params = params;
                	config.url= url;
                	me.fireEvent("downloadFile", config);
                },
                failure: function(response) {
                    form.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                }
            });	
		},
		
		rellenarDtoMantenimiento: function (form){
			var me = this;
			var list = {};
			var primerCampo=form.down('[name="codCartera"]');
			list[primerCampo.name] = primerCampo.value;
			while (!Ext.isEmpty(primerCampo.nextSibling())) {
				primerCampo = primerCampo.nextSibling();
				if (primerCampo.xtype.match('datefield')) {
					var fecha = primerCampo.value.toLocaleDateString();
					list[primerCampo.name] = fecha;
				}else{
					list[primerCampo.name] = primerCampo.value;
				}
			}
			
			return list;
		},
		
		onSelectComboCodCartera: function(cmb, value){
			var me = this;
			var comboPropietario = me.lookupReference('codPropietarioRef');
			comboPropietario.value=null;
			
			if (comboPropietario != null || comboPropietario != undefined) {
				
				comboPropietario.getStore().getProxy().setExtraParams({'codCartera':value});
				comboPropietario.getStore().load();
				
			}
		},
	    hideWindowCrearMantenimiento: function(btn) {
    		var me = this; 
    		btn.up('window').hide();
    		var store = btn.up('[xtype="mantenimientosmain"]').down('[xtype="mantenimientoprincipalfiltros"]').nextSibling().store;
    		if (store != null) {
    			store.load();
    		}
    	},
		onClickBorrarMantenimiento: function(view, rowIndex, colIndex, item, e, record, row) {
			var me = this,			
			url = null,
			grid = null;

			var idMantenimiento = record.data.id;
			me.getView().mask(HreRem.i18n("msg.mask.loading"));
	
	
			if(!Ext.isEmpty(view) && !Ext.isEmpty(view.up('grid'))){
				grid = view.up('grid');
			}

			Ext.Msg.show({
				title : HreRem.i18n('title.eliminar'),
				msg : HreRem.i18n('msg.confirmar.borrado.mantenimiento'),
				buttons : Ext.MessageBox.YESNO,
				fn : function(buttonId) {

					if (buttonId == 'yes') {
						url = $AC.getRemoteUrl('configuracion/deleteMantenimiento');
						Ext.Ajax.request({
							url : url,
							params : {
								idMantenimiento : idMantenimiento
							},
							success : function(response, opts) {
								me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
								grid.getStore().load();
							},
							failure : function(record, operation) {
								me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
								
							},
							callback : function(record, operation) {
								me.getView().unmask();
							}
						});
					}else{
						me.getView().unmask();
					}
				}
			});
		},
		
		onClickBotonAnyadirMantenimiento : function(btn) {
		var me = this;

		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		var form = btn.up().up().down("form"), 
		url = $AC.getRemoteUrl("configuracion/createMantenimiento");		
 
		params = {
			codCartera : form.items.items[0].getValue(),
			codSubCartera : form.items.items[1].getValue(),
			codPropietario : form.items.items[2].getValue(),
			carteraMacc: form.items.items[3].getValue()
		};
		if (form.isValid()) {
			form.submit({
				url : url,
				params : params,
				method: 'POST',
				success : function(fp, o) {
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					me.getView().unmask();
					me.hideWindowCrearMantenimiento(btn);
				},
				failure : function(record, operation) {
					if (!Ext.isEmpty(operation) && !Ext.isEmpty(operation.result) && !Ext.isEmpty(operation.result.fwk) && !Ext.isEmpty(operation.result.fwk.fwkExceptions[0])) {
						me.fireEvent("errorToast",operation.result.fwk.fwkExceptions[0]);
					}else{
						me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					}
					me.getView().unmask();
				}
			});
		} else {
			me.getView().unmask();
		}
	}
});
