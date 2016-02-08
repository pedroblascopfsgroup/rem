<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>
	<pfsforms:ddCombo name="tipoReclamacion" 
		labelKey="plugin.mejoras.procedimiento.cabecera.tipoReclamacion" 
		label="**Tipo de Reclamaci&oacute;n" value="${procedimiento.tipoReclamacion.id}" 
		dd="${tiposReclamacion}" width="200"/>
		
	<pfs:currencyfield name="principal" 
		labelKey="plugin.mejoras.procedimiento.cabecera.saldorecuperar" 
		label="**Principal" value="${procedimiento.saldoRecuperacion}"
		/>
	
	<pfsforms:numberfield name="estimacion" 
		labelKey="plugin.mejoras.procedimiento.cabecera.recuperacion" 
		label="**Estimaci&oacute;n principal"  
		value="${procedimiento.porcentajeRecuperacion}" />

	<pfsforms:numberfield name="plazoRecuperacion" 
		labelKey="plugin.mejoras.procedimiento.cabecera.meses" 
		label="**Plazo de recuperaci&oacute;n" 
		value="${procedimiento.plazoRecuperacion}" />
		
	
 
	var codPlaza = '';
	var codJuzgado='';
	var codProc='';
	
	var decenaInicio = 0;
	
	var dsplazas = new Ext.data.Store({
		autoLoad: false,
		baseParams: {limit:10, start:0},
		proxy: new Ext.data.HttpProxy({
			url: page.resolveUrl('editprocedimiento/plazasPorDescripcion')
		}),
		reader: new Ext.data.JsonReader({
			root: 'plazas'
			,totalProperty: 'total'
		}, [
			{name: 'codigo', mapping: 'codigo'},
			{name: 'descripcion', mapping: 'descripcion'}
		])
	});
	
	
	
	var dsprocuradoresRecord = Ext.data.Record.create([
		 {name:'nombre'}
		,{name:'id'}
	]);
	
	var dsprocuradores = page.getStore({
		flow:'procurador/getListaProcuradoresDeLaSociedad'
		,reader: new Ext.data.JsonReader({
			root:'procuradores'
			,totalProperty: 'total'
		},dsprocuradoresRecord)
	});
	
