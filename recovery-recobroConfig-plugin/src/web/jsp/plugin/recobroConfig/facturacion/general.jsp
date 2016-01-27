<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	<pfs:hidden name="ESTADO_DEFINICION" value="${ESTADO_DEFINICION}"/>
	<pfs:hidden name="ESTADO_BLOQUEADO" value="${ESTADO_BLOQUEADO}"/>
	<pfs:hidden name="ESTADO_DISPONIBLE" value="${ESTADO_DISPONIBLE}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>
	
	<pfs:textfield name="nombre" labelKey="plugin.recobroConfig.modeloFacturacion.nombre"
		label="**Nombre" value="${modelo.nombre}" readOnly="true" />

	<pfs:textfield name="descripcion" labelKey="plugin.recobroConfig.modeloFacturacion.descripcion"
		label="**Descripcion" value="${modelo.descripcion}"  readOnly="true" />
		
	<pfsforms:textfield name="estado" labelKey="plugin.recobroConfig.itinerario.columna.estado" 
		label="**Estado" value="${modelo.estado.descripcion}" readOnly="true" />	
		
	<pfsforms:textfield name="propietario" labelKey="plugin.recobroConfig.itinerario.columna.propietario" 
		label="**Propietario" value="${modelo.propietario.username}" readOnly="true" />		
		
	
	<pfs:defineParameters name="parametros" paramId="${modelo.id}" />
	

	var recargar = function (){
		app.openTab('${modelo.nombre}'
					,'recobromodelofacturacion/openLauncher'
					,{idModFact:${modelo.id}}
					,{id:'modeloFacturacion'+${modelo.id} ,iconCls : 'icon_facturacion'}
				)
	};
	
	<pfs:buttonedit flow="recobromodelofacturacion/editaModeloFacturacion" name="btEditar" 
		windowTitleKey="plugin.modeloFacturacion.consulta.modificar" parameters="parametros" windowTitle="**Modificar"
		on_success="recargar"/>
		
	var btLiberar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloRanking.liberar" text="**Liberar" />'
		,iconCls : 'icon_play'
		,disabled : true
		,handler : function(){
    			var parms = {};
    			parms.idModFact = ${modelo.id};
    			page.webflow({
					flow: 'recobromodelofacturacion/liberarModeloFacturacion'
					,params: parms
					,success : function(){ 
						recargar();
					}
				});
		}
	});		
	
	<%-- 
	<pfs:panel name="panel1" columns="2" collapsible="true" bbar="btEditar" tbar="" 
		titleKey="plugin.modeloFacturacion.consulta.datosGenerales" title="**Datos generales">
		<pfs:items items="nombre"  />
		<pfs:items items="descripcion" />
	</pfs:panel>
	--%>
	
	var panel1 = new Ext.form.FieldSet({
		style:'padding:0px'
 		,border:true
		,layout : 'table'
		,layoutConfig:{
			columns:2
		}
		,autoWidth:true
		,title:'<s:message code="plugin.modeloFacturacion.consulta.datosGenerales" text="**Datos generales"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:350}
		,items :[{items:[estado, nombre]} ,{items : [propietario, descripcion]} ]
	});

	<pfs:defineRecordType name="TramosRT">
		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="nombre"/>
		<pfs:defineTextColumn name="idModFact"/>
	</pfs:defineRecordType>
	
	<pfs:remoteStore name="tramosDS"
			dataFlow="recobromodelofacturacion/getTramosModeloFacturacion"
			resultRootVar="tramos" 
			recordType="TramosRT" 
			autoload="true"
			parameters="parametros"
			/>

	<pfs:defineColumnModel name="tramosCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.tramosFacturacion.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
			<pfs:defineHeader dataIndex="idModFact"
			captionKey="plugin.recobroConfig.tramosFacturacion.idModFact" caption="**idModFact"
			sortable="true" hidden="true"/>
			<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.tramosFacturacion.nombre" caption="**Nombre"
			sortable="true" />
	</pfs:defineColumnModel>
	
	var btnAdd = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.tramoFacturacion.nuevo" text="**Añadir tramo" />'
		<app:test id="btnAdd" addComa="true" />
		,iconCls : 'icon_mas'
		,disabled : false
		,handler :  function(){
		    	var w= app.openWindow({
								flow: 'recobromodelofacturacion/addTramoFacturacion'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.tramoFacturacion.nuevo" text="Añadir tramo" />'
								,params: {idModFact:${modelo.id}}
							});
							w.on(app.event.DONE, function(){
								w.close();
								gridTramos.store.webflow({id:${modelo.id}});
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});				
		}
	});	
	
	var btnBorrar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,handler : function(){
			if (gridTramos.getSelectionModel().getCount()>0){
				Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == 'yes'){
    					var parms = {}
    					parms.id = gridTramos.getSelectionModel().getSelected().get('id');
    					parms.idModFact = gridTramos.getSelectionModel().getSelected().get('idModFact');
    					page.webflow({
							flow: 'recobromodelofacturacion/borrarTramoFacturacion'
							,params: parms
							,success : function(){ 
								gridTramos.store.webflow({id:gridTramos.getSelectionModel().getSelected().get('idModFact')}); 
							}
						});
    				}
				});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="${novalueMsgKey}" text="${novalueMsg}" />');
			}
		}
	});	
		 
	var gridTramos = new Ext.grid.GridPanel({
        store: tramosDS
        ,cm: tramosCM
        ,title: '<s:message code="plugin.recobroConfig.tramosFacturacion.titulo" text="**Tramos definidos"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding-top: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar:[btnAdd, btnBorrar]
    });	
    
    if ( '${modelo.estado.codigo}'==ESTADO_DEFINICION.getValue() && '${modelo.propietario.id}' == usuarioLogado.getValue()){
		btLiberar.setDisabled(false);
	} else {
		btLiberar.setDisabled(true);
	}

	 btnAdd.setDisabled(true);
     btnBorrar.setDisabled(true);
     btEditar.setDisabled(true);

     <sec:authorize ifAllGranted="ROLE_CONF_PROC_FACTURACION">
		btnAdd.setDisabled(false);
		btnBorrar.setDisabled(false);
		btEditar.setDisabled(false);
    </sec:authorize>

    if ('${modelo.estado.codigo}'==ESTADO_BLOQUEADO.getValue()){
        btnAdd.setDisabled(true);
        btnBorrar.setDisabled(true);
        btEditar.setDisabled(true);
    } 	
	
	var panel2 = new Ext.form.FieldSet({
		style:'padding:0px'
 		,border:false
		,layout : 'table'
		,layoutConfig:{
			columns:2
		}
		,autoWidth:true
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:100,style:'padding:0 0 0 0'}
		,items :[{items:[btEditar]} ,{items : [btLiberar]} ]
	}); 
	
    var compuesto = new Ext.Panel({
		height:700
		,autoWidth:true
		,bodyStyle:'padding: 10px'
		,items:[panel1
				,panel2
				,gridTramos
			]
	});
    
	page.add(compuesto);
	
	
</fwk:page>