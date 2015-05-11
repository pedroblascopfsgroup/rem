<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ tag body-content="scriptless"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="titleKey" required="true" type="java.lang.String"%>
<%@ attribute name="title" required="true" type="java.lang.String"%>
<%@ attribute name="newOrEditFlow" required="true" type="java.lang.String"%>
<%@ attribute name="id" required="true" type="java.lang.Long"%>
<%@ attribute name="dataFlow" required="true" type="java.lang.String"%>
<%@ attribute name="resultRootVar" required="true" type="java.lang.String"%>
<%@ attribute name="resultTotalVar" required="true" type="java.lang.String"%>
<%@ attribute name="recordType" required="true" type="java.lang.String"%>
<%@ attribute name="editWindowTitleKey" required="true" type="java.lang.String"%>
<%@ attribute name="editWindowTitle" required="true" type="java.lang.String"%>

<%@ attribute name="iconCls" required="false" type="java.lang.String"%>
<%@ attribute name="addRecordFlow" required="false" type="java.lang.String"%>
<%@ attribute name="addRecordWindowTitle" required="false" type="java.lang.String"%>
<%@ attribute name="addRecordWindowTitleKey" required="false" type="java.lang.String"%>
<%@ attribute name="deleteRecordFlow" required="false" type="java.lang.String"%>
<%@ attribute name="pagination" required="false" type="java.lang.Boolean"%>

	var limit=10;
	var ${name}_store__params = {id: ${id}}
	
	var DEFAULT_WIDTH=700;

		
	var ${name}_Store = page.getStore({
		limit:limit
		,remoteSort : true
		,flow: '${dataFlow}'
		,reader: new Ext.data.JsonReader({
	    	root : '${resultRootVar}'
	    	,totalProperty : '${resultTotalVar}'
	    }, ${recordType})
	});

<c:if test="${addRecordFlow != null}">
	var btnAdd = new Ext.Button({
		text : '<s:message code="pfs.tags.detailpanel.agregar" text="**Agregar" />'
		<app:test id="btnAgregar" addComa="true" />
		,iconCls : 'icon_mas'
		,handler : function() {
						var w= app.openWindow({
								flow: '${addRecordFlow}'
								,closable:false
								,width : DEFAULT_WIDTH
								,title : '<s:message code="${addRecordWindowTitleKey}" text="${addRecordWindowTitle}" />'
								,params: ${name}_store__params
							});
							w.on(app.event.DONE, function(){
								w.close();
								${name}_Store.webflow(${name}_store__params);
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
				   }
	});

	/*
	var btnDel= new Ext.Button({
		text : '<s:message code="pfs.tags.detailpanel.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,handler : function(){ 
			${name}_Store.webflow(${name}_store__params);
			page.fireEvent(app.event.CANCEL); 
		}
	});
	*/
</c:if>

	<pfs:defineColumnModel name="${name}_CM">
		<jsp:doBody />
	</pfs:defineColumnModel>
	
	<c:if test="${pagination}">var ${name}_pagingBar=fwk.ux.getPaging(${name}_Store);</c:if>
	
	var ${name}_Grid = app.crearGrid(${name}_Store,${name}_CM,{
		title:'<s:message code="${titleKey}" text="${title}"/>'
		<app:test id="${name}" addComa="true" />
		,style:'padding: 5px;'
		<c:if test="${iconCls}">
		,iconCls:'${iconCls}'
		</c:if>
		,cls:'cursor_pointer'
		,stripeRows:true
		,bbar : [  
			<c:if test="${pagination}">${name}_pagingBar</c:if> 
		]
		//,height : 250
	});
	
	${name}_Grid.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	var ${name}_w = app.openWindow({
    			flow:'${newOrEditFlow}'
    			,params:{id:rec.get('id')}
    			,width:DEFAULT_WIDTH - 20
    			,title : '<s:message code="${editWindowTitleKey}" text="${editWindowTitle}" />'
				//,closable:true
    	});
    	${name}_w.on(app.event.DONE, function(){
				${name}_w.close();
				${name}_Store.webflow(${name}_store__params);
		});
		${name}_w.on(app.event.CANCEL, function(){
				${name}_w.close();
		});
 	});
 	
 	var ${name} = new Ext.Panel({
		autoHeight : true
		,bodyStyle:'padding:5px;cellspacing:10px;'
		,border : false
		,items : [
			${name}_Grid
			,{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,bodyStyle:'padding:-20px;cellspacing:20px;'
				<c:if test="${addRecordFlow != null}">,items:[
					{items: [btnAdd]}
				]</c:if>
			}
		]
	});