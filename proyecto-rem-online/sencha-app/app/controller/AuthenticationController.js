/**
 * @class HreRem.controller.AuthenticationController
 * @author Jose Villel
 * 
 * Controlador de aplicación para gestionar el renderizado o no, habilitado o no, etc de componentes
 * en función de los permisos/funciones/roles que tenga el usuario.
 * 
 * Para utilizarlo es necesario añadir al componente en cuestión algunos de los atributos siguientes:
 * 
 * 			- secFunPermToShow
 * 			- secFunPermToRender
 * 			- secFunPermToEnable
 * 			- secRolesPermToEdit
 * 			- secRolesPermToEnable
 * 
 * o llamar a las funciones
 * 			- confirmFunToFunctionExecution()
 * 			- confirmRolesToFunctionExecution
 *
 * con el valor de la función/permiso/rol que tendrá que evaluar el controlador.
 * 
 */
Ext.define('HreRem.controller.AuthenticationController', {
    extend: 'HreRem.ux.controller.ControllerBase',
    
    init: function() {
    	var me = this;
    	
    	/**
    	 * Creamos una variable global para referenciar a este controlador desde cualquier punto de la aplicación.
    	 */
    	$AU = me;   	
    	
    },

    listen: {
    	controller : {
    		'*': {
				usuarioIdentificado: 'cargarUsuarioIdentificado'
             }
    	}
   	},

    control: {
    	
    	'component[secFunPermToShow]' : {
    		
    		beforerender : 'confirmFunPermToShow'
    	},
    	
    	'component[secFunPermToRender]' : {

    		beforerender : 'confirmFunPermToRender'
    	},
    	
    	'component[secFunPermToEnable]' : {
    		
    		beforerender : 'confirmFunPermToEnable'
    	},
    	
    	'component[secRolesPermToEdit]' : {
    		
    		beforerender : 'confirmRolesPermToEdit'
    	},
    	
    	'component[secRolesPermToEnable]' : {
    		
    		beforerender : 'confirmRolesPermToEnable'
    	}
    },
    
    
    /**
     * Función que se ejecutará cuando la aplicación lance el evento 'usuarioIdentificado'
     * @param {} session que lanzará el evento 'usuarioIdentificado'
     */
    cargarUsuarioIdentificado: function(session) {
    	
    	var me = this;  
    	me.session = session;
    	if(Ext.isEmpty(session.user)) {
    		me.warn("No se ha cargado el usuario.");
    	} else {
    		me.log(session.user.get("data"));
    	}
    	
    },
    
    /**
     * Función que muestra/oculta el componente que recibe si el usuario tiene o no la función cuyo
     * valor se encontrará en el atributo secFunPermToShow.
     * (No mostrar supone que se genera el código html pero se oculta el componente mediante css )
     * @param {} cmp
     */
    confirmFunPermToShow: function(cmp) {
    	
    	var me = this;
    	if (!Ext.isEmpty(cmp.secFunPermToShow) && !me.userHasFunction(cmp.secFunPermToShow)){
    		cmp.hide();
    		cmp.show = function(){return true};
    		me.log("ConfirmPermToshow ["+cmp.id+"] hide");
    	}
    },    
    
    /**
     * Función que renderiza o no el componente que recibe si el usuario tiene o no la función cuyo
     * valor se encontrará en el atributo secFunPermToRender.
     * (No renderizar supone que no se genera código html para el componente por lo que intentar 
     * añadirlo en el caso de haber un cambio de permisos en caliente puede suponer algún problema añadido)
     * @param {} cmp
     * @return {Boolean}
     */
    confirmFunPermToRender: function(cmp) {
    	var me = this;
    	if (!Ext.isEmpty(cmp.secFunPermToRender) && !me.userHasFunction(cmp.secFunPermToRender)){	
    		me.log("confirmPermToRender ["+cmp.id+"] not render");
    		return false;
    	}    	
    	return true;
    },
    
     /**
     * Función que renderiza o no el tab que recibe si el usuario tiene o no la función cuyo
     * valor se encontrará en el atributo secFunPermToRenderTab.
     * (No renderizar supone que no se genera código html para el componente por lo que intentar 
     * añadirlo en el caso de haber un cambio de permisos en caliente puede suponer algún problema añadido)
     * @param {} cmp
     * @return {Boolean}
     */
    confirmFunPermToRenderTab: function(cmp) {
    	var me = this;
    	if (!Ext.isEmpty(cmp.secFunPermToRenderTab) && !me.userHasFunction(cmp.secFunPermToRenderTab)){	
    		
    		if (cmp.tab) {
    			cmp.tab.hide();
    			cmp.tab.destroy();
    		}
    		me.log("confirmPermToRender ["+cmp.id+"] not render");
    		return false;
    	}    	
    	return true;
    },
    
    /**
     * Función que habilita o deshabilita el componente que recibe si el usuario tiene o no la función cuyo
     * valor se encontrará en el atributo secFunPermToEnable.
     * @param {} cmp
     */
    confirmFunPermToEnable: function(cmp) {
    	
    	var me = this;
    	if (!Ext.isEmpty(cmp.secFunPermToEnable) && !me.userHasFunction(cmp.secFunPermToEnable)){
    		cmp.setDisabled(true);
    		if(cmp.tab) {
    			cmp.tab.setDisabled(true);
    		}
    		me.log("confirmFuncPermToEnable ["+cmp.id+"] disabled");
    	}
    },
    
    /**
     * Funci�n que devuelve true o false dependiendo
     * de si el atributo de ID de usuario pasado por par�metro es igual al del usuario logueado
     * @param {} cmp
     */
    sameUserPermToEnable: function(idUsuario) {
    	var me = this;
    	if (me.getUser().userId == idUsuario)
    		return true;
    	else
    		return false;
    	
    },
    
     /**
     * Función que cambia el componente a readOnly que recibe si el usuario no es de alguno de los roles incluidos
     * en el atributo secRolesPermToEdit.
     * @param {} cmp
     */
    confirmRolesPermToEdit: function(cmp) {
    	var me = this;
    	
    	if (!Ext.isEmpty(cmp.secRolesPermToEdit) && !me.userIsRol(cmp.secRolesPermToEdit)){

    		cmp.setReadOnly(true);    		
    		me.log("confirmRolesPermToEdit ["+cmp.id+"] read only");
            
    	}
    	
    },
    
     /**
     * Función que habilita o deshabilita el componente que recibe si el usuario tiene o no el rol cuyo valor
     * se encontrará en el atributo secRolesPermToEnable. 
     * @param {} cmp
     */
    confirmRolesPermToEnable: function(cmp) {
    	
    	var me = this;
    	if (!Ext.isEmpty(cmp.secRolesPermToEnable) && !me.userIsRol(cmp.secRolesPermToEnable)){
    		cmp.setDisabled(true);
    		if(cmp.tab) {
    			cmp.tab.setDisabled(true);
    		}
    		me.log("confirmRolesPermToEnable ["+cmp.id+"] disabled");
    	}
    },
    
    /**
     * Función que permite la ejecución de la funcíon que recibe si el usuario tiene o no el rol recibido. 
     * @param {} funcion a ejecutar
     * @param {} roles codigo/s de usuario
     */
    confirmRolesToFunctionExecution: function (funcion, roles) {
    	
    	var me = this;
    	if (me.userIsRol(roles)){
			
    		funcion();
    		me.log("confirmRolesToFunctionExecution ["+funcion+"] executed");
    	} 	
    	
    	
    },
    
     /**
     * Permite la ejecución de la funcíon que recibe si el usuario tiene o no el permiso recibido. 
     * @param {} funcion
     * @param {} fun
     */
    confirmFunToFunctionExecution: function (funcion, fun) {
    	
    	var me = this;
    	
    	
    	if (me.userHasFunction(fun)){
			
    		funcion();
    		me.log("confirmFunToFunctionExecution ["+fun+"] executed");
    	} 	
    	
    	
    },
    
    /**
     * Función que devuelve true si el usuario contiene el permiso que recibe.En caso contrario devuelve false.
     * @param {} value
     * @return {} boolean
     */
    userHasFunction: function(value) {
    	
    	var me = this;
    	userHasFunction = false;

    	if(Ext.isArray(value)) {
    		
    		Ext.Array.each(value, function(fun, index) {
    			
    			if (Ext.Array.contains(me.getUser().authorities, fun)) {
    				userHasFunction = true;
    				return false;
    			}
    			
    		});
    		
    	} else {    		
    		userHasFunction = Ext.Array.contains(me.getUser().authorities, value);    		
    	}    	
    	return userHasFunction; 
    },
    
    userIsRol: function(roles) {
    	
    	var me = this,
    	userIsRol = false;

    	if(Ext.isArray(roles)) {
    		
    		Ext.Array.each(roles, function(rol, index) {
    			
    			if (Ext.Array.contains(me.getUser().roles, rol)) {
    				userIsRol = true;
    				return false;
    			}
    			
    		});
    		
    	} else {
    		
    		userIsRol = Ext.Array.contains(me.getUser().roles, roles);
    		
    	}
    	
    	return userIsRol;   	

    }, 
    
    getUser: function() { 
    	var me = this;
    	
    	if(!Ext.isEmpty(me.session) && !Ext.isEmpty(me.session.user)) {
    		return me.session.user.get("data");
    	}
    	
    	return {};
    }

    
});
