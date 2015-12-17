<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<fwk:page>
	var consoleItem = Ext.data.Record.create([
		{name:'name'}
		,{name:'action'}
	]);
	
	var consoleStore = page.getStore({
		eventName : 'listado'
		,flow:'console/consoleItems'
		,reader: new Ext.data.JsonReader({
	    	root : 'consoleItems'
	    }, consoleItem)
	});
	consoleStore.webflow();
	
	var devonConsole = new Ext.grid.GridPanel({
		store : consoleStore
		,viewConfig : { forceFit : true }
		,cm : new Ext.grid.ColumnModel([
			{dataIndex : 'name'}
			,{dataIndex : 'action', hidden : true}
			])
		,autoHeight: true	
		,listeners : {
			rowclick : function(grid, rowIndex){
				var rec=this.getStore().getAt(rowIndex);
                app.openTab(rec.get('name'), rec.get('action'), {}, {id:rec.get('name')} );
			}
		}
 		,monitorResize: true
	    ,doLayout: function() {
			var parentSize = Ext.get(this.getEl().dom.parentNode).getSize(true); 
	     	this.setWidth(parentSize.width);
	     	Ext.grid.GridPanel.prototype.doLayout.call(this);
	    }
	});

	page.add(devonConsole);
</fwk:page>