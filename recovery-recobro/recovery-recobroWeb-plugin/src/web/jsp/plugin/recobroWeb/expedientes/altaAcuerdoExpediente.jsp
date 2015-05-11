<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	var labelStyle='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:120px'
	var labelStyleTextField='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:160px'	
	var style='margin-bottom:1px;margin-top:1px';

	var dictDespacho = <app:dict value="${despachosExterno}"/>;

	var despachosStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictDespacho
	});
	
	var despachoCombo = new Ext.form.ComboBox({
				name:'despachoCombo'
				<app:test id="editDespacho" addComa="true" />
				,hiddenName:'despachoCombo'
				,store:despachosStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'----'
				,style:'margin:0px'
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,allowBlank: false
				,fieldLabel : '<s:message code="plugin.recobroConfig.agencia.alta.despachoAgencia" text="**Grupo" />'
				<c:if test="${acuerdo!=null}">
	      			,value:"${acuerdo.despacho.codigo}" 
	      		</c:if>
	});
 		
	//TIPO ACUERDO

	var dictTipoAcuerdo = <app:dict value="${palancasPermitidas}"/>;

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
				,allowBlank: false
				//,readOnly:${readOnly}
				//,disabled:${esGestor && acuerdo.estaVigente}
				,fieldLabel : '<s:message code="acuerdo.conclusiones.tipoAcuerdoCombo" text="**Tipo Acuerdo" />'
				<c:if test="${acuerdo!=null}">
	      			,value:"${acuerdo.tipoPalanca.codigo}" 
	      		</c:if>
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
			,allowBlank: false
			//,readOnly:${readOnly}
			//,disabled:${esGestor && acuerdo.estaVigente}
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
					<c:when test="${acuerdo==null}">
						app.codigoAcuerdoEnConformacion; //se está dando de alta
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
		//,readOnly:${readOnly}
		//,disabled:${esGestor && acuerdo.estaVigente}
		<c:if test="${acuerdo!=null}">
	      ,value:'<s:message javaScriptEscape="true" text="${acuerdo.observaciones}"/>' 
	    </c:if>	
	});
	<%--
	var creaDblSelectMio = function(label, config){
	
	var store = config.store ;
	var cfg = {
	    	fieldLabel: label || ''
	    	,displayField:'descripcion'
	    	,valueField: 'codigo'
	    	,imagePath:"/${appProperties.appName}/js/fwk/ext.ux/Multiselect/images/"
	    	,dataFields : ['codigo', 'descripcion']
	    	,fromStore:store
	    	,toData : []
	        ,msHeight : config.height || 80
			,labelStyle:labelStyle
	        ,msWidth : config.width || 180
	        ,drawTopIcon:false
	        ,drawBotIcon:false
	        ,drawUpIcon:false
			,drawDownIcon:false
			,disabled:false
			,toSortField : 'codigo'
	    };
	if(config.id) {
		cfg.id = config.id;
	}


	var itemSelector = new Ext.ux.ItemSelector(cfg);
	if (config.funcionReset){
		itemSelector.funcionReset = config.funcionReset;
	}


	//modificación al itemSelector porque no tiene un método setValue. Si se cambia de versión se tendrá que revisar la validez de este método
	itemSelector.setValue =  function(val) {
        if(!val) {
            return;
        }
        val = val instanceof Array ? val : val.split(',');
        var rec, i, id;
        for(i = 0; i < val.length; i++) {
            id = val[i];
            if(this.toStore.find('id',id)>=0) {
                continue;
            }
            rec = this.fromStore.find('id',id);
            if(rec>=0) {
            	rec = this.fromStore.getAt(rec);
                this.toStore.add(rec);
                this.fromStore.remove(rec);
            }
        }
    };

	itemSelector.getStore =  function() {
		return this.toStore;
	};


	return itemSelector;
	}; 
	
	var contrato = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsListContratosStore = page.getStore({
		flow: 'incidenciaexpediente/getListadoContratosExpediente'
		,reader: new Ext.data.JsonReader({
			root : 'listado'
	      }, contrato)
	     }); 
	     
	optionsListContratosStore.webflow({'id':'${idExpediente}'});
	alert('${contratosAcuerdo}');
	     
	var recargarComboContratos = function(){
		optionsListContratosStore.webflow({'id':'${idExpediente}'}); 
		comboContratos.setValue('${contratosAcuerdo}');
	};	     
	     
	var comboContratos = creaDblSelectMio('<s:message code="plugin.expediente.incidencias.nuevaIncidencia.contrato" text="**Contratos" />'
	,{store:optionsListContratosStore, funcionReset:recargarComboContratos});
	 --%>
	 
	var contratosExpediente = <app:dict value="${contratos}"/>;
	var comboContratos = app.creaDblSelect(contratosExpediente
                              ,'<s:message code="recobroWeb.acuerdoExpediente.altaAcuerdo.contratos" text="**Contratos" />'
                              ,{width: 200,height: 100});
      
    comboContratos.setValue('${contratosAcuerdo}');         
	 
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
			,allowBlank: false
			//,disabled:${esGestor && acuerdo.estaVigente}
			//,readOnly:${readOnly}
			,width:160
			,autoCreate : {tag: "input", type: "text",maxLength:"13", autocomplete: "off"}
		}
	);

	importePago.setValue('${acuerdo.importePago}');
	
	
	//PERIODO
	var quita  = app.creaNumber('quita',
		'<s:message code="recobroWeb.acuerdoExpediente.altaAcuerdo.quita" text="**% Quita" />',
		'',
		{
			labelStyle:labelStyle
			<app:test id="editPeriodoNumber" addComa="true" />
			,style:style
			,allowDecimals: false
			,allowNegative: false
			,maxLength:3
			//,disabled:${esGestor && acuerdo.estaVigente}
			//,readOnly:${readOnly}
			,width:160
			,autoCreate : {tag: "input", type: "text",maxLength:"3", autocomplete: "off"}
		}
	);

	quita.setValue('${acuerdo.porcentajeQuita}');
	<%-- 
	var validarEnvio = function(){
		<c:if test="${!(esGestor && acuerdo.estaVigente)}">
		if (tipoAcuerdoCombo.getValue()!= null && !(tipoAcuerdoCombo.getValue()==='')){
			if (solicitanteCombo.getValue()!= null && !(solicitanteCombo.getValue()==='')){
				if (periodicidadCombo.getValue() != null && !(periodicidadCombo.getValue()==='')){
					if(periodo.getValue() != null && !(periodo.getValue()==='')){
						if(importePago.getValue() != null && !(importePago.getValue()==='')){
							return true;
						}
					}
				}
			}
		}		
		</c:if>
		<c:if test="${(esGestor || esSupervisor) && acuerdo.estaVigente}">
			if (fechaCierre.getValue()!=null && !(fechaCierre.getValue()==="")){
				return true;
			}
		</c:if>
		return false;
	}--%>
	
	var validarEnvio = function(){
		if (despachoCombo.getValue()!= null && !(despachoCombo.getValue()==='')){	
			if (tipoAcuerdoCombo.getValue()!= null && !(tipoAcuerdoCombo.getValue()==='')){
				if (solicitanteCombo.getValue()!= null && !(solicitanteCombo.getValue()==='')){
					if(importePago.getValue() != null && !(importePago.getValue()==='')){
						if (comboContratos.getValue()!= null && !(comboContratos.getValue()==='')){
							return true;
						}
					}
				}
			}
		}
		return false;	
	}
	
	var btnAceptarConclusiones = new Ext.Button({
	       text : '<s:message code="app.guardar" text="**Guardar" />'
			,iconCls : 'icon_ok'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
				if (!observacionesConclusion.validate()) {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="acuerdos.conclusiones.observaciones.error"/>');
				}				
	      		else if (validarEnvio()){
		      		page.webflow({
		      			flow:'expedienterecobro/guardarAcuerdoExpediente'
		      			,params:{
		      				   idExpediente:${idExpediente} 
		      				   ,tipoPalanca:tipoAcuerdoCombo.getValue()
		      				   ,solicitante:solicitanteCombo.getValue()
		      				   ,estado:estadoCombo.getValue()
		      				   ,contratos:comboContratos.getValue()
		      				   ,importePago:app.resolverSiNulo(importePago.getValue())
		      				   ,observaciones:app.resolverSiNulo(observacionesConclusion.getValue())
		      				   ,quita:quita.getValue()
		      				   ,idDespacho:despachoCombo.getValue()
		      				   <c:if test="${acuerdo!=null}">
		      				   ,idAcuerdo:${acuerdo.id}
		      				   </c:if>
		      				}
		      			,success: function(){
	            		   page.fireEvent(app.event.DONE);
	            		}	
		      		});
	      		}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="recobroWeb.acuerdoExpediente.altaAcuerdo.faltanDatos" text="**Faltan datos"/>');
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
		 			{items:[tipoAcuerdoCombo,solicitanteCombo,estadoCombo]}
				 	,{items:[despachoCombo,importePago,quita]}
				 	,{colspan:2,width:600,items:[comboContratos]}
					,{colspan:2,width:700,items:[tituloobservaciones,{items:observacionesConclusion,border:false,style:'margin-top:5px'}]}
		 		]
		 	}
		]
		,bbar : bottomBar
	});
	

	page.add(panelAlta);

</fwk:page>
