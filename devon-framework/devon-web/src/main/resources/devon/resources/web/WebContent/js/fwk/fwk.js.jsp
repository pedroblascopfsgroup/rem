<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

/**
 * Namespace para toda la funcionalidad del framework
 */
/*global fwk*/
fwk={};


fwk.getContext = function(){
	return '<c:url value="/"/>';
};

// funciones genéricas js
fwk.js = {};
fwk.js.hasProperties = function(obj, props){
    var notFound=[];
    if (!Ext.isArray(props)) props = [props];
    for(var i=0;i < props.length;i++){
        if (obj[props[i]]===undefined){
            notFound.push(props[i]);
        }
    }
    return notFound.length ? notFound:true;
};

/**
 * Asegura que existen las propiedades o lanza una excepción
 */
fwk.js.assertProperties = function(obj, props){
    var notFound=fwk.js.hasProperties(obj, props);
    if (notFound!==true){
        fwk.debug.window("Faltan propiedades al objeto :"+notFound, obj, props, notFound);
        throw new String("Faltan propiedades al objeto");
    }
};

/**
 * Elimina las propiedades de un objeto
 */
fwk.js.removeProperties = function(obj, props){
	if (!Ext.isArray(props)) props = [props];
	for(var i=0;i < props.length;i++){
		delete obj[props[i]];
	}
};


/**
 * extrae propiedades de un objeto y las devuelve como resultado. Modifica el objeto original
 * eliminando las propiedades extraídas
 */
fwk.js.extractProperties = function(obj){
	if (!obj) return {};
	var props=Array.prototype.slice.call(arguments,1);
	var result = {};
	for(var i=0;i<props.length;i++){
		var value = obj[props[i]];
		if (value!=undefined){
			result[props[i]]=value;
			delete obj[props[i]];
		}
	}
	return result;
};


/*
 * obtiene las propiedades de un objeto en un array
 */
fwk.js.getProperties = function(obj) {
	  var i, v;
	  var count = 0;
	  var props = [];
	  if (typeof(obj) === 'object') {
	    for (i in obj) {
	      v = obj[i];
	      if (v !== undefined && typeof(v) !== 'function') {
	        props[count] = i;
	        count++;
	      }
	    }
	  }
	  return props;
};

/*
 * copia las propiedades que indicamos de un objeto a otro si existen. Si no
 * existe podemos proporcionar un valor por defecto
 * a = {a:1,b:true}
 * b = {}
 * copyProperies(b,a,['a','b',['c','defValue'],'other'])
 *
 * -> b=={a:1,b:true,c:'defValue'}
 *
 * si no pasamos array de propiedades, se copiarán todas las del objeto src
 */
fwk.js.copyProperties = function(obj, srcObject, props){
	srcObject=srcObject ||{};
	if (props==undefined){
		props = [];
		for(var x in srcObject){
			props.push(x);
		}
	}
	for(var i=props.length;i--;){
		var prop=props[i];
		var def
		if (Ext.isArray(prop)){
			def=prop[1];
			prop=prop[0];
		}
		if (srcObject.hasOwnProperty(prop)){
			obj[prop]=srcObject[prop];
		}else if(def!==undefined){
			obj[prop]=def;
		}
	}
};

/**
 * Redirecciona a la página de login
 */
fwk.loginRedirect = function(){
	Ext.Msg.alert(fwk.constant.errorMsg, fwk.constant.loginRedirect);
	window.location=getContext()+'${appProperties.security.defaultTargetUrl}';
};

fwk.constant = {
	pageSize : 10
	,paginationMsg : '<s:message code="fwk.constant.paginationMsg" text="**Mostrando {0} - {1} de {2}" />'
	,emptyMsg : '<s:message code="fwk.constant.emptyMsg" text="**No hay datos" />'
	,errorMsg : '<s:message code="fwk.constant.errorMsg" text="**Mensaje de error" />'
	,loginRedirect : '<s:message code="fwk.constant.loginRedirect" text="**No tiene los permisos necesarios para continuar en la aplicación. Se redireccionará a la página de entrada." />'
	,alert : '<s:message code="fwk.constant.alert" text="**Mensaje de alerta" />'
	,fwkError : '<s:message code="fwk.constant.fwkError" text="**Advertencia: La operación no se pudo realizar..." />'
	,fwkUserError : '<s:message code="fwk.constant.fwkUserError" text="**Error en el servidor" />'
	,confirmar : '<s:message code="fwk.constant.confirmar" text="**Mensaje de confirmacion" />'
};

