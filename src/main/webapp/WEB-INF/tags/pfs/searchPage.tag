<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ tag body-content="scriptless"%>

<%@ attribute name="searchPanelTitleKey" required="true" type="java.lang.String"%>
<%@ attribute name="searchPanelTitle" required="true" type="java.lang.String"%>
<%@ attribute name="gridPanelTitleKey" required="true" type="java.lang.String"%>
<%@ attribute name="gridPanelTitle" required="true" type="java.lang.String"%>
<%@ attribute name="columns" required="true" type="java.lang.Integer"%>
<%@ attribute name="parameters" required="true" type="java.lang.String"%>
<%@ attribute name="columnModel" required="true" type="java.lang.String"%>
<%@ attribute name="dataFlow" required="true" type="java.lang.String"%>
<%@ attribute name="resultRootVar" required="true" type="java.lang.String"%>
<%@ attribute name="resultTotalVar" required="true" type="java.lang.String"%>
<%@ attribute name="recordType" required="true" type="java.lang.String"%>
<%@ attribute name="createFlow" required="true" type="java.lang.String"%>
<%@ attribute name="updateFlow" required="true" type="java.lang.String"%>
<%@ attribute name="createTitleKey" required="true" type="java.lang.String"%>
<%@ attribute name="createTitle" required="true" type="java.lang.String"%>

<%@ attribute name="updateTitleKey" required="false" type="java.lang.String"%>
<%@ attribute name="updateTitle" required="false" type="java.lang.String"%>
<%@ attribute name="updateTitleData" required="false" type="java.lang.String"%>
<%@ attribute name="newTabOnUpdate" required="false" type="java.lang.Boolean"%>
<%@ attribute name="iconCls" required="false" type="java.lang.String"%>
<%@ attribute name="buttonDelete" required="false" type="java.lang.String"%>
<%@ attribute name="gridName" required="false" type="java.lang.String"%>
<%@ attribute name="emptySearch" required="false" type="java.lang.Boolean"%>
<%@ attribute name="defaultWidth" required="false" type="java.lang.Integer"%>

<c:if test="${gridName == null}">
	<c:set var="gridName" value="grid" />
</c:if>

var limit=25;
<c:if test="${defaultWidth == null}">
var ${gridName}_DEFAULT_WIDTH=700;
</c:if>
<c:if test="${defaultWidth != null}">
var ${gridName}_DEFAULT_WIDTH=${defaultWidth};
</c:if>

var createTitle = function(row){
<c:if test="${updateTitleKey != null}">
	<c:if test="${updateTitleData != null}">
	return '<s:message code="${updateTitleKey}" text="${updateTitle}" /> - ' + row.get('${updateTitleData}');
	</c:if>
	<c:if test="${updateTitleData == null}">
	return '<s:message code="${updateTitleKey}" text="${updateTitle}" /> ';
	</c:if>
</c:if>
<c:if test="${updateTitleKey == null}">
	<c:if test="${updateTitleData != null}">
	return row.get('${updateTitleData}');
	</c:if>
	<c:if test="${updateTitleData == null}">
	return '';
	</c:if>
</c:if>
};

<pfs:remoteStore name="dataStore" resultRootVar="${resultRootVar}" resultTotalVar="${resultTotalVar}" recordType="${recordType}" dataFlow="${dataFlow}" />

/*
var xxxdataStore = page.getStore({
		limit:limit
		,remoteSort : true
		<%--,loading:false --%>
		,flow: '${dataFlow}'
		,reader: new Ext.data.JsonReader({
	    	root : '${resultRootVar}'
	    	,totalProperty : '${resultTotalVar}'
	    }, ${recordType})
	});
*/
var validarAntesDeBuscar = function(){
	buscarFunc(false);
};


