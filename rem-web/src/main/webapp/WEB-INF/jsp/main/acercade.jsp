<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
var fieldSetPlataforma=new Ext.form.FieldSet({
	html:'Plataforma.....'
	,autoHeight:true
	,border:true
	,title:'<s:message code="acercade.plataforma" text="**Datos de la plataforma" />'
});
var fieldSetRelease=new Ext.form.FieldSet({
	html:'Release....'
	,autoHeight:true
	,style:'padding-top:5px'
	,border:true
	,title:'<s:message code="acercade.release" text="**Release" />'
});
var btnOk = new Ext.Button({
	text : '<s:message code="acercade.ok" text="**Ok" />'
	,iconCls : 'icon_ok'
	,handler : function() {
		page.fireEvent(app.event.DONE); 
	}
});
	
var mainPanel=new Ext.Panel({
	autoHeight:true
	,bodyStyle:'padding:5px'
	,items:[fieldSetPlataforma,fieldSetRelease]
	,bbar:[btnOk]
});
page.add(mainPanel);
</fwk:page>