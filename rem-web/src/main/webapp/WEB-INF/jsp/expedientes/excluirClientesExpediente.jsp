<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

<%--  JSP utilizado en los flows excluirClientesExpediente y decisionExcluirCliente  --%>

var personas =
<json:object>
	<json:array name="personas" items="${personas}" var="per">
		<json:object>
			<json:property name="id" value="${per.id}" />
			<json:property name="nombre" value="${per.nombre}" />
			<json:property name="apellido" value="${per.apellido1}" />
			<json:property name="apellido2" value="${per.apellido2}" />
			<json:property name="incluido" value="false" />
		</json:object>
	</json:array>
</json:object>;

var clientesStore = new Ext.data.JsonStore({
	data : personas
	,root : 'personas'
	,fields : ['id', 'nombre', 'apellido', 'apellido2', 'incluido']
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
    header : '<s:message code="expedientes.excluirclientes.excluir" text="**Excluir"/>'
    ,dataIndex:'incluido'});

var clientesCm = new Ext.grid.ColumnModel([
	{dataIndex : 'id', hidden:true }
	,{header : '<s:message code="expedientes.excluirclientes.nombre" text="**nombre"/>', dataIndex : 'nombre' }
	,{header : '<s:message code="expedientes.excluirclientes.apellido" text="**apellido"/>', dataIndex : 'apellido' }
	,{header : '<s:message code="expedientes.excluirclientes.apellido2" text="**apellido2"/>', dataIndex : 'apellido2' }
	,checkColumn
]);

var clientesGrid = new Ext.grid.EditorGridPanel({
	store: clientesStore
	,title:'<s:message code="expedientes.excluirclientes.seleccionar" text="**Seleccione clientes a excluir del Expediente" />'
	,name:'excluidos'
	,cm: clientesCm
	,style: 'padding-right:5px'
	<c:if test="${expediente.estadoItinerario.codigo!='RE'}">
		,plugins: checkColumn
	</c:if>
	,viewConfig: {forceFit:true}
	,width: 590
	,height: 170
	,clicksToEdit: 1
});

function transform(records) {
    var str='';
    var data;
    for(var i=0; i < records; i++) {
        data = clientesGrid.getStore().getAt(i).data;
	 	if(data.incluido==true)
	       	str+=data.id;
		if(i!=records-1)	// Si no es el último elemento
			str+=',';
    }
    return str;
};

var clientesExcluidos =
	<json:object name="clientesExcluidos">
		<json:array name="personasId" items="${exclusion.personas}" var="persona">
				<json:object>
					<json:property name="id" value="${persona.id}" />
				</json:object>
		</json:array>
	</json:object>;

// Destildamos todos los elementos de la lista
for(i=0; i < clientesGrid.getStore().getTotalCount(); i++) {
	clientesGrid.getStore().getAt(i).data.incluido=false;
}

// Si ya existía la solicitud de esclusión, dejamos tildados
// solo los elementos que fueron tildados (seleccionados) anteriormente
for(i=0; i < clientesExcluidos.personasId.length; i++) {
	for(j=0; j < clientesGrid.getStore().getTotalCount(); j++) {
		if(clientesExcluidos.personasId[i].id==clientesGrid.getStore().getAt(j).data.id) {
			clientesGrid.getStore().getAt(j).data.incluido=true;
		}
	}
}
var tituloobservaciones = new Ext.form.Label({
		   	text:'<s:message code="expedientes.excluirclientes.observaciones" text="**Observaciones"/>'
			,style:'font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
			});
var observaciones=new Ext.form.TextArea({
	fieldLabel:'<s:message code="expedientes.excluirclientes.observaciones" text="**Observaciones"/>'
	,name:'observaciones'
	,hideLabel:true
	,value:'<s:message text="${exclusion.observacionesSolicitud}" javaScriptEscape="true" />'
	,width:590
	,height:150
	,maxLength:1024
	<c:if test="${expediente.estadoItinerario.codigo=='RE'}">
	,readOnly:true
	</c:if>
});

var items={
	layout:'form'
	,style:'padding:5px'
	,defaults:{xtype:'fieldset',autoHeight:true,border:false}
	,items:[{ xtype : 'errorList', id:'errL' }
	,{
		items:[clientesGrid]
	},{
		items:[tituloobservaciones]
	}
	,{
		items:[observaciones]
	}
	]
};

<c:if test="${expediente.estadoItinerario.codigo=='RE'}">
	var btnOk = new Ext.Button({
	  text: '<s:message code="app.botones.aceptar" text="**Aceptar" />'
	  ,iconCls: 'icon_ok'
	  ,handler: function() {
	        page.submit({
	           flow: 'fase2/expedientes/decisionExcluirClientesExpediente'
	           ,eventName: 'close'
	           ,formPanel: panel
	           ,success: function(){  page.fireEvent(app.event.DONE); }
	        });
	      }
	});
</c:if>

<c:if test="${expediente.estadoItinerario.codigo=='CE'}">
	var btnGuardar = new Ext.Button({
	  text: '<s:message code="app.guardar" text="**Guardar" />'
	  ,iconCls: 'icon_ok'
	  ,handler: function() {
	        var params = { excluidos: transform(clientesGrid.getStore().getTotalCount()), idExclusion: '${exclusion.id}'};
	        page.submit({
	           flow: 'fase2/expedientes/excluirClientesExpediente'
	           ,eventName: 'update'
	           ,formPanel: panel
	           ,success: function(){  page.fireEvent(app.event.DONE); }
	           ,params: params
	        });
	      }
	});
	
	var btnCancelar = new Ext.Button({
		text: '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls: 'icon_cancel'
		,handler: function(){
			page.submit({
	            flow: 'fase2/expedientes/excluirClientesExpediente'
				,eventName: 'cancel'
				,formPanel: panel
				,success: function(){ page.fireEvent(app.event.CANCEL); } 	
			});
		}
	});
</c:if>

var panel = new Ext.form.FormPanel({
	autoHeight : true
	,bodyStyle : 'padding:5px'
	,border : false
	,items : [
		 { xtype : 'errorList', id:'errL' }
		,{ 
			border : false
			,layout : 'anchor'
			,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
			,items : items
		}
	]
	,bbar : [
		<c:if test="${expediente.estadoItinerario.codigo=='CE'}">btnGuardar, btnCancelar</c:if>
		<c:if test="${expediente.estadoItinerario.codigo=='RE'}">btnOk</c:if>
	]
});

page.add(panel);

</fwk:page>
