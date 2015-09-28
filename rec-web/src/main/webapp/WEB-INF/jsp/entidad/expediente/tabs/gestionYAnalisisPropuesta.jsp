<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){
    
	var actuacionesRealizadas = <json:object name="actuaciones">
			<json:array name="actuaciones" items="${acuerdo.actuacionesRealizadas}" var="actuacion">	
					<json:object>
						<json:property name="id" value="${actuacion.id}" />
						<json:property name="tipoActuacion" value="${actuacion.ddTipoActuacionAcuerdo.descripcion}" />
						<json:property name="fecha">
							<fwk:date value="${actuacion.fechaActuacion}" />
						</json:property>
				 		<json:property name="resultado" value="${actuacion.ddResultadoAcuerdoActuacion.descripcion}" />
				 	 	<json:property name="actitud" value="${actuacion.tipoAyudaActuacion.descripcion}" />
				 	 	<json:property name="observaciones" value="${actuacion.observaciones}"/>
				 	</json:object>
			</json:array>
		</json:object>;
	
	var actuacionesRealizadasStore = page.getStore({
		limit:25
		,remoteSort : true
		,storeId : 'actuacionesRealizadasStore'
		,flow : 'acuerdos/detalleAcuerdoExpediente'
		,reader : new Ext.data.JsonReader({root:'actuaciones'}, ['id','tipoActuacion','fecha','resultado','actitud','observaciones'])
	});
	
	entidad.cacheStore(actuacionesRealizadasStore);

   var cmActuacionesRealizadas = new Ext.grid.ColumnModel([
   	   {dataIndex : 'id', hidden:true}
      ,{header : '<s:message code="acuerdos.actuaciones.tipo" text="**Tipo Actuación" />', dataIndex : 'tipoActuacion'}
      ,{header : '<s:message code="acuerdos.actuaciones.fecha" text="**Fecha" />', dataIndex : 'fecha'}
      ,{header : '<s:message code="acuerdos.actuaciones.resultado" text="**Resultado" />', dataIndex : 'resultado'}
      ,{header : '<s:message code="acuerdos.actuaciones.actitud" text="**Actitud" />', dataIndex : 'actitud'}
      ,{header : '<s:message code="acuerdos.actuaciones.observaciones" text="**Observaciones" />', dataIndex : 'observaciones'}
   ]);

   <c:if test="${puedeEditar}">	
	   var btnEditActuacion = new Ext.Button({
	       text:  '<s:message code="app.editar" text="**Editar" />'
	       <app:test id="EditActuacionBtn" addComa="true" />
	       ,iconCls : 'icon_edit'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
				var rec = actuacionesRealizadasGrid.getSelectionModel().getSelected();
				if(!rec) {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="acuerdos.actuaciones.listado.sinSeleccion" text="**Debe seleccionar una actuación para editar." />');
				} else {
					var w = app.openWindow({
						flow : 'acuerdos/editActuacionesRealizadasAcuerdo'
						,width:600
						,title : '<s:message code="app.agregar" text="**Agregar" />'
						,params : {idAcuerdo:'${acuerdo.id}', idActuacion:rec.get('id')}
					});
					w.on(app.event.DONE, function(){
						w.close();
						page.fireEvent(app.event.DONE);
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
	      }
	   });
   	
    
	   var btnAltaActuacion = new Ext.Button({
	       text:  '<s:message code="app.agregar" text="**Agregar" />'
	       <app:test id="AltaActuacionBtn" addComa="true" />
	       ,iconCls : 'icon_mas'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
				var w = app.openWindow({
					flow : 'acuerdos/editActuacionesRealizadasAcuerdo'
					,width:600
					,title : '<s:message code="app.agregar" text="**Agregar" />'
					,params : {idAsunto:'${acuerdo.asunto.id}', idAcuerdo:'${acuerdo.id}'}
				});
				w.on(app.event.DONE, function(){
					w.close();
					page.fireEvent(app.event.DONE);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
	      }
	   });
   </c:if>
   
   	var actuacionesRealizadasGrid = new Ext.grid.GridPanel({
   	 	title : '&nbsp;'<app:test id="actuacionesGrid" addComa="true" /> 
		,store:actuacionesRealizadasStore
		,cm:cmActuacionesRealizadas 
		,cls:'cursor_pointer'
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,style:'padding:50px;'
		,autoWidth:true
		,autoHeight : true
		,bbar : [<c:if test="${puedeEditar}"> 
 	        	btnAltaActuacion,btnEditActuacion 
 	        </c:if>]
	});


	var fieldSetActuacionesRealizadas = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuaciones.titulo" text="**Actuaciones Realizadas"/>'
		,autoHeight:true
		//,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false, style:'margin:4px;width:97%',border:true}
		,items : [
		 	actuacionesRealizadasGrid
		]
	});

   actuacionesRealizadasGrid.on('layout', function() {
		//fwk.log('visible: '+this.isVisible());
		if(this.isVisible()){
			var parentSize = app.contenido.getSize(true);
			this.setWidth(parentSize.width-40);//el  -10 es un margen
			Ext.grid.GridPanel.prototype.doLayout.call(this);
		}
	});
	
	var actuaciones = <json:object name="actuaciones">
			<json:array name="actuaciones" items="${actuacionesAExplorar}" var="actuacionAExplorar">	
					<json:object>
						<json:property name="id" value="${actuacionAExplorar.id}" />
						<json:property name="codTipoSolucionAmistosa" value="${actuacionAExplorar.ddSubtipoSolucionAmistosaAcuerdo.ddTipoSolucionAmistosa.codigo}" />
						<json:property name="tipoSolucionAmistosa" escapeXml="false">
							<c:if test="${actuacionAExplorar.activo}">
								${actuacionAExplorar.ddSubtipoSolucionAmistosaAcuerdo.ddTipoSolucionAmistosa.descripcion}
							</c:if>
							<c:if test="${!actuacionAExplorar.activo}">
								<span style="color: gray;">${actuacionAExplorar.ddSubtipoSolucionAmistosaAcuerdo.ddTipoSolucionAmistosa.descripcion}</span>
							</c:if>
						</json:property>
				 		<json:property name="codSubtipoSolucion" value="${actuacionAExplorar.ddSubtipoSolucionAmistosaAcuerdo.codigo}" />
				 		<json:property name="subtipoSolucion" escapeXml="false">
							<c:if test="${actuacionAExplorar.activo}">
								${actuacionAExplorar.ddSubtipoSolucionAmistosaAcuerdo.descripcion}
							</c:if>
							<c:if test="${!actuacionAExplorar.activo}">
								<span style="color: gray;">${actuacionAExplorar.ddSubtipoSolucionAmistosaAcuerdo.descripcion}</span>
							</c:if>
						</json:property>
				 	 	<json:property name="valoracion" escapeXml="false">
							<c:if test="${actuacionAExplorar.activo}">
								${actuacionAExplorar.ddValoracionActuacionAmistosa.descripcion}
							</c:if>
							<c:if test="${!actuacionAExplorar.activo}">
								<span style="color: gray;">${actuacionAExplorar.ddValoracionActuacionAmistosa.descripcion}</span>
							</c:if>
						</json:property>
				 	 	<json:property name="observaciones" escapeXml="false">
							<c:if test="${actuacionAExplorar.activo}">
								${actuacionAExplorar.observaciones}
							</c:if>
							<c:if test="${!actuacionAExplorar.activo}">
								<span style="color: gray;">${actuacionAExplorar.observaciones}</span>
							</c:if>
						</json:property>
						<json:property name="isActivo" >
							<c:if test="${actuacionAExplorar.activo}">
								true
							</c:if>
							<c:if test="${!actuacionAExplorar.activo}">
								false
							</c:if>
						</json:property>
				 	</json:object>
			</json:array>
		</json:object>;

    var actuacionesStore = new Ext.data.JsonStore({
		data : actuaciones
		,root : 'actuaciones'
		,fields : ['id','codTipoSolucionAmistosa','tipoSolucionAmistosa','codSubtipoSolucion','subtipoSolucion','valoracion','observaciones', 'isActivo']
	});
	
	var actuacionesStore = page.getStore({
		limit:25
		,remoteSort : true
		,storeId : 'actuacionesStore'
		,flow : 'acuerdos/detalleAcuerdoExpediente'
		,reader : new Ext.data.JsonReader({root:'actuaciones'}, ['id','codTipoSolucionAmistosa','tipoSolucionAmistosa','codSubtipoSolucion',
		'subtipoSolucion','valoracion','observaciones','isActivo'])
	});
	
	entidad.cacheStore(actuacionesStore);

   var cmActuacionesAExplorar = new Ext.grid.ColumnModel([
   	   {dataIndex: 'id', hidden:true, fixed:true}
   	  ,{dataIndex: 'codTipoSolucionAmistosa', hidden:true, fixed:true}
      ,{header : '<s:message code="acuerdos.actuacionesAExplorar.tipoSolucionAmistosa" text="**Tipo Solición Amistosa" />', dataIndex : 'tipoSolucionAmistosa'}
   	  ,{dataIndex: 'codSubtipoSolucion', hidden:true, fixed:true}
      ,{header : '<s:message code="acuerdos.actuacionesAExplorar.subtipoSolucion" text="**Subtipo Solución" />', dataIndex : 'subtipoSolucion'}
      ,{header : '<s:message code="acuerdos.actuacionesAExplorar.valoracion" text="**Valoración" />', dataIndex : 'valoracion'}
      ,{header : '<s:message code="acuerdos.actuacionesAExplorar.observaciones" text="**Observaciones" />', dataIndex : 'observaciones'}
   	  ,{dataIndex: 'isActivo', hidden:true, fixed:true}
   ]);
   <c:if test="${puedeEditar}">
	   var btnEditActuacionAExplorar = new Ext.Button({
	       text:  '<s:message code="app.editar" text="**Editar" />'
	       <app:test id="btnEditActuacionAExplorar" addComa="true" />
	       ,iconCls : 'icon_edit'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
				var rec = actuacionesAExplorarGrid.getSelectionModel().getSelected();
				if(!rec) {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="acuerdos.actuaciones.listado.sinSeleccion" text="**Debe seleccionar una actuación para editar." />');
				} else {
					var w = app.openWindow({
						flow : 'acuerdos/editActuacionesAExplorarAcuerdo'
						,width:570
						,title : '<s:message code="app.agregar" text="**Agregar" />'
						,params : {idAcuerdo:'${acuerdo.id}', idActuacion:rec.get('id'), codSubtipoSolucion:rec.get('codSubtipoSolucion')}
					});
					w.on(app.event.DONE, function(){
						w.close();
						page.fireEvent(app.event.DONE);
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
	       }
	   });
   </c:if>
   
   var actuacionesAExplorarGrid = new Ext.grid.GridPanel({
            title : '&nbsp;'
         <app:test id="actuacionesGrid" addComa="true" />
         ,store:actuacionesStore
		 ,cm:cmActuacionesAExplorar 
         ,style:'padding-right:10px'
         ,autoHeight : true
		 ,border:true
		 ,margin:90
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
         ,bbar : [
	        <c:if test="${puedeEditar}">
	        	btnEditActuacionAExplorar
	        </c:if>
	     ]
   });

   actuacionesAExplorarGrid.on('rowclick', function(grid, rowIndex, e) {
   		var rec = grid.getStore().getAt(rowIndex);
		if(rec.get('isActivo')=='false') {
			btnEditActuacionAExplorar.disable();
		} else {
			btnEditActuacionAExplorar.enable();
		}
   });

   var fieldSetActuaciones = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuacionesAExplorar.titulo" text="**Actuaciones A Explorar"/>'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false, style:'margin:4px;width:97%'}
		,items : [
		 	actuacionesAExplorarGrid
		]
	});
   


	var labelStyle='font-weight:bolder;width:150px';
	
	var tipoAyuda = new Ext.ux.form.StaticTextField({
		 fieldLabel:'<s:message code="expedientes.consulta.tabgestion.tipoayuda" text="**Tipo Ayuda"/>'
		,name:'tipoAyudaDescripcion'
		,labelStyle:labelStyle
		,value:'${expediente.aaa.tipoAyudaActuacion.descripcion}'
	});

	var descAyuda= app.crearTextArea(
		'<s:message code="expedientes.consulta.tabgestion.descayuda" text="**Descrcion Ayuda"/>'
		,'<s:message text="${expediente.aaa.descripcionTipoAyudaActuacion}" javaScriptEscape="true" />'
		,true
		,labelStyle
		,'descripcionTipoAyudaActuacion'
		,{width:300}
	);
	
	var causasImpago=new Ext.ux.form.StaticTextField({
		fieldLabel:'<s:message code="expedientes.consulta.tabgestion.causasimpago" text="**Causa Impago" />'
		,value:'${expediente.aaa.causaImpago.descripcion}'
		,labelStyle:labelStyle
		,name:'causasImpago'
	});
		
	var comentarios= app.crearTextArea(
		'<s:message code="expedientes.consulta.tabgestion.comentarios" text="**Comentarios"/>'
		,'<s:message text="${expediente.aaa.comentariosSituacion}" javaScriptEscape="true" />'
		,true
		,labelStyle
		,'comentariosSituacion'
		,{width:300,height:70}
	);

	var panelGyA = new Ext.Panel({
		style:'padding: 5px'
		,defaults:{
		    style:'margin:5px'
		}
		,border : false
		,autoHeight:true 
		,autoWidth:true
	      ,items:[fieldSetActuacionesRealizadas, fieldSetActuaciones]
	   });
	
	var formGestion = new Ext.form.FormPanel({
		border:false
		,autoHeight:true
		,items:[tipoAyuda, descAyuda, causasImpago, comentarios]
	});

	var panelGestion = new Ext.form.FieldSet({
		title:'<s:message code="expedientes.consulta.tabgestion.revision" text="**Revisión"/>'
		,border:true
		,style:'padding:5px'
		,height:427
		,width:450
		,defaults : {border:false }
		,monitorResize: true
		,items:[formGestion]
	});

	var panel = new Ext.Panel({
			autoHeight:true
			,autoWidth:true
			,layout:'table'
			,title:'<s:message code="expedientes.consulta.tabgestion.titulo" text="**Gestion y Analisis"/>'
			,layoutConfig:{columns:2}
			,titleCollapse:true
			,style:'margin-right:20px;margin-left:10px'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[panelGyA]}
					,{layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[panelGestion]}
			]
			,nombreTab : 'tabGestionyAnalisis'
	});
	
	panel.getCodExpediente = function(){
		return entidad.get("data").cabecera.codExpediente;
	}
	
 	panel.getValue = function(){};
	panel.setValue = function(){
    	entidad.cacheOrLoad(data,actuacionesStore, {id : panel.getCodExpediente()});
	}
	
	return panel;
})
