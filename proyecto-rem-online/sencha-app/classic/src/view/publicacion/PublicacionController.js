Ext.define('HreRem.view.publicacion.PublicacionController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.publicaciones',

	// Función que se ejecuta al hacer click en el botón Buscar.
	onSearchClick: function(btn) {
		
		var me = this;
		me.getViewModel().data.activospublicacion.load(1);
		
	},
	
	// Función que se ejecuta al hacer click en el botón de Limpiar.
	onCleanFiltersClick: function(btn) {
		var form = btn.up('panel').getForm();
		
		form.reset();

		form.findField('admision').setValue(false);
		form.findField('gestion').setValue(false);
		form.findField('estadoPublicacionCodigo').setValue(null);
		form.findField('estadoPublicacionAlquilerCodigo').setValue(null);
		
	},
	
	paramLoading: function(store, operation, opts) {
		
		var initialData = {};
		var searchForm = this.getReferences().ActivosPublicacionSearch;
		var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
		
		Ext.Object.each(criteria, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete criteria[key];
			}
		});	

		store.getProxy().extraParams = criteria;
		
		return true;

	},
	
	// Función que se ejecuta cuando se realiza doble click en un elemento del grid.
	onActivosPublicacionListDobleClick: function(grid, record) {       
    	var me = this;    	
    	me.abrirPestañaPublicacionActivo(record);
	},
	
	// Función que abre la pestaña de Publicación del activo.
	abrirPestañaPublicacionActivo: function(record)  {
	   	 var me = this;
	   	 me.getView().fireEvent('abrirDetalleActivoPrincipal', record);
   },
	
	// Función que se ejecuta al hacer click en el botón de Exportar.
	onClickDescargarExcel: function(btn) {
		
    	var me = this,
		config = {};

		var initialData = {};

		var searchForm = btn.up('formBase');
		var params = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
		
		Ext.Object.each(params, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete params[key];
			}
		});
		
		config.params = params;
		config.url= $AC.getRemoteUrl("activo/generateExcelPublicaciones");
		
		me.fireEvent("downloadFile", config);		
    },
    
	// Función para que el combo "Motivos de ocultación" del "Estado publicación Venta" 
	// se oculte cuando se selecciona "Oculto Venta".
    hiddenMotivosOcultacionVenta: function() {

		var me = this;
		var estadoPublicacionVenta = me.getViewModel().get('estadoPublicacionVenta');
		var motivosOcultacionVenta = me.lookupReference('motivosOcultacionVenta');
		
    	if (estadoPublicacionVenta.selection.data.codigo == CONST.ESTADO_PUBLICACION_VENTA['OCULTO']){
    		motivosOcultacionVenta.setHidden(false);
    	} else {
    		motivosOcultacionVenta.setHidden(true);
	    }
	},
	
	// Función para que el combo "Motivos de ocultación" del "Estado publicación Alquiler" 
	// se oculte cuando se selecciona "Oculto Alquiler".
	hiddenMotivosOcultacionAlquiler: function() {

		var me = this;
		var estadoPublicacionAlquiler = me.getViewModel().get('estadoPublicacionAlquiler');
		var motivosOcultacionAlquiler = me.lookupReference('motivosOcultacionAlquiler');

    	if (estadoPublicacionAlquiler.selection.data.codigo == CONST.ESTADO_PUBLICACION_ALQUILER['OCULTO']){
    		motivosOcultacionAlquiler.setHidden(false);
    	} else {
    		motivosOcultacionAlquiler.setHidden(true);
	    }	
    }
});