/**
 * crea el objeto que mantendrá los eventos del framework
 */
fwk.Event = function(){
    this.addEvents( 'userError' ,'fwkError' ,'stats' );
};

Ext.extend(fwk.Event, Ext.util.Observable);

fwk.event = new fwk.Event();


/**
 * Muestra un cuadro de alerta para notificar al usuario
 */
fwk.alert = function(text){
	Ext.Msg.show({
		title : fwk.constant.alert
		,msg :text
		,icon : Ext.MessageBox.WARNING
	});
};


/**
 * Muestra una ventana tipo outlook para notificar al usuario
 */
fwk.toast = function(msg, title){
	var n=new Ext.ux.ToastWindow({
		title : title || ''
		,html : msg || ''
	}).show(document);
};

/**
 * registra un log de mensajes de log. Si estamos en debug (existe Ext.log) entonces saldrán por la consola
 */
fwk.log = function(msg){
	fwk.log.history.push(msg);
	if (Ext.log){
		Ext.log("log", new Date()+"<br/>"+msg);
	}
};

fwk.log.history = [];

/**
 * Utilidades referentes al manejo del DOM del navegador
 */
fwk.dom = {};

fwk.dom.findParent = function(id,sel){
    var el=Ext.get(id);
        if (el){
            var panel = el.findParent(sel);
            if (panel){
                return Ext.getCmp(panel.id);
            }
        }
};

/**
 * Funcionalidad Ajax del framework
 */
fwk.ajax = {
	requestcomplete: 0
};


fwk.ajax.debug = function(){
	fwk.ajax.debug.arr = [];
    var store = new Ext.data.SimpleStore({
        fields :[
            {name : 'date', type : 'date'}
            ,{name : 'conn'}
            ,{name : 'response'}
            ,{name : 'options'}
            ]
    });
	Ext.Ajax.on('requestcomplete', function(conn, response, options){
		fwk.ajax.debug.arr.push([ new Date(), conn, response, options ]);
        store.loadData(fwk.ajax.debug.arr);
	});

    if (fwk.ajax.debug.win){
        fwk.ajax.debug.win.show();
    }else{
        var textarea = new Ext.form.TextArea({
            width : 400
            ,height : 300
        });

        var filtro = new Ext.form.TextField({
            enableKeyEvents: true
        });
        var dateRenderer=function(value){return value.format("h:i:s");};
        var responseRenderer = function(value){
            return value.responseText;
        };
        var bjson = new Ext.Button({
            text : 'json print'
            ,handler : function(){
                textarea.setValue(textarea.getValue().parseJSON().toJSONString());
            }
        });
        var panel = new Ext.grid.GridPanel({
            store : store
            ,columns : [
                {id :'date', dataIndex : 'date', renderer :  dateRenderer, width : 40}
             ,{id : 'response',dataIndex : 'response', renderer : responseRenderer}
            ]
            ,viewConfig : {forceFit : true}
            ,height : 200
            ,width : 400
            ,tbar : [filtro, bjson]
        });

        filtro.on('keypress', function(){
            store.filterBy(function(record){ if (record.get("response").responseText.indexOf(filtro.getValue())>=0) return true;} );
        });

        panel.on('rowclick', function(grid, index, e){
            var record = this.getStore().getAt(index);
            //lo guardamos para acceder fácilmente
            fwk.ajax.debug.record=record;
            textarea.setValue(record.get('response').responseText);
        });

        var win = new Ext.Window({
            title : 'Ajax debug'
            ,items : [panel, textarea]
            ,height : 500
            ,widht : 400
        });
        fwk.ajax.debug.win=win;
    }

    win.show();
        win.on('resize', function(comp, width, height, rawW, rawH){
            panel.setWidth(width);
            textarea.setWidth(width);
        });

    //shortcut
    fwkd = function(){
        return fwk.ajax.debug.record.response.responseText;
    }
};



/**
 * Encuentra un control de tipo panel a partir de un elemento html
 * @param {id} id string o elemento html del cual partir
 * @return el panel Ext padre que contiene el elemento
 */
