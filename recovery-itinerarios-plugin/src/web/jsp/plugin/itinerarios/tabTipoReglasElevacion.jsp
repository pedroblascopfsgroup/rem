<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


<%-- Datos JSON, determinan estados a mostrar del itinerario --%>
var estadosItinerario = <json:array name="estadosItinerario" items="${formEstadosItinerarios}" var="et" >
	<json:object>
		<json:property name="id" value="${et.id}" />
		<json:property name="estadoItinerario" value="${et.estadoItinerario.descripcion}" />
		<json:property name="codigo" value="${et.estadoItinerario.codigo}" />
		<json:property name="automatico" value="${et.automatico}" />
	</json:object>
</json:array>;

<%-- Constantes --%>
var estadoCE = '<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_COMPLETAR_EXPEDIENTE" />';
var estadoRE = '<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica.ESTADO_REVISAR_EXPEDIENTE" />';
var strSplitterChar = '_';
var textFieldName = 'txt';
var btnName = 'btn';
var storeName = 'reglaElevacionDS';
var gridName = 'gridReglas';
var btnAutoName = 'btnAuto';
var btnDeleteName = 'btnDelete';

<%-- Variables varias --%>
var panels = "";
var panelsToDisplay = estadosItinerario.length;
var fieldSets = new Array();
var stores = new Array();
var refrescoCompletarActivar = ${ceSiNo};
var refrescoRevisarActivar = ${reSiNo};
var recargar = function (){
	app.openTab('${itinerario.nombre}'
				,'plugin.itinerarios.consultaItinerario'
				,{id:${itinerario.id}}
				,{id:'ItinerarioRT${itinerario.id}'}
			)
};		
	
<%-- Montar cadena de paneles a utilizar de forma dinamica --%>
for (i = 0; i < panelsToDisplay; i++) {
    panels += "panel" + estadosItinerario[i].codigo;
    if(i < panelsToDisplay -1){
    	panels += ",";
    }
}

