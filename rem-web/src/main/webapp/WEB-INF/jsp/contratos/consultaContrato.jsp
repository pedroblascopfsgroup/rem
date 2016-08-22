<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>

	
	var tabs = <app:includeArray files="${tabsContrato}" />;
	
	//Buscamos la solapa que queremos abrir
	var nombreTab = '${nombreTab}';
	var nrotab = 0;
		
	//tab activo por nombre
	if (nombreTab != null){
		for(var i=0;i< tabs.length;i++){
			if (tabs[i].initialConfig && nombreTab==tabs[i].initialConfig.nombreTab){
				nrotab = i;
				break;
			}
		}
	}
	
	
	
	var contratoTabPanel=new Ext.TabPanel({
		items:tabs
		,defaults:{
			height:350

		}
		,layoutOnTabChange:true 
		,activeItem:nrotab
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false
	});

	//contratoTabPanel.setActiveTab(tabs[0]);

	var panel = new Ext.Panel({
		autoHeight : true
		,items : [contratoTabPanel]
		,tbar: new Ext.Toolbar()
		,id:'cnt-${contrato.id}'	
	});

	page.add(panel);

	var botonRefrezcar = new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrezcar" />'
		,iconCls: 'icon_refresh'
		,handler: function() {

			if (contratoTabPanel.getActiveTab() != null && contratoTabPanel.getActiveTab().initialConfig.nombreTab != null)
				app.abreContratoTab(${contrato.id}, '${contrato.codigoContrato}', contratoTabPanel.getActiveTab().initialConfig.nombreTab);
			else
				app.abreContrato(${contrato.id}, '${contrato.codigoContrato}');
		
		}
	});

	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(botonRefrezcar);

</fwk:page>