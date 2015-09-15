<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>


labelNumIntervalos = new Ext.form.Label({
   	text: '<s:message code="metricas.indicadores.numIntervalos" text="**Núm. de intervalos para generar el indicador" />' + ':'
	,style: 'font-size:11;padding:10px;font-weight:bolder;'
});

var txtNumIntervalos = new Ext.form.DisplayField({
	name: 'numeroIntervalos.valor'
	,value: '${numeroIntervalos.valor}'
	,width: 50
	,style: 'font-size:11;padding:10px;font-weight:bolder;'
});

var btnModificarIntervalos = new Ext.Button({
    text:'<s:message code="metricas.indicadores.numIntervalos.modificar" text="**Modificar núm. de intervalos" />'
    ,iconCls: 'icon_edit'
    ,handler: function() {
		var w = app.openWindow({
			flow : 'metricas/editNumIntervalos'
			,width:400
			,title : '<s:message code="app.editarRegistro" text="**Editar" />'
		  });
		w.on(app.event.DONE, function(){
			w.close();
			refrescarNumIntervalos();
		  });
		w.on(app.event.CANCEL, function(){ w.close(); });
	}
});

var refrescarNumIntervalos = function() {
	formNumIntervalos.load({
		url : app.resolveFlow('metricas/numIntervalosData')
	});
};

var formNumIntervalos = new Ext.form.FormPanel({
	border:false
	,autoWidth:true
	,autoHeight:true
	,layoutConfig: {columns:2}
	,layout: 'table'
	,items:[
			{items:[labelNumIntervalos],border:false}
			,{items:[txtNumIntervalos],border:false}
         ]
});

var panelNumIntervalos = new Ext.Panel({
	autoHeight: true
	,autoWidth: true
	,layout: 'table'
	,border:false
	,layoutConfig: {columns:2}
	,defaults: {xtype:'panel', border: false, cellCls: 'vtop'}
	,items: [
		{items:[formNumIntervalos],border:false}
		,{items:[btnModificarIntervalos],border:false,style:'margin-left:25px'}
	   ]
});
