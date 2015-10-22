<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	//Agrego los filtros al panel
	var panelFiltros = new Ext.Panel({
		,title : '<s:message code="expedientes.listado.filtros" text="**Filtro de Expedientes" />'
		,defaults : {xtype:'panel' ,cellCls: 'vtop'}
		,bodyStyle:'cellspacing:10px;'
		,collapsible:true
		,titleCollapse:true
		,border:true
		,autoHeight:true
		,items:filtroTabPanel
		,tbar : [btnBuscar, btnReset, btnExportarXls, '->', app.crearBotonAyuda()]
	});
	
	//filtro pestañas
	var filtroTabPanel= new Ext.TabPanel({
		items:[filtrosTabDatosGenerales, filtrosTabExpediente, filtrosTabContrato]
		,id:'idTabFiltrosPrePro'
		,layoutOnTabChange:true
		,autoScroll:true
		,autoHeight:true
		,autoWidth:true
		,border:false
		,activeItem:0
	});
	
	//filtro Datos Generales
	var filtrosTabDatosGenerales =<%@ include file= "tabs/tabDatosGenerales.jsp" %>;
	
	//filtro Expediente
	var filtrosTabExpediente = <%@ include file= "tabs/tabExpediente.jsp" %>;
	
	//Filtro Contrato
	var filtrosTabContrato = <%@ include file = "tabs/tabContrato.jsp" %>;
	
	
	//panel principal
	var mainPanel = new Ext.Panel({
		items:[
			{
				layout:'form'
				,defaults : {xtype:'panel' , cellCls : 'vtop'}
				,border:false
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,items:[panelFiltros]
			}
		]
		,autoHeight:true
		,border:false
	});
	
	//botones toolbar panel
	var btnBuscar=app.crearBotonBuscar({
<!-- 		handler : buscarFunc -->
		<app:test id="btnBuscarPrePro" addComa="true"/>
	});	
	
	 var btnExportarXls=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a XLS" />'
        ,iconCls:'icon_exportar_csv'
<!--         ,handler: function() { -->
<!-- 					if (validarEmptyForm()){ -->
<!-- 						if (validaMinMax()){ -->
<!-- 							var flow='expedientes/listadoExpedientesExcelData'; -->
<!-- 		                    var params = getParametros(); -->
<!-- 		                    params.REPORT_NAME='busqueda.xls'; -->
<!-- 		                    app.openBrowserWindow(flow,params); -->
<!-- 						}else{ -->
<%-- 							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>'); --%>
<!-- 						} -->
<!-- 					}else{ -->
<%-- 						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>') --%>
<!-- 					}                     -->

					
<!--                 } -->
        }
    );
    
<!--     var btnReset = app.crearBotonResetCampos([ -->
	
<!-- 	]); -->
		
	//añadimos el panel principal a la pagina
	page.add(mainPanel);

</fwk:page>