<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

Ext.BLANK_IMAGE_URL = '/${appProperties.appName}/js/fwk/ext/resources/images/default/s.gif';  // Ext 2.0
var App= function(){
	this.addEvents(
		'logout'
	);


	//panel donde aparecerán las pantallas
	this.contenido = new Ext.TabPanel({
		id : 'contenido'
		,region : 'center'
		,deferredRender : true
		,activeTab : 0
		,autoScroll:true
		,enableTabScroll : true
		,cls : 'ajax-panel'
		,border : false
	});

	
	// Admin Console
	<sec:authorize ifAllGranted="ROLE_ADMIN">
	this.devonConsole = new Ext.Panel({
		id : 'devonConsole'
		,title : '<s:message code="devon.console.title" text="**Console" />'
		,autoLoad : {url : 'consolePanel.htm', scripts:true}
		,autoHeight : true
	});
	</sec:authorize>


	var accordion = new Ext.Panel({
		autoWidth : true
		,autoHeight : true
		,items : [<sec:authorize ifAllGranted="ROLE_ADMIN">this.devonConsole</sec:authorize>]
		,layout : 'accordion'
		,layoutConfig : {
			animate : true
		}
	});


	var panelIzq = new Ext.Panel({
		title : '<s:message code="main.arbol_tareas.titulo" text="**Panel de trabajo" />'
		,region : 'west'
		,id : 'west-panel'
		,split : true
		,width : 200
		,collapsible : true
		,hideCollapseTool : false
		,titleCollapse : true
		,border : false
		,items : [ accordion	]
	});

	this.viewport = new Ext.Viewport({
		layout : 'border'
		,items : [
		         new Ext.BoxComponent({ // raw
					region : 'north'
					,id:"header"
					,el : 'north'
					,collapsible : true
					,height : 82
					,minSize : 60
					,border : false
				})
				,panelIzq
		        ,this.contenido
				]
	});

};


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
			if (paging.loading) paging.loading.hide();
		}
	});

	store.on('beforeload', function(){
		if (paging.loading) paging.loading.show();
	});
	store.on('load', function(){
		if (paging.loading) paging.loading.hide();
	});
	return paging;
}



Ext.extend(App, Ext.util.Observable);



Ext.onReady(function() {
	BLANK_IMAGE_URL = "resources/images/default/s.gif";

	Ext.QuickTips.init();

	/* global app */

	//control del enlace de logout
	Ext.get("logout").on('click', function(){
		Ext.Msg.confirm('<s:message code="app.confirmar" text="**confirmar" />', '<s:message code="main.logout.confirmar" text="**¿Seguro que desea salir de la aplicación?" />', function(boton){
			if (boton=="yes"){
				window.location="/${appProperties.appName}/j_spring_security_logout";
			}
		});
	});
	
});

app = new App();

/**
* abre un nuevo tab, o lo muestra si ya existe (le pasamos el id)
* devolverá true/false si crea el tab nuevo o simplemente lo muestra
*
*/
app.openTab = function(title, flow, params, config){
	var url = '/${appProperties.appName}/'+flow+'.htm';
	config = config || {};
	//si existe, lo mostraremos
	//TODO: controlar en el callback en caso de que tengamos un error
	var autoLoad = {url : url+"?"+Math.random()
			,scripts: true
			,method : 'POST'
			,callback : function(scope, success, response, options){}
			};
	if (params){
		autoLoad.params = params;
	}
	//si existe el tab, borraremos el contenido y recargamos
	if (config.id){
		var control = Ext.getCmp(config.id);
		if (control){
			var id =control.el.child('.x-panel').id;
            Ext.getCmp(config.id).remove(id,true);
			Ext.getCmp(config.id).load(autoLoad);
			control.show();
			return false;
		}
	}
	
	if (config.closable == null) config.closable = true;
	
	var cfg = {
		title : title
		,closable : config.closable 
		,layout : 'fit'
		,autoScroll : true
		,autoHeight : true
		,iconCls: config.iconCls || ''
		//,autoWidth  : true
		,autoLoad : autoLoad
	};
	if (config.id) cfg.id=config.id;
	this.contenido.add(cfg).show();
	return true;
};

/*
 * eventos predefinidos de la aplicación, usar en vez de strings
 */
app.event = {
	CANCEL : 'cancel'
	,DONE : 'done'
	,OPEN_ENTITY : 'abrirEntidad'
};






/**
 * devuelve el nombre de la aplicación
 */
app.getAppName = function(){
	return "${appProperties.appName}";
};



/**
 *
 */
app.resolveFlow = function(flow){
	return "/${appProperties.appName}/"+ (flow? flow : this.getFlowId()) +".htm";
};


/**
 * Abre la pantalla para generar una comunicación
 * @param {} tipo indica si es de cliente, expediente, etc
 * @param {} id identificador del registro sobre el que notificamos
 */