fwk.dom.findParentPanel = function(id){
    return fwk.dom.findParent(id, '.x-panel');
};


fwk.dom.findParentWindow = function(id){
    return fwk.dom.findParent(id, '.x-window');

};

/**
 * Encuentra el primer componente contenedor, sea window o panel
 */
fwk.dom.findParentContainer = function(id){
    var panel=fwk.dom.findParentPanel(id);
    var window=fwk.dom.findParentWindow(id);

    if (panel && !window) return panel;
    if (!panel && window) return window;

    if (panel.getEl().contains(window.getEl())) return panel;
    return window;
};


//añade un control a un componente tipo
fwk.dom.addToParentContainer = function(node, control){
    var panel=fwk.dom.findParentContainer(node);
    if (panel){
        panel.add(control);
        panel.doLayout();
    }
};

/**
 * Funciones a ejecutar sobre los parámetros que viajan en la response
 */
fwk.handlers = {};

/**
 * Muestra los errores en un label que se añade si no existe al panel
 * que realiza la llamada ajax
 *
 * @data es el objeto JSON de la respuesta (ya ha pasado por Ext.decode)
 * @config es el objeto con el que se hizo la llamada ajax
 */
fwk.handlers.fwkUserExceptions = function(userExceptions, config, data){
    if (!userExceptions) return;  //si no hay errores, pues no hacemo nada

    //si no hay formulario, mostraremos los errores en un alert
    var form ;
    //FIXME: seguro que puede venir en config.userConfig??
    if (config.userConfig) form = config.userConfig.formPanel;
    //esta es la forma de encontrar el userConfig
    if (!form){
        if( config.scope && config.scope.options && config.scope.options.userConfig ){
            form = config.scope.options.userConfig.formPanel;
        }
    }
    if(!form){
    	Ext.Msg.alert(fwk.constant.fwkUserError,userExceptions);
        return;
    }

    form = form.getForm();


    var errorList = form.findField('errorList');
    //si no existe, pero hemos puesto autoErrors, crearemos el errorList
    if(!errorList && config.options.userConfig.autoErrors){
    	errorList = new fwk.ux.ErrorList();
    	form.insert(0, errorList);
		form.doLayout();
    }

    if (errorList){
    	errorList.setRawValue(userExceptions);

    }else{
        Ext.Msg.alert(fwk.constant.fwkUserError,userExceptions);
    }

};

/**
 * Muestra las excepciones del framework y las no controladas (p.ej. NullPointerException)
 * se muestran en una ventana popup
 */
fwk.handlers.fwkExceptions = function(fwkExceptions, config, data){
//	fwkExceptions= "<ul><li>"+fwkExceptions.join("</li><li>")+"</li></ul>";
  //  Ext.Msg.alert(fwk.constant.fwkError,fwkExceptions);
	fwk.showErrors(fwk.constant.fwkError,fwkExceptions);
};

fwk.handlers.events = function(events, config, data){
    //para cada evento de servidor, lanzaremos un evento de cliente
    var ev = events.user;
    if(ev){
        for(var i=0;i < ev.length;i++){

            fwk.event.fireEvent(ev[i].type, ev[i].params);
        }
    }
};

/**
 * Muestra una lista de errores
 */
fwk.showErrors = function(title, errors){
	if (!Ext.isArray(errors)) errors = [errors];
	errors= "<ul><li>"+errors.join("</li><li>")+"</li></ul>";
	Ext.Msg.alert(title,errors);
}

/**
 * Cuando llegan errores a un formulario algunos se muestran en los controles (ExtJS) y los que no
 * se tienen que mostrar en un errorList o en un alert
 *
 * en options nos viene el form DOM, tenemos que buscar el componente ExtJS del formulario
 */
fwk.showNotHandledErrors = function(errors, options){
	var msgs=[];
	var f=false;
	if (options.form!==undefined){
		var formId=options.form.id;
		f=fwk.dom.findParentPanel(formId);
		if (f) f=f.getForm();
	}
	for(x in errors){
		if (!f || !f.findField(x)){
			msgs.push(errors[x]);
		}
	}
	if (msgs.length>0){
		fwk.showErrors(fwk.constant.fwkUserError,msgs);
	}
};

