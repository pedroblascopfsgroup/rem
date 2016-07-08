<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	<%@ include file="tabStockProducto.jsp" %>
	var tabProducto=createTabStockProducto();
	
	<%@ include file="tabStockAntiguedad.jsp" %>
	var tabAntiguedad=createTabStockAntiguedad();
	
	var gestorTabPanel=new Ext.TabPanel({
		items:[
			tabProducto
			,tabAntiguedad
		]
		,layoutOnTabChange:true 
		//,frame:true
		,activeItem:0 
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false
			
	});
	var panel = new Ext.Panel({
		bodyStyle : 'padding : 5px'
		,autoHeight : true
		,items : [gestorTabPanel]
		,tbar : new Ext.Toolbar()
	});
	page.add(panel);
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(app.crearBotonAyuda());
	
</fwk:page>