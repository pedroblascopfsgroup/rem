<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>


<%--  Este JSP ya no se usa en el flow decisionExcluirClientesExpediente, se usa el  --%>
<%--  mismo que en excluirClientesExpediente por ahora !!!!!!!!                      --%>


var clientes =
<json:object>
	<json:array name="clientes" items="${clientes}" var="cli">
		<json:object>
			<json:property name="id" value="${cli.id}" />
			<json:property name="nombre" value="${cli.persona.nombre}" />
			<json:property name="apellido" value="${cli.persona.apellido1}" />
			<json:property name="incluido" value="false" />
		</json:object>
	</json:array>
</json:object>;
	
var clientesStore = new Ext.data.JsonStore({
	data : clientes
	,root : 'clientes'
	,fields : ['id', 'nombre', 'apellido', 'incluido']
});

Ext.grid.CheckColumn = function(config){
    Ext.apply(this, config);
    if(!this.id){
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype = {
    init : function(grid) {
        this.grid = grid;
        this.grid.on('render', function(){
            var view = this.grid.getView();
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },
    onMouseDown : function(e, t){
        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
            e.stopEvent();
            var index = this.grid.getView().findRowIndex(t);
            var record = this.grid.store.getAt(index);
            record.set(this.dataIndex, !record.data[this.dataIndex]);
        }
    },
    renderer : function(v, p, record){
        p.css += ' x-grid3-check-col-td'; 
        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
};  


var checkColumn = new Ext.grid.CheckColumn({
    header : '<s:message code="" text="**Excluir"/>'
    ,dataIndex:'incluido'});

var clientesCm = new Ext.grid.ColumnModel([
	{dataIndex : 'id', hidden:true }
	,{header : '<s:message code="nombre" text="**nombre"/>', dataIndex : 'nombre' }
	,{header : '<s:message code="apellido" text="**apellido"/>', dataIndex : 'apellido' }
	,checkColumn
]);

var clientesGrid = new Ext.grid.EditorGridPanel({
	store: clientesStore
	,title:'<s:message code="" text="**Clientes a excluir del Expediente" />'
	,name:'excluidos'
	,cm: clientesCm
	,style: 'padding-right:5px'
	,plugins: checkColumn
	,viewConfig: {forceFit:true}
	,width: 350
	,height: 170
});

var observacionesSolicitud=new Ext.form.TextArea({
	fieldLabel:'<s:message code="" text="**Observaciones"/>'
    ,value:'<s:message text="${exclusion.observacionesSolicitud}" javaScriptEscape="true" />'
	,width:220
	,readOnly:true
});

var observaciones=new Ext.form.TextArea({
	fieldLabel:'<s:message code="" text="**Observaciones"/>'
	,width:220
	,name:'observacionesRespuesta'
    ,value:'<s:message text="${exclusion.observacionesRespuesta}" javaScriptEscape="true" />'
});

var decision = new Ext.form.Checkbox({
	fieldLabel:'<s:message code="" text="**Acepta Exclusion" />'
	,name:'decision'
	<c:if test="${exclusion.aceptado==1}">
	,checked:true
	</c:if>
});

var idExclusion = new Ext.form.Hidden({name:'idExclusion', value :'${exclusion.id}'});

var items={
	layout:'form'
	,style:'padding:5px'
	,defaults:{xtype:'fieldset',autoHeight:true}
	,items:[{ xtype : 'errorList', id:'errL' }
	,{
		border:false
		,items:[clientesGrid]
	},{
		title:'<s:message code="" text="**Datos de la solicitud" />'
		,items:[observacionesSolicitud]
	},{
		title:'<s:message code="" text="**Respuesta" />'
		,items:[observaciones,decision,idExclusion]
	}
	]
}

var panelEdicion = app.crearABMWindow(page , items);

</fwk:page>