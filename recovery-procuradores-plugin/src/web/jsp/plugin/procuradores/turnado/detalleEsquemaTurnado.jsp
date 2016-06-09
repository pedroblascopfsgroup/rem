<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	<pfsforms:textfield
	labelKey="plugin.procuradores.turnado.descripcionEsquema"
	label="**Descripci&oacute;n esquema"
	name="nombreEsquema"
	value="${nombreEsquema}"/>
	
	<c:if test="${idEsquema==null}" >
	var idEsquema = null;
	nombreEsquema.setDisabled(false);	
	</c:if>
	<c:if test="${idEsquema!=null}" >
	var idEsquema = ${idEsquema};
	nombreEsquema.setDisabled(true);
	</c:if>
	
	var idsTuplasBorradas = [];
	var idsRangosBorrados = [];
	var idsRangosCreados = [];
	var modificacionesRangos = [];
	var idsTuplasConfigDefinitivas = [];

	var nombreEsquemaHz = app.creaPanelHz({style : "margin-left:4px;margin-top:4px;margin-bottom:4px;"},[{html:"<b><s:message code="plugin.procuradores.turnado.descripcionEsquema" text="**Descripci&oacute;n esquema"/></b>"+":", border: false, width : 133, cls: 'x-form-item', style: "margin-top:4px;"}
					  ,nombreEsquema]);
	
	var nombreEsquemaPanel = new Ext.form.FieldSet({
		title : '<s:message code="plugin.procuradores.turnado.informacionTurnado" text="**Información esquema" />'
		,layout:'table'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,collapsible : true
		,collapsed : true
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false}
		,items : [nombreEsquemaHz]
		,listeners: {
			expand:  function(){
				turnadoFiltrosFieldSet.collapse(true);
				infoConfiguracionTurnado.collapse(true);	
			}
		}	
		,doLayout:function() {
				var margin = 40;
				this.setWidth(900-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
	<%@ include file="panelFiltrosPlazaTPO.jsp" %>
	<%@ include file="panelNuevaConfiguracion.jsp" %>
	
	var gestionPanelSuperior = function(funcion){
		
		infoConfiguracionTurnado.setVisible(!infoConfiguracionTurnado.isVisible());
		turnadoFiltrosFieldSet.setVisible(!turnadoFiltrosFieldSet.isVisible());
		if(funcion==1){
			//Limpiar rangos
			rangosStore.removeAll()
			//Limpiar panel de nueva configuracion
			cmbPlazas.clearValue();
			botonAddPlaza.setDisabled(true);
			botonRemovePlaza.setDisabled(true);
			cmbTPO.clearValue();
			botonAddTPO.setDisabled(true);
			botonRemoveTPO.setDisabled(true);
			Ext.getCmp('turn_procu_lista_procedimientos').removeAll();
			Ext.getCmp('turn_procu_lista_plazas').removeAll();
			gestionarPanelNuevaPlaza();
			gestionarPanelNuevoTPO();
		}
		if(infoConfiguracionTurnado.isVisible()){
			infoConfiguracionTurnado.expand(true);
			if(rangosGrid.getSelectionModel().hasSelection()) rangosGrid.getSelectionModel().clearSelections();
			rangosStore.removeAll();
			btnNuevo.setDisabled(true);
			btnBorrarRango.setDisabled(true);
			btnEditarRango.setDisabled(true);
		}
	};
	
	<%-- Botones grids --%>
	var btnNuevo = new Ext.Button({
			text : '<s:message code="plugin.procuradores.turnado.nuevoRango" text="**Nuevo rango" />'
			,iconCls : 'icon_mas'
			,disabled: true
			,handler : function(){
				btnNuevo.setDisabled(true);
				gestionarPanelEdicionRangos(false, 'NEW', rangosGrid.getSelectionModel().getSelected(),null);
			}
	});
	
	var btnBorrarRango = new Ext.Button({
			text : '<s:message code="app.borrar" text="**Borrar" />'
			,iconCls : 'icon_menos'
			,disabled: true
			,handler : function(){
					Ext.Msg.minWidth=360;			
					Ext.Msg.confirm('<s:message code="plugin.procuradores.turnado.confirmarBorrarRango" text="**Borrar rango" />', '<s:message code="plugin.procuradores.turnado.mensajeConfirmarBorrarRango" text="**Estas seguro que desa borrar el rango seleccionado?" />', this.evaluateAndSend);
			}
			,evaluateAndSend: function(seguir) {      			
	         			if(seguir== 'yes') {
	         				//Borrado logico de la regla
	         				borrarRango(rangosGrid.getSelectionModel().getSelected().data.rangoId);
						}
	    	} 
	});
	var btnEditarRango = new Ext.Button({
			text : '<s:message code="app.editar" text="**Modificar" />'
			,iconCls : 'icon_edit'
			,disabled: true
			,handler : function(){
				btnEditarRango.setDisabled(true);
				//Obtener todas las entradas del store con mismos identificadores de rango
				Ext.Ajax.request({
					url: '/pfs/turnadoprocuradores/getIdsRangosRelacionados.htm'
					,params: {
								idConfig: rangosGrid.getSelectionModel().getSelected().data.rangoId
							}
					,method: 'POST'
					,success: function (result, request){
						var r = Ext.util.JSON.decode(result.responseText);
						////Obtener ids/codigos de los despachos y porcentajes
						var listaDespachosUpdate = [];
						for(var i=0; i< r.idsRangos.length; i++){
							listaDespachosUpdate.push(r.idsRangos[i].idRango);
						}
						gestionarPanelEdicionRangos(false, 'EDIT', rangosGrid.getSelectionModel().getSelected(),listaDespachosUpdate);
					}
					,error: function(result, request){
						Ext.Msg.minWidth=360;
						Ext.Msg.alert("Error","Error");
					}
				});
			}
	});
	
		
	var btnNuevaConfiguracion = new Ext.Button({
			text : '<s:message code="plugin.procuradores.turnado.btn.nuevaConfiguracion" text="**Crear nueva configuraci&oacute;n" />'
			,iconCls : 'icon_mas'
			,handler : function(){
				btnNuevaConfiguracion.setDisabled(true);
				btnNuevaConfiguracion.setVisible(false);
				btnGuardarNuevaConfiguracion.setVisible(true);
				btnCancelarNuevaConfiguracion.setDisabled(false);
				btnCancelarNuevaConfiguracion.setVisible(true);
				gestionPanelSuperior(0);
			}
	});
	
	var btnGuardarNuevaConfiguracion = new Ext.Button({
			text : '<s:message code="plugin.procuradores.turnado.btn.guardarNuevaConfiguracion" text="**Guardar nueva configuración" />'
			,iconCls : 'icon_ok'
			,disabled: true
			,hidden: true
			,handler : function(){
				<%-- Pasar de las variables de nueva configuracion, a las totales y reiniciarlas --%>
				idsTuplasConfigDefinitivas=idsTuplasConfig;
				idsTuplasConfig=[];
				idsTuplasBorradas = idsTuplasBorradasConfig;
				idsTuplasBorradasConfig = [];
				idsRangosBorrados = idsRangosBorradosConfig;
				idsRangosBorradosConfig = [];
				nuevasPlazasConfig=[];
				<%-- Gestion botones--%>
				btnGuardarNuevaConfiguracion.setDisabled(true);
				btnGuardarNuevaConfiguracion.setVisible(false);
				btnCancelarNuevaConfiguracion.setDisabled(true);
				btnCancelarNuevaConfiguracion.setVisible(false);
				btnNuevaConfiguracion.setDisabled(false);
				btnNuevaConfiguracion.setVisible(true);
				btnGuardar.setDisabled(false);
				
				gestionPanelSuperior(1);
				plazasStore.webflow({ idEsquema : idEsquema });
				tposStore.removeAll();
				//Webflob para cargar el grid
				rangosStore.webflow({idEsquema : idEsquema, nuevaConfig : infoConfiguracionTurnado.isVisible()});
			}
	});
	
	var btnCancelarNuevaConfiguracion = new Ext.Button({
			text : '<s:message code="plugin.procuradores.turnado.btn.cancelarNuevaConfiguracion" text="**Cancelar nueva configuraci&oacute;n" />'
			,iconCls : 'icon_cancel'
			,disabled: true
			,hidden: true
			,handler : function(){
				<%-- Cancelar nueva configuracion (deshacer cambios) --%>
				Ext.Msg.minWidth=360;			
				Ext.Msg.confirm('<s:message code="plugin.procuradores.turnado.confirmarCancelacion" text="**Confirmacr cancelación" />', '<s:message code="plugin.procuradores.turnado.confirmarCancelacionMsg" text="**Estas seguro que desea cancelar los cambios?" />', this.evaluateAndSend);
			}
			,evaluateAndSend: function(seguir) {
				if(seguir){
					cancelarModificacion(1);
					//Gestion botones
					btnGuardarNuevaConfiguracion.setDisabled(true);
					btnGuardarNuevaConfiguracion.setVisible(false);
					btnCancelarNuevaConfiguracion.setDisabled(true);
					btnCancelarNuevaConfiguracion.setVisible(false);
					btnNuevaConfiguracion.setDisabled(false);
					btnNuevaConfiguracion.setVisible(true);
					gestionPanelSuperior(1);
				}
			}
	});
	
	<%-- Grid rangos --%>
	var rango = Ext.data.Record.create([
		 {name:'id'}
		 ,{name:'idPlazaTpo'}
		 ,{name:'plaza'}
		 ,{name:'plazaId'}
		 ,{name:'tipoProcedimiento'}
		 ,{name:'tipoProcedimientoId'}
		 ,{name:'rangoId'}
		 ,{name:'importeDesde'}
		 ,{name:'importeHasta'}
		 ,{name:'despacho'}
		 ,{name:'porcentaje'}
	]);				
	
	var rangosStore = page.getGroupingStore({
        flow: 'turnadoprocuradores/getRangosGrid'
        ,groupField:'plaza'
		,groupOnSort:'true'
        ,reader: new Ext.data.JsonReader({
	    	 root : 'rangosEsquema'
	     }, rango)
	})
	
	var rangosCm = new Ext.grid.ColumnModel([	    
		{header: 'Id', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="plugin.procuradores.turnado.grids.plaza" text="**Plaza"/>', dataIndex: 'plaza', width: 50, sortable: false}
		,{header: '<s:message code="plugin.procuradores.turnado.grids.tpo" text="**T. Procedimiento"/>', dataIndex: 'tipoProcedimiento', width: 50, sortable: false}
		,{header: '<s:message code="plugin.procuradores.turnado.impoMinimo" text="**Imp. minimo"/>', dataIndex: 'importeDesde', width: 20, sortable: false}
		,{header: '<s:message code="plugin.procuradores.turnado.impoMaximo" text="**Imp. maximo"/>', dataIndex: 'importeHasta', width: 20, sortable: false}
		,{header: '<s:message code="plugin.procuradores.turnado.despacho" text="**Despacho"/>', dataIndex: 'despacho', width: 50, sortable: false}
		,{header: '<s:message code="plugin.procuradores.turnado.grids.porcentaje" text="**%"/>', dataIndex: 'porcentaje', width: 15, sortable: false}
	]);
	
	var sm = new Ext.grid.RowSelectionModel({
		checkOnly : false
		,singleSelect: true
        ,listeners: {
            rowselect: function(p, rowIndex, r) {
            	if (!this.hasSelection()) {
            		return;
            	}
            	if(r.data.importeDesde!=null && r.data.importeDesde!=""){
					btnBorrarRango.setDisabled(false);
					if(!infoConfiguracionTurnado.isVisible()){
						btnEditarRango.setDisabled(false);
					}
				}
				else{
					btnBorrarRango.setDisabled(true);
					btnEditarRango.setDisabled(true);
				}
				btnNuevo.setDisabled(false);
            }
         }
	});
	
	var rangosGrid = new Ext.grid.EditorGridPanel({
		store: rangosStore
		,cm: rangosCm
		,title:'<s:message code="plugin.procuradores.turnado.listaRangos" text="**Lista rangos"/>'
		,stripeRows: true
		,height:300
		,resizable:false
		,titleCollapse : true
		//,collapsible : true
		//,collapsed : true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		//,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding-bottom:10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		//,clicksToEdit:0
		,selModel: sm
		,bbar : [btnNuevo,btnBorrarRango,btnEditarRango,btnNuevaConfiguracion,btnGuardarNuevaConfiguracion,btnCancelarNuevaConfiguracion]
		//,view: new Ext.grid.GroupingView({
			//forceFit:true
			//,hideGroupedColumn: true
			//,groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
		//})
		,doLayout:function() {
				var margin = 40;
				this.setWidth(650-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
	<%@ include file="panelEdicionRangos.jsp" %>
	var gridRangosPanel = app.creaPanelHz({style : "margin-top:4px;margin-bottom:4px;"},[rangosGrid,rangoImportesFieldSet]);
	
	var topPanel = new Ext.Panel({
		autoHeight:true
		,border:false
		,defaults : {xtype:'panel' ,cellCls : 'vtop'}
		,items:[nombreEsquemaPanel,infoConfiguracionTurnado,turnadoFiltrosFieldSet,gridRangosPanel]
	});	
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			<%-- Cancelar configuraciones realizada --%>
			Ext.Msg.minWidth=360;			
			Ext.Msg.confirm('<s:message code="plugin.procuradores.turnado.confirmarCancelacion" text="**Confirmar cancelación" />', '<s:message code="plugin.procuradores.turnado.confirmarCancelacionMsg" text="**Estas seguro que desea cancelar los cambios?" />', this.evaluateAndSend);
		}
		,evaluateAndSend: function(seguir) {
			if(seguir){
				cancelarModificacion(0);
			}	
		}
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,disabled: true
		,iconCls : 'icon_ok'
		,handler : function(){
			mainPanel.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
			if(!infoConfiguracionTurnado.isVisible()){
				//Cerrar ventana
				page.fireEvent(app.event.DONE);
			}
			else{
				Ext.Msg.minWidth=360;
				Ext.Msg.alert('Advertencia', '<s:message code="plugin.procuradores.turnado.errorConfiguracionEnCurso" text="**Por favor, guarde o cancele la nueva configuración en curso" />' );
			}
		}
		<app:test id="btnGuardarABM" addComa="true"/>
	});
	
	<%-- Funciones --%>
	function borrarRango(idConfig){
		mainPanel.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
		var params = {idConfig: idConfig};
		if(infoConfiguracionTurnado.isVisible()) params.idsplazasTpo = idsTuplasConfig;
		Ext.Ajax.request({
			url: '/pfs/turnadoprocuradores/borrarRangoConfigEsquema.htm'
			,params: params
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//Guardar ids de tuplas y rangos
				for(var i=0; i< r.idsRangos.length; i++){
					idsRangosBorrados.push(r.idsRangos[i].idRango);
				}
				//Webflob para cargar el grid
				rangosStore.webflow({idEsquema : idEsquema, nuevaConfig : infoConfiguracionTurnado.isVisible()});
				btnGuardar.setDisabled(false);
				if(infoConfiguracionTurnado.isVisible()) gestionarPanelNuevoTPO();
				mainPanel.container.unmask();
			}
			,error: function(result, request){
				Ext.Msg.minWidth=360;
				Ext.Msg.alert("Error","Error borrando");
				mainPanel.container.unmask();
			}
		});
	}
	
	function cancelarModificacion(flag){
		mainPanel.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
		var params = {};
		<%-- Si se trata de cancelacion de una nueva configuracion --%>
		if(flag==1){
			params.idsTuplasConfig = idsTuplasConfig;
			params.idsTuplasBorradasConfig = idsTuplasBorradasConfig;
			params.idsRangosBorradosConfig = idsRangosBorradosConfig;
		}
		else{
			<%-- Si se trata de cancelacion de toda la sesion --%>
			if(infoConfiguracionTurnado.isVisible()){
				params.idsTuplasConfig = idsTuplasConfig;
				params.idsTuplasBorradasConfig = idsTuplasBorradasConfig;
				params.idsRangosBorradosConfig = idsRangosBorradosConfig;	
			}
			params.idsTuplasBorradas = idsTuplasBorradas;
			params.idsRangosBorrados = idsRangosBorrados;
			params.idsRangosCreados = idsRangosCreados; 
			params.modificacionesRangos = modificacionesRangos;
			params.idsTuplasConfigDefinitivas = idsTuplasConfigDefinitivas;
		}
		Ext.Ajax.request({
			url: '/pfs/turnadoprocuradores/cancelarEdicionEsquema.htm'
			,params: params
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				//Resetear las variables que sean necesario
				if(flag==1){
					idsTuplasConfig = [];
					idsTuplasBorradasConfig = [];
					idsRangosBorradosConfig = [];
				}
				else{
					idsTuplasConfig = [];
					idsTuplasBorradasConfig = [];
					idsRangosBorradosConfig = [];
					idsTuplasBorradas = [];
					idsTuplasBorradas = [];
					idsRangosCreados = [];
					modificacionesRangos = [];
					idsTuplasConfigDefinitivas = [];
				}
				nuevasPlazasConfig=[];
				//Webflob para cargar el grid
				rangosStore.webflow({idEsquema : idEsquema, nuevaConfig : infoConfiguracionTurnado.isVisible()});
				//Cerrar ventana si se trata de cancelacion de la sesion
				if(flag!=1){
					page.fireEvent(app.event.CANCEL);
				}
				mainPanel.container.unmask();
			}
			,error: function(result, request){
				Ext.Msg.minWidth=360;
				Ext.Msg.alert("Error","Error cancelando");
				mainPanel.container.unmask();
			}
		});
	}
	
	var mainPanel = new Ext.FormPanel({
		autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,bbar: [btnGuardar,btnCancelar]
		,items:[{layout:'form', items: [topPanel]}
		]
	});	
	
	page.add(mainPanel);
	
	rangosStore.webflow({idEsquema : idEsquema, nuevaConfig : infoConfiguracionTurnado.isVisible()});
	
</fwk:page>