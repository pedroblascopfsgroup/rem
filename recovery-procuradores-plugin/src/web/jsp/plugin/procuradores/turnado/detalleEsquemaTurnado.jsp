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
	debugger;
	<c:if test="${idEsquema==null}" >
	var idEsquema = null;	
	</c:if>
	<c:if test="${idEsquema!=null}" >
	var idEsquema = ${idEsquema};
	</c:if>

	<pfsforms:textfield
		labelKey="plugin.procuradores.turnado.tipoProcedimiento**"
		label="**Nombre del esquema"
		name="nombreEsquema"
		value="${nombreEsquema}"
		readOnly="false" />
	
	var nombreEsquemaPanel = new Ext.form.FieldSet({
		title : '<s:message code="plugin.procuradores.turnado.tipoProcedimiento**" text="**Información esquema" />'
		,layout:'table'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,collapsible : true
		,collapsed : false
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:200 }
		,items : [nombreEsquema]
		,doLayout:function() {
				var margin = 40;
				this.setWidth(900-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
	<%@ include file="panelFiltrosPlazaTPO.jsp" %>
	<%@ include file="panelNuevaConfiguracion.jsp" %>
	
	var gestionPanelSuperior = function(){
		infoConfiguracionTurnado.setVisible(!infoConfiguracionTurnado.isVisible());
		turnadoFiltrosFieldSet.setVisible(!turnadoFiltrosFieldSet.isVisible());
		
		if(infoConfiguracionTurnado.isVisible()){
			if(rangosGrid.getSelectionModel().hasSelection()) rangosGrid.getSelectionModel().clearSelections();
			rangosStore.removeAll();
		}
	};
	
	<%-- Botones grids --%>
	var btnNuevo = new Ext.Button({
			text : '<s:message code="app.nuevo" text="**Nuevo" />'
			,iconCls : 'icon_mas'
			,handler : function(){
				btnNuevo.setDisabled(true);
				gestionarPanelEdicionRangos(false, 'NEW', rangosGrid.getSelectionModel().getSelected());
			}
	});
	
	var btnBorrarRango = new Ext.Button({
			text : '<s:message code="app.borrar" text="**Borrar" />'
			,iconCls : 'icon_menos'
			,disabled: true
			,handler : function(){			
					Ext.Msg.confirm('<s:message code="plugin.procuradores.turnado.confirmarBorrarPlaza**" text="**Borrar rango" />', '<s:message code="plugin.procuradores.turnado.mensajeConfirmarBorrarPlaza**" text="**Estas seguro que desa borrar el rango seleccionado?" />', this.evaluateAndSend);
			}
			,evaluateAndSend: function(seguir) {      			
	         			if(seguir== 'yes') {
	         				//TODO BORRAR REGLA
						}
	    	} 
	});
	var btnEditarRango = new Ext.Button({
			text : '<s:message code="app.editar" text="**Modificar" />'
			,iconCls : 'icon_edit'
			,disabled: true
			,handler : function(){
				btnEditarRango.setDisabled(true);
				gestionarPanelEdicionRangos(false, 'EDIT', rangosGrid.getSelectionModel().getSelected());
			}
	});
	
		
	var btnNuevaConfiguracion = new Ext.Button({
			text : '<s:message code="app.nuevo**" text="**Crear nueva configuración" />'
			,iconCls : 'icon_mas'
			,handler : function(){
				btnNuevaConfiguracion.setDisabled(true);
				btnNuevaConfiguracion.setVisible(false);
				btnGuardarNuevaConfiguracion.setDisabled(false);
				btnGuardarNuevaConfiguracion.setVisible(true);
				btnCancelarNuevaConfiguracion.setDisabled(false);
				btnCancelarNuevaConfiguracion.setVisible(true);
				gestionPanelSuperior();
			}
	});
	
	var btnGuardarNuevaConfiguracion = new Ext.Button({
			text : '<s:message code="app.nuevo**" text="**Guardar nueva configuración" />'
			,iconCls : 'icon_ok'
			,disabled: true
			,hidden: true
			,handler : function(){
				<%-- Reset de las variable auxilaries que permiten la cancelacion de nuevas configuraciones --%>
				nuevasPlazasConfig = [];
				idsTuplasConfig = [];
				<%-- Guardar nueva configuracion (aplicar cambios) --%>
				btnGuardarNuevaConfiguracion.setDisabled(true);
				btnGuardarNuevaConfiguracion.setVisible(false);
				btnCancelarNuevaConfiguracion.setDisabled(true);
				btnCancelarNuevaConfiguracion.setVisible(false);
				btnNuevaConfiguracion.setDisabled(false);
				btnNuevaConfiguracion.setVisible(true);
				gestionPanelSuperior();
			}
	});
	
	var btnCancelarNuevaConfiguracion = new Ext.Button({
			text : '<s:message code="app.nuevo**" text="**Cancelar nueva configuración" />'
			,iconCls : 'icon_cancel'
			,disabled: true
			,hidden: true
			,handler : function(){
				<%-- Cancelar  modificaciones realizadas --%>
				//TODO
				<%-- Reset de las variable auxilaries que permiten la cancelacion de nuevas configuraciones --%>	
				nuevasPlazasConfig = [];
				idsTuplasConfig = [];
				<%-- Cancelar nueva configuracion (deshacer cambios) --%>
				btnGuardarNuevaConfiguracion.setDisabled(true);
				btnGuardarNuevaConfiguracion.setVisible(false);
				btnCancelarNuevaConfiguracion.setDisabled(true);
				btnCancelarNuevaConfiguracion.setVisible(false);
				btnNuevaConfiguracion.setDisabled(false);
				btnNuevaConfiguracion.setVisible(true);
				gestionPanelSuperior();
			}
	});
	
	<%-- Grid rangos --%>
	var rango = Ext.data.Record.create([
		 {name:'id'}
		 ,{name:'plaza'}
		 ,{name:'tipoProcedimiento'}
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
		,{header: 'plaza', dataIndex: 'plaza',hidden: true, sortable: false}
		,{header: '<s:message code="plugin.config.rangoturnado.buscador.grid.descripcion" text="**T. Procedimiento"/>', dataIndex: 'tipoProcedimiento', sortable: false}
		,{header: '<s:message code="plugin.config.rangoturnado.buscador.grid.estado_cod" text="**Imp. minimo"/>', dataIndex: 'importeDesde', sortable: false}
		,{header: '<s:message code="plugin.config.rangoturnado.buscador.grid.estado_des" text="**Imp. maximo"/>', dataIndex: 'importeHasta', sortable: false}
		,{header: '<s:message code="plugin.config.rangoturnado.buscador.grid.fechaSolicitud" text="**Despacho"/>', dataIndex: 'despacho', sortable: false}
		,{header: '<s:message code="plugin.config.rangoturnado.buscador.grid.usuario" text="**Porcentaje"/>', dataIndex: 'porcentaje', sortable: false}
	]);
	
	var sm = new Ext.grid.RowSelectionModel({
		checkOnly : false
		,singleSelect: true
        ,listeners: {
            rowselect: function(p, rowIndex, r) {
            	gestionarPanelEdicionRangos(true);
            	if (!this.hasSelection()) {
            		gestionarPanelEdicionRangos(true, '', '');
            		btnBorrarRango.setDisabled(true);
				btnEditarRango.setDisabled(true);
            		return;
            	}
            	var borrable = r.data.borrable;
            	var activable = r.data.activable;
				btnBorrarRango.setDisabled(false);
				btnEditarRango.setDisabled(false);
            }
         }
	});
	
	var rangosGrid = new Ext.grid.EditorGridPanel({
		store: rangosStore
		,cm: rangosCm
		,title:'<s:message code="" text="**Lista rangos"/>'
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
		,view: new Ext.grid.GroupingView({
			forceFit:true
			,hideGroupedColumn: true
			,groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
		})
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
		,handler : function(){page.fireEvent(app.event.CANCEL);}
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			<%--Ext.Ajax.request({
				url: page.resolveUrl(''),
				params: {
					id:''									
				},
				method: 'POST',
				success: function ( result, request ) {
					page.fireEvent(app.event.DONE);
				}
			});
			 --%>				
		}
		<app:test id="btnGuardarABM" addComa="true"/>
	});
	
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
	
	rangosStore.webflow({idEsquema : idEsquema,  idPlaza : '', idTPO : ''});
	
</fwk:page>