<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	Ext.util.CSS.createStyleSheet(".icon_instruccion { background-image: url('../img/plugin/instruccionesExterna/pencil.png');}");
	  
	<pfsforms:ddCombo name="filtroProcedimiento"
		labelKey="plugin.instruccionesExterna.busqueda.procedimiento"
		label="**Tipo de procedimiento" value="" dd="${tiposProcedimiento}" 
		 />
		 

	<%--<pfsforms:ddCombo name="filtroTareaProcedimiento"
		labelKey="plugin.instruccionesExterna.busqueda.tareas"
		label="**Tareas" value="" dd="${tareas}" 
		 />	
		 --%>
		  
	
	var TipoTar = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsTareasStore = page.getStore({
	       flow: 'instruccionesexterna/getListaTiposTarea'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoTareas'
	    }, TipoTar)	       
	});		
	
	var filtroTareaProcedimiento = new Ext.form.ComboBox({
		store:optionsTareasStore
		,displayField:'descripcion'
		,valueField:'id'
		,name:'causa'
		,mode: 'local'
		,editable:false
		,triggerAction: 'all'
		,fieldLabel : '<s:message code="plugin.instruccionesExterna.busqueda.tareas" text="**Tareas" />'
	});
	
	
	filtroProcedimiento.on('select', function(){
		Ext.Ajax.request({
			url: page.resolveUrl('instruccionesexterna/getListaTiposTarea')
			,params: {idProcedimiento:filtroProcedimiento.getValue()}
			,method: 'POST'
			,success: function (result, request){
				optionsTareasStore.webflow({'idProcedimiento': filtroProcedimiento.getValue()}); 
			}
			,error: function(result, request){
			}
			,failure: function(result, request){
			}
		}); 
		
		filtroTareaProcedimiento.reset();
	});
				
	<pfs:defineRecordType name="InstruccionesTareasRT">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="tipoProcedimiento" />
			<pfs:defineTextColumn name="tareaProcedimiento" />
			<pfs:defineTextColumn name="label" />		
	</pfs:defineRecordType>
			
	<pfs:defineColumnModel name="instruccionesTareasCM">
		<pfs:defineHeader dataIndex="tipoProcedimiento"
			captionKey="plugin.instruccionesExterna.busqueda.tipoProcedimiento" caption="**Tipo de Procedimiento"
			sortable="true" firstHeader="true" />
		<pfs:defineHeader dataIndex="tareaProcedimiento"
			captionKey="plugin.instruccionesExterna.busqueda.tipoTarea" caption="**Tipo de Tarea"
			sortable="true" />
		
	</pfs:defineColumnModel>
	
	
	
	<pfs:defineParameters name="getParametros" paramId="" 
		tipoProcedimiento="filtroProcedimiento"
		tareaProcedimiento="filtroTareaProcedimiento"
		 />
	
	
	<pfs:button caption="**Editar Instrucción" name="btEditar" captioneKey="plugin.instruccionesExterna.listado.editar" iconCls="icon_edit" >
		if (instruccionesGrid.getSelectionModel().getCount()>0){
			var id = instruccionesGrid.getSelectionModel().getSelected().get('id');

			var parametros = {
				id : id
				,getParametros : getParametros
			};
    		var w= app.openWindow({
                 flow: 'plugin.instruccionesExterna.editarInstrucciones'
                ,closable: true                  
                ,width : 700
                ,title : '<s:message code="plugin.instruccionesExterna.busqueda.modificar" text="**Modificar" />'
                ,params: parametros
           });
      	 	w.on(app.event.DONE, function(){
				w.close();
				//plazosGrid.store.webflow(parametros);
				//recargar() ;
							
			});
			w.on(app.event.CANCEL, function(){
				 w.close(); 
			});						
		}else{
			Ext.Msg.alert('<s:message code="plugin.instruccionesExterna.listado.editar" text="**Editar Plazo" />','<s:message code="plugin.instruccionesExterna.listado.novalor" text="**Debe seleccionar un valor de la lista" />');
		}
		
	</pfs:button> 
	 
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />; 		
	<pfs:searchPage searchPanelTitle="**Búsqueda de Instrucciones de Tareas"  searchPanelTitleKey="plugin.instruccionesExterna.busqueda.panel.title" 
			columnModel="instruccionesTareasCM" columns="2"
			gridPanelTitleKey="plugin.instruccionesExterna.configuracion.menu" gridPanelTitle="**Instrucciones de Tareas Externas" 
			createTitleKey="plugin.instruccionesExterna.busqueda.grid.nuevo" createTitle="**Nueva instruccion de Tarea" 
			createFlow="plugin.instruccionesExterna.altaInstruccionTarea" 
			updateFlow="plugin.instruccionesExterna.consultarInstruccionTarea" 
			updateTitleData="tareaProcedimiento"
			dataFlow="plugin.instruccionesExterna.buscaInstruccionesData"
			resultRootVar="instrucciones" resultTotalVar="total"
			recordType="InstruccionesTareasRT" 
			parameters="getParametros" 
			newTabOnUpdate="true"
			gridName="instruccionesGrid"
			buttonDelete="btEditar" 
			iconCls="icon_instruccion">
			<pfs:items
			items="filtroProcedimiento"
			/> 
			<pfs:items
			items="filtroTareaProcedimiento"
			/>			
	</pfs:searchPage>

	btnNuevo.hide();
	
	btEditar.hide();
	
	<sec:authorize ifAllGranted="ROLE_EDITINSTRUCCIONESEXT">
		btEditar.show();
	</sec:authorize>
	
	filtroForm.getTopToolbar().add(buttonsL,'->', buttonsR);
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());

</fwk:page>


