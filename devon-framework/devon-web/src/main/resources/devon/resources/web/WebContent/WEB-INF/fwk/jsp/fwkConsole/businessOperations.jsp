<%@ page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<fwk:page>

	var datos = <json:object>
	<json:array name="listado" items="${boList}" var="bo">
       <json:object> 
            <json:property name="Label" value="${bo}" />
       </json:object>
    </json:array>
	</json:object>;	
	
	
	var gridMaster = new Ext.data.JsonStore({
	 
			root : 'listado'
			,data :  datos
			,fields:[{name:'Label'}]
	});
	

	var gridCm = new Ext.grid.ColumnModel([
		{header : 'Name', dataIndex : 'Label', sortable:true, width:480 }
	]);


	var gridGridM = new Ext.grid.GridPanel({
		store : gridMaster
		,title : 'Business Operations'
		,cm : gridCm
		,width : 500
		,height : 400
	});




	var panel	= new Ext.Panel({
		autoHeight : true
		,autoWidth:true
		,defaults: {style: 'margin:40px'} 
		,border : false
		,items : [gridGridM]
	});

	page.add(panel);

</fwk:page>

<div id="mago">
<table>
<tr><td style="text-align: center;"><img src="../fwk/img/wizard.gif" /><br/><font size="1">Powered by DEVON </font></td></tr>
</table>
</div> 
