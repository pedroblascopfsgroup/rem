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

var crearActuacionesRealizadas=function(){

	var actuaciones = <json:object name="actuaciones">
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
		
	var actuacionesStore = new Ext.data.JsonStore({
		data : actuaciones
		,root : 'actuaciones'
		,fields : ['id','tipoActuacion','fecha','resultado','actitud','observaciones']
	});

   var cmActuaciones = new Ext.grid.ColumnModel([
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
				var rec = actuacionesGrid.getSelectionModel().getSelected();
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
   
   //var actuacionesGrid = app.crearGrid(actuacionesStore,cmActuaciones,{
<%--    var actuacionesGrid = app.crearGrid(actuacionesStore,cmActuaciones,{ --%>
<%--          title : '&nbsp;' --%>
<%--          <app:test id="actuacionesGrid" addComa="true" /> --%>
<%--          ,style:'padding:50px' --%>
<%--          ,autoHeight : true --%>
<%-- 		 ,border:true --%>
<%-- 		 ,frame:false --%>
<%--          ,cls:'cursor_pointer' --%>
<%-- 		 ,margin:90 --%>
<%--          ,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) --%>
<%--          ,bbar : [ --%>
<%--          	<c:if test="${puedeEditar}"> --%>
<%-- 	        	btnAltaActuacion,btnEditActuacion --%>
<%-- 	        </c:if> --%>
<%-- 	     ] --%>
<%--    });  --%>
   
   	var actuacionesGrid = new Ext.grid.GridPanel({
   	 	title : '&nbsp;'<app:test id="actuacionesGrid" addComa="true" /> 
		,store:actuacionesStore
		,cm:cmActuaciones 
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


	var fieldSetActuaciones = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuaciones.titulo" text="**Actuaciones Realizadas"/>'
		,autoHeight:true
		//,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false, style:'margin:4px;width:97%',border:true}
		,items : [
		 	actuacionesGrid
		]
	});

   actuacionesGrid.on('layout', function() {
					//fwk.log('visible: '+this.isVisible());
					if(this.isVisible()){
						var parentSize = app.contenido.getSize(true);
						this.setWidth(parentSize.width-40);//el  -10 es un margen
						Ext.grid.GridPanel.prototype.doLayout.call(this);
					}

	});
   //return fieldSetActuaciones;
   return {
		title:'<s:message code="acuerdos.actuaciones.titulo" text="**Actuaciones Realizadas"/>'
		,autoHeight:true
		,xtype:'fieldset'
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop', style:'margin:4px;width:97%'}
		,items : [
		 	actuacionesGrid
		]
	} 
	
   
 };
 var hacemeUnGridChe =	function(myStore,columnModel, config){
 		config = config || {};

		//añado tooltips a las columnas (sólo si tienen header)
		var ccfg = columnModel.config;
		for(var i=0;i < ccfg.length;i++){
			if (ccfg[i].header){
				ccfg[i].tooltip = ccfg[i].header;
			}
		}

		var cfg = {
				title: config.title || '**'
				,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
				,store: myStore
				,style : config.style
				,cm:columnModel
			    ,clicksToEdit:1
			    ,resizable:true
			    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
			    //,width: config.width || (columnModel.getTotalWidth()+25)
				,autoWidth:true
			    //,width:200
			    ,height: config.height || 350
				//,maxHeight:config.maxHeight || 150
			    ,autoHeight: config.autoHeight || false
			    ,bbar : config.bbar
			    ,viewConfig : {  forceFit : true}
			    ,monitorResize: true
				,doLayout: function() {
					//fwk.log('visible: '+this.isVisible());
					if(this.isVisible()){
						var parentSize = app.contenido.getSize(true);
						this.setWidth(parentSize.width-10);//el  -10 es un margen
						if(!config.dontResizeHeight){
							this.setHeight(config.height||150);
						}
						Ext.grid.GridPanel.prototype.doLayout.call(this);
					}

				}
			};
			if(config.id) {
				cfg.id=config.id;
			}
		if (config.iconCls) cfg.iconCls=config.iconCls;
		if (config.height) cfg.height=config.height;
		if (config.plugins) cfg.plugins=config.plugins;
		if (config.cls) cfg.cls=config.cls;

		//implementa el tooltip para ver el contenido de las celdas
		cfg.onRender = function() {
        	Ext.grid.GridPanel.prototype.onRender.apply(this, arguments);
        	this.addEvents("beforetooltipshow");
	        this.tooltip = new Ext.ToolTip({
	        	renderTo: Ext.getBody(),
	        	target: this.view.mainBody,
	        	listeners: {
	        		beforeshow: function(qt) {
	        			var v = this.getView();
			            var rows = (this.store != null ? this.store.getCount() : 0);
			            if (rows <=0 ) return false;

			            var store = this.getStore();
			            var row = v.findRowIndex(qt.baseTarget);
			            var cell = v.findCellIndex(qt.baseTarget);
			            if (cell===false) return;
			            var field = this.getColumnModel().config[cell].dataIndex;

			            var rowData = this.getView().getCell(row,cell);
			            rowData = rowData.innerText? rowData.innerText : rowData.textContent;

			            if(rowData != this.lastRowData){
			            	this.fireEvent("beforetooltipshow", this, row, cell, rowData);
			            }
			            this.lastRowData = rowData;
			            if (!rowData) return false;
	        		},
	        		scope: this
	        	}
	        });
        };

        cfg.listeners = {
			render: function(g) {
			g.on("beforetooltipshow", function(grid, row, col, rowData) {
				grid.tooltip.body.update(rowData);
			});
			}
        };

		var myGrid = new Ext.grid.GridPanel(cfg);

			return myGrid;
	};
	
 

//----------------------------------------------------------------
//Fin Actuaciones Realizadas
//----------------------------------------------------------------