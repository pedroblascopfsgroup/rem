/**
 * @class HreRem.ux.controller.ControllerBase
 * @author Jose Villel
 * 
 * Controlador de aplicación base, en el que se gestionan aspectos comunes a todos los controladores de aplicación.
 * 
 */
Ext.define('HreRem.ux.controller.ControllerBase', {
	extend : 'Ext.app.Controller',
	
	requires: ['Ext.window.Toast'],

	errorCodes : {
		
		SC_UNAUTHORIZED : 401,
		COMMUNICATION_FAILURE : 0
	},
	
	

	/**
	 * Muestra logs en la consola
	 * 
	 * @param {String}
	 *            msg Mensaje de log
	 */
	log : function(msg) {
		var me = this;
		if ($AC.isDebugMode() && Ext.isDefined(Ext.global.console)) {
			if(Ext.isString(msg)) { 
			Ext.global.console.log('[' + me.self.getName() + ' :: '
					+ Ext.Date.format(new Date(), 'H:i:s:u') + '] ' + msg);
			} else {
				Ext.global.console.log(msg);
			}
		}
	},
	
 	logTime : function(msg) {
		var me = this;
		if ($AC.isDebugMode() && Ext.isDefined(Ext.global.console)) {
			if(Ext.isString(msg)) { 
				Ext.global.console.log('[' + me.self.getName() + ' :: ' + msg + "[" + ((new Date().getTime() - me.lt) / 1000) + "]");
			}
		}
	},
	
	setLogTime : function() {
		var me = this;
		
		me.lt = new Date().getTime();
		
	},
	
	
	/**
	 * Muestra warns en la consola
	 * 
	 * @param {String}
	 *            msg Mensaje de log
	 */
	warn : function(msg) {
		var me = this;
		if ($AC.isDebugMode() && Ext.isDefined(Ext.global.console)) {
			Ext.global.console.warn('[' + me.self.getName() + ' :: '
					+ Ext.Date.format(new Date(), 'H:i:s') + '] ' + msg);
		}
	},
	
	
	/**
	 * Muestra ventana info tipo toast con el mensaje que recibe.
	 * @param {} info
	 */
	infoToast : function(text) {
		
		Ext.toast({
		     html: text,
		     width: 320,
		     height: 100,
		     align: 't',
		     cls: 'x-toast-info',
		     autoCloseDelay: 2500
		     
		 });
		

	},
	
	/**
	 * Muestra ventana warn tipo toast con el mensaje que recibe.
	 * @param {} info
	 */
	warnToast : function(text) {
		
		Ext.toast({
		     html: text,
		     width: 320,
		     height: 100,
		     align: 't',
		     cls: 'x-toast-warn',
		     autoCloseDelay: 8000
		 });
		

	},
	
	/**
	 * Muestra ventana error tipo toast con el mensaje que recibe.
	 * @param {} info
	 */
	errorToast: function(text) {
		
		Ext.toast({
		     html: text,
		     width: 320,
		     height: 100,
		     align: 't',
		     cls: 'x-toast-error',
		     autoCloseDelay: 8000
		 });
		
	}
	

});