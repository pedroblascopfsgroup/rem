<%@ page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<fwk:page>

	var usersStore = new Ext.data.JsonStore({
		autoLoad: true
		,url: '/${appProperties.appName}/activeusers/data.htm'
		,root: 'data'
		,fields: ['username', 'loginTime', 'remoteAddress']
	});

	var botonRefresh = new Ext.Button({
		text : 'Refresh'
		,iconCls : 'fwk_recargar'
		,handler:function(){
			usersStore.reload();
		}
	});

	var usersGrid = new Ext.grid.GridPanel({
		store: usersStore
		,title: 'Active Users'
		,cm: new Ext.grid.ColumnModel([
				{header: 'Username', dataIndex: 'username', sortable:true, width:200 },
				{header: 'Login Time', dataIndex: 'loginTime', sortable:true, width:150 },
				{header: 'Remote Address', dataIndex: 'remoteAddress', sortable:true, width:150 }
			])
		,width: 700
		,height: 400
		,tbar: [botonRefresh]
	});

	var panel = new Ext.Panel({
		autoHeight : true
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [usersGrid]
	});
	
	//page.add(usersGrid);
	page.add(panel);
	
</fwk:page>

<div id="mago">
<table>
<tr><td style="text-align: center;"><img src="../fwk/img/wizard.gif" /><br/><font size="1">Powered by DEVON</font></td></tr>
</table>
</div> 