<!-- 	var dsprocuradores = new Ext.data.Store({ -->
<!-- 		autoLoad: false, -->
<!-- 		baseParams: {limit:10, start:0}, -->
<!-- 		proxy: new Ext.data.HttpProxy({ -->
<!-- 			url: page.resolveUrl('procurador/getListaProcuradoresDeLaSociedad') -->
<!-- 		}), -->
<!-- 		reader: new Ext.data.JsonReader({ -->
<!-- 			root: 'procuradores' -->
<!-- 			,totalProperty: 'total' -->
<!-- 		}, [ -->
<!-- 			{name: 'nombre', mapping: 'nombre'}, -->
<!-- 			{name: 'id', mapping: 'id'} -->
<!-- 		]) -->
<!-- 	}); -->

	TaskLocation = Ext.data.Record.create([
	    {name: "nombre"},
	    {name: "id"}
	]);
	
	var record = new TaskLocation({
	    id: 0,
	    nombre: "--Todas--"
	});
	


	var dssociedadprocuradores = new Ext.data.Store({
		autoLoad: false,
		baseParams: {limit:10, start:0},
		proxy: new Ext.data.HttpProxy({
			url: page.resolveUrl('procurador/getListaSociedadesProcuradores')
		}),
		reader: new Ext.data.JsonReader({
			root: 'sociedadesProcuradores'
			,totalProperty: 'total'
		}, [
			{name: 'nombre', mapping: 'nombre'},
			{name: 'id', mapping: 'id'}
		])
	});
	
	dssociedadprocuradores.add(record);
	dssociedadprocuradores.commitChanges();
	

	var idTipoPlaza = new Ext.form.ComboBox ({
		store:  dsplazas,
		allowBlank: true,
		blankElementText: '--',
		disabled: false,
		displayField: 'descripcion', 	// descripcion
		valueField: 'codigo', 		// codigo
		fieldLabel: '<s:message code="plugin.mejoras.procedimiento.cabecera.plaza" text="**Plaza de Juzgado" />',		// Pla de juzgado
		hiddenName:'tipoPlaza',
		loadingText: 'Searching...',
		width: 200,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'local',
		value:'${procedimiento.juzgado.plaza.codigo}'
	});	
	
	var procuradorJuzgado = new Ext.form.ComboBox ({
		store:  dsprocuradores,
		allowBlank: true,
		blankElementText: '--',
		disabled: false,
		displayField: 'nombre', 	// nombre
		valueField: 'id', 		// id
		fieldLabel: '<s:message code="plugin.procuradores.procedimiento.cabecera.procuradorJuzgado" text="**Procurador juzgado" />',		// Procurador de juzgado
		hiddenName:'procuradorJuzgado',
		loadingText: 'Searching...',
		width: 200,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'local',
		queryDelay: '800',
		value:'${procuradorDelProcedimiento.id}'
	});	
	
	
	var sociedadProcuradores =new Ext.form.ComboBox({
		store: dssociedadprocuradores
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,displayField: 'nombre'
		,valueField: 'id'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.procuradores.procedimiento.cabecera.sociedadProcuradores" text="**Sociedad de procuradores" />'
		,width:200
		,value:''
		
	});
	
	
	codProc='${procuradorDelProcedimiento.id}'
	codPlaza='${procedimiento.juzgado.plaza.codigo}';
	codJuzgado='${procedimiento.juzgado.codigo}';
		<%--
	<pfsforms:ddCombo name="idTipoPlaza" 
		labelKey="plugin.santander.procedimiento.cabecera.plaza" 
		label="**plaza" 
		value="${procedimiento.juzgado.plaza.id}" 
		dd="${plazas}"
		width="200"
		/>--%>
			   
	var idTipoJuzgadoRecord = Ext.data.Record.create([
		{name:'id'}
		,{name:'descripcion'}
	]);
	
	var idTipoJuzgadoStore = page.getStore({
		flow:'editprocedimiento/buscarJuzgadosPlaza'
		,reader: new Ext.data.JsonReader({
			idProperty: 'codigo'
			,root:'juzgado'
		},idTipoJuzgadoRecord)
	});
	
	
	var idTipoJuzgado =new Ext.form.ComboBox({
		store: idTipoJuzgadoStore
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'id'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.mejoras.procedimiento.cabecera.juzgado" text="**Tipo de Juzgado" />'
		,width:200
		,value:''
		
	});
	
	
	if (idTipoPlaza.getValue()!=null && idTipoPlaza.getValue()!=''){
		idTipoJuzgadoStore.webflow({codigo:idTipoPlaza.getValue()});
	}
	
	
	
	idTipoJuzgadoStore.on('load', function(){  
            idTipoJuzgado.setValue(${procedimiento.juzgado.id});
       });
            
       	 
	Ext.onReady(function() {
		decenaInicio = 0;
		if (codPlaza!=''){
			Ext.Ajax.request({
					url: page.resolveUrl('editprocedimiento/buscaPlazasPorCod')
					,params: {codigo: codPlaza}
					,method: 'POST'
					,success: function (result, request){
						var r = Ext.util.JSON.decode(result.responseText)
						decenaInicio = (r.paginaParaPlaza);
						dsplazas.baseParams.start = decenaInicio;	
						idTipoPlaza.store.reload();
						dsplazas.on('load', function(){ 
							idTipoPlaza.setValue(codPlaza);
							dsplazas.events['load'].clearListeners();
						});
					}				
			});
		}
		
		<c:if test="${isDespachoIntegral}">
   			sociedadProcuradores.store.reload();
		</c:if>
		

		
		if (codProc!=''){
			dsprocuradores.baseParams.procurador = codProc;
<!-- 			dsprocuradores.baseParams.start = '${posListProcuradores}'; -->
			procuradorJuzgado.store.reload();
			dsprocuradores.on('load', function(){ 
					procuradorJuzgado.setValue(codProc);
					dsprocuradores.events['load'].clearListeners();				
			});
			
			dsprocuradores.baseParams.procurador = '';
			
		}		

	});
	
	idTipoPlaza.on('afterrender', function(combo) {
		combo.mode='remote';	
	}); <%----%>
	
	procuradorJuzgado.on('afterrender', function(combo) {
		combo.mode='remote';	
	});
	
	
	
	var recargarIdTipoJuzgado = function(){
		idTipoJuzgado.store.removeAll();
		idTipoJuzgado.clearValue();
		idTipoJuzgadoStore.on('load',function(){
		idTipoJuzgado.setValue();
		});
		if (idTipoPlaza.getValue()!=null && idTipoPlaza.getValue()!=''){
			idTipoJuzgadoStore.webflow({codigo:idTipoPlaza.getValue()});
		}
	}
	
	
	idTipoPlaza.on('select', function(){
		recargarIdTipoJuzgado();
		idTipoJuzgado.setDisabled(false);
	});
	
	
	var recargarProcuradores = function(){
		procuradorJuzgado.store.removeAll();
		procuradorJuzgado.clearValue();
<!-- 		dsprocuradores.on('load', function(){   -->
<!--  			procuradorJuzgado.setValue();  -->
<!-- 		}); 		 -->
		
		dsprocuradores.webflow({codigo:sociedadProcuradores.getValue()});
	}
	

	
	sociedadProcuradores.on('select', function(){
		
		recargarProcuradores();
		
		if(dssociedadprocuradores.indexOf(record) == -1){
			dssociedadprocuradores.add(record); 
	 		dssociedadprocuradores.commitChanges(); 
		}
		
	});
	
	<pfsforms:textfield name="numeroAutos" 
		labelKey="plugin.mejoras.asunto.tabHistorico.numeroAutos" 
		label="**N&uacute;mero de autos" 
		width="100"
		value="${procedimiento.codigoProcedimientoEnJuzgado=='---' ? '' : procedimiento.codigoProcedimientoEnJuzgado}" />
	
	numeroAutos.validator = function(v) {
    	return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : '<s:message code="genericForm.validacionProcedimiento" text="**Debe introducir un n&uacute;mero con formato xxxxx/xxxx" />';
    };	 
		
	var validarDatos=function(){
		var v=numeroAutos.getValue();
		if (v==null || v==""){
			return false;
		}else{
			return /^[0-9]{5}\/[0-9]{4}$/.test(v)? true : false;
		}
	}
	
	var getParametros = function() {
	 	var p = {};
	 	p.id = ${procedimiento.id};
	 	p.tipoReclamacion = tipoReclamacion.getValue() ? tipoReclamacion.getValue() : '';
	 	p.principal = principal.getValue() ? principal.getValue() : 0;
	 	p.estimacion = estimacion.getValue() ? estimacion.getValue() : 0;
	 	p.plazoRecuperacion = plazoRecuperacion.getValue()  ? plazoRecuperacion.getValue() : 0;
	 	p.tipoPlaza = idTipoPlaza.getValue() ? idTipoPlaza.getValue() : '';
	 	p.procuradorJuzgado = procuradorJuzgado.getValue() ? procuradorJuzgado.getValue() : '';
	 	p.tipoJuzgado = idTipoJuzgado.getValue() ? idTipoJuzgado.getValue() : '';
	 	p.numeroAutos = numeroAutos.getValue() ? numeroAutos.getValue() : '---';
	    return p;
	}  				
	 	
 	var btnGuardar = new Ext.Button({
       text:  '<s:message code="app.guardar" text="**Guardar" />'
       ,iconCls : 'icon_ok'
       ,handler:function(){
			if (!validarDatos()) {
				alert('<s:message code="genericForm.validacionProcedimiento" text="**Debe introducir un n&uacute;mero con formato xxxxx/xxxx" />');
			}else {			
 	      		var p = getParametros(); 
 	      		page.webflow({ 
 	      			flow:'procurador/saveDatosProcedimiento' 
 	      			,params: p 
 	      			,success: function(){ 
 	            		   page.fireEvent(app.event.DONE); 
 	            	} 
 	      		}); 
			}
     	}
    });

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});

	var camposFieldSet = new Ext.form.FieldSet({
		border:false
		<c:choose>
		    <c:when test="${isDespachoIntegral}">
		       ,items : [tipoReclamacion,idTipoPlaza,idTipoJuzgado,sociedadProcuradores,procuradorJuzgado,numeroAutos,principal,plazoRecuperacion,estimacion]
		    </c:when>
		    <c:otherwise>
		       ,items : [tipoReclamacion,idTipoPlaza,idTipoJuzgado,numeroAutos,principal,plazoRecuperacion,estimacion]
		    </c:otherwise>
		</c:choose>
		
	});

	var panelEdicion = new Ext.form.FormPanel({
		bodyStyle : 'padding:10px'
		,autoHeight : true
		,items : [{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,columnWidth:.5
						<c:choose>
						    <c:when test="${isDespachoIntegral}">
						       ,items:[tipoReclamacion,idTipoPlaza,idTipoJuzgado,sociedadProcuradores,procuradorJuzgado]
						    </c:when>
						    <c:otherwise>
						       ,items:[tipoReclamacion,idTipoPlaza,idTipoJuzgado]
						    </c:otherwise>
						</c:choose>
						
					},{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,columnWidth:.5
						,items:[numeroAutos,principal,plazoRecuperacion,estimacion]
					}
				]
			}
		]
		,bbar : [btnGuardar, btnCancelar]
	});

	page.add(panelEdicion);
	
</fwk:page>