/**
 * @class HreRem.controller.RootController
 * @author Jose Villel
 * 
 * Controlador de aplicación que gestiona el inicio de la aplicación, login y aspectos globales de configuración.
 * 
 */
Ext.define('HreRem.controller.RootController', {
    extend: 'HreRem.ux.controller.ControllerBase',
    
    requires: ['HreRem.view.login.Login'],
    
    models: ['HreRem.model.User'],
    
    
    init: function() {
    	
    	var me = this;
    	
    	me.initConfigApp();
    	   
    },
    listen: {
        controller : {
    		'*': {    		
	    		log: 'log',
	    		warn: 'warn'    		
    		}
    	}
    },
    
 	control: {
    	
    	'loginwindow' : {    		
    		loginsuccesful :'onLaunch',
    		
    		loginfailure: 'onLoginFailure'
    	},
    	
    	'component' : {    		
    		log : 'log'
    	},
    	
    	'proxy' : {    		
    		exception : 'log'
    	}

 	},

    
    onLaunch: function () {    	
    	
    	var me = this;
    	
    	if(!Ext.isEmpty(me.winLogin)) {
    		me.winLogin.destroy();
    		me.winLogin= null;
    	}

    	/*
    	 *  Recogemos la información del usuario identificado
    	 */
		Ext.Ajax.request({
			
		     url: $AC.getRemoteUrl('generic/getAuthenticationData'),
		
		     success: function(response, opts) {
		        var user = new HreRem.model.User(Ext.decode(response.responseText));
		        
		        me.session = new Ext.data.Session({
					autoDestroy: false,
					user: user
        		});      		
        		
        		me.fireEvent("usuarioIdentificado", me.session);   
        		
        		/*
        		 * Buscamos las opciones del menú principal y superior por usuario.
        		 */
        		var menuPrincipal = Ext.create("HreRem.store.MenuPrincipalStore");    	
		    	menuPrincipal.on({load: function(store,records,op) {
		    		
		            var storeTop = Ext.create('HreRem.store.MenuTopStore');
		            storeTop.load({
		            		callback: function(){		            			
		            			me.showUI(user.get("data").userName, store, storeTop);
		            		}
		            });
		    	}
		    	});
		    	
		    	/*
		    	 * Llamada al servicio que gestiona el registro de acceso.
		    	 */
		    	Ext.Ajax.request({			
				     url: $AC.getRemoteUrl('generic/registerUser'),				
				     success: function(response, opts) {
				     	me.log("Control de acceso terminado");
				     }
		    	});
		     }
		 });
       
    },
    
    /**
     * Función que crea el viewport de la aplicación
     */
    showUI: function(userName, store, storeTop) {
    	var me = this;
    	me.initConfigRem();
        me.viewport = Ext.create('HreRem.view.Viewport',{userName: userName, menuPrincipal: store, menuTop : storeTop});
    },
    
    initConfigApp: function() {
    	
    	var me = this;    	    	
    	me.initi18nConfig();    	
    	me.initAjaxConfig();
    	
    	//TODO: implementar manera de avisar al usuario de que ExtJS ha dejado de funcionar.
//    	window.onerror=function(){
//    		 alert('Ha ocurrido un error')
//    		 return true
//    	}
    },
    
    initConfigRem: function() {
    	
    	var me = this;    	
		me.initFormatConfig();		
		me.initVtypeConfig();  	
    	
    },

    /**
     * Inicia i18n
     */
    initi18nConfig: function () {    	

    	HreRem.i18n = function(key) {
        	return this.getApplication().bundle.getMsg(key);
        };

    },
    
 	showLogin: function() {
    	
    	var me = this;

    	// Si ya hemos creado el viewport y por inactividad volvemos al login, refrescamos la página. 
    	if(!Ext.isEmpty(me.viewport)) {    		
    		location.reload(true);    		
	  	} else {	  		
	  		if(Ext.isEmpty(me.winLogin)){
				me.winLogin = Ext.create('HreRem.view.login.Login');
			} else {
				me.winLogin.show();
			}
	  	}
    },
    
    onLoginFailure:function(action) {
    	var me = this;
		Ext.Msg.alert(HreRem.i18n('msg.error'), HreRem.i18n("msg.error.usuario.pass.incorrecto"), function() {me.showLogin();});
    	
    },
    
        
    getSession: function() {
        return this.session;
    },
    
    
    /**
     * Configuración global de peticiones Ajax
     */
    initAjaxConfig: function() {
    	
    	var me = this;
    	
    	Ext.Ajax.setTimeout($AC.getDefaultTimeout());
    	
		Ext.Ajax.on('requestexception', function(con, response, op, e) {
			switch (response.status) {
				
				case me.errorCodes['SC_UNAUTHORIZED']:					
					con.abortAll(); // Si hay más peticiones pendientes van a dar el mismo error. Las cancelamos.			
					me.showLogin();
					me.log(HreRem.i18n('msg.error.usuario.no.identificado'));
					break;
				case me.errorCodes['COMMUNICATION_FAILURE']:
				    me.log(HreRem.i18n('msg.error.perdida.comunicacion'));
				    break;				    
			}
		  
		});
    },
    
    /**
     * Configuración global de formatos
     */
    initFormatConfig: function() {
		/**
		 * Configuración de formatos
		 */
		if (Ext.util && Ext.util.Format) {
			Ext.apply(Ext.util.Format, {
			currencyAtEnd: true
			});
		}
		
		/**
		 * Configuración de Ext.Date
		 */ 
		if(Ext.Date) {
			Ext.apply(Ext.Date, {
				// Evita el 'date rollover' de javascript
				useStrict: true
			});
		}
		
		if(Ext.PagingToolbar) {
			Ext.PagingToolbar.override({
				emptyMsg: ""
			})
		}

	},

	/**
	* Configuración global de VTYPES para validaciones de campo de formularios.
	*/
	initVtypeConfig: function() {
		
		if(Ext.form.VTypes) {
		
			Ext.apply(Ext.form.VTypes, {
			
				'codigoPostal': function () {
					var re = /^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$/;
					return function (v) { return re.test(v); };
				}(),
				'codigoPostalText': HreRem.i18n('txt.validacion.codigo.postal'),
				'idufir': function () {
					var re = /^[0-9]{14}$/;
					return function (v) { return re.test(v); };
				}(),
				'idufirText': HreRem.i18n('txt.validacion.idufir'),
				'telefono': function () {
					var re = /^((\+?34([ \t|\-])?)?[9|8|7|6]((\d{1}([ \t|\-])?[0-9]{3})|(\d{2}([ \t|\-])?[0-9]{2}))([ \t|\-])?[0-9]{2}([ \t|\-])?[0-9]{2})$/;
					return function (v) { return re.test(v); };
				}(),
				'telefonoText': HreRem.i18n('txt.validacion.telefono'),
				'anyo': function () {
					var re = /^[0-9]{4}$/;
					return function (v) { return re.test(v); };
				}(),
				'anyoText': HreRem.i18n('txt.validacion.anyo'),
				'dosDigitos': function () {
					var re = /^[0-9]{2}$/;
					return function (v) { return re.test(v); };
				}(),
				'dosDigitosText': HreRem.i18n('txt.validacion.dos.digitos'),
				'tresDigitos': function () {
					var re = /^[0-9]{3}$/;
					return function (v) { return re.test(v); };
				}(),
				'tresDigitosText': HreRem.i18n('txt.validacion.tres.digitos'),
				'onlyImages': function() {
					var re =/(.)+((\.png)|(\.jpg)|(\.jpeg)(\w)?)$/i;
					return function (v) { return re.test(v); };
				}(),
				'onlyImagesText': HreRem.i18n("txt.validacion.solo.imagenes"),
				'emailCustom': function() {
					var re = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
					return function (v) { return re.test(v); };
				}(),
				'emailCustomText': HreRem.i18n("txt.validacion.email.custom")
			});
		}

	}

    
    
    
});
