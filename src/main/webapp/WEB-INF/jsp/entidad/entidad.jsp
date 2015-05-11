<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
if (!window.console) {
 //IE debugging
  console={};
  console.debug=console.error=function(){};
}
/*cada entidad tendra la siguiente estructura

   id          : id del elemento actualmente visible (cliente, contrato, etc)
   cache       : estado de las entidades
     data      : datos obtenidos del servidor para un elemento
     activeTab : tab activo la ultima vez que estaba visible el elemento
     panel     : panel en el que se visualiza la entidad

*/

log = function(str,obj){
  if (obj){
    var matches = str.match(/#\w+/g);
    for (var x in matches){
       var prop=x.substr(1);
       var value=obj[prop];
       str = str.replaceAll(x,value);
    }
  }
  if (!log.filter) {
    log.filter=".*";
  }
  if (str.match(new RegExp(log.filter))){
      if (obj) console.debug(obj);
  }
}


//generico para todas las entidades: cliente, contrato, etc...
app.entidad = function( id, clienteTabs, clienteToolbar, flow, icon){
	app.entidad.entidades = app.entidad.entidades || [];
	app.entidad.primeras = app.entidad.primeras || {};
	app.entidad.entidades.push(this);
	var _selfEntidad=this;
	this.cache = {};
	this.id=id;
	this.entidadNombre=id;
	this.icon = icon;
	if (! app.contenido.getUltimoTab){
		app.contenido.getUltimoTab = function(){
			var l = 0
			return this.items.get(l);
		}
	}

	if (!Ext.getCmp("todoVacio")){
		app.contenido.add(new Ext.Panel({
		  id :"todoVacio"
		  ,noCerrar : true //este tab tampoco lo cerramos
		}));
		app.contenido.hideTabStripItem(Ext.getCmp("todoVacio"));
	}

	
	 /*mete un valor en el cache para el elemento
		- id si se pasa como parametro (3 params)
		- this.actualId (valor actualmente visible) si se llama con 2 params*/
	this.put = function(id, key, value){
		if (arguments.length==2){
		  value=key;
		  key=id;
		  id=this.actualId;
		}
		if (!this.cache[id]) { this.cache[id]={}; }
		this.cache[id][key]=value;
	}

	/* obtiene la propiedad key de la cache de elementos
	  si no se pasa el id, se obtiene del elemento actual */
	this.get = function(id, key){
		if (arguments.length==1){
		  key=id;
		  id=this.actualId;
		}
		if (!key){
		  return this.cache[id];
		}
		return this.cache[id][key];
	}

	 /* activa el panel actual, introduce el panel de la entidad en el tab visible */
	this.setActual = function(panel){
		var id=panel.getEntidadId();
		data = this.get(id, "data");
		this.actualId=id;
		var panel=this.get(id, "panel");
		panel.add(this.panelDeTabs); // <-- inserta el panel en el tab principal
		state = this.toolbar.setValue(data);
		this.toolbar.doLayout();

		//hack: el layout del panel y menu hace que el toolbar haga visible todos los botones
		//por tanto hay que diferir el setState que maneja la visibilidad hasta que se haya refrescado el DOM
		this.setState.defer(10,this,[state]);
		//hack
	}

	this.setVisibleTabs = function(data){
		for(var i=0;i < this.subTabs.items.length;i++){
		  var visible = true;
		  if (this.subTabs.items.get(i).setVisibleTab){
			 visible &= this.subTabs.items.get(i).setVisibleTab(data);
		  }
		  if(visible){
		this.subTabs.unhideTabStripItem(i);
		  }else{
		this.subTabs.hideTabStripItem(i);
		  }
		}
	};
	 
	this.activateTab = function(){
		var tab=this.get("activeTab");
		var panel=this.get("panel");
		var data = this.get("data");
		if(tab){
		}else{
		  tab = this.subTabs.items.get(0);
		}


		panel.doLayout();
		this.setVisibleTabs(data);
		var state;
		if (this.subTabs.getActiveTab()==tab){
		  state=tab.setValue();
		  this.setState(state);
		}else{
		  //hack: esta parte es compleja
		  //este activateTab hace que se vuelva a ejecutar el activateTab cuando acabemos de ejecutar este metodo
		  //puesto que se dispara el activate del subTab
		  this.subTabs.setActiveTab(tab);
		  //hack
		}

		//evitamos llamar 2 veces a tmoDoLayout limpiando el timer si ha pasado por aqui antes del tmo
		//if(this.tmoDoLayout){
	  //clearTimeout(this.tmoDoLayout);
	   // }
		//this.tmoDoLayout=setTimeout(function(){ log("doLayout");panel.doLayout();}, 50);   
	//panel.doLayout();

		//IMPORTANTE el layout del componente lo sacamos de esta llamada
		// porque crea problemas repintar en este punto del ciclo
		//panel.doLayout();

	}

	this.activateSubTab = function(subtab){
		this.put("activeTab", subtab);
		subtab.setValue();
	}

	this.setState = function(state){
		if (!state) return;
		if (state.esVisible) this.setVisible(state.esVisible);
		if (state.esEnabled) this.setEnabled(state.esEnabled);
	}

	/* Aqui se crean los subtabs */
	this.crearPanel=function(id, tabs, toolbar,flow){
		var page = new fwk.Page("pfs", "", "", "");
		this.toolbar=toolbar(this,page);
		var tabsInitialized=[];
		for(var i=0;i < tabs.length;i++){
		  var subtab=tabs[i](page,this);
		  subtab.on("beforehide", function(){
			});
		  subtab.on("activate", function(){
			 //_selfEntidad.activateEntidad(this);
			 _selfEntidad.activateSubTab(this);
		  });
		  subtab.on("deactivate", function(){
			var state=this.getValue();
			_selfEntidad.put(this.initialConfig.nombreTab, state);
		  });
		  tabsInitialized.push(subtab);
		}

		//subpaneles de la entidad
		this.subTabs = new Ext.TabPanel({
		  border : false
		  ,items : tabsInitialized
		  ,autoDestroy : false
		  ,enableTabScroll:true
		});

		//este es el panel con los subpaneles
		this.panelDeTabs = new Ext.Panel({ 
		  border : false
		  ,autoHeight : true
		  ,tbar : this.toolbar
		  ,items : this.subTabs
		  ,autoDestroy : false
		  ,id : this.id+'-panelDeTabs'
		});


		//este es el tab donde se esconde cuando no hay ninguna entidad visible (para que no se destruya)
		this.panelContenedor = new Ext.Panel({
		  title : "invisible" + id
		  ,items : this.panelDeTabs
		});
		app.contenido.add(this.panelContenedor);
		//app.contenido.hideTabStripItem(this.panelContenedor); //no lo necesitamos visible
	}

	this.activateEntidad = function(tab){
		this.put("activeTab", tab);
		this.activateTab();
		//tab.setValue();
	}

	this.existing = function(id){
	  return Ext.getCmp(this.entidadNombre+"-"+id);
	}

	
	this.abrir = function(id, nombre,params){
		app.entidad.showMask();

		if (!app.entidad.primeras[this.entidadNombre]){
			app.entidad.primeras[this.entidadNombre] = id;
		}
		
		
		if (params && typeof(params)=="object")
			var nombreTab = params.nombreTab
		else
			var nombreTab = params
				
		if (Ext.get(this.panelContenedor.ownerCt.getTabEl(this.panelContenedor)).isVisible()){
			this.panelContenedor.ownerCt.hideTabStripItem(this.panelContenedor);
		}
		
		var panelEntidad = this.existing(id);
		if (panelEntidad) {
		  if (panelEntidad.mustUnHideTab){
			Ext.getCmp(app.contenido.id).unhideTabStripItem(panelEntidad);
			panelEntidad.mustUnHideTab = false;
		  }
		  if (panelEntidad.mustShow){
			panelEntidad.show();
			panelEntidad.mustShow = false;
		  }
		  this.ajaxEntidad(this,id,panelEntidad,params);
		  app.entidad.hideMask();
		  return;
		}
		//este panel se crea para cada elemento entidad, es el que tiene el titulo del cliente
		panelEntidad = new Ext.Panel({
		  title : nombre
		  ,autoScroll:true
		  ,autoHeight:true
		  ,closable : true
		  ,id : this.entidadNombre + "-"+id
		  ,iconCls : this.icon || 'icon_cliente'
		  , entidadNombre : this.entidadNombre
		});


		// el id de la entidad del panel lo obtenemos a partir del id real del panel extjs
		panelEntidad.getEntidadId = function() { return this.id.replace(/[^-]*-/,""); }


		//al activar este panel, hay que setear los datos
		panelEntidad.on("activate", this.seteaDatos );

		panelEntidad.on("deactivate", function(){
		  var tab=_selfEntidad.subTabs.getActiveTab();
		  var state=tab.getValue();
		  _selfEntidad.put(tab.initialConfig.nombreTab, state);
		});

		panelEntidad.on("beforeclose", function(p){
		 if (Ext.isIE){
			p.mustUnHideTab = true;
			var contenedor = p.findParentByType(Ext.TabPanel);
			Ext.getCmp(contenedor.id).hideTabStripItem(p);
			p.hide();
			p.mustShow = true;
			var ea = app.contenido.getUltimoTab();
			if (ea){
				app.contenido.setActiveTab(ea);
			}
		 	return false;
		 }else{
		 }
		  if (this.cerrando) {
			delete this.cerrando;
			return true;
		  }
		this.cerrando=true;
		  _selfEntidad.cierraTab(id);
		  //setTimeout( app.contenido.remove(p), 100);
		  //return false;
		});
		panelEntidad.on("close", function(){
		});

		this.put(id, "panel", panelEntidad);


		app.contenido.add(panelEntidad);

		this.ajaxEntidad(this,id,panelEntidad,params);

	}

	this.seteaDatos = function(){
		  _selfEntidad.setActual(this);
		  _selfEntidad.activateTab();
	};

	this.ajaxCallParams = null;
	this.ajaxEntidad = function(_selfEntidad,id,panel,paramsEntrada){

		if (paramsEntrada && typeof(paramsEntrada)=="object") {
			var params = paramsEntrada;
		} else {
			var params = {id : id};
			if (paramsEntrada) params.nombreTab=paramsEntrada;
		} 
		this.ajaxCallParams = params;
		Ext.Ajax.request({
		   url : flow
		   ,params : params
		   ,success : function(resp){
				//hack
				//app.contenido.setActiveTab.defer(10,app.contenido,[panel]);
				var data = Ext.decode(resp.responseText);
				_selfEntidad.put(id,"data",data);
				var tabs=_selfEntidad.subTabs.items;
				var tab=tabs.get(0);
				if (data.nombreTab){
					//TODO: activar el tab que tenga este nombre
					//XXX: experimental vvvvvvvvvv
					for(var i=0;i < tabs.length;i++){
						if (tabs.get(i).initialConfig && tabs.get(i).initialConfig.nombreTab==data.nombreTab){
							//_selfEntidad.subTabs.owner.setActiveTab(tabs.get(i));
							tab=tabs.get(i);
							_selfEntidad.put(id,"activeTab", tab);
							break;
						} 
					}
					//XXX: experimental ^^^^^^^^^^^^^^^
				}
				//_selfEntidad.subTabs.ownerCt.ownerCt.ownerCt.setActiveTab(tab);
				//if ((app.getActiveId() == id) && _selfEntidad.panelDeTabs.isVisible() && (app.contenido.getActiveTab()==_selfEntidad.get("panel"))){
				var idActivo ='sinEntidadActiva'
				if (app.contenido.getActiveTab()){
					idActivo = app.contenido.getActiveTab().id;
				}
				var mismaEntidad = false;
				if (idActivo.indexOf(_selfEntidad.entidadNombre) ==0) {
					mismaEntidad = true;
				}
				if (mismaEntidad && (app.getActiveId() == id)){
					//Ya estamos en el panel activo, no se dispara el evento de tab activo, por tanto hay que provocarlo
					_selfEntidad.seteaDatos.apply(_selfEntidad.get("panel"));	
				}else{
					app.contenido.setActiveTab(panel);
				}
				//_selfEntidad.activateTab();
				app.entidad.hideMask();
			}
		   ,failure : function(){
			app.entidad.hideMask();
                   }
		});
	}

	this.cierraTab = function(idClosed){
		  //delete this.cache[this.actualId];
		  // this.actualId => ultima pesta�a abierta
		  // idClosed => id de la pesta�a a cerrar
		  delete this.cache[idClosed];
		  //for(x in this.cache){
		  //  return;  //si hay algo en cache es que aun hay tabs de la entidad
		  //}
		  _selfEntidad.panelContenedor.add(_selfEntidad.panelDeTabs);
		  _selfEntidad.panelContenedor.doLayout();
	};




	//creamos el panel para esta entidad
	this.crearPanel(id, clienteTabs, clienteToolbar, flow);


};

app.entidad.cerrarTodo = function(){
    this.panelContenedor.add(this.panelDeTabs);
    for(var id in this.cache){
	app.contenido.remove(this.cache[id].panel);
    }
    this.cache = {};
};

app.entidad.showMask = function(){
  if (!app.entidad.showMask.mask){
    app.entidad.showMask.mask = new Ext.LoadMask(app.contenido.el.dom, {msg:'Cargando...'});
  }
  app.entidad.showMask.mask.show();
};

app.entidad.hideMask = function(){
  if (app.entidad.showMask.mask){
    app.entidad.showMask.mask.hide();
  }
};

app.entidad.fn = {};
/*
  Recupera los datos de un store almacenados en el cache de una entidad
*/
app.entidad.prototype.cacheOrLoad= function(data,store, params){
  if (!store) return;
  store.cacheData=data;
  if (data[store.storeId]){
    store.removeAll();
    store.add(data[store.storeId]);
  }else{
    store.webflow(params);
  }
};

/*
   asigna en el onload del store una función que guarda los datos del store con id == storeId en los datos del elemento
   por ejemplo, para storeId=expedientesStore y el cliente=113993 tendriamos:
    app.cliente.cache[113993].data[expedienteStore]=PAGINA_DE_DATOS
*/
app.entidad.prototype.cacheStore=function(store){
  store.on("load",function(store,records,opts){

    if (store.cacheData){
      store.cacheData[store.storeId]=store.getRange();
    }
  });
}


//TODO: ver tema visibilidad, los controles de menu no se han renderizado hasta que no se muestran por primera vez!!!
/*
*/
app.entidad.prototype.setVisible=function(esVisible){
    for(i=esVisible.length;i-->0;){
      var control = esVisible[i][0];
      var visible = esVisible[i][1];
      if (typeof(control)=="string"){
        control = Ext.getCmp(control);
      }

        if(!control.show || !control.hide) {
          continue;
        }
	//Modificacion para esconder la etiqueta Y el control si es un statictextfield
	if (control.getXType && control.getXType() == 'statictextfield'){
		if (control.getEl() != undefined) {
		  var control2 = control.getEl().up('.x-form-item');
	  	  if (control2) control=control2;
	  	}
	}
        try{
                if (visible)
                   control.show();
                else 
                   control.hide();
        }catch(e){
          //console.error(e); //esto depende de si ya son visibles los controles
        }
    }
}

app.entidad.prototype.setEnabled=function(esEnabled){
    for(i=esEnabled.length;i-->0;){
		var control = esEnabled[i][0];
		var enabled = esEnabled[i][1];
		if(!control.show || !control.hide) continue;
		//if(!control.rendered) continue;
		if (enabled)
			control.enable();
		else
			control.disable();
    }
}

// cambia el valor de la etiqueta (y con el segundo parametro la etiqueta del label)
app.entidad.prototype.setLabel = function(id, value, label){
      if (value==undefined) value="";
     var node=Ext.get('entidad-'+this.id+'-'+id);
         if (node){
        node.dom.innerHTML=value;
      }
      if (!label) return;
      var node=Ext.get("x-form-el-entidad-cliente-"+id);
      if(node && node.dom.previousSibling){
         node.dom.previousSibling.innerHTML=label;
      }
  }

//ANGEL TODO 
app.entidad.prototype.refrescar = function(){
    var data = this.get("data");
    var id=data.id;
    var panelEntidad = this.existing(id);
    this.ajaxEntidad(this, id, panelEntidad);
}

app.entidad.prototype.getData = function(id){
     var result=this.get("data");
     if(!id) return result;

     var parts = id.split(".");
     for(var i=0;i < parts.length;i++){
      result=result[parts[i]];
     }
     return result;
}
//cambiamos el comportamiento de app.openTab para interceptar las entidades que nos interesan
var old_openTab = app.openTab;

//  app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'decision');
//	app.openTab(rec.get('descripcion'), 'procedimientos/consultaProcedimiento', {id:rec.get('idEntidad'),tarea:rec.get('id'),fechaVenc:rec.get('fechaVenc'),nombreTab:'decision'} , 
//		{id:'procedimiento'+rec.get('idEntidad'),iconCls:'icon_procedimiento'});
				

app.entidad.interceptores = {};

app.openTab = function(title,flow,params,config){
	var interceptor = app.entidad.interceptores[flow]
	if (!app.entidad.fastMode || !interceptor) {
		return old_openTab.call(app,title,flow,params,config);
	}if (interceptor){
		interceptor.method.call(interceptor.scope, params.id, title, params, config);
	}
}

//cambiamos el comportamiento de la apertura de entidades
app.entidad.fastMode=true;

/* ------------------ CAMBIOS A /main/shared.js ------------------------- 
   Esto se deberia incorporar a recovery, es inocuo si no se utilizan funciones como parametros

 Necesitamos que los valores de los botones a crear se obtengan al ejecutar una funcion, puesto que no los conocemos en la creacion de los botones
 asi que introducimos la funcion app.executeParams que detecta si un parametro es una funcion y la ejecuta
*/

app.crearBotonAgregar = function(config){

	fwk.js.assertProperties(config, ["flow"]);

	return new Ext.Button({
           text:  config.text || '<s:message code="app.agregar" text="**Agregar" />'
           ,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
           ,handler:function(){
		var params = config.params || {}; //ANGEL
         	app.executeParams(params);
			var w = app.openWindow({
				flow : config.flow
				,closable:false
				,width : config.width || 600
				,title : config.title || '<s:message code="app.nuevoRegistro" text="**Nuevo registro" />'
				,params : params 
			});
			w.on(app.event.DONE, function(){
				w.close();
				if (config.success && typeof(config.success)=="function"){
					config.success();
				}
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
           }
	});
};


app.executeParams = function(params){
 for (var param in params){
    if (Ext.isFunction(params[param])){
       params[param]=params[param]();
    }
 }
}
/*
* Crea un botón para editar un registro, necesita los siguientes parámetros
* @grid : el grid del que obtendrá el id del registro a editar. Sólo editará si hay un registro seleccionado
* @flow : el flow a llamar para la ventana de detalle
* @title : título de la ventana de detalle, por defecto clave app.editarRegistro
* @text : texto del botón, por defecto clave app.agregar
* @params : parámetros a pasar al flow
* @success : callback a ejecutar cuando se cierra la ventana
*/
app.crearBotonEditar = function(config){
	fwk.js.assertProperties(config, ["flow"]);
	var cfg = {
           text: config.text || '<s:message code="app.editar" text="**Editar" />'
           ,iconCls : 'icon_edit'
		   ,cls: 'x-btn-text-icon'
           ,handler:function(){
			var grid = fwk.dom.findParentPanel(this.id);
			var rec = grid.getSelectionModel().getSelected();
			if (!rec) return;
			var params = config.params || {};
			params.id = rec.get("id");
         app.executeParams(params);
			var w = app.openWindow({
				flow : config.flow
				,width : config.width || 600
				,closable: false
				,title : config.title || '<s:message code="app.editarRegistro" text="**Editar registro" />'
				,params : params
			});
			w.on(app.event.DONE, function(){
				w.close();
				if (config.success && typeof(config.success)=="function"){
					config.success();
				}
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
           }
	};
	if(config.id) {
		cfg.id = config.id;
	}
	return new Ext.Button(cfg);
};

/*
* Crea un botón para borrar un registro, necesita los siguientes parámetros
* @grid : el grid del que obtendrá el id del registro a editar. Sólo editará si hay un registro seleccionado
* @flow : el flow a llamar para el borrado
* @confirmText : texto de la pregunta para borrar, por defecto app.borrarRegistro
* @text : texto del botón, por defecto clave app.borrar
* @params : parámetros a pasar al flow
* @success : callback a ejecutar cuando se cierra la ventana
*/
app.crearBotonBorrar = function(config){
	fwk.js.assertProperties(config, ["flow", "page"]);

	var cfg = {
		text : config.text || '<s:message code="app.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,handler : function(){
			var grid=fwk.dom.findParentPanel(this.id);
			var rec = grid.getSelectionModel().getSelected();
			if (rec){
				Ext.Msg.confirm(fwk.constant.confirmar, config.confirmText || '<s:message code="app.borrarRegistro" text="**¿Seguro que desea borrar el registro?" />', this.decide, this);
			}
		}
		,decide : function(boton){
			if (boton=='yes'){ this.borrar(); }
		}
		,borrar : function(){
			var grid = fwk.dom.findParentPanel(this.id);
			var rec = grid.getSelectionModel().getSelected();
			if (!rec) return;
			var params = config.params || {};
			params.id = rec.get("id");
         app.executeParams(params);
			config.page.webflow({
				flow : config.flow
				,params : params || {}
				,success : function() {
					if (config.success && typeof(config.success)=="function"){
						config.success();
					}
				 }
			});
		}
	};

	if(config.id) {
		cfg.id = config.id;
	}
	return new Ext.Button(cfg);
};

app.getActiveId = function(){
  if (app.contenido.getActiveTab()){
	return app.contenido.getActiveTab().id.replace(/[^-]*-/,"");
  }
}


// debemos sobreescribir la funcion del fwk para obtener los datasources de forma que se puedan cachear. los cambios estan entre los comentarios //optimizacion recovery
fwk.Page.prototype.getStore = function(config){
	fwk.js.assertProperties(config, ['reader']);

	var _page = this;

	//si llamamos a otro flow, se crear� un nuevo objeto page.
	if (config.flow && config.flow!=this.getFlowId()){
		_page = new fwk.Page(this.getAppName(), '','',config.flow);
	}

  //-- optimizacion recovery
	var storeCfg = {
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
	};
	if (config.storeId) storeCfg.storeId=config.storeId;
	var store = new Ext.data.Store(storeCfg);

	if (config.remoteSort!=undefined){
		store.remoteSort = config.remoteSort;
	}
  //-- optimizacion recovery

	store.webflow = function(params, callback){
		//si vienen estos par�metros, no pueden estar en el baseParams puesto que si no,
		//reemplazar�an a los params que usa la paginaci�n
		var p = fwk.js.extractProperties(params,'start', 'limit');

		var baseParams = params || {};
		//actualizamos los par�metros base al nuevo token
		this.page.addParams(baseParams, this.flow, this.eventName);
		//XXX: cuidado! aqu� estamos accediendo directamente a una propiedad del objeto Store de ExtJS.
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


		//s�lo asociamos si existe alg�n par�metro. porque si no, no funciona bien la paginaci�n de ExtJS
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
