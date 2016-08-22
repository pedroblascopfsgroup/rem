Ext.define('HreRem.view.activos.actuaciones.ActuacionesController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.actuaciones',
    
    


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
    	var tabspanel = grid.up("tabpanel");
    	var tabs = tabspanel.up("tabpanel"),
       id = prefix + '_' + rec.get('idActuacion'),
       tab = tabs.items.getByKey(id);
       
        if (!tab) {
        	cfg.itemId = id;
            cfg.xtype = xtype;
            cfg.closable = true;
            cfg.session= true;
            tab = tabs.add(cfg);
        }
        // Inyectamos los datos del record al form destino
	    tab.down('cabeceratabmain').loadRecord(rec);
	    tab.down('cabeceraactivo').loadRecord(rec);

	    tabs.setActiveTab(tab);
        var tabPanelActuacion = tab.down('tabpanel');
        tabPanelActuacion.fireEvent("pintarfavorito", tabPanelActuacion, tab.idActuacion);
    },
    
    temporalBorrar: function () {
    	
    	alert("Entro");
    	
    },
    
    createTabTareaActiva: function (prefix, rec, cfg, tabActivos, xtype) {
    	    	
    	var id = prefix + '_' + rec.getId(),
                       tab = tabActivos.items.getByKey(id);
       
        if (!tab) {
        	cfg.itemId = id;
            cfg.xtype = xtype;
            cfg.closable = true;
            cfg.session= true;
            tab = tabActivos.add(cfg);
        }
        // Inyectamos los datos del record al form destino
	    tab.down('cabeceratabmain').loadRecord(rec);
	    tab.down('cabeceraactivo').loadRecord(rec);
	    
	    tabPanelTareas = tab.down('tabpanel');
	    tabActivas = tabPanelTareas.down('tareastabmain');
	    tabPanelTareas.setActiveTab(tabActivas);
        tabs.setActiveTab(tab);
    },
    
    
    
    onActuacionDblClick: function(grid, rec) {
        this.createTab('actuacion', rec, {
        	title: 'Actuacion ' + rec.get('idActuacion'),
        	closable: true,
        	session: true,
        	idActuacion: rec.get("idActuacion"),
        	codigoTareaActiva: rec.get("codigoTareaActiva")
        }, grid, "actuaciontabmain");
    }
    
});