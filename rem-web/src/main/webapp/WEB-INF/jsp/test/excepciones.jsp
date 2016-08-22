<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:page>

var panel = new Ext.Panel();


var btnEx1 = new Ext.Button({
	text : 'excepcion 1'
	,handler: function(){
		page.webflow({
			url : 'test/excepcion1'
			,form : formPanel
		});
	}
});

var btnEx2 = new Ext.Button();

var formPanel = new Ext.form.FormPanel({
	items : [
		{xtype : 'errorList' }
		,btnEx1
		,btnEx2
	]
});



panel.add(formPanel);

page.add(panel);


</fwk:page>