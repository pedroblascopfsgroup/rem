<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>

	var labelStyle='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:120px'
	var labelStyleTextField='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:160px'	
	var style='margin-bottom:1px;margin-top:1px';
<!-- 	var sinTipoAcuerdo = false; -->
<%-- 	<sec:authorize ifAllGranted="OCULTA_TIPO_ACUERDO"> --%>
<!-- 		sinTipoAcuerdo = true; -->
<%-- 	</sec:authorize> --%>

	//TIPO ACUERDO

	var dictTipoAcuerdo = <app:dict value="${tiposAcuerdo}"/>;

	//store generico de combo diccionario
	var tipoAcuerdoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoAcuerdo
	});
	

	//SOLICITANTE
	var dictSolicitante = <app:dict value="${solicitantes}"/>;
	
	//store generico de combo diccionario
	var solicitanteStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictSolicitante
	});
	
	var solicitanteCombo = new Ext.form.ComboBox({
			name:'solicitanteCombo'
			<app:test id="editSolicitanteCombo" addComa="true" />
			,hiddenName:'solicitanteCombo'
			,store:solicitanteStore
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'local'
			,style:'margin:0px'
			,emptyText:'----'
			,triggerAction: 'all'
			,labelStyle:labelStyle
			,readOnly:${readOnly}
			,disabled:${esGestor && acuerdo.estaVigente}
			,fieldLabel : '<s:message code="acuerdo.conclusiones.solicitanteCombo" text="**Solicitante" />'
			<c:if test="${acuerdo!=null}">
	      		,value:"${acuerdo.solicitante.codigo}" 
	      	</c:if>
	});

	
	//ESTADO
	var dictEstado = <app:dict value="${estados}"/>;
	
	//store generico de combo diccionario
	var estadoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictEstado
	});

	
	var estadoCombo = new Ext.form.ComboBox({
			name:'estadoCombo'
			,hiddenName:'estadoCombo'
			,store:estadoStore
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'local'
			,emptyText:'----'
			,style:'margin:0px'
			,triggerAction: 'all'
			,labelStyle:labelStyle
			,disabled:true
			,value:app.codigoAcuerdoEnConformacion
			,fieldLabel : '<s:message code="acuerdo.conclusiones.estadoCombo" text="**Estado" />'
	});
	
	var fechaLimite =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.mejoras.acuerdos.nuevo.fechaLimite" text="**fechaInscripcion" />'
			,labelStyle: labelStyle
			,name:'fechaLimite'
			,value:	''
			,style:'margin:0px'		
	});		

	//OBSERVACIONES
	var tituloobservaciones = new Ext.form.Label({
   		text:'<s:message code="acuerdo.conclusiones.observaciones" text="**Observaciones" />'
		//,style:'font-weight:bolder;width:100px'
		,style:'font-weight:bolder;font-family:tahoma,arial,helvetica,sans-serif;font-size:11px;'
	});
	var observacionesConclusion = new Ext.form.TextArea({
		width:630
		<app:test id="editObservacionesConclusion" addComa="true" />
		,maxLength:2000
		,height:200
		,labelStyle:labelStyle
		,readOnly:${readOnly}
		,disabled:${esGestor && acuerdo.estaVigente}
		<c:if test="${acuerdo!=null}">
	      ,value:'<s:message javaScriptEscape="true" text="${acuerdo.observaciones}"/>' 
	    </c:if>	
	});
	
		var importeCostas  = app.creaNumber('periodo',
		'<s:message code="acuerdo.conclusiones.importe.costas" text="**Importe costas" />',
		'',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:5
<%-- 			,disabled:${esGestor && acuerdo.estaVigente} --%>
<%-- 			,readOnly:${readOnly} --%>
			,width:160
			,autoCreate : {tag: "input", type: "text",maxLength:"5", autocomplete: "off"}
		}
	);

	//TIPO DE PAGO
	var dictTipoPago = <app:dict value="${tiposPago}"/>;
	
	//store generico de combo diccionario
	var tipoPagoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoPago
	});


	//PERIODICIDAD
	var dictPeriodicidad = <app:dict value="${periodicidad}"/>;
	
	//store generico de combo diccionario
	var periodicidadStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictPeriodicidad
	});
	

	//UNIDAD
	var dictUnidad ={diccionario:[{codigo:'1',descripcion:'Unidad 1'}]};
		

	
	var validarEnvio = function(){
		<c:if test="${!(esGestor && acuerdo.estaVigente)}">
			if (solicitanteCombo.getValue()!= null && !(solicitanteCombo.getValue()==='')){
					return true;
			}	
		</c:if>
		return false;
	}
	
	var btnAceptarConclusiones = new Ext.Button({
	       text : '<s:message code="app.guardar" text="**Guardar" />'
			,iconCls : 'icon_ok'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	       		btnAceptarConclusiones.disable();
				if (!observacionesConclusion.validate()) {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="acuerdos.conclusiones.observaciones.error"/>');
				}				
	      		else if (validarEnvio()){
		      		page.webflow({
		      			flow:'plugin/mejoras/acuerdos/plugin.mejoras.acuerdos.guardarAcuerdo'
		      			,params:{
				      			<c:if test="${idAsunto!=null}">
				      				idAsunto:${idAsunto},
				      			</c:if>
				      			<c:if test="${idExpediente!=null}">
				      				idExpediente:${idExpediente},
				      			</c:if>
<!-- 		      				   tipoAcuerdo:tipoAcuerdoCombo.getValue() -->
		      				   solicitante:solicitanteCombo.getValue()
		      				   ,estado:estadoCombo.getValue()
		      				   ,observaciones:app.resolverSiNulo(observacionesConclusion.getValue())
								,importeCostas:app.resolverSiNulo(importeCostas.getValue())
		      				   <c:if test="${acuerdo!=null}">
		      				   ,idAcuerdo:${acuerdo.id}
		      				   </c:if>
		      				   ,fechaLimite:app.format.dateRenderer(fechaLimite.getValue())
		      				}
		      			,success: function(){
	            		   page.fireEvent(app.event.DONE);
	            		}	
		      		});
	      		}else{
	      			<c:if test="${!(esGestor && acuerdo.estaVigente)}">
	      				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.mejoras.acuerdos.conclusiones.faltanDatosSinTipoAcuerdo" text="**Debe rellenar los datos"/>');
<!-- 	      				if (sinTipoAcuerdo) { -->
<%-- 							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.mejoras.acuerdos.conclusiones.faltanDatosSinTipoAcuerdo" text="**Debe rellenar los datos"/>'); --%>
<!-- 						} else { -->
<%-- 							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.mejoras.acuerdos.conclusiones.faltanDatos" text="**Debe rellenar los datos"/>'); --%>
<!-- 						} -->
	      			</c:if>
	      			<c:if test="${esGestor && acuerdo.estaVigente}">
	      				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="acuerdos.conclusioes.faltaFechaCierre"/>');
	      			</c:if>
					btnAceptarConclusiones.enable();
	      		}
	     	}
	});
		
	var btnCancelarConclusiones = new Ext.Button({
	       text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	      		page.fireEvent(app.event.CANCEL);
	     	}
	});


	var bottomBar = [];
	
	<c:if test="${!readOnly}">
		bottomBar.push(btnAceptarConclusiones);
	</c:if>

	bottomBar.push(btnCancelarConclusiones);

	
	var panelAlta = new Ext.form.FormPanel({
		bodyStyle : 'padding:5px'
		,layout:'anchor'
		,autoHeight : true
		,defaults:{
			border:false
			,cellCls:'vtop'
		}
		,items : [
		 	{ xtype : 'errorList', id:'errL' }
		 	,{
		 		layout:'table'
		 		,autoHeight:true
		 		,border:false
		 		,layoutConfig:{columns:2}
		 		,defaults:{border:false,xtype:'fieldset',autoHeight:true,width:350}
		 		,items:[
		 			{items:[solicitanteCombo,estadoCombo,fechaLimite,importeCostas]}
				 	,{items:[
				 	]}
					,{colspan:2,width:700,items:[tituloobservaciones,{items:observacionesConclusion,border:false,style:'margin-top:5px'}]}
		 		]
		 	}
		]
		,bbar : bottomBar
	});
	

	page.add(panelAlta);

</fwk:page>