<%-- Bucle crear elementos cuerpo --%>
for(i = 0; i < panelsToDisplay; i++){
	
	<%-- Variable Hidden --%>
	var idEstadoVal = new Ext.form.Hidden({
			value: estadosItinerario[i].id
		});
	
	<%-- Variable con ID de itinerario e ID de estado --%>
	var itinerarioParams = function(){
			return {
					idEstado : idEstadoVal.getValue()
	      			,id:${itinerario.id}
	      			}
	};

	<%-- Columnas del datasource --%>
	<pfs:defineRecordType name="ReglasElevacionRT">
		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="ddTipoReglasElevacion"/>
		<pfs:defineTextColumn name="ambitoExpediente"/>
	</pfs:defineRecordType>
	
	<%-- Columnas de la tabla --%>
	<pfs:defineColumnModel name="reglasElevacionCM">
		<pfs:defineHeader captionKey="plugin.itinerarios.reglasElevacion.tipoRegla" sortable="false" 
			dataIndex="ddTipoReglasElevacion" caption="**Tipo de Regla" firstHeader="true"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.reglasElevacion.ambitoExpediente" sortable="false" 
			dataIndex="ambitoExpediente" caption="**Ámbito del Expediente" />
	</pfs:defineColumnModel>
	
	<%-- Data Store (Datos del grid) --%>
	stores[storeName+strSplitterChar+estadosItinerario[i].codigo]= page.getStore({
																	remoteSort : true
																	,flow: 'plugin.itinerarios.tipoReglasElevacionData'
																	,reader: new Ext.data.JsonReader({
																    	root : 'reglasElevacion'
																    }, ReglasElevacionRT)
																});
								
	stores[storeName+strSplitterChar+estadosItinerario[i].codigo].webflow(itinerarioParams());										

	<%-- Generar botones añadir y borrar --%>
	var botones = new Array();

	botones.push( new Ext.Button({
			text : '<s:message code="pfs.tags.buttonadd.agregar" text="**Agregar" />'
			,iconCls : 'icon_mas'
			,id: btnName+'Add'+strSplitterChar+i.toString()
			,handler: function(thisButton, eventObject) {
					var nameSplitted = thisButton.getId().split(strSplitterChar);
					var w= app.openWindow({
							flow: 'plugin.itinerarios.nuevaReglaElevacion'
							,closable: false
							,width : 700
							,title : '<s:message code="plugin.itinerarios.reglasElevacion.nuevaCE" text="**Añadir regla de elevación" />'
							,params: {
								id:${itinerario.id}
		    				 			,estadoItinerario : estadosItinerario[nameSplitted[1]].codigo
		    						}
						});
						w.on(app.event.DONE, function(){
							w.close();
							var tmpStoreName = storeName+strSplitterChar+estadosItinerario[nameSplitted[1]].codigo;									
							stores[tmpStoreName].webflow({
		    				 			idEstado : estadosItinerario[nameSplitted[1]].id
		    				 			,id:${itinerario.id}
		    						});	
						});
						w.on(app.event.CANCEL, function(){
							 w.close(); 
						});
			}
	}));
	
	botones.push( new Ext.Button({
			text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
			,id: btnName+btnDeleteName+strSplitterChar+i.toString()
			,iconCls : 'icon_menos'
			,handler : function(thisButton, eventObject){
			var nameSplitted = thisButton.getId().split(strSplitterChar);
			var tmpGridName = gridName+strSplitterChar+nameSplitted[1];
			if (Ext.ComponentMgr.get(tmpGridName).getSelectionModel().getCount()>0){
				Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == 'yes'){
    					var parms = {
	      				 			id: ${itinerario.id}
	      				 			,idEstado: estadosItinerario[nameSplitted[1]].id
	      						};
    					parms.idRegla = Ext.ComponentMgr.get(tmpGridName).getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'plugin.itinerarios.bajaReglaElevacionEstado'
							,params: parms
							,success : function(){ 
								Ext.ComponentMgr.get(tmpGridName).store.webflow(parms);
								<c:if test="${onSuccess != null}">${onSuccess}();</c:if>
							}
						});
	    			}
				});
			}else{
					Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="plugin.itinerarios.reglasElevacion.message.novalue" text="**Seleccione una función de la lista" />');
			}
			}
		}));
	
	
	<%-- Tabla de reglas de la seccion --%>
		var elementos = new Array();
		var titleGrid = "<s:message code="plugin.itinerarios.tipoReglasElevacion.reglasGenerico" text="**Reglas de Elevación del Estado" />";
		titleGrid += " " + estadosItinerario[i].estadoItinerario;
		var grid_cfg={
		title : titleGrid
		,id : gridName+strSplitterChar+i.toString()
		,collapsible : false
		,collapsed: false
		,titleCollapse : false
		,stripeRows:true
		,bbar : botones
		,height:200
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,margin: app.contenido.getSize(true).width-1050
		,iconCls:'icon_elevacion'
		};
		
		var grid = app.crearGrid(stores[storeName+strSplitterChar+estadosItinerario[i].codigo],reglasElevacionCM,grid_cfg);

		
		<%-- Comprobar si es seccion CE o RE para añadir opcion de automatico al FieldSet --%>
		if(estadosItinerario[i].codigo == estadoCE || estadosItinerario[i].codigo == estadoRE){
		
			<%-- Etiqueta de texto automatizar --%>
			var titleTextField = estadosItinerario[i].codigo+"Automatico";
			var textField = new Ext.ux.form.StaticTextField({
				id : textFieldName+strSplitterChar+estadosItinerario[i].id
				,fieldLabel : '<s:message code='plugin.itinerarios.estados.automatico' text='**Automático' />'
				,value : ''
				,name : titleTextField
				,labelStyle:'font-weight:bolder'
			});
			if (estadosItinerario[i].automatico) {
				textField.setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.activado" text="**Activado" />');
			} else {
				textField.setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivado" text="**Desactivado" />');
			}
			
			
			<%-- Boton automatizar --%>
			var botonAuto = new Ext.Button({
			text : ''
			,id: btnAutoName+strSplitterChar+estadosItinerario[i].id+strSplitterChar+i.toString()
			,handler : function(thisButton, eventObject) {
						var nameSplitted = thisButton.getId().split(strSplitterChar);
						page.webflow({
							flow: 'plugin/itinerarios/plugin.itinerarios.marcaAutomatico'
							,params:{
										idEstado : nameSplitted[1]
		     						}
						});
						if(estadosItinerario[nameSplitted[2]].codigo == estadoCE){
							if (!refrescoCompletarActivar) {
								Ext.ComponentMgr.get(textFieldName+strSplitterChar+nameSplitted[1]).setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.activado" text="**Activado" />');
								thisButton.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivar" text="**Desactivar" />');
								refrescoCompletarActivar = true;
							 } else {
								Ext.ComponentMgr.get(textFieldName+strSplitterChar+nameSplitted[1]).setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivado" text="**Desactivado" />');
								thisButton.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.activar" text="**Activar" />');
								refrescoCompletarActivar = false;
							}
						}else if(estadosItinerario[nameSplitted[2]].codigo == estadoRE){
							if (!refrescoRevisarActivar) {
								Ext.ComponentMgr.get(textFieldName+strSplitterChar+nameSplitted[1]).setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.activado" text="**Activado" />');
								thisButton.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivar" text="**Desactivar" />');
								refrescoRevisarActivar = true;
							 } else {
								Ext.ComponentMgr.get(textFieldName+strSplitterChar+nameSplitted[1]).setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivado" text="**Desactivado" />');
								thisButton.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.activar" text="**Activar" />');
								refrescoRevisarActivar = false;
							}
						}
					  }
			});
			if (estadosItinerario[i].automatico){
				botonAuto.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivar" text="**Desactivar" />');
			}else{
				botonAuto.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.activar" text="**Activar" />');
			}
			
			elementos.push(textField);
			elementos.push(botonAuto);
		
		}
		
		elementos.push(grid);
			
		<%-- Estados de los itinerarios(FieldSets). Mostrar elementos que lo componen --%>
		var titleFieldset = "<s:message code="plugin.itinerarios.reglasElevacion.estadoGenerico" text="**"/>";
		titleFieldset += " " + estadosItinerario[i].estadoItinerario.toUpperCase();
		fieldSets.push(new Ext.form.FieldSet({
			title: titleFieldset
			,autoHeight:true
			//,border:true
			//,bodyStyle:'padding:5px;cellspacing:10px;'
			,width : 1000
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:true}
			,items : elementos
		}));
	
}

<%-- Cuerpo entero de la Pestaña (tabpage), rellenar con los fieldSets --%>
var create_#PARENTNAME#_Tab=function(){
	var panel = new Ext.Panel({
		title:'<s:message code="plugin.itinerarios.reglasElevacion.titulo" text="**Reglas de elevacion"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,items:[fieldSets]
	});
	return panel;
}
