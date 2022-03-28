 /**
 * Controlador global de aplicación que gestiona la funcionalidad de la entidad Activo
 */
Ext.define('HreRem.controller.WindowsController', {
    extend: 'HreRem.ux.controller.ControllerBase',   
    
    requires: [
		'HreRem.view.trabajos.detalle.CrearTrabajo', 'HreRem.view.common.adjuntos.AdjuntarDocumento', 'HreRem.view.common.adjuntos.AdjuntarFoto',
		'HreRem.view.common.adjuntos.AdjuntarFotoSubdivision', 'HreRem.ux.window.geolocalizacion.ValidarGeoLocalizacion',
		'Ext.form.action.StandardSubmit', 'HreRem.view.activos.detalle.EditarPropietario', 'HreRem.ux.window.MessageBox',
		'HreRem.view.common.adjuntos.AdjuntarFactura'
	],

    modalWindows: [],
    
    listen: {
    	
    	global: {
    			infoToast: 'infoToast',
	    		warnToast: 'warnToast',
	    		errorToast: 'errorToast',
	    		errorToastLong: 'errorToastLong'
    	},

    	
    	controller : {
    		'*': {
    		
	    		infoToast: 'infoToast',
	    		warnToast: 'warnToast',
	    		errorToast: 'errorToast',
	    		errorToastLong: 'errorToastLong',
	    		downloadFile: 'downloadFile'
    		}
    	},
    	
    	component: {
    		'*': {
    			infoToast: 'infoToast',
	    		warnToast: 'warnToast',
	    		errorToast: 'errorToast',
	    		errorToastLong: 'errorToastLong'
    		}
    	}
   	},
    
    
    control: {   	

    	'activosmain, activosdetallemain, trabajosdetalle, agrupacionesdetallemain, formBase, gastodetallemain, expedientedetallemain' : {    		
    		openModalWindow : 'openModalWindow'

    	}
    },
    
    openModalWindow: function (windowClassName, conf) {
    	var me = this,    	
			window = me.findWindow(windowClassName);

    	if(Ext.isEmpty(window)) {
    		window = Ext.create(windowClassName, conf); 
			me.modalWindows.push(window);
    	} else {
        	Ext.apply(window, conf);
    	}

    	window.show();
    },
    
    findWindow:function(windowClassName) {
    	
    	var me = this,
    	window = null;
    	
    	Ext.Array.each(me.modalWindows, function(modalWindow, index) {
    		if(modalWindow.$className == windowClassName) {
    			window = modalWindow;
    			return false;
    		}
    	});
    	
    	return window;
    	
    },
    
	downloadFile: function(config) {
	    config = config || {};
	    
	    var url = config.url,
	        method = config.method || 'GET',// Either GET or POST. Default is POST.
	        params = config.params || {};
	
	    // Create form panel. It contains a basic form that we need for the file download.
	    var form = Ext.create('Ext.form.Panel', {
	        standardSubmit: true,
	        url: url,
	        method: method
	    });

	    // Call the submit to begin the file download.
	    form.submit({
	        target: '_blank', // Avoids leaving the page. 
	        params: params,
			headers: {'Content-Type':'charset=UTF-8;','accept-charset':'UTF-8'}
	    });
	
	    // Clean-up the form after 100 milliseconds.
	    // Once the submit is called, the browser does not care anymore with the form object.
	    Ext.defer(function(){
	        form.destroy();
	    }, 1000);
		
	}
});
