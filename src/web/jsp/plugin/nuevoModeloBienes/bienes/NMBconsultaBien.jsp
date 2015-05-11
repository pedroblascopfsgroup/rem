<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>

	var buttons = <app:includeArray files="${buttonsBien}" />;
	var tabs = <app:includeArray files="${tabsBien}" />;
	
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
	
	var bienTabPanel=new Ext.TabPanel({
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

	var panel = new Ext.Panel({
		autoHeight : true
		,items : [bienTabPanel]
		,tbar: new Ext.Toolbar()
		,id:'bie-${NMBbien.id}'	
	});

	var botonRefrezcar = new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrezcar" />'
		,iconCls: 'icon_refresh'
		,handler: function() {
			if (bienTabPanel.getActiveTab() != null && bienTabPanel.getActiveTab().initialConfig.nombreTab != null)
				app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
			else 
				app.abreBien(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}');
		}
	});
	
	panel.getTopToolbar().add(buttons);
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(botonRefrezcar);

	page.add(panel);

</fwk:page>