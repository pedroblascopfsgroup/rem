<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>


var width=250;
var style='text-align:left;font-weight:bolder;width:200;margin:3';

var tituloGestor = new Ext.form.Label({
   	text:'<s:message code="gestionesRealizadas.comentario" text="**Comentario"/>'
	,style:'font-weight:bolder; font-size:11'
});

<c:if test="${readOnly}">
var refrescarObservacion = function() {
	panelForm.load({
		url: app.resolveFlow('politica/observacionesGestionData')
		,params:{id:${analisisPolitica.id}}
	});
};
</c:if>

var comentarioGestiones = new Ext.form.TextArea({
	fieldLabel: '<s:message code="gestionesRealizadas.comentario" text="**Comentario"/>'
	,hideLabel: true
	,width:370
	,height:135
	,labelStyle:style
	,name:'observacionesGestionesRealizadas'
	,value:'<s:message text="${analisisPolitica.observacionesGestionesRealizadas}" javaScriptEscape="true" />'
	,maxLength: 250
	<c:if test="${readOnly}">,readOnly:true</c:if>
});

<c:if test="${!readOnly}">
	var idH = new Ext.form.Hidden({name: 'idAnalisisPersonaPolitica', value:'${analisisPolitica.id}'});
</c:if>

var panelForm = new Ext.form.FormPanel({	<%-- Si es de lectura el panel es de tipo form para el refrezco  --%>
	border:false
	,width:375
	,height:140
	,layout: 'table'
	,items:[
		{items:[comentarioGestiones],border:false}
      ]
});

<c:if test="${!readOnly}">
	var comentarioGestionesH = new Ext.form.Hidden({name: 'observacionesGestiones'});
	var gestionesIncluirH = new Ext.form.Hidden({name: 'gestionesIncluir'});
	var saveForm = new Ext.form.FormPanel({
			items:[idH,comentarioGestionesH,gestionesIncluirH]
	  });
</c:if>

 var btnModificar = new Ext.Button({
	text: '<s:message code="analisisPersona.modificar" text="**Modificar" />',
	iconCls: 'icon_edit',
	handler: function(){
		var win = app.openWindow({
			flow: 'politica/editarGestionesRealizadas'
			,title: '<s:message code="gestionesRealizadas.editar" text="**Editar Gestiones Realizadas" />'
			,closable: true
			,params: {id:${analisisPolitica.id}}
		    ,autoHeight: true
		    ,width: 800
		});
		win.on(app.event.CANCEL,function(){win.close();});
		win.on(app.event.DONE,
			function(){
				win.close();
				refrescarObservacion();
				gestionesStore.webflow({id:${analisisPolitica.cicloMarcadoPolitica.persona.id}});
			}
		);
	}
});


//DEFINICION DEL CHECKCOLUM

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
	<c:if test="${!readOnly}">
	    onMouseDown : function(e, t){
	        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
	            e.stopEvent();
	            var index = this.grid.getView().findRowIndex(t);
	            var record = this.grid.store.getAt(index);
	            record.set(this.dataIndex, !record.data[this.dataIndex]);
	        }
	    },
	</c:if>
    renderer : function(v, p, record){
        p.css += ' x-grid3-check-col-td'; 
        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
};

<c:if test="${!readOnly}">
function transform(grid) {
	var store = grid.getStore();
	var str = '';
	var datos;
	for (var i=0; i < store.data.length; i++) {
		datos = store.getAt(i);
		if(datos.get('seleccionado') == true) {
			if(str!='') str += ',';
      		str += datos.get('codigo');
		}
	}
	return str;
}
</c:if>
		
/******/

var Gestion = Ext.data.Record.create([
	{name:'codigo'}
	,{name:'descripcion'}
	,{name:'seleccionado'}
]);

	var gestionesStore = page.getStore({
	eventName : 'listado'
	,flow:'politicas/gestionesRealizadas'
	,reader: new Ext.data.JsonReader({
		root: 'listadoGestiones'
	}, Gestion)
});

var checkColumnGestiones = new Ext.grid.CheckColumn({
	header:'<s:message code="panelGestiones.incluido" text="**Incluir" />'
	,width:61, dataIndex:'seleccionado'
});	

var gestionesCm = new Ext.grid.ColumnModel([
	{dataIndex : 'codigo', hidden:true, fixed:true}
	,{header : '<s:message code="panelGestiones.gestion" text="**Tipo Gestión"/>',width: 315, dataIndex : 'descripcion' }
	,checkColumnGestiones
]);

var gestionesGrid = new Ext.grid.GridPanel({
	store : gestionesStore
	,title:'<s:message code="panelGestiones.gestionesRealizadas" text="**Gestiones Realizadas" />'
	,cm : gestionesCm
	,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
	,plugins: checkColumnGestiones
	,clicksToEdit:1
	,width: 380
	,height : 150
	,doLayout: function() {
		  Ext.grid.GridPanel.prototype.doLayout.call(this);
	}
});

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			comentarioGestionesH.setValue(comentarioGestiones.getValue());
			gestionesIncluirH.setValue(transform(gestionesGrid));
			
			page.submit({
				eventName : 'update'
				,formPanel : saveForm
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
		}
	});
	var btnCancelar = new Ext.Button({
		text: '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls: 'icon_cancel'
		,handler: function(){
			page.fireEvent(app.event.CANCEL);
		  }
	});

var panel = new Ext.Panel({
	layout:'form'
	,style:'margin-top:8px'
	,bodyStyle: 'padding:4px'
    ,autoHeight: true
    ,autoWidth: true
	,items:[
		{
         autoHeight: true
        ,autoWidth: true
        ,border:false
        ,layout: 'table'
        ,layoutConfig: {columns:2}
        ,items: [
					{
						layout:'form'
						,border:false
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[gestionesGrid]
					}
					,{
						layout:'form'
						,border:false
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[tituloGestor,panelForm<c:if test="${!readOnly}">,saveForm</c:if>]
					}
				]
		}
		<c:if test="${(verAnalisis == null || (verAnalisis != null && !verAnalisis)) && readOnly}">
			,btnModificar
		</c:if>
	]
	<c:if test="${!readOnly}">,bbar:[btnGuardar,btnCancelar]</c:if>
   });

	gestionesStore.webflow({id:${analisisPolitica.cicloMarcadoPolitica.persona.id}});