app.creaBotonComunicacion = function(tipo, id,titulo, texto, func){

	var btnComunicacion = new Ext.Button({
		text : '<s:message code="menu.clientes.consultacliente.menu.comunicacion" text="**Comunicación" />'
		,iconCls : 'icon_comunicacion'
		,handler : function(){
			Ext.Msg.prompt(titulo, texto, func,
				{ tipo : tipo, id:id}
				,150);
		}
	});

	return btnComunicacion;
};
/**
 * Crea un objeto Store a partir de un array de diccionario de Datos<br>
 * Funcion util para crear combos a partir de diccionarios
 * @param {} data
 * @return {} un store de diccionario de datos
 */
app.createDDStore=function(data){
	var store = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion']
        ,root: 'diccionario'
        ,data : data
	})
	return store;
}


/**
 * crea un boton para abrir la pantalla de solicitar prorroga
 * @param {}
 * @param {}
 */
app.creaBotonSolicitarProrroga = function(){
	var btnOk = new Ext.Button({
		title:'Ok'
	});
	var btnCancel;
	var buttonPanel = new Ext.Panel({
		layout:'column'
		,defaults:{
			style:'cellspacing:10px'
		}
		,items:[btnOk,btnOk]
	});
	var txtFecha = new Ext.form.DateField();
	var winPro = new Ext.Window({
		title:'**Solicitar Prorroga'
		,modal:true
		,layout:'anchor'
		,width:200
		,height:250
		,items:[
			{
				xtype:'panel'
				,anchor: '100%'
				,items:txtFecha
			},{
				xtype:'panel'
				,anchor: '100%'
				,items:buttonPanel
			}]
	});
	var btnProrroga = new Ext.Button({
		text : '<s:message code="app.botones.solicitarprorroga" text="**Solicitar Prórroga" />'
		,iconCls : 'icon_prorroga'
		,handler : function(){
			winPro.show();
		}
	});

	return btnProrroga;
};

//lógica para manejar el menú superior


//esta pantalla estará siempre disponible y se podrá refrescar mediante el evento 'inicial.reload'
var pantallaInicial = new Ext.Panel({
	title : '<s:message code="main.pantallaInicial.titulo" text="**Inicio" />'
		,closable : false
		,border : false
		,layout : 'fit'
		,autoScroll : true
		,autoHeight : true
		//,autoLoad : {url : "/${appProperties.appName}/main/inicial.htm", scripts: true, method : 'POST'}
});

//La carga de esta pantalla inicial queda para Fase2
//app.contenido.add(pantallaInicial).show();


app.on('inicial.reload',function(){
	pantallaInicial.load({url : "/${appProperties.appName}/main/inicial.htm", scripts: true, method : 'POST'});
});

fwk.event.on('FileUploadDoneEvent', function(event){
	fwk.toast("upload completado");
});

app.openUrl = function(title, url){
	var url = '/${appProperties.appName}/'+url

	var autoLoad = {url : url+"?"+Math.random()
			,scripts: true
			,method : 'POST'
			,callback : function(scope, success, response, options){}
			};

	//si existe el tab, borraremos el contenido y recargamos

	var size = this.contenido.getSize();
	var cfg = {
		title : title
		,closable : 'true'
		,layout : 'fit'
		,autoScroll : true
		,autoHeight : true
		,iconCls: 'icon_ayuda'
		//,autoWidth  : true
		//,autoLoad : autoLoad
		,html : '<iframe src="'+url+'" width="'+(size.width*.97)+'" height="'+(size.height*.99)+'" noborder="true"/>'
	};
	//if (config.id) cfg.id=config.id;
	this.contenido.add(cfg).show();
	return true;
};


app.loginRedirect = function(){
	Ext.Msg.alert(fwk.constant.errorMsg, fwk.constant.loginRedirect, function(){
		top.location = '/${appProperties.appName}/${security.defaultTargetUrl}';
	});
}


app.autologin = function(fn, args){
	try{
		app[fn](args);
	}catch(e){
		fwk.log("Error en autologin fn="+fn+" args="+args);
	}

};

app.abreClientePorCodigo=function(codigo,nombre){
	this.openTab(nombre||'Cliente', 'clientes/consultaCliente', {codigo : codigo}, {id:'cliente'+id,iconCls:'icon_cliente'} );

	//this.addFavorite(id, nombre, this.constants.FAV_TIPO_CLIENTE);

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

//Se carga la pantalla inicial (se mete en Ext.onReady para evitar que se cargue antes de cargar Extjs y de un fallo)
Ext.onReady(function(){
	app.openTab("Overview",
			"console/overview",
			{ titulo:"Overview"	}, 
			{id:'overview',iconCls:'icon_pendientes_tab',closable:false}
	);
});