var buscarFunc = function(v){
		<c:if test="${!emptySearch}">
		var valido = (v == null) ? true : v;
		if (! valido){
			valido = ${parameters}_validarForm();
		}
		</c:if>
		<c:if test="${emptySearch}">
		var valido = true;
		</c:if>
		if (valido){
                var params= ${parameters}();

                params.start=0;

                params.limit=limit;

                dataStore.webflow(params);

				
				//Cerramos el panel de filtros y esto hará que se abra el listado de personas
				filtroForm.collapse(true);

		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
		}
	};


	var btnBuscar=app.crearBotonBuscar({
		handler : validarAntesDeBuscar
	});
	
	var btnReset = app.crearBotonResetCampos(${parameters}_camposFormulario);
	
	var btnNuevo = app.crearBotonAgregar({
		flow : '${createFlow}'
		,title : '<s:message code="${createTitleKey}" text="${createTitle}" />'
		,text : '<s:message code="${createTitleKey}" text="${createTitle}" />'
		,params : {}
		//,success : buscarFunc
		,width: ${gridName}_DEFAULT_WIDTH
		//,closable:true
		<c:if test="${iconCls != null}">,iconCls:'${iconCls}'</c:if>
	});


var filtroForm = new Ext.Panel({
		title : '<s:message code="${searchPanelTitleKey}" text="${searchPanelTitle}" />'
		<%-- 
		,collapsible : true
		,titleCollapse : true
		,layout:'table'
		,layoutConfig : {
			columns:${columns + 1}
		}
		,autoWidth:true
		//,border: false
		,style:'margin-right:20px;margin-left:10px'
		,bodyStyle:'padding:5px;cellspacing:20px;padding-bottom: 0px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		--%>
		,autoHeight:true
		,autoWidth:true
		,layout:'table'
		,layoutConfig:{columns:${columns + 1}}
		,titleCollapse : true
		,collapsible:true
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[
			{width:'0px'}
			<jsp:doBody/>
		]
		,tbar : [btnBuscar, btnReset, btnNuevo]
		,listeners:{	
			beforeExpand:function(){
				${gridName}.collapse(true);
				${gridName}.setHeight(200);				
			}
			,beforeCollapse:function(){
				${gridName}.expand(true);
				${gridName}.setHeight(475);
			}
		}
	});
	
	var pagingBar=fwk.ux.getPaging(dataStore);
	var cfg={
		title : '<s:message code="${gridPanelTitleKey}" text="${gridPanelTitle}" />'
		,collapsible : true
		,collapsed: true
		,titleCollapse : true
		,stripeRows:true
		,bbar : [  pagingBar <c:if test="${buttonDelete != null}">,${buttonDelete}</c:if>]
		,height:200
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		<c:if test="${iconCls != null}">,iconCls:'${iconCls}'</c:if>
	};
	var ${gridName}=app.crearGrid(dataStore,${columnModel},cfg);

	${gridName}.on('rowdblclick', function(grid, rowIndex, e) {
	var rec = grid.getStore().getAt(rowIndex);
	<c:if test="${newTabOnUpdate}">
		app.openTab(createTitle(rec),"${updateFlow}",{id:rec.get('id')},{id:'${recordType}'+rec.get('id')<c:if test="${iconCls != null}">,iconCls:'${iconCls}'</c:if>});
	</c:if>
	<c:if test="${! newTabOnUpdate}">
    	var w = app.openWindow({
    			flow:'${updateFlow}'
    			,title : createTitle(rec)
    			,params:{id:rec.get('id')}
    			,width:${gridName}_DEFAULT_WIDTH
    			<c:if test="${iconCls != null}">,iconCls:'${iconCls}'</c:if>
				//,closable:true
    	});
    	w.on(app.event.DONE, function(){
				w.close();
				buscarFunc();
		});
		w.on(app.event.CANCEL, function(){
				w.close();
		});
		</c:if>
    });

    <%-- 
    var compuesto = new Ext.Panel({
	    items : [
	    	filtroForm
			,${gridName}
	    	]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
    --%>
    
    var mainPanel = new Ext.Panel({
		items : [
			{
				layout:'form'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,items:[filtroForm]
			}
			,{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[${gridName}]
			}
    	]
	    //,bodyStyle:'padding:10px'
	    ,autoHeight : true
	    ,border: false
    });
	
	//añadimos al padre y hacemos el layout
	page.add(mainPanel);