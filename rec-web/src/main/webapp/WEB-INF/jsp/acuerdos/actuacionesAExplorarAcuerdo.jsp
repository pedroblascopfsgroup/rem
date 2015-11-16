<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
//----------------------------------------------------------------
// Inicio actuaciones Realizadas
//----------------------------------------------------------------

var crearActuacionesAExplorar=function(){

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

<%--    var actuacionesAExplorarGrid = app.crearGrid(actuacionesStore,cmActuacionesAExplorar,{ --%>
<%--          title : '&nbsp;' --%>
<%--          <app:test id="actuacionesGrid" addComa="true" /> --%>
<%--          ,style:'padding-right:10px' --%>
<%--          ,autoHeight : true --%>
<%-- 		 ,border:true --%>
<%-- 		 ,margin:90 --%>
<%--          ,cls:'cursor_pointer' --%>
<%--          ,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) --%>
<%--          ,bbar : [ --%>
<%-- 	        <c:if test="${puedeEditar}"> --%>
<%-- 	        	btnEditActuacionAExplorar --%>
<%-- 	        </c:if> --%>
<%-- 	     ] --%>
<%--    });  --%>
   
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

   //return fieldSetActuaciones;   
   return {
		title:'<s:message code="acuerdos.actuacionesAExplorar.titulo" text="**Actuaciones A Explorar"/>'
		,autoHeight:true
		,xtype:'fieldset'
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false, style:'margin:4px;width:97%',border:true}
		,items : [
		 	actuacionesAExplorarGrid
		]
	}
   
 };

//----------------------------------------------------------------
//Fin Actuaciones Realizadas
//----------------------------------------------------------------