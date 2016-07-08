<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function() {

	var panel = new Ext.Panel({
		title: '<s:message code="scoring.titulo" text="**Scoring" />'
		,height: 445
		,autoWidth: true
		,bodyStyle: 'padding:10px'
		,layout: 'table'
		,layoutConfig: {columns:1}
		,nombreTab : 'scoringPanel'
	});



	panel.on('render', function()
	{

		var fechaRecord = Ext.data.Record.create([
			 {name:'codigo'}
			,{name:'descripcion'}
		]);
	
		var fechaStore = page.getStore({
		    flow: 'clientes/fechasScoringData'
		    ,reader: new Ext.data.JsonReader({
		    	 root : 'diccionario'
		    }, fechaRecord)
		});
	
		var fechaCombo = new Ext.form.ComboBox({
			store:fechaStore
			,displayField:'descripcion'
			,valueField:'codigo'
			,forceSelection:true
			,mode: 'local'
			,triggerAction: 'all'
			,editable: false
			,fieldLabel: '<s:message code="cirbe.filtro.desde" text="**Desde" />'
			,name: 'fecha'
		});
	
		var fechasString = '${fechasAlertas}';
			
		labelFecha = new Ext.form.Label({
		   	text:'<s:message code="scoring.filtro.fecha" text="**Fecha" />'+':'
			,style:'font-size:11;padding:15px;font-weight:bolder;'
		});
	
		var btnAgregar = new Ext.Button({
			text : '<s:message code="scoring.filtro.boton.agregar" text="**Añadir nueva fecha" />'
			,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
	        ,handler:function() {
					
					if(fechaCombo.getValue()===''){ 
						Ext.Msg.show({
						   title: fwk.constant.errorMsg
						   ,msg: "<s:message code="scoring.filtro.fecha.error" text="**Debe seleccionar una fecha para agregar." />"
						   ,buttons: Ext.Msg.OK
						   ,animEl: 'elId'
						   ,icon: Ext.MessageBox.ERROR
						});
					} else {
						//panel.doLayout();
						if (fechasString != ''){
							fechasString += ',';
						}
						fechasString += fechaCombo.getValue();
						scoringGrid.store.load({params:{
								idPersona:${persona.id}
								,fechas:fechasString
						}});
						fechaStore.webflow({idPersona:${persona.id},fechas:fechasString});
					}
	    	    }
		  });
	
	
		scoringGrid = new Ext.ux.DynamicGridPanel({
		    storeUrl: '../clientes/scoringData.htm'
		    ,height: 300
		    ,collapsible: true
		});
		
		
	
		var panelFiltro = new Ext.form.FieldSet({
			title: '<s:message code="scoring.filtro.fechas" text="**Fechas" />'
			,autoHeight: true
			,autoWidth: true
			,bodyStyle: 'padding:7px;'
			,layout: 'table'
			,layoutConfig: {columns:3}
			,defaults: {xtype:'panel', border: false, cellCls: 'vtop'}
			,items: [
				{items:[labelFecha],border:false,style:'margin-left:5px'}
				,{items:[fechaCombo],border:false}
				,{items:[btnAgregar],border:false,style:'margin-left:20px;margin-right:40px'}
			   ]
		});
	
	
		var activaPanel = function()
		{
			panel.doLayout();
			scoringGrid.setVisible(true);		
			scoringGrid.doLayout();
			
			fechaStore.webflow({idPersona:${persona.id},fechas:fechasString});
		}
		
		panel.on('render', function(){
			scoringGrid.store.load({
				params:{
					idPersona:${persona.id}
					,fechas:fechasString
				}
				,callback:activaPanel
			});
		});			
		
	
		panel.add(panelFiltro);
		panel.add(scoringGrid);
	});
	

	return panel;
})()
