//el objeto global aplicación
var App= function(){
	this.addEvents(
		'logout'
	);
	
	this.contenido = new Ext.TabPanel({
		id : 'contenido'
		,region : 'center'
		,deferredRender : false
		,activeTab : 0
		,cls : 'ajax-panel'
	});

	//crea el objeto tree y lo carga por ajax
	this.tree =  new Ext.Panel({
		title : 'Panel de trabajo',
		border : false,
		iconCls : 'nav',
		id : 'tareas'
		,autoLoad : {url : 'admin/tree.htm', scripts:true}
	});


	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [new Ext.BoxComponent({ // raw
			region : 'north',
			el : 'north',
			height : 82,
			minSize : 60
		}), {
			region : 'south',
			contentEl : 'south',
			split : true,
			height : 100,
			minSize : 100,
			maxSize : 200,
			collapsible : true,
			title : 'Alertas',
			margins : '0 0 0 0'
		},  {
			region : 'west',
			id : 'west-panel',
			title : 'Opciones',
			split : true,
			width : 200,
			minSize : 175,
			maxSize : 400,
			collapsible : true,
			margins : '0 0 0 5',
			layout : 'accordion',
			layoutConfig : {
				animate : true
			},
			items : [
					this.tree
					, {
					title : 'Clientes'
					,border : false
					,iconCls : 'settings'
				}]
		}, this.contenido]
	});
	
};

Ext.extend(App, Ext.util.Observable);

App.prototype.openTab = function(title, flow){
	var url = '/pfs/'+flow+'.htm';
	this.contenido.add({
		title : title
		,closable : 'true'
		,layout : 'fit'
		,autoScroll : true
		,autoHeight : true
		/* ,autoShow : true */
		,autoLoad : {url : url+"?"+Math.random(), scripts: true}
	}).show();
};


Ext.onReady(function() {
	BLANK_IMAGE_URL = "resources/images/default/s.gif";
	
	Ext.QuickTips.init();

	/* global app */
	app = new App();

});

