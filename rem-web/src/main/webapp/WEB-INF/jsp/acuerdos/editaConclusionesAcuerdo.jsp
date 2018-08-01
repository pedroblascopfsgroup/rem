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

	//TIPO ACUERDO

	var dictTipoAcuerdo = <app:dict value="${tiposAcuerdo}"/>;

	//store generico de combo diccionario
	var tipoAcuerdoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoAcuerdo
	});

	var tipoAcuerdoCombo = new Ext.form.ComboBox({
				name:'tipoAcuerdoCombo'
				<app:test id="editTipoAcuerdoCombo" addComa="true" />
				,hiddenName:'tipoAcuerdoCombo'
				,store:tipoAcuerdoStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'----'
				,style:'margin:0px'
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,readOnly:${readOnly}
				,disabled:${esGestor && acuerdo.estaVigente}
				,fieldLabel : '<s:message code="acuerdo.conclusiones.tipoAcuerdoCombo" text="**Tipo Acuerdo" />'
				<c:if test="${acuerdo!=null}">
	      		,value:"${acuerdo.estadoAcuerdo.codigo}" 
	      		</c:if>
	});

	//SOLICITANTE
	debugger;
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
	
	
	//es supervisor: ${esSupervisor}
	//es acuerdo null?: ${acuerdo==null}
	//es gestor: ${esGestor}

	var estado = <c:choose >
					<c:when test="${esSupervisor && acuerdo==null}">
						app.codigoAcuerdoVigente; //se está dando de alta, y es un supervisor, se crea en estado vigente;
					</c:when>
					<c:when test="${esGestor && acuerdo==null}">
						app.codigoAcuerdoEnConformacion; //se está dando de alta, y es un gestor, se crea en conformación;
					</c:when>
					<c:when test="${acuerdo!=null}">
						"${acuerdo.estadoAcuerdo.codigo}"; //tomo el estado que está cargado
					</c:when>
					<c:otherwise>
						app.codigoAcuerdoEnConformacion;
					</c:otherwise>
				 </c:choose>
	
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
			,value:estado
			,fieldLabel : '<s:message code="acuerdo.conclusiones.estadoCombo" text="**Estado" />'
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

	//TIPO DE PAGO
	var dictTipoPago = <app:dict value="${tiposPago}"/>;
	
	//store generico de combo diccionario
	var tipoPagoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoPago
	});
	
	var tipoPagoCombo = new Ext.form.ComboBox({
				name:'tipoPagoCombo'
				<app:test id="editTipoPagoCombo" addComa="true" />
				,hiddenName:'tipoPagoCombo'
				,store:tipoPagoStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'----'
				,style:'margin:0px'
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,readOnly:${readOnly}
				,disabled:${esGestor && acuerdo.estaVigente}
				,fieldLabel : '<s:message code="acuerdo.conclusiones.tipoPagoCombo" text="**Tipo Pago" />'
				<c:if test="${acuerdo!=null}">
	      		,value:"${acuerdo.tipoPagoAcuerdo.codigo}" 
	      		</c:if>
	});


	//PERIODICIDAD
	var dictPeriodicidad = <app:dict value="${periodicidad}"/>;
	
	//store generico de combo diccionario
	var periodicidadStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictPeriodicidad
	});
	
	var periodicidadCombo = new Ext.form.ComboBox({
				name:'periodicidadCombo'
				<app:test id="editPeriodicidadCombo" addComa="true" />
				,hiddenName:'periodicidadCombo'
				,store:periodicidadStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,style:'margin:0px'
				,emptyText:'----'
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,readOnly:${readOnly}
				,disabled:${esGestor && acuerdo.estaVigente}
				,fieldLabel : '<s:message code="acuerdo.conclusiones.periodicidadCombo" text="**Periodicidad" />'
				<c:if test="${acuerdo!=null}">
	      		,value:"${acuerdo.periodicidadAcuerdo.codigo}" 
	      		</c:if>
	});

	//UNIDAD
	var dictUnidad ={diccionario:[{codigo:'1',descripcion:'Unidad 1'}]};
	

	//IMPORTE PAGO
	var importePago  = app.creaNumber('importePago',
		'<s:message code="acuerdo.conclusiones.importePago" text="**Importe Pago" />',
		'',
		{
			labelStyle:labelStyle
			<app:test id="editImportePagoNumber" addComa="true" />
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			,disabled:${esGestor && acuerdo.estaVigente}
			,readOnly:${readOnly}
			,width:160
			,autoCreate : {tag: "input", type: "text",maxLength:"13", autocomplete: "off"}
		}
	);

	importePago.setValue('${acuerdo.importePago}');
	
	
	//PERIODO
	var periodo  = app.creaNumber('periodo',
		'<s:message code="acuerdo.conclusiones.periodo" text="**Período" />',
		'',
		{
			labelStyle:labelStyle
			<app:test id="editPeriodoNumber" addComa="true" />
			,style:style
			,allowDecimals: false
			,allowNegative: false
			,maxLength:3
			,disabled:${esGestor && acuerdo.estaVigente}
			,readOnly:${readOnly}
			,width:160
			,autoCreate : {tag: "input", type: "text",maxLength:"3", autocomplete: "off"}
		}
	);

	periodo.setValue('${acuerdo.periodo}');
	
	var validarEnvio = function(){
		<c:if test="${!(esGestor && acuerdo.estaVigente)}">
		if (tipoAcuerdoCombo.getValue()!= null && !(tipoAcuerdoCombo.getValue()==='')){
			if (solicitanteCombo.getValue()!= null && !(solicitanteCombo.getValue()==='')){
				return true;
			}
		}		
		</c:if>
		<c:if test="${(esGestor || esSupervisor) && acuerdo.estaVigente}">
			if (fechaCierre.getValue()!=null && !(fechaCierre.getValue()==="")){
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
		      			flow:"acuerdos/guardarAcuerdo"
		      			,params:{
		      				   idAsunto:${idAsunto} 
		      				   ,tipoAcuerdo:tipoAcuerdoCombo.getValue()
		      				   ,solicitante:solicitanteCombo.getValue()
		      				   ,estado:estadoCombo.getValue()
		      				   ,tipoPago:app.resolverSiNulo(tipoPagoCombo.getValue())
		      				   ,importePago:app.resolverSiNulo(importePago.getValue())
		      				   ,observaciones:app.resolverSiNulo(observacionesConclusion.getValue())
		      				   ,periodicidad:app.resolverSiNulo(periodicidadCombo.getValue())
		      				   ,periodo:app.resolverSiNulo(periodo.getValue())
		      				   <c:if test="${acuerdo!=null}">
		      				   ,idAcuerdo:${acuerdo.id}
		      				   </c:if>
		      				   <c:if test="${(esGestor || esSupervisor) && acuerdo.estaVigente}">
		      				   ,fechaCierre:app.format.dateRenderer(fechaCierre.getValue())
		      				   </c:if>
		      				}
		      			,success: function(){
	            		   page.fireEvent(app.event.DONE);
	            		}	
		      		});
	      		}else{
	      			<c:if test="${!(esGestor && acuerdo.estaVigente)}">
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="acuerdos.conclusioes.faltanDatos"/>');
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

	<c:if test="${(esGestor || esSupervisor) && acuerdo.estaVigente}">
		var fechaCierre = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="acuerdos.fechaCierre" text="**Fecha Cierre" />'
			,name:'fechaCierre'
			,style:'margin:0px'
			,labelStyle:labelStyleTextField
		});
		//app.format.dateRenderer(fechaCreacionDesde.getValue());
	</c:if>


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
		 			{items:[tipoAcuerdoCombo,solicitanteCombo,estadoCombo,{html:'&nbsp;',border:false}]}
				 	,{items:[
						tipoPagoCombo
						,importePago
				 		,periodicidadCombo
				 		,periodo
				 		<c:if test="${(esGestor || esSupervisor) && acuerdo.estaVigente}">
				 		,fechaCierre
				 		</c:if>
				 	]}
					,{colspan:2,width:700,items:[tituloobservaciones,{items:observacionesConclusion,border:false,style:'margin-top:5px'}]}
		 		]
		 	}
		]
		,bbar : bottomBar
	});
	

	page.add(panelAlta);

</fwk:page>