//capturamos todas las respuestas ajax
//TODO: ver si se está decodificando 2 veces por petición!!!!
Ext.Ajax.on('requestcomplete', function(conn, response, options){
	fwk.ajax.requestcomplete++;

    var getContentType=function(r){
        if (!r.getResponseHeader) return "";
        if (typeof r.getResponseHeader ==   "function"){
            return r.getResponseHeader('Content-Type');
        }
        return r.getResponseHeader['Content-Type'];
    }

    if( getContentType(response).indexOf('application/json')>=0){
        var decoded = Ext.decode(response.responseText);
        if (decoded.errors){
        	fwk.showNotHandledErrors(decoded.errors, options);
        }

        if (!decoded.fwk) return;

        var params = decoded.fwk;

        //para cada handler, le pasaremos la información que quiere manejar y llamaremos a la función
        for(handler in fwk.handlers){
        	if (params[handler]){
        		fwk.handlers[handler](params[handler], options, decoded);
        	}
    	}
    }
    if( getContentType(response).indexOf('application/error')>=0){
        fwk.showErrors(fwk.constant.fwkError,'<s:message code="fwk.constant.generic.error" text="**Error en servidor" />');
        response.responseText="";
    }

});


fwk.debug = function(){
    fwk.log((new Date().format('H:i:s'))+" "+Array.prototype.slice.call(arguments,0));
};

fwk.debug.debugging = true;

fwk.debug.isDebugEnabled = function(){
    return fwk.debug.debugging;
};

fwk.debug.globals = [];
fwk.debug.storeArgs = function(args){
    var values=[];
    for(var i=0;i < args.length;i++){
        values.push(args[i]);
    }
    fwk.debug.globals.push(values);
};

fwk.debug.lastArgs = function(){
    return fwk.debug.globals[fwk.debug.globals.length-1];
};

fwk.debug.window = function(){
    var html = "";
    fwk.debug.window.args=[];
    for(var i=0;i < arguments.length;i++){
    	fwk.debug.window.args[i]=arguments[i];
        var o = arguments[i];
        html += "<br/>arguments["+i+"]=";
        if (typeof(o)==="string"){
            html += o;
        }else{
            html += "<a href='#' onclick='ObjectExplorer.explore(fwk.debug.window.args["+i+"], \"full\")'>obj</a>";
//            html += "<a href='#' onclick='alert(2)'>obj</a>";
        }
    }

    var w = new Ext.Window({
        title : 'debug'
        ,autoHeight : true
        ,html : html
        ,bodyStyle : 'padding:10px'
    });
    w.show();
}


// TODO: ver que hacemos con los errores
/**
 * Guardamos los errores que se producen
 */
fwk.debug.error = function(){
    var err = {};
    err.date = new Date();
    err.args = ""+arguments;
    fwk.debug.error.errors.push(err);
    fwk.log(err.args);
};

/**
 * Almacén de errores
 */
fwk.debug.error.errors = [];


fwk.array = {};
fwk.array.extract =function(array, key){
    var l=array.length;
    var values = [];
    for(var i=0;i < l;i++){
        if (array[i][key]!=undefined) values.push(array[i][key]);
    }
    return values;
};

fwk.records = {};
fwk.records.getFields = function(records, key){
    var l=array.length;
    var values = [];
    for(var i=0;i<l;i++){
        if (array[i].get(key)!=undefined) values.push(array[i].get(key));
    }
    return values;
};



//----- Page ----------------------------------------------

/**
 * Objeto pagina que expone la funcionalidad del framework a las páginas javascript
 */
