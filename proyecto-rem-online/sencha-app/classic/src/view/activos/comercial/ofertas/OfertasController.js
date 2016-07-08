Ext.define('HreRem.view.activos.comercial.ofertas.OfertasController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.ofertas',
    
    


	//Funcion que se ejecuta al hacer click en el botón buscar
	onSearchClick: function(btn) {
		
		var initialData = {};
		var filters = [];

		var searchForm = btn.up('formBase');
		if (searchForm.isValid()) {
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				filters.push(Ext.util.Filter.create({property: key, value: val}));
			});

			btn.up('formBase').up('panel').down('gridBase').getStore().filter(filters);
        }
	},
	
	
	// Funcion que se ejecuta al hacer click en el botón limpiar
	onCleanFiltersClick: function(btn) {

		btn.up('panel').getForm().reset();
			
	},
    
    
    
    createTab: function (prefix, rec, cfg, grid, xtype) {
    	var tabspanel = grid.up("tabpanel").up("tabpanel");
    	
    	var tabs = tabspanel.up("tabpanel"),
       id = prefix + '_' + rec.get('idOferta'),
       tab = tabs.items.getByKey(id);
    	
        if (!tab) {
        	cfg.itemId = id;
            cfg.xtype = xtype;
            cfg.closable = true;
            cfg.session= true;
            tab = tabs.add(cfg);
        }
       
        // Inyectamos los datos del record al form destino
        tab.down('datosgeneralesoferta').loadRecord(rec);
        tab.down('datoseconomicosoferta').loadRecord(rec);
        tab.down('condicioneseconomicasdetalle').loadRecord(rec);
        tab.down('condicionesjuridicasdetalle').loadRecord(rec);
        tab.down('cabeceraactivooferta').loadRecord(rec);

        tabs.setActiveTab(tab);
        
        var tabPanelOferta = tab.down('tabpanel');
        tabPanelOferta.fireEvent("pintarfavorito", tabPanelOferta, tab.idOferta);        
        
    },
    
    
    
    onOfertaDblClick: function(grid, rec) {
        this.createTab('oferta', rec, {
        	title: 'Oferta ' + rec.get('idOferta'),
        	closable: true,
        	idOferta: rec.get("idOferta")
        }, grid, "ofertadetalle");
    },
    
    //TODO A priori mostrar un alert de "Se ha guardado correctamente"
    onSaveDatosEconomicosClick: function(button) {
    	
    	alert("Los datos han sido guardados correctamente");
    	/*
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
    	window.destroy();*/

    },
    
    //TODO A priori mostrar un alert de "Se ha guardado correctamente"
    onSaveClick: function(button) {
    	
    	var me = this,
    	form = me.lookupReference("formOfertaAlta"),
    	window = me.lookupReference("windowOfertaAlta"),
    	record;  

    	form.updateRecord(); 	
    	record = form.getRecord();
    	//debugger;
    	//if(window.altaVisita) {
    	//me.lookupReference("ofertaslist").getStore().add(record);
    	record.set('idOferta',1060)
    	me.getView().getStore().add(record);
    	//}
    	me.getView().remove(window);
    	window.destroy();

    },
    
    onSaveEditClick: function(btn) {
		
    	Ext.Msg.show({
		    title:'Edición de Oferta',
		    message: 'Oferta actualizada correctamente',
		    buttons: Ext.Msg.OK,
		    icon: Ext.Msg.INFO,
		    fn: function(btn) {
		        if (btn === 'yes') {
		            button.up("window").destroy();
		        }
		    }
		});    	
		
	},
    
    // Funcion que se ejecuta al hacer click en el botón de añadir oferta
    onAddClick: function(btn) {
    	var me = this; 
    	//debugger;
    	// Abrimos el formulario con una oferta vacia
    	me.abrirFormularioAltaOferta(Ext.create("HreRem.model.Oferta", {idActivo:me.getViewModel().get("idActivo")}));       	
    },
    
    onFuncionalidadNoDesarrolladaClick: function(btn) {
    	
    	Ext.Msg.show({
		    title:'Oferta',
		    message: 'Funcionalidad no implementada',
		    buttons: Ext.Msg.OK,
		    icon: Ext.Msg.INFO,
		    fn: function(btn) {
		        if (btn === 'yes') {
		            button.up("window").destroy();
		        }
		    }
		});    	
    	    	
    },
    
    abrirFormularioAltaOferta: function (oferta) {

        var me = this,
        winFormOferta = Ext.create(HreRem.view.activos.comercial.ofertas.OfertaAlta);
        winFormOferta.down('form').loadRecord(oferta);
        winFormOferta.show();
        me.getView().add(winFormOferta);	        
    },

    onCancelClick: function(button) {
    	
    	var me = this;
    	
    	Ext.Msg.show({
		    title:'Cancelar Alta',
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
    
    onGeneratePdf: function(button) {
    	
    	/*var win =Ext.create('Ext.window.Window', {
            title: 'Propuesta Activo 1050',
            width: 400,
            height: 600,
            modal   : true,
            closeAction: 'hide',
            items: { 
                     xtype: 'component',
                     html : '<iframe src="../../../resources/docs/PropuestaOferta.pdf" width="100%" height="100%"></iframe>'
                  }
        }).show();*/
    	
    	var url = "../../../resources/docs/PropuestaOferta.pdf";
    	if (printPanel == null) {
	    	var printPanel = Ext.create('Ext.form.Panel', {
	    	  title:'Propuesta Oferta',
	    	  //id: 'printTabPanel',
	    	  standardSubmit: true,
	    	  layout: 'fit',
	    	  timeout: 120000
	    	});
    	}

    	printPanel.submit({
    	             target : '_new',
    	             url  : url
    	            });
        

    	
    },
    
    
	onClickBotonFavoritos: function(btn) {
		var me = this,			
		tabpanel = btn.up('tabpanel');
		
		tabpanel.fireEvent('marcarfavorito', tabpanel, btn)
		
		
	}
    

        
    
});