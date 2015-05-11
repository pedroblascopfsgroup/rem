<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>

//----------------------------------------------------------------
// Inicio creditos por convenio
//----------------------------------------------------------------

var crearActuacionesRealizadas=function(){

	var convenioCreditos = <json:object name="convenioCreditos">
								<json:array name="convenioCreditos" items="${pagina}" var="convCre">
									<c:forEach items="${convCre.convenioCreditos}" var="cc">
										<json:object>
											<json:property name="idConvenio" 
												value="${convCre.convenio.id}" />
											<json:property name="idConvenioCredito"
												value="${cc.id}" />
											<json:property name="quita" value="${cc.quita}"/>
											<json:property name="espera"
												value="${cc.espera}" />
											<json:property name="carencia"
												value="${cc.carencia}" />	
											<json:property name="comentario"
												value="${cc.comentario}" />
											<json:property name="tipoDefinitivo"
												value="${cc.credito.tipoDefinitivo.descripcion}" />
											<json:property name="principalDefinitivo" value="${cc.credito.principalDefinitivo}"/>
											<json:property name="conformidad" value="${cc.conformidadConvenio.descripcion}"/>
										</json:object>
									</c:forEach>
								</json:array>
							</json:object>;
						
	var convenioCreditosStore = new Ext.data.JsonStore({
		data : convenioCreditos
		,root : 'convenioCreditos'
		,fields : ['idConvenioCredito','quita','espera','carencia','comentario','tipoDefinitivo','principalDefinitivo','conformidad']
	});

   	var cmConvenioCreditos = new Ext.grid.ColumnModel([
   	   {dataIndex : 'idConvenioCredito', hidden:true}
      ,{header : '<s:message code="asunto.concurso.tabConvenios.tipoDefinido" text="**Tipo definitivo" />', dataIndex : 'tipoDefinitivo'}
      ,{header : '<s:message code="asunto.concurso.tabConvenios.principal" text="**Principal definitivo" />', dataIndex : 'principalDefinitivo', align:'right'}
      ,{header : '<s:message code="asunto.concurso.tabConvenios.quita" text="**% Quita" />', dataIndex : 'quita', align:'right'}
      ,{header : '<s:message code="asunto.concurso.tabConvenios.espera" text="**Espera" />', dataIndex : 'espera', align:'right'}
      ,{header : '<s:message code="asunto.concurso.tabConvenios.carenciaMeses" text="**Carencia en meses" />', dataIndex : 'carencia'}
      ,{header : '<s:message code="asunto.concurso.tabConvenios.observaciones" text="**Observaciones" />', dataIndex : 'comentario'}
      ,{header : '<s:message code="asunto.concurso.tabConvenios.conformidad" text="**Conformidad" />', dataIndex : 'conformidad'}
     
   	]);

    
  	var btEditarCreditoConvenio_Procedimiento = function() {
		if (convenioCreditosGrid.getSelectionModel().getCount()>0){
			var idConvenioCredito =  convenioCreditosGrid.getSelectionModel().getSelected().get('idConvenioCredito');	
			if (idConvenioCredito != '') {
				var parametros = {
						idConvenioCredito : idConvenioCredito
				};
				var w= app.openWindow({
							flow: 'plugin/procedimientos/concursal/editarConvenioCredito'
							,closable: true
							,width : 580
							,title : '<s:message code="asunto.concurso.tabConvenios.tituloModificarConvenioCredito" text="**Modificar" />'
							,params: parametros
				});
				w.on(app.event.DONE, function(){
							w.close();
							page.fireEvent(app.event.DONE);
				});
				w.on(app.event.CANCEL, function(){w.close();});
			}else{
				Ext.Msg.alert('<s:message code="asunto.concurso.tabConvenios.tituloModificarConvenioCredito" text="**Modificar" />','<s:message code="asunto.concurso.tabConvenio.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="asunto.concurso.tabConvenios.tituloModificarConvenioCredito" text="**Modificar" />','<s:message code="asunto.concurso.tabConvenio.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
		}
   	}; 
	
   	var btEditarCreditoConvenio = new Ext.Button({
		text : '<s:message code="app.editar" text="**Modificar" />'
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,handler : function() {
			btEditarCreditoConvenio_Procedimiento();
		}
   	});
	
   	var convenioCreditosGrid = app.crearGrid(convenioCreditosStore,cmConvenioCreditos,{
         title : '&nbsp;'
         <app:test id="convenioCreditosGrid" addComa="true" />
         ,style:'padding:50px'
         ,autoHeight : true
		 ,border:true
		 ,frame:false
         ,cls:'cursor_pointer'
		 ,margin:90
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,bbar : [  btEditarCreditoConvenio  ]
   	}); 

	// Evento doble click
	convenioCreditosGrid.on('rowdblclick', function(grid, rowIndex, e) {
		btEditarCreditoConvenio_Procedimiento();
    });	
    
	var fieldSetConvenioCreditos = new Ext.form.FieldSet({
		title:'<s:message code="asunto.concurso.tabConvenios.creditosTitulo" text="**Creditos"/>'
		,autoHeight:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false, style:'margin:4px;width:97%',border:true}
		,items : [
		 	convenioCreditosGrid
		]
	});

   convenioCreditosGrid.on('layout', function() {
		if(this.isVisible()){
			var parentSize = app.contenido.getSize(true);
			this.setWidth(parentSize.width-40);//el  -10 es un margen
			Ext.grid.GridPanel.prototype.doLayout.call(this);
		}
	});

   //return fieldSetActuaciones;
   return {
		title:'<s:message code="asunto.concurso.tabConvenios.creditosTitulo" text="**Créditos"/>'
		,autoHeight:true
		,xtype:'fieldset'
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop', style:'margin:4px;width:97%'}
		,items : [
		 	convenioCreditosGrid
		]
	} 
 
 }; // FIN crearActuacionesRealizadas

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
				,store: myStore
				,style : config.style
				,cm:columnModel
			    ,clicksToEdit:1
			    ,resizable:true
			    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
				,autoWidth:true
			    ,height: config.height || 350
			    ,autoHeight: config.autoHeight || false
			    ,bbar : config.bbar
			    ,viewConfig : {  forceFit : true}
			    ,monitorResize: true
				,doLayout: function() {
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
//Fin Creditos para el convenio
//----------------------------------------------------------------