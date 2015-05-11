<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>

<fwk:page>
	
	<pfs:hidden name="idBien" value="${dto.idBien}"/>
	<pfs:hidden name="idInstrucciones" value="${dto.idInstrucciones}"/>
	<pfs:hidden name="idProcedimiento" value="${dto.idProcedimiento}"/>
	<pfs:hidden name="tipoSubasta" value="${dto.codigoTipoSubasta}"/>

		var primeraSubasta = new Ext.ux.form.XDateField({
			width:100
			,height:20
			,name:'primeraSubasta'
			,fieldLabel:'<s:message code="plugin.nuevoModeloBienes.dictarInstrucciones.primeraSubasta" text="**F. primera subasta" />'
			,value:'<fwk:date value="${dto.primeraSubasta != null ? dto.primeraSubasta : ''}" />'
			, allowBlank: false
		});
	
		var segundaSubasta = new Ext.ux.form.XDateField({
			width:100
			,height:20
			,name:'segundaSubasta'
			,fieldLabel:'<s:message code="plugin.nuevoModeloBienes.dictarInstrucciones.segundaSubasta" text="**F. segunda subasta" />'
			,value:'<fwk:date value="${dto.segundaSubasta != null ? dto.segundaSubasta : ''}" />'
			, allowBlank: false
		});
		
		var terceraSubasta = new Ext.ux.form.XDateField({
			width:100
			,height:20
			,name:'terceraSubasta'
			,fieldLabel:'<s:message code="plugin.nuevoModeloBienes.dictarInstrucciones.terceraSubasta" text="**F. tercera subasta" />'
			,value:'<fwk:date value="${dto.terceraSubasta != null ? dto.terceraSubasta : ''}" />'
			, allowBlank: false
		});
		
		<pfs:ddCombo name="notarios" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.notario" label="**Notario" value="${dto.notario}" dd="${listaNotarios}" />
		<pfs:currencyfield name="valorSubasta" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.valorSubasta" label="**Valor subasta" value="${dto.valorSubasta}" />
		<pfs:currencyfield name="totalDeuda" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.totalDeuda" label="**Total deuda" value="${dto.totalDeuda}" />
		<pfs:currencyfield name="principal" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.principal" label="**Principal" value="${dto.principal}" />
		<pfs:currencyfield name="cargasAnteriores" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.cargasAnteriores" label="**Cargas anteriores" value="${dto.cargasAnteriores}" />
		<pfs:currencyfield name="peritacionActual" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.peritacionActual" label="**Peritación actual" value="${dto.peritacionActual}" />
		<pfs:currencyfield name="tipoSegundaSubasta" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.tipoSegundaSubasta" label="ipo 2ª subasta" value="${dto.tipoSegundaSubasta}" />
		<pfs:currencyfield name="importeSegundaSubasta" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.importeSegundaSubasta" label="**Importe segunda subasta" value="${dto.importeSegundaSubasta}" />
		<pfs:currencyfield name="tipoTerceraSubasta" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.tipoTerceraSubasta" label="**Tipo tercera subasta" value="${dto.tipoTerceraSubasta}" />
		<pfs:currencyfield name="importeTerceraSubasta" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.importeTerceraSubasta" label="**mporte tercera subasta" value="${dto.importeTerceraSubasta}" />
		<pfs:currencyfield name="responsabilidadCapital" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.respCapital" label="**Capital" value="${dto.responsabilidadCapital}" />
		<pfs:currencyfield name="responsabilidadIntereses" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.respIntereses" label="**Intereses" value="${dto.responsabilidadIntereses}" />
		<pfs:currencyfield name="responsabilidadDemoras" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.respDemoras" label="**Demoras" value="${dto.responsabilidadDemoras}" />
		<pfs:currencyfield name="responsabilidadCostas" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.respCostas" label="**Costas" value="${dto.responsabilidadCostas}" />
		<pfs:currencyfield name="propuestaCapital" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.propCapital" label="**Capital" value="${dto.propuestaCapital}" />
		<pfs:currencyfield name="propuestaIntereses" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.propIntereses" label="**Intereses" value="${dto.propuestaIntereses}" />
		<pfs:currencyfield name="propuestaDemoras" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.propDemoras" label="**Demoras" value="${dto.propuestaDemoras}" />
		<pfs:currencyfield name="propuestaCostas" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.propCostas" label="**Costas" value="${dto.propuestaCostas}" />
		<pfs:currencyfield name="costasProcurador" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.costasProcurador" label="**Costas procurador" value="${dto.costasProcurador}" />
		<pfs:currencyfield name="costasLetrado" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.costasLetrado" label="**Costas letrado" value="${dto.costasLetrado}" />
		<pfs:currencyfield name="limiteConPostores" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.limiteConPostores" label="**Límite con postores" value="${dto.limiteConPostores}" />
		<pfs:ddCombo name="postores" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.postores" label="**Postores" value="${dto.idPostores}" dd="${ddPostores}" />
		<pfs:textfield name="observaciones" width="620" labelKey="plugin.nuevoModeloBienes.dictarInstrucciones.observaciones" label="**Observaciones" value="${dto.observaciones}" />
		observaciones.height = 50;
		
		var fechaInscripcion = new Ext.ux.form.XDateField({
			width:100
			,height:20
			,name:'fechaInscripcion'
			,fieldLabel:'<s:message code="plugin.nuevoModeloBienes.dictarInstrucciones.fechaInscripcion" text="**F. tercera subasta" />'
			,value:'<fwk:date value="${dto.fechaInscripcion != null && dto.codigoTipoSubasta == '01' ? dto.fechaInscripcion : ''}" />'
		});
		
		var fechaLlaves = new Ext.ux.form.XDateField({
			width:100
			,height:20
			,name:'fechaLlaves'
			,fieldLabel:'<s:message code="plugin.nuevoModeloBienes.dictarInstrucciones.fechaLLaves" text="**F. tercera subasta" />'
			,value:'<fwk:date value="${dto.fechaLlaves != null ? dto.fechaLlaves : ''}" />'
		});
	
		<pfs:defineParameters name="parametros" paramId=""
			codigoTipoSubasta="tipoSubasta"
			idInstrucciones="idInstrucciones"
			idBien="idBien"
			idProcedimiento="idProcedimiento"
			primeraSubasta="primeraSubasta"
			segundaSubasta="segundaSubasta"
			terceraSubasta="terceraSubasta"
			valorSubasta="valorSubasta"
			totalDeuda="totalDeuda"
			principal="principal"
			cargasAnteriores="cargasAnteriores"
			peritacionActual="peritacionActual"
			tipoSegundaSubasta="tipoSegundaSubasta"
			importeSegundaSubasta="importeSegundaSubasta"
			tipoTerceraSubasta="tipoTerceraSubasta"
			importeTerceraSubasta="importeTerceraSubasta"
			responsabilidadCapital="responsabilidadCapital"
			responsabilidadIntereses="responsabilidadIntereses"
			responsabilidadDemoras="responsabilidadDemoras"
			responsabilidadCostas="responsabilidadCostas"
			propuestaCapital="propuestaCapital"
			propuestaIntereses="propuestaIntereses"
			propuestaDemoras="propuestaDemoras"
			propuestaCostas="propuestaCostas"
			fechaInscripcion="fechaInscripcion"
			fechaLlaves="fechaLlaves"
			notario="notarios"
			observaciones="observaciones"
			costasProcurador="costasProcurador"
			costasLetrado="costasLetrado"
			limiteConPostores="limiteConPostores"
			postores="postores"
		/>
		
		var responsabilidad = new Ext.form.FieldSet({
			title:'<s:message code="plugin.nuevoModeloBienes.dictarInstrucciones.responsabilidades" text="**Responsabilidad"/>'
			,defaults :  {border : false }
			,width:300
			,items : [
				 { layout:'table'
				   ,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
				   ,items:[ {items:[responsabilidadCapital, responsabilidadIntereses, responsabilidadDemoras, responsabilidadCostas]}]
				 }
			]
		});
		
		var propuesta = new Ext.form.FieldSet({
			title:'<s:message code="plugin.nuevoModeloBienes.dictarInstrucciones.propuestas" text="**Propuesta"/>'
			,defaults :  {border : false}
			,width:300
			,items : [{
				 layout:'table'
				 ,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
				 ,items:[ {items:[propuestaCapital, propuestaIntereses, propuestaDemoras, propuestaCostas]}]
			}]
		});
		
		var validarForm = function() {
			if ('${dto.codigoTipoSubasta}' == '01') {
				if(primeraSubasta.getValue() == null || primeraSubasta.getValue()== '' ){
					return false;
				} else if (segundaSubasta.getValue() == null || segundaSubasta.getValue()== '' ){
					return false;
				} else if(terceraSubasta.getValue() == null || terceraSubasta.getValue()== '' ){
					return false;
				}
			} 
			return true;
		}
		
		var btnGuardar = new Ext.Button({
			text : '<s:message code="app.guardar" text="**Guardar" />'
			,iconCls : 'icon_ok'
			,handler : function() {
				if(validarForm()){
					page.webflow({
						flow: 'instruccionessubasta/guardarInstrucciones'
						,params: parametros
						,success : function(){ 
							page.fireEvent(app.event.DONE); 
						}
					});
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios" code="plugin.nuevoModeloBienes.procedimiento.embargos.dictarInstrucciones.camposObligatorios"/>');
				}
		   	}
		});
		
		var btnCancelar= new Ext.Button({
			text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
			,handler : function(){ page.fireEvent(app.event.CANCEL); }
		});
		
		if ('${dto.codigoTipoSubasta}' == '01') {
		
			var instrucciones = new Ext.form.FormPanel({
				autoHeight : true
				,border : false
				,layout:'anchor'
				,items : [
				 	 { xtype : 'errorList', id:'errL' }
				 	,{
				 		autoHeight:true
				 		,border:false
				 		,bodyStyle:'padding-left:20px; padding-right:20px; padding-bottom: 0px;'
						,defaults :  {layout:'table', autoHeight : true, border : true, width:540, cellCls : 'vtop', bodyStyle : 'padding-left:5px' }
				 		,items:[
				 		   	  { layout:'table'
							   ,autoWidth:true
							   ,border : false
							   ,bodyStyle : 'padding:0px; margin:0px;' 
							   ,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
							   ,items:[
							 	 {items:[primeraSubasta, notarios, principal, peritacionActual, valorSubasta]}
							    ,{items:[segundaSubasta, tipoSegundaSubasta, importeSegundaSubasta, cargasAnteriores, fechaInscripcion]}
								,{items:[terceraSubasta, tipoTerceraSubasta, importeTerceraSubasta, totalDeuda, fechaLlaves]}
							 ]}
							 , { layout:'table'
							   ,border : false
							   ,width:700
							   ,bodyStyle : 'padding-left:50px; margin:0px;' 
							   ,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
							   ,items:[
							 	 {items:[responsabilidad]}
							    ,{items:[propuesta]}
								]}
							 ,{ layout:'form'
							   ,border : false
							   ,width:750
							   ,bodyStyle : 'padding-left:12px; padding-bottom:12px'
							   ,items:[observaciones]}
						 ]
						 ,bbar : [
							btnGuardar, btnCancelar
						 ]
					  } 
				  ]
			});
		
		} else {
		
			var instrucciones = new Ext.form.FormPanel({
				autoHeight : true
				,border : false
				,layout:'anchor'
				,items : [
				 	 { xtype : 'errorList', id:'errL' }
				 	,{
				 		autoHeight:true
				 		,border:false
				 		,bodyStyle:'padding-left:20px; padding-right:20px; padding-bottom: 0px;margin:5px'
						,layout:'column'
						,layoutConfig:{
							columns:2
						}
						,defaults :  {layout:'table', autoHeight : true, border : true, width:540, cellCls : 'vtop', bodyStyle : 'padding-left:5px' }
				 		,items:[
				 		   	  { layout:'table'
							   ,autoWidth:true
							   ,border : false
							   ,bodyStyle : 'padding:5px; margin:5px;' 
							   ,defaults :  {xtype : 'fieldset', autoHeight : true, border : true , style : 'margin:5px'}
							   ,items:[
							 	 {title:'Importes',items:[principal, propuestaIntereses,costasProcurador,costasLetrado]}
							    ,{title:'Instrucciones',items:[limiteConPostores,postores ]}
							    
							 ]}
							 ,{ layout:'form'
							   ,border : false
							   ,width:750
							   ,bodyStyle : 'padding-left:12px; padding-bottom:12px'
							   ,items:[observaciones]}
						 ]
						 ,bbar : [
							btnGuardar, btnCancelar
						 ]
					  } 
				  ]
			});
			
		}
		
	page.add(instrucciones);
	
</fwk:page>