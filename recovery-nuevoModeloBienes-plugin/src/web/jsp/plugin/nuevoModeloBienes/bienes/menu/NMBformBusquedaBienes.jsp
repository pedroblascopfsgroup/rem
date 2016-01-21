<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>

var formBusquedaBienes=function(){
	Ext.util.CSS.createStyleSheet(".icon_solvencia { background-image: url('../img/plugin/editor/button_remove.gif'); background-repeat: no-repeat; background-position:center;}");
	var limit=25;
	var paramsBusquedaInicial={
		start:0
		,limit:limit
		,id:'${id}'
		,poblacion:'${poblacion}'
		,codPostal:'${codPostal}'
		,idTipoBien:'${idTipoBien}'
		,valorDesde:'${valor}'
		,totalCargasDesde:'${totalCargas}'
		,valorHasta:'${valor}'
		,totalCargasHasta:'${totalCargas}'
		,fechaVerificacion:'${fechaVerificacion}'
		,numContrato:'${numContrato}'
		,codCliente:'${codCliente}'
	};
	
	var txtIdBien = app.creaInteger('id', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.codBien" text="**Cï¿½digo del bien" />', '${id}'); 
	var txtPoblacion = app.creaText('poblacion', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.poblacion" text="**Poblaciï¿½n" />', '${poblacion}');
	var txtCodPostal = app.creaText('codPostal', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.codPostal" text="**Cï¿½digo Postal" />', '${codPostal}');
	<pfs:ddCombo name="comboTipoBien" 
		labelKey="plugin.nuevoModeloBienes.busquedaBienes.filtros.tipoBien" label="**Tipo de bien"
		blankElement="true" blankElementText="Todos" value="${idTipoBien}" dd="${tiposBien}" />;
	var fechaVerifNMB=new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.fechaVerificacion" text="**Fecha Verificacion" />'
		,labelStyle:'width:150px'
		,name:'fechaVerificacion'
		,style:'margin:0px'	
		,value:	'<fwk:date value="${fechaVerificacion}" />'	
	});
	
	var txtValorDesde = app.creaNumber('valor', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.valorImporteDesde" text="**Valor importe desde" />', '${valorDesde}');
	var txtTotalCargasDesde = app.creaNumber('totalCargas', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.totalCargasDesde" text="**Total cargas importe desde" />', '${totalCargasDesde}');
	var txtValorHasta = app.creaNumber('valor', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.valorImporteHasta" text="**Valor importe hasta" />', '${valorHasta}');
	var txtTotalCargasHasta = app.creaNumber('totalCargas', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.totalCargasHasta" text="**Total cargas importe hasta" />', '${totalCargasHasta}');
	var txtNumContrato = app.creaText('numContrato', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.numContrato" text="**Num. Contrato" />', '${numContrato}');
	var txtPrimerTitularNIF = app.creaText('nifPrimerTitular', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.nifTitular" text="**NIF Titular" />', '${nifPrimerTitular}');
	var txtCodCliente = app.creaText('codCliente', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.codCliente" text="**Cod. Cliente" />', '${codCliente}');
	var txtNifCliente = app.creaText('nifCliente', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.nifCliente" text="**NIF Cliente" />', '${nifCliente}');
	
	var solvenciaNoEncontradaNMB =  new Ext.form.Checkbox({
			//id:'solvenciaNoEncontrada'
			fieldLabel:'<s:message code="plugin.nuevoModeloBienes.solvenciaNoEncontrada" text="**Solvencia no encontrada"/>'
			//,labelStyle:'width:185px;height:50px;'
			,name:'solvenciaNoEncontradaNMB'
			,style:'margin:0px'		
		
		});
		
	<%--Nuevos filtros datos del bien--%>
	var txtNumActivo = app.creaInteger('numActivo', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.numActivo" text="**Nï¿½ activo" />', '${numActivo}'); 
	var txtNumRegistro = app.creaInteger('numRegistro', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.numRegistro" text="**Nï¿½ registro" />', '${numRegistro}'); 
	var txtReferenciaCatastral = app.creaText('referenciaCatastral', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.referenciaCatastral" text="**Referencia catastral" />', '${referenciaCatastral}'); 
	var txtSubtipoBien = app.creaInteger('subtipoBien', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.subtipoBien" text="**Subtipo bien" />', '${subtipoBien}'); 
	var txtTasacionDesde = app.creaInteger('tasacionDesde', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.valorTasacionDesde" text="**Valor tasaciï¿½n desde" />', '${tasacionDesde}'); 
	var txtTasacionHasta = app.creaInteger('tasacionHasta', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.valorTasacionHasta" text="**Valor tasaciï¿½n hasta" />', '${tasacionHasta}'); 
	var txtTipoSubastaDesde = app.creaInteger('tipoSubastaDesde', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.tipoSubastaDesde" text="**Tipo subasta desde" />', '${tipoSubastaDesde}'); 
	var txtTipoSubastaHasta = app.creaInteger('tipoSubastaHasta', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.tipoSubastaHasta" text="**Tipo subasta hasta" />', '${tipoSubastaHasta}');
	var txtNumFinca = app.creaText('numFinca', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.numFinca" text="**Nï¿½ finca" />', '${numFinca}'); 
	
	<%-- Filtros localizaciones --%>
	var txtDireccion = app.creaText('direccion', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.direccion" text="**Direcciï¿½n" />', '${direccion}');
	var txtProvincia = app.creaText('provincia', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.provincia" text="**Provincia" />', '${provincia}');
	var txtLocalidad = app.creaText('localidad', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.localidad" text="**Localidad" />', '${localidad}');
	var txtCodigoPostal = app.creaText('codigoPostal', '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.filtros.codPostal" text="**Cï¿½digo Postal" />', '${codigoPostal}');
	
	
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
	
<%-- ************************* PESTAï¿½A 1 FILTROS BIEN *************************************** --%>
	
	var filtrosTabDatosBien = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.busquedaBienes.tabFiltros.datosBien" text="**Datos del bien" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:4}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [txtIdBien, txtPoblacion, txtValorDesde, txtTotalCargasDesde /*, comboValorOp, comboTotalCargasOp*/,txtTasacionDesde, txtTipoSubastaDesde]
				},{
					layout:'form'
					,items: [txtCodPostal, comboTipoBien, txtValorHasta, txtTotalCargasHasta /*, txtValor, txtTotalCargas*/, txtTasacionHasta, txtTipoSubastaHasta]
				},{
					layout:'form'
					,items: [
					<sec:authorize ifNotGranted="PERSONALIZACION-BCC">
					txtNumActivo,
					</sec:authorize> 
					txtNumRegistro, txtReferenciaCatastral, txtSubtipoBien, txtNumFinca]
				}]
	});

<%-- ************************* PESTAï¿½A 2 FILTROS BIEN *************************************** --%>
	var tabFiltrosRelacion = false;	
	var filtrosTabRelacionesBien = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.busquedaBienes.tabFiltros.relacionesBien" text="**Relaciones del bien" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:4}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [txtNumContrato, txtPrimerTitularNIF]
				},{
					layout:'form'
					,items: [txtCodCliente, txtNifCliente]
				}]
	});
	filtrosTabRelacionesBien.on('activate',function(){
		tabFiltrosRelacion=true;
	});
		
		
<%-- ************************* PESTAï¿½A 3 FILTROS BIEN LOCALIZACIï¿½N *************************************** --%>
	var tabFiltrosLocalizacion = false;	
	var filtrosTabLocalizacionBien = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.busquedaBienes.tabFiltros.localizacion" text="**Localizaciones del bien" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:4}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [txtDireccion, txtProvincia, txtLocalidad, txtCodigoPostal]
				}]
	});
	filtrosTabLocalizacionBien.on('activate',function(){
		tabFiltrosLocalizacion=true;
	});
		
<%-- ******************* MODIFICACION BOTON BUSCAR PARA QUE SE DESACTIVEN BUSQUEDAS EN PARALELO ******************** --%>		
	var validarForm=function(){
		if(txtIdBien.getValue() != ''){
			return true;
		}
		if(txtPoblacion.getValue() != ''){
			return true;
		}
		if(txtCodPostal.getValue() != ''){
			return true;
		}
		if(comboTipoBien.getValue() != ''){
			return true;
		}
		if(txtValorDesde.getValue() != ''){
			return true;
		}
		if(txtTotalCargasDesde.getValue() != ''){
			return true;
		}
		if(txtValorHasta.getValue() != ''){
			return true;
		}
		if(txtTotalCargasHasta.getValue() != ''){
			return true;
		}
		if(txtNumContrato.getValue() != ''){
			return true;
		}
		if(txtPrimerTitularNIF.getValue() != ''){
			return true;
		}
		if(txtCodCliente.getValue() != ''){
			return true;
		}
		if(txtNifCliente.getValue() != ''){
			return true;
		}
		if(txtNumActivo.getValue() != ''){
			return true;
		}
		if(txtNumRegistro.getValue() != ''){
			return true;
		}
		if(txtReferenciaCatastral.getValue() != ''){
			return true;
		}
		if(txtSubtipoBien.getValue() != ''){
			return true;
		}
		if(txtTasacionDesde.getValue() != ''){
			return true;
		}
		if(txtTasacionHasta.getValue() != ''){
			return true;
		}
		if(txtTipoSubastaDesde.getValue() != ''){
			return true;
		}
		if(txtTipoSubastaHasta.getValue() != ''){
			return true;
		}
		if(txtNumFinca.getValue() != ''){
			return true;
		}
		if(txtDireccion.getValue() != ''){
			return true;
		}
		if(txtProvincia.getValue() != ''){
			return true;
		}
		if(txtLocalidad.getValue() != ''){
			return true;
		}
		if(txtCodigoPostal.getValue() != ''){
			return true;
		}
	};
	
	var buscarFunc=function(){
		if(validarForm()){
			var isBusqueda=true;
			panelFiltros.collapse(true);
			pagingBar.show();
			bienesStore.webflow(getParametros());
			panelFiltros.getTopToolbar().setDisabled(true);	
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','Introduzca parámetros de búsqueda');
		}
	};
    
    buttonsL[0] = app.crearBotonBuscar({
		handler : buscarFunc
	});	
		
<%-- *************TABPANEL QUE CONTIENE TODAS LAS PESTAï¿½AS********************************   --%>	
	var filtroTabPanel=new Ext.TabPanel({
		items:[filtrosTabDatosBien, filtrosTabRelacionesBien, filtrosTabLocalizacionBien]
		,id:'idTabFiltrosBien'
		,layoutOnTabChange:true 
		,autoScroll:true
		,height:250
		//,autoHeight:true
		,autoWidth : true
		,border : false	
		,activeItem:0
	});

<%-- **************************** PANEL QUE CONTIENE EL PANEL DE PESTAï¿½AS******************** --%>
	
	var panelFiltros = new Ext.Panel({
		autoHeight:true
		,autoWidth:true
		,title : '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.FiltrosTitulo" text="**Filtro de Bienes" />'
		,titleCollapse:true
		,collapsible:true
		,tbar : [buttonsL,'->', buttonsR]
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,style:'padding-bottom:10px; padding-right:10px;'
		,items:[{items:[{
						layout:'form'
						,items:[
								filtroTabPanel
							   ]
					   }]	
				}]
		,listeners:{	
			beforeExpand:function(){
				bienesGrid.setHeight(125);
				}
			,beforeCollapse:function(){
				bienesGrid.setHeight(435);
				bienesGrid.expand(true);
			}
		}
	});
	
	var getParametros=function(){
		var b = {};
		b.id=txtIdBien.getValue();
		b.poblacion=txtPoblacion.getValue();
		b.codPostal=txtCodPostal.getValue();
		b.idTipoBien=comboTipoBien.getValue();
		b.valorDesde=txtValorDesde.getValue();
		b.totalCargasDesde=txtTotalCargasDesde.getValue();
		b.valorHasta=txtValorHasta.getValue();
		b.totalCargasHasta=txtTotalCargasHasta.getValue();
		b.fechaVerificacion=fechaVerifNMB.getValue();
		b.solvenciaNoEncontrada = solvenciaNoEncontradaNMB.getValue();
		if(tabFiltrosRelacion){
			b.numContrato=txtNumContrato.getValue();
			b.codCliente=txtCodCliente.getValue();
			b.nifPrimerTitular=txtPrimerTitularNIF.getValue();
			b.nifCliente=txtNifCliente.getValue();
		}
				
		b.numActivo=txtNumActivo.getValue();
		b.numRegistro=txtNumRegistro.getValue();
		b.referenciaCatastral=txtReferenciaCatastral.getValue();
		b.subtipoBien=txtSubtipoBien.getValue();
		b.tasacionDesde=txtTasacionDesde.getValue();
		b.tasacionHasta=txtTasacionHasta.getValue();
		b.tipoSubastaDesde=txtTipoSubastaDesde.getValue();
		b.tipoSubastaHasta=txtTipoSubastaHasta.getValue();
		if(tabFiltrosLocalizacion){
			b.direccion=txtDireccion.getValue();
			b.provincia=txtProvincia.getValue();
			b.localidad=txtLocalidad.getValue();
			b.codigoPostal=txtCodigoPostal.getValue();		
		}
		b.numFinca=txtNumFinca.getValue();
		return b;
	}
	
	resetFiltros = function(){
		txtIdBien.reset();
		txtPoblacion.reset();
		txtCodPostal.reset();
		comboTipoBien.reset();

		txtValorDesde.reset();
		txtTotalCargasDesde.reset();
		txtValorHasta.reset();
		txtTotalCargasHasta.reset();
		fechaVerifNMB.reset();
		if(tabFiltrosRelacion){
			txtNumContrato.reset();
			txtCodCliente.reset();
			txtPrimerTitularNIF.reset();
			txtNifCliente.reset();
		}
		solvenciaNoEncontradaNMB.reset();		
		
		txtNumActivo.reset();
		txtNumRegistro.reset();
		txtReferenciaCatastral.reset();
		txtSubtipoBien.reset();
		txtTasacionDesde.reset();
		txtTasacionHasta.reset();
		txtTipoSubastaDesde.reset();
		txtTipoSubastaHasta.reset();
		if(tabFiltrosLocalizacion){
			txtDireccion.reset();
			txtProvincia.reset();
			txtLocalidad.reset();
			txtCodigoPostal.reset();
		}
		txtNumFinca.reset();
	}
	
	 var rendererChechkbox = function(value, metaData, record, rowIndex, colIndex, store){ 
		console.debug(metaData);
		console.debug(record);
		console.debug(store);
	  if(value == true){ 

            metaData.css = 'icon_solvencia';
        }
        else{

            //metaData.css='icon_checkbox_off';
        }
        return '';
    };
	
	var bien = Ext.data.Record.create([
		 {name:'id'}
		,{name:'tipo'}
		,{name:'descripcionBien'}
		,{name:'refCatastral'}
		,{name:'poblacion'}
		,{name:'valorActual'}
		,{name:'superficie'}
		,{name:'origen'}
		,{name:'valorActual'}
		,{name:'importeCargas'}
		,{name:'codigoInterno'}
		,{name:'solvenciaNoEncontrada'}
		,{name:'numActivo'}
		,{name:'numRegistro'}
		,{name:'referenciaCatastral'}
		,{name:'subtipoBien'}
		,{name:'direccion'}
		,{name:'provincia'}
		,{name:'localidad'}
		,{name:'codigoPostal'}
		,{name:'numFinca'}
	]);
	
	var bienesStore = page.getStore({
		 flow: 'plugin/nuevoModeloBienes/bienes/busquedas/NMBlistadoBienesData'
		,limit: limit
		,remoteSort: true
		,baseParams:paramsBusquedaInicial
		,reader: new Ext.data.JsonReader({
	    	 root : 'bienes'
	    	,totalProperty : 'total'
	     }, bien)
	});	
	
	var bienesCm = new Ext.grid.ColumnModel([
	    {header : '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.numFinca" text="**N&uacute;mero finca"/>', dataIndex : 'numFinca' }
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.refCatastral" text="**R. Catastral"/>', width: 200, sortable: false, dataIndex: 'refCatastral'}
	    <sec:authorize ifNotGranted="PERSONALIZACION-BCC">
		,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.numActivo" text="**Nº activo"/>', sortable: false, dataIndex: 'numActivo'}
		</sec:authorize>
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.tipo" text="**Tipo"/>', width: 200, sortable: false, dataIndex: 'tipo'}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.descripcion" text="**Descipciï¿½n"/>', width: 200, sortable: true, dataIndex: 'descripcionBien'}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.poblacion" text="**Poblaciï¿½n"/>', width: 200, sortable: false, dataIndex: 'poblacion'}
		,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.Valor" text="**Valor"/>', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'valorActual'}
		,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.Cargas" text="**Cargas"/>', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'importeCargas'}
		,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.origen" text="**Origen"/>', sortable: true, dataIndex: 'origen'}
		,{header: '<s:message code="plugin.nuevoModeloBienes.solvenciaNoEncontrada" text="**Solvencia no encontrada"/>', dataIndex: 'solvenciaNoEncontrada', sortable: true,renderer:rendererChechkbox}	    
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.idBien" text="**Cï¿½digo"/>', dataIndex: 'id', sortable: true, hidden:true}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.codigoInterno" text="**codigoInterno"/>', width: 200, sortable: true, dataIndex: 'codigoInterno', hidden:true}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.superficie" text="**Superficie"/>', dataIndex: 'superficie', renderer: app.format.sqrMtsRenderer, align:'right', sortable: false, hidden:true}

<%-- 		,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.numRegistro" text="**Nï¿½ registro"/>', sortable: false, dataIndex: 'numRegistro', hidden:true} --%>
<%--		,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.referenciaCatastral" text="**Referencia catastral"/>', sortable: false, dataIndex: 'referenciaCatastral', hidden:true}  --%>
<%-- 		,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.subtipoBien" text="**Subtipo bien"/>', sortable: false, dataIndex: 'subtipoBien', hidden:true} --%>
<%-- 		,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.direccion" text="**Direcciï¿½n"/>', sortable: false, dataIndex: 'direccion', hidden:true} --%>
<%-- 		,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.provincia" text="**Provincia"/>', sortable: false, dataIndex: 'provincia', hidden:true} --%>
<%-- 		,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.localidad" text="**Localidad"/>', sortable: false, dataIndex: 'localidad', hidden:true} --%>
<%-- 		,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaBienes.grid.codigoPostal" text="**Cï¿½digo postal"/>', sortable: false, dataIndex: 'codigoPostal', hidden:true} --%>
	]);

	<sec:authorize ifAllGranted="SOLVENCIA_BORRAR">
		var btnBorrarBien =  app.crearBotonBorrar({
			text : '<s:message code="app.borrar" text="**BorrarBien" />'
			,flow : 'clientes/borrarBien'
			,success : function(){
				var rec = bienesGrid.getSelectionModel().getSelected();
        	    var desc= "cliente" + rec.get('id');
				app.closeTab({id:desc});
				app.clientesFav.fireEvent('reloadFav');
				bienesStore.webflow();
			}
			,page : page
		})
	</sec:authorize>
		
	var pagingBar=fwk.ux.getPaging(bienesStore);
	pagingBar.hide();
	
	solvenica_borrar = 1;
	<sec:authorize ifAllGranted="SOLVENCIA_BORRAR">
		solvenica_borrar = 2;
	</sec:authorize>
	if (solvenica_borrar==1){
		var cfg={
			title:'<s:message code="plugin.nuevoModeloBienes.busquedaBienes.tituloGrid" text="**Bienes"/>'
			,style:'padding-bottom:10px; padding-right:20px;'
			,cls:'cursor_pointer'
			,iconCls : 'icon_bienes'
			,collapsible : true
			,collapsed: true		
			,titleCollapse : true
			,resizable:true
			,dontResizeHeight:true		
			,bbar : [pagingBar]
			,autoHeight:true
		};
	}else{
		var cfg={
			title:'<s:message code="plugin.nuevoModeloBienes.busquedaBienes.tituloGrid" text="**Bienes"/>'
			,style:'padding-bottom:10px; padding-right:20px;'
			,cls:'cursor_pointer'
			,iconCls : 'icon_bienes'
			,collapsible : true
			,collapsed: true		
			,titleCollapse : true
			,resizable:true
			,dontResizeHeight:true		
			,bbar : [pagingBar, btnBorrarBien]
			,autoHeight:true
		};
	}	

	var bienesGrid = app.crearGrid(bienesStore,bienesCm,cfg);
		
	bienesGrid.on('load', function(){
		bienesGrid.setTitle('<s:message code="plugin.nuevoModeloBienes.busquedaBienes.titussloGrido" text="**Bienes" arguments="'+bienesStore.getTotalCount()+'"/>');
		panelFiltros.collapse(true);
	});
	
	<sec:authorize ifAllGranted="SOLVENCIA_BORRAR">
		bienesGrid.on('rowclick',function(grid, rowIndex, e){
			var rec = grid.getStore().getAt(rowIndex);
	        var origen= rec.get('origen');
			if(origen=='Automï¿½tica'){
				btnBorrarBien.disable();
			} else {
				btnBorrarBien.enable();
			}
		});
	</sec:authorize>
	
	var bienesGridListener = function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
	    var idBien= rec.get('id');
    	if(!idBien)	return;
    	var desc = idBien + ' ' +  rec.get('tipo');
    	app.abreBien(idBien,desc);
    };
	    	
	bienesGrid.addListener('rowdblclick', bienesGridListener);
	
	bienesStore.on('load',function(){
           panelFiltros.getTopToolbar().setDisabled(false);
    });
	
	var mainPanel = new Ext.Panel({
		items : [
			 panelFiltros
			,bienesGrid
    	]
	    ,bodyStyle:'padding:15px'
	    ,autoHeight : true
	    ,border: false
    });
    
	return mainPanel;
}
