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
			labelKey="plugin.arquetipos.modelo.nombre" label="**Nombre"
			value="" searchOnEnter="true" />
			
	<pfsforms:textfield name="filtroDescripcion"
			labelKey="plugin.arquetipos.modelo.descripcion" label="**Descripcion" maxLength="50"
			value="" searchOnEnter="true" />	
		
	<pfsforms:dblselect name="filtroArquetipo"
			labelKey="plugin.arquetipos.modelo.arquetipos" label="**Arquetipos"
			dd="${arquetipos}" height="120" propertyCodigo="id" propertyDescripcion="nombre"/>
			
	<pfsforms:ddCombo name="filtroEstado"
		labelKey="plugin.arquetipos.modelo.estado"
		label="**Estado" value="" dd="${ddEstadoModelo}" propertyCodigo="codigo"/>	
	
	<pfsforms:datefield name="filtroFechaInicioVigencia" labelKey="plugin.arquetipos.modelo.fechaInicioVigencia" label="**Fecha de vigencia entre" />
	
	<pfsforms:datefield name="filtroFechaFinVigencia" labelKey="plugin.arquetipos.modelo.fechaFinVigencia" label="**y ..." />		
			
	<pfs:defineRecordType name="ModeloRT">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="descripcion" />
			<pfs:defineTextColumn name="estado" />
	</pfs:defineRecordType>
			
	<pfs:defineColumnModel name="modeloCM">
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.arquetipos.modelo.nombre" caption="**Nombre"
			sortable="true" firstHeader="true" />
		<pfs:defineHeader dataIndex="descripcion"
			captionKey="plugin.arquetipos.modelo.descripcion" caption="**Descripcion"
			sortable="true" />
		<pfs:defineHeader dataIndex="estado"
			captionKey="plugin.arquetipos.modelo.estado" caption="**Estado"
			sortable="true" />		
	</pfs:defineColumnModel>
	
	<pfs:defineParameters name="getParametros" paramId="id" 
		nombre="filtroNombre" descripcion ="filtroDescripcion" listaArquetipos="filtroArquetipo"  estadoModelo="filtroEstado" />
	
	
	
	var parametrosConFecha = function(){
		var p = getParametros();
		//fechaInicioVigencia_date="filtroFechaInicioVigencia"  fechaFinVigencia_date="filtroFechaFinVigencia"
		if (filtroFechaInicioVigencia.getValue()!=''){
			p.fechaInicioVigencia = filtroFechaInicioVigencia.getValue().format("d/m/Y");
		}
		if (filtroFechaFinVigencia.getValue()!=''){
			p.fechaFinVigencia = filtroFechaFinVigencia.getValue().format("d/m/Y");
		}
		return p;
	};
	
	var parametrosConFecha_validarForm = function(){
		return true;
	};
	
	var parametrosConFecha_camposFormulario = getParametros_camposFormulario;
	parametrosConFecha_camposFormulario.push(filtroFechaInicioVigencia);
	parametrosConFecha_camposFormulario.push(filtroFechaFinVigencia);
	
	<pfs:buttonremove name="btBorrar" 
		novalueMsg="**Debe seleccionar un valor de la tabla" 
		flow="plugin/arquetipos/modelosarquetipos/ARQbajaModelo" 
		paramId="idModelo"  
		datagrid="modelosGrid" 
		novalueMsgKey="modelos.noValor"
		parameters="parametrosConFecha"/>
		
	Ext.util.CSS.createStyleSheet(".icon_modelo { background-image: url('../img/plugin/arquetipos/modelo.png');}");
		
		<pfs:searchPage searchPanelTitle="**Búsqueda de Modelos de Arquetipos"  searchPanelTitleKey="plugin.arquetipos.modelo.busqueda" 
			columnModel="modeloCM" columns="2"
			gridPanelTitleKey="plugin.arquetipos.modelos.titulo" gridPanelTitle="**Modelos" 
			createTitleKey="plugin.arquetipos.modelo.nuevo" createTitle="**Nuevo Modelo" 
			createFlow="plugin/arquetipos/modelosarquetipos/ARQaltaModelo" 
			updateFlow="plugin/arquetipos/modelosArquetipos/ARQconsultarModelo" 
			updateTitleData="nombre"
			dataFlow="plugin/arquetipos/modelosArquetipos/ARQbusquedaModelosData"
			resultRootVar="modelos" resultTotalVar="total"
			recordType="ModeloRT" 
			parameters="parametrosConFecha" 
			newTabOnUpdate="true"
			gridName="modelosGrid"
			buttonDelete="btBorrar"
			iconCls="icon_modelo" >
			<pfs:items
			items="filtroNombre, filtroDescripcion,filtroFechaInicioVigencia, filtroFechaFinVigencia "
			width="450" />
			<pfs:items
			items="filtroEstado, filtroArquetipo" 
			width="900"/>	
		</pfs:searchPage>
	
		filtroForm.getTopToolbar().add(buttonsL,'->', buttonsR);
		filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());
		
</fwk:page>


