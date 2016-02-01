<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>

<fwk:page>

	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
	
	<pfsforms:textfield name="filtroNombre"
			labelKey="plugin.arquetipos.listado.nombre" label="**Nombre"
			value="" searchOnEnter="true" />
			
	<pfsforms:ddCombo name="filtroRule"
		labelKey="plugin.arquetipos.listado.rule"
		label="**Paquete" value="" dd="${paquetes}" propertyDescripcion="name" propertyCodigo="id"/>
		
	<pfsforms:ddCombo name="filtroModelo"
		labelKey="plugin.arquetipos.listado.modelo"
		label="**Modelo" value="" dd="${modelos}" propertyDescripcion="nombre" propertyCodigo="id"/>	
	
	<pfsforms:ddCombo name="filtroEstado"
		labelKey="plugin.arquetipos.listado.estado"
		label="**Estado" value="" dd="${ddEstadoModelo}" />
	
	
			
	<pfs:defineRecordType name="ArquetipoRT">
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="rule" />
			<pfs:defineTextColumn name="gestion" />
			<pfs:defineTextColumn name="plazoDisparo" />  
			<pfs:defineTextColumn name="tipoSaltoNivel" />  
	</pfs:defineRecordType>
			
	<pfs:defineColumnModel name="arquetiposCM">
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.arquetipos.listado.nombre" caption="**Nombre"
			sortable="true" firstHeader="true" />
		<pfs:defineHeader dataIndex="rule"
			captionKey="plugin.arquetipos.listado.rule" caption="**Paquetes"
			sortable="true" />	
		<pfs:defineHeader dataIndex="gestion"
			captionKey="plugin.arquetipos.listado.gestion" caption="**Gestión"
			sortable="true" />
		<pfs:defineHeader dataIndex="plazoDisparo"
			captionKey="plugin.arquetipos.listado.plazoDisparo" caption="**Plazo de Disparo"
			sortable="true" />
		<pfs:defineHeader dataIndex="tipoSaltoNivel"
			captionKey="plugin.arquetipos.listado.tipoSaltoNivel" caption="**Tipo Salto Nivel"
			sortable="true" />
	</pfs:defineColumnModel>
	
	
	<pfs:defineParameters name="getParametros" paramId="" 
		nombre="filtroNombre" rule="filtroRule"  
		modelo="filtroModelo" estado="filtroEstado" />
	
	<pfs:buttonremove name="btBorrar" 
		novalueMsg="**Debe seleccionar un valor de la tabla" 
		flow="arquetipos/ARQeliminarArquetipo" 
		paramId="idArquetipo"  
		datagrid="arquetiposGrid" 
		novalueMsgKey="plugin.arquetipos.noValor"
		parameters="getParametros"/>
	
	var getParametros_validarForm=function(){
		return true;
	};
	
	<pfs:button caption="**Editar Arquetipo" name="btEditar" captioneKey="plugin.arquetipos.listado.editar" iconCls="icon_edit" >
		if (arquetiposGrid.getSelectionModel().getCount()>0){
    		var idArquetipo = arquetiposGrid.getSelectionModel().getSelected().get('id');
    		var parametros = {
							idArquetipo : idArquetipo
				};
    		var w= app.openWindow({
                                         flow: 'arquetipos/ARQeditarArquetipo'
                                         ,closable: true
                                         ,width : 700
                                         ,title : '<s:message code="plugin.arquetipos.busqueda.modificar" text="**Modificar" />'
                                         ,params: parametros
                        });
           	 		w.on(app.event.DONE, function(){
								w.close();
								//recargar() ;
								
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
			
			}else{
				Ext.Msg.alert('<s:message code="plugin.arquetipos.listado.editar" text="**Editar Arquetipo" />','<s:message code="plugin.arquetipos.listado.novalor" text="**Debe seleccionar un valor de la lista" />');
			}
		
	</pfs:button>
	
	Ext.util.CSS.createStyleSheet(".icon_arquetipo { background-image: url('../img/plugin/arquetipos/arquetipo.png');}");
			
	<pfs:searchPage searchPanelTitle="**Búsqueda de Arquetipos"  searchPanelTitleKey="plugin.arquetipos.listado.busqueda" 
			columnModel="arquetiposCM" columns="2"
			gridPanelTitleKey="plugin.arquetipos.titulo" gridPanelTitle="**Arquetipos" 
			createTitleKey="plugin.arquetipos.listado.nuevo" createTitle="**Nuevo Arquetipo" 
			createFlow="plugin/arquetipos/arquetipos/ARQnuevoArquetipo" 
			updateFlow="plugin/arquetipos/arquetipos/ARQconsultaArquetipo" 
			updateTitleData="nombre"
			dataFlow="plugin/arquetipos/arquetipos/ARQbusquedaArquetiposData"
			resultRootVar="arquetipos" resultTotalVar="total"
			recordType="ArquetipoRT" 
			parameters="getParametros" 
			newTabOnUpdate="true"
			gridName="arquetiposGrid"
			buttonDelete="btBorrar, btEditar"
			iconCls="icon_arquetipo"
			 >
			<pfs:items
			items="filtroNombre, filtroRule"
			width="450" />
			<pfs:items
			items="filtroModelo, filtroEstado" 
			width="900"/>
	</pfs:searchPage>
	
	filtroForm.getTopToolbar().add(buttonsL,'->', buttonsR);
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());

</fwk:page>


