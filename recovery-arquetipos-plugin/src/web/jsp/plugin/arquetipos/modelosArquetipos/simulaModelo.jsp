<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>
	Ext.Ajax.timeout=25*60*1000; //Timeout de 25 minutos
	Ext.util.CSS.createStyleSheet("button.icon_simular { background-image: url('../img/plugin/arquetipos/start_simula.png');}");
	
	 
	var resultadoSimulacion = new Ext.data.Record.create([
		{name:'arquetipo'}
		,{name:'clientes'}
	]); 
	 
	var columnas = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.arquetipos.modelo.simula.arquetipo" text="**Arquetipo"/>', dataIndex: 'arquetipo', width:225}
		,{header : '<s:message code="plugin.arquetipos.modelo.simula.clientes" text="**Clientes"/>', dataIndex: 'clientes', width: 75}
	]);
	
	 var columnasPruebas = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.arquetipos.modelo.simula.arquetipo" text="**Arquetipo"/>', dataIndex: 'arquetipo', width:225}
		,{header : '<s:message code="plugin.arquetipos.modelo.simula.clientes" text="**Clientes"/>', dataIndex: 'clientes', width: 75}
	]);	
	 
	 var simulacionVigente = page.getStore({
		flow: 'plugin/arquetipos/modelosArquetipos/ARQsimulacionDeModeloData'
		,reader: new Ext.data.JsonReader({
	    	root : 'simulacion'
	    }, resultadoSimulacion)
	});
	
	var simulacionPruebas = page.getStore({
		flow: 'plugin/arquetipos/modelosArquetipos/ARQsimulacionDeModeloData'
		,reader: new Ext.data.JsonReader({
	    	root : 'simulacion'
	    }, resultadoSimulacion)
	});
	 
	 var gridVigente = new Ext.grid.EditorGridPanel({
		store : simulacionVigente
		,title:'<s:message code="plugin.arquetipos.modelo.simula.vigente.grid" text="**Modelo vigente" />'
		,cm : columnas
		,width:columnas.getTotalWidth()+30
		,height : 400
	});
	
	var gridPruebas = new Ext.grid.EditorGridPanel({
		store : simulacionPruebas
		,title:'<s:message code="plugin.arquetipos.modelo.simula.pruebas.grid" text="**Modelo de pruebas" />'
		,cm : columnasPruebas
		,width:columnasPruebas.getTotalWidth()+30
		,height : 400
	});
	 
	 var cancelar= new Ext.Button({
		text : '<s:message code="plugin.arquetipos.modelo.simular.cerrarventana" text="**Cerrar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.DONE); }
	});
	 
	 
	 var iniciar= new Ext.Button({
		text : '<s:message code="plugin.arquetipos.modelo.simular.iniciar" text="**Iniciar simulación" />'
		,iconCls : 'icon_simular'
		,handler : function(){
           	msgEspere=Ext.MessageBox.wait("<s:message code="plugin.arquetipos.modelo.simular.wait" text="**Espere" />","<s:message code="plugin.arquetipos.modelo.simular.simulando" text="**Simulando" />");
           	var l1 = false;
           	var l2 = false;
			<%--AJAX 1 --%>
			Ext.Ajax.request({
				url: page.resolveUrl('plugin/arquetipos/modelosArquetipos/ARQsimulacionDeModeloData')
				,params: {event:'simulaModeloVigente'}
				,method: 'POST'
				,success: function (result, request){
					var r = Ext.util.JSON.decode(result.responseText);
						simulacionVigente.loadData(r);
						l1 = true;
						if (l2) msgEspere.hide();
					}
			});
			<%--AJAX 2 --%>
			Ext.Ajax.request({
				url: page.resolveUrl('plugin/arquetipos/modelosArquetipos/ARQsimulacionDeModeloData')
				,params: {event:'simulaModelo',id: '${idModelo}'}
				,method: 'POST'
				,success: function (result, request){
					var r = Ext.util.JSON.decode(result.responseText);
						simulacionPruebas.loadData(r);
						l2 = true;
						if (l1) msgEspere.hide();
					}
			});
        }
	});
	 
	 var panel = new Ext.form.FormPanel({
	    items : [
			{
			layout: 'table'
			,bodyStyle:'padding:5px;cellspacing:25px;cellpadding:25px;'
	    	,layoutConfig:{columns:2}
			,items:[gridVigente,gridPruebas]
			,border:false
			},{
			layout: 'table'
			,bodyStyle:'padding:5px;cellspacing:25px;'
	   		,layoutConfig:{columns:2}
			,items: [iniciar, cancelar]
			,border: false
			}			
	    ]
	    ,border:false
	    ,autoHeight : true
	    ,border: false
	    ,closable:true
        ,autoScroll:true
    });
	//añadimos al padre y hacemos el layout
	page.add(panel);
	
	
	simulacionVigente.webflow({event:'muestraModeloVigente'});
	simulacionPruebas.webflow({event:'muestraModelo',id: '${idModelo}'});
</fwk:page>