fwk.Page = function(appName, uuid, flowExecutionKey, flowExecutionUrl){
	/*private*/
	var _uuid=uuid || '';
	var _appName = appName;
	var _flowExecutionKey=flowExecutionKey || '';
	var _flowId=flowExecutionUrl || '';
	var _parentPanel;
	this._flowExecutionKeyCopy=_flowExecutionKey; //DEBUG: esta copia es para debug, eliminar

	if (_flowId.indexOf("\.htm")>0){
		//XXX: el formato del flowExecutionUrl por defecto es : "/pfs/admin/editarUsuarios.htm?execution =e16s1", lo eliminamos
		_flowId=_flowId.replace(/\/[^\/]*\//,"");
		_flowId=_flowId.replace(/\.htm\?.*$/,"")
	}

	if (_uuid){
		_parentPanel = fwk.dom.findParentContainer(Ext.get(uuid).dom);
	}

	this.getParentPanel = function(){
		return _parentPanel;
	};

	this.getFlowExecutionKey = function(){
		//fwk.log("getFlowExecutionKey="+_flowExecutionKey);
		return _flowExecutionKey;
	};

	this.setFlowExecutionKey = function(newKey){
		_flowExecutionKey = newKey;
		this._flowExecutionKeyCopy = newKey;
	};

	this.getUUID=function(){
		return _uuid;
	};

	this.getFlowId = function(){
		return _flowId;
	};

	this.getAppName = function(){
		return _appName;
	}

};

/**
 * Actualiza el flowExecutionKey en el objeto que mantiene la página.
 */
fwk.Page.prototype.updateKey = function(response){
    if (!response.fwk) response=Ext.decode(response.responseText);
    if (response==undefined || !response.fwk) return;
    var key = response.fwk.flowExecutionKey || '';
    this.setFlowExecutionKey(key);

};

/**
 * Ejecuta las llamadas asignadas por el usuario después de haberla tratado en una
 * acción de webflow. Deben haberse pasado dentro del config en la propiedad userConfig
 */
fwk.Page.prototype.executeCallbacks = function(config, data){
	//fwk.debug.window("scope", scope, "config", config);
    if (config && config.userConfig){
        var f = data.success? config.userConfig.success : config.userConfig.error;
    	if (f && typeof(f)=="function"){
    		//Nota: aquí no sé si pasar config, o config.userConfig que al fin y al cabo es lo
    		//que ha utilizado el usuario para hacer la llamada
    		//XXX: this aquí no es window!!!, debería ser
        	f.call(config.scope || this,data,config.userConfig);
    	}
    }
};


/**
 * Añade un control al panel que representa la página.
 */
fwk.Page.prototype.add = function(controls){
	if (!Ext.isArray(controls)) controls = [controls];
    for(var i=0;i < controls.length;i++){
        this.getParentPanel().add(controls[i]);
    }
    this.getParentPanel().doLayout();
};

/**
 * Lanza un evento al panel que contiene a la página actual
 */
fwk.Page.prototype.fireEvent = function(eventName, args){
	this.getParentPanel().fireEvent(eventName, args)
}
/**
 * Instala un manejador de eventos en el panel que contiene la página
 */
fwk.Page.prototype.on = function(eventName, handler, scope, options){
    this.getParentPanel().on(eventName, handler, scope, options);
};

/**
 * Añade los parámetros necesarios para la ejecución del webflow
 */
fwk.Page.prototype.addParams = function(params, flow, eventName){
	//fwk.log("addParams flow="+flow + " eventName="+eventName+ "this.flowUrl="+this.getFlowId()+" this.flowkey="+this.getFlowExecutionKey());
	if (eventName){
		params._eventId=eventName;
	}

	//fwk.log("getFlowExecutionKey==true??"+(this.getFlowExecutionKey())+":"+(this.getFlowExecutionKey()==true));
	if ((!flow || flow==this.getFlowId()) && this.getFlowExecutionKey()!==''){
		params.execution=this.getFlowExecutionKey();
	}
};





/**
 * crea un HttpProxy que obtiene la conexión de la llamada a un webflow. Nos hace falta
 * la referencia al objeto page para poder actualizar el token de navegación del flow
 * @config {String} flow nombre del flow a ejecutar
 * @config {Page} page objeto de la página actual
 * @config {Function} success (optional) función que se llamará cuando la respuesta llegue con success==true
 * @config {Function} error (optional) función que se llamará cuando la respuesta llegue con success==false
 * @config {Function} failure (optional) función que se llamará cuando tengamos un error en la respuesta
 */
fwk.Page.prototype.getProxy = function(config){
	var cfg = {
			url : this.resolveUrl(config.flow)
			,page : this
			,method : 'POST'
			,success : function(response, cfg){
				var data = Ext.decode(response.responseText);
				cfg.page.updateKey(data);
				cfg.page.executeCallbacks(cfg,data)
			}
			,userConfig : config
		};

		return new Ext.data.HttpProxy(cfg);
};

/**
 * obtiene un objeto Store que se actualizará haciendo llamadas a un flow y
 * mantendrá la navegación.
 *
 * Se debe crear a partir del objeto page que tenemos referenciado en la página
 * @config {Reader} reader El objeto que se usará como reader en el Store
 * @config {String} flow el flow al que se realizarán las peticiones ajax
 * @config {String} eventName el nombre del evento en el flujo que se enviará
 */
fwk.Page.prototype.getStore = function(config){
	fwk.js.assertProperties(config, ['reader']);

	var _page = this;

	//si llamamos a otro flow, se creará un nuevo objeto page.
	if (config.flow && config.flow!=this.getFlowId()){
		_page = new fwk.Page(this.getAppName(), '','',config.flow);
	}

	var store = new Ext.data.Store({
		proxy : _page.getProxy({
			flow : config.flow || _page.getFlowId()
			,page : _page
		})
		//TODO:
		,limit : config.limit || fwk.constant.pageSize
		,reader : config.reader
		,eventName : config.eventName
		,page : _page
		,flow : config.flow
		,setBaseParams : function(params){
    		this.baseParams = params;
    	}
	});

	if (config.remoteSort!=undefined){
		store.remoteSort = config.remoteSort;
	}

	store.webflow = function(params, callback){
		//si vienen estos parámetros, no pueden estar en el baseParams puesto que si no,
		//reemplazarían a los params que usa la paginación
		var p = fwk.js.extractProperties(params,'start', 'limit');

		var baseParams = params || {};
		//actualizamos los parámetros base al nuevo token
		this.page.addParams(baseParams, this.flow, this.eventName);
		//XXX: cuidado! aquí estamos accediendo directamente a una propiedad del objeto Store de ExtJS.
		//No se puede hacer de otra forma por ahora
		this.baseParams = baseParams;

		var cfg = {
				userCallback : callback
				//tenemos que actualizar los baseParams para que reflejen el nuevo token
				,callback : function(r,options, success){
								if (success && this.page){
									if (this.page.getFlowExecutionKey()){
										this.baseParams.execution = this.page.getFlowExecutionKey();
									}
								}
								if (options.userCallback){
									options.userCallback(r,options,success);
								}
							}
		};


		//sólo asociamos si existe algún parámetro. porque si no, no funciona bien la paginación de ExtJS
		if ( fwk.js.getProperties(p).length ){
			cfg.params = p;
		}else{
			cfg.params = {
					limit : this.limit
					,start : 0
			};
		}

		this.load(cfg);
	};

	return store;
};

/**
 * usamos el objeto página para resolver la url
 */
fwk.Page.prototype.resolveUrl = function(flow){
	return fwk.getContext() + (flow? flow : this.getFlowId()) +".htm";
};

/**
 * Este método creará una nueva página si es necesario para mantener una conversación con
 * webflow distinta a la de la 'page' actual. Esto ocurre si la petición la realizamos a un
 * flow que tiene distinto id que el de la página en la que estamos
 */
fwk.Page.prototype.getPageObject = function(config){
	if (config.flow && config.flow!=this.getFlowId()){
		return new fwk.Page(this.getAppName(),'','',config.flow);
	}
	return this;
};

/**
 * Realiza una petición ajax que devolverá una respuesta JSON que será pasada una función de callback que le proporcionemos
 * @flow String el nombre del flow al que realiza la petición
 * @page el objeto javascript que mantiene la información de la página actual. Se utiliza para mantener el flowExecutionKey
 * @success callback que se ejecutará cuando el resultado sea ok
 * @params parámetros que se enviarán a la petición del flow
 * @options opciones para la request ajax
 * @config {Function} success (optional) función que se llamará cuando la respuesta llegue con success==true
 * @config {Function} error (optional) función que se llamará cuando la respuesta llegue con success==false
 * @config {Function} failure (optional) función que se llamará cuando tengamos un error en la respuesta
 * @config {Object} scope (optional) scope en el que se ejecutarán los callback
 * recibirá los parámetros:
 *   data : el objeto json ya decodificado
 *   config : la configuración original de la llamada
 */

fwk.Page.prototype.webflow = function(config){

	var _page = this.getPageObject(config);

    var p = {
    	url : _page.resolveUrl(config.flow)
    	,method : config.method || 'POST'
    	,params : config.params || {}
    	,page : _page
    	,userConfig : config
    	,options : config.options || {}
    	,scope : config.scope || _page
    };

   	_page.addParams(p.params, config.flow, config.eventName);

    p.success = function(response, config){
        var data = Ext.decode(response.responseText);
        //IMPORTANTE: en cada llamada debemos refrescar el flowExecutionKey
        config.page.updateKey(data);
        //ejecutamos la función pasada como parámetro si tenemos error, o respuesta ok.
        //pasamos los datos ya decodificados
        config.page.executeCallbacks(config, data);

    };

    p.failure = function(response, config){
        fwk.debug.error("La llamada ajax ha fallado", response, config);
        if (config.userConfig && config.userConfig.failure ){
        	config.userConfig.failure(response,config);
        }
    };

    Ext.Ajax.request( p );
    return _page;
};


/**
 * Envía un formulario a un flow.
 * @config {String} flow El flow al que se enviará, por ejemplo:
 * flow : 'admin/editUsuario'  sin el nombre de aplicación ni el .htm
 * @config {String} flow (optional) nombre del flow a ejecutar, por defecto el mismo que ha cargado la página
 * @config {String} eventName (optional) nombre del envento a ejecutar en el flow
 * @config {FormPanel} formPanel el control formpanel que contiene el formulario a enviar.
 * @config {Function} success (optional) función que se llamará cuando la respuesta llegue con success==true
 * @config {Function} error (optional) función que se llamará cuando la respuesta llegue con success==false
 * @config {Function} failure (optional) función que se llamará cuando tengamos un error en la respuesta
 * Es necesario para poder pintar los errores en el mismo si existe un errorList
 */
fwk.Page.prototype.submit = function(config){
	var _page = this.getPageObject(config);

    fwk.js.assertProperties(config, ['formPanel']);

    var params = {}; //los parametros a enviar
    if (config.params){
    	for(x in config.params){
    		params[x]=config.params[x];
    	}
    }
    _page.addParams(params, config.flow, config.eventName);

    //las opciones que se pasan al submit
    var options = {
        url : _page.resolveUrl(config.flow)
        ,params : params
        ,success : function(form,action){
            formPanel.container.unmask();
            action.options.page.updateKey(action.result);
            action.options.page.executeCallbacks(action.options, action.result);

        }
        ,failure : function(form,action){
            formPanel.container.unmask();
            action.options.page.executeCallbacks(action.options, action.result);
        }
        ,userConfig : config
        ,page : _page
    };


    var formPanel = config.formPanel;

	formPanel.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
    formPanel.getForm().submit(options);

    return _page;
};


/**
 * Crea el objeto necesario para una página que se recarga vía Ajax. Este objeto se necesita para mantener el flujo de
 * navegación de webflow. También contiene información del panel que contiene a la página y que puede usarse para
 * añadir contenido al mismo.<br/>
 *
 * Llama a la función que define el código de la página y la envuelve en un try para evitar excepciones que lleguen al usuario
 */
fwk.onReady = function(appName, id, flowExecutionKey, flowExecutionUrl, initFunction){
	var page = new fwk.Page(appName, id, flowExecutionKey, flowExecutionUrl);
    try{
        initFunction(page);
    }catch(e){
        fwk.log(e);
    }
};



// controles personalizados del framework

fwk.ux = {};
/**
 * Encapsula la creación de un objeto Ext.PagingToolbar con las opciones
 * por defecto más normales
 */
fwk.ux.getPaging = function(store, config){
	config = config || {};
	var cfg = {
		pageSize : store.limit || fwk.constant.pageSize
		,store : store
		,displayInfo : true
		,displayMsg : fwk.constant.paginationMsg
		,emptyMsg : fwk.constant.emptyMsg
		,lastText:'<s:message code="pagination.ultimapagina" text="**Ultima Pagina" />'
		,nextText:'<s:message code="pagination.paginasiguiente" text="**Pagina Siguiente" />'
		,prevText:'<s:message code="pagination.paginaanterior" text="**Pagina Anterior" />'
		,firstText:'<s:message code="pagination.primerapagina" text="**Primera Pagina" />'
		,width : config.width || 450

	};

	var paging = new Ext.PagingToolbar(cfg);

	paging.on('render', function(){
		if (!config.loading){
			paging.loading.hide();
		}
	});

	store.on('beforeload', function(){
		paging.loading.show();
	});
	store.on('load', function(){
		paging.loading.hide();
	});
	return paging;
}


<%@ include file="errorList.js.jsp" %>
