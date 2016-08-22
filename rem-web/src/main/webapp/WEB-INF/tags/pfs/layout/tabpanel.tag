<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="tabs" required="true" type="java.lang.String"%>
<%@ attribute name="tbar" required="false" type="java.lang.String"%>
<%@ attribute name="activeItem" required="false" type="java.lang.String"%>

var ${name}_activeTab = 0;
<c:if test="${activeItem != null}">${name}_activeTab=${activeitem};</c:if>

var ${name}_tabs=new Ext.TabPanel({
		items:[${tabs}]
		,layoutOnTabChange:true 
		,activeItem:${name}_activeTab
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false
			
	});
	
	var ${name} = new Ext.Panel({
		bodyStyle : 'padding : 5px'
		,autoHeight : true
		,items : [${name}_tabs]
		<c:if test="${tbar != null}">,tbar : ${tbar}</c:if>
		//,id:'asunto-${asunto.id}'
	});


