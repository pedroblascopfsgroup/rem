<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>
	

	var tipo = app.creaCombo({
		data : <app:dict value="${tiposBien}" />
		<app:test id="tipoBienCombo" addComa="true" />
		,name : 'bien.tipoBien'
		//,allowBlank : false
		,fieldLabel : '<s:message code="bienesCliente.tipo" text="**Tipo" />'
		,value : '${bien.tipoBien.codigo}'
	});

		debugger;
	var poblacion = app.creaText('bien.poblacion', '<s:message code="bienesCliente.poblacion" text="**Poblacion" />' , '${bien.poblacion}', {maxLength:50});
	
	var refCatastral = app.creaText('bien.referenciaCatastral', '<s:message code="bienesCliente.refcatastral" text="**Ref. catastral" />' , '<s:message text="${bien.referenciaCatastral}" javaScriptEscape="true" />', {maxLength:50,width:250});
	
	var datosRegistrales = app.crearTextArea('<s:message code="bienesCliente.datosRegistrales" text="**Datos registrales" />' , '<s:message text="${bien.datosRegistrales}" javaScriptEscape="true" />',false,'','bien.datosRegistrales', {maxLength:50});
	
	var part = app.creaInteger(
		'bien.participacion'
		, '<s:message code="bienesCliente.participacion" text="**Participacion" />' 
		, '${bien.participacion}'
		, {
			autoCreate : {
				tag: "input"
				, type: "text",maxLength:"3"
				, autocomplete: "off"
			}
			, maxLength:3
			, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener m�s de 8 d�gitos" arguments="3" />'
		}
	);

	var today = new Date();

	var fechaVerif=new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="bienesCliente.fechaverificacion" text="**Fecha VErificacion" />'
		//,labelStyle:labelStyle
		,name:'bien.fechaVerificacion'
		,value:	'<fwk:date value="${bien.fechaVerificacion}" />'
		,maxValue: today
		,style:'margin:0px'		
	});
	var valor = app.creaNumber(
		'bien.valorActual'
		, '<s:message code="bienesCliente.valorActual" text="**Valor actual" />' 
		, '${bien.valorActual}'
		, {
			autoCreate : {
				tag: "input"
				, type: "text"
				,maxLength:"8"
				, autocomplete: "off"
			}
			, maxLength:8
			, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener m�s de 8 d�gitos" arguments="8" />'
		}
	);
	var cargas = app.creaNumber(
		'bien.importeCargas'
		, '<s:message code="bienesCliente.cargas" text="**Cargas" />' 
		, '${bien.importeCargas}'
		, {
			autoCreate : {
				tag: "input"
				, type: "text",maxLength:"8"
				, autocomplete: "off"
			}
			, maxLength:8
			, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener m�s de 8 d�gitos" arguments="8" />'
		}
	);
	var superficie = app.creaNumber(
		'bien.superficie'
		, '<s:message code="bienesCliente.superficie" text="**Superfice en m2" />' 
		, '${bien.superficie}'
		, {
			autoCreate : {
				tag: "input"
				, type: "text"
				,maxLength:"8"
				, autocomplete: "off"
			}
			, maxLength:8
			, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener m�s de 8 d�gitos" arguments="8" />'
		}
	);
			
	
	var descripcion= app.crearTextArea(
		'<s:message code="bienesCliente.descripcion" text="**descripcion" />'
		,'<s:message text="${bien.descripcionBien}" javaScriptEscape="true" />'
		,false
		,''
		,'bien.descripcionBien'
		, {
			maxLength:250 <app:test id="descripcionBien" addComa="true" />
		}
	);
	
	var validarForm = function() {
/*
		if((poblacion.getValue() == null || poblacion.getValue()== '') && poblacion.disabled==false) {
			return false;
		}
*/
		if(tipo.getValue() == null || tipo.getValue()== '' ){
			return false;
		}
/*
		if((refCatastral.getValue() == null || refCatastral.getValue()=== '') && refCatastral.disabled==false) {
			return false;
		}
		if((datosRegistrales.getValue() == null || datosRegistrales.getValue()=== '') && datosRegistrales.disabled==false) {
			return false;
		}
*/
		if(part.getValue() == null || part.getValue()=== '') {
			return false;
		}
		if(valor.getValue() == null || valor.getValue()=== '') {
			return false;
		}
		if(cargas.getValue() == null || cargas.getValue()=== '') {
			return false;
		}
/*
		if((superficie.getValue() == null || superficie.getValue()=== '') && superficie.disabled==false) {
			return false;
		}
*/
		if(descripcion.getValue() == null || descripcion.getValue()=== '') {
			return false;
		}
		return true;
	}

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function() {
						if(validarForm()){
							//datosRegistrales.enable();
							//refCatastral.enable();
							//poblacion.enable();
							//superficie.enable();
							page.submit({
								eventName : 'update'
								,formPanel : panelEdicion
								,success : function(){ page.fireEvent(app.event.DONE); }
							});
						}else{
							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="bienesCliente.form.camposIncompletos"/>');
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

	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[tipo, part,valor, cargas , descripcion ]
						,columnWidth:.5
					},{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,columnWidth:.5
						,items:[ refCatastral, superficie ,poblacion, datosRegistrales,fechaVerif]
					}
				]
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});

	var desactivarCamposInmueble = function() {
	//El cliente no quiere que se habiliten los campos. Los quiere siempre activos. Se comprobar�n cuando de verdad se diferencien con un tipo los bienes/inmuebles
/*
		if(tipo.getValue()==app.tipoBien.CODIGO_TIPOBIEN_PISO || tipo.getValue()==app.tipoBien.CODIGO_TIPOBIEN_FINCA) {
			datosRegistrales.enable();
			refCatastral.enable();
			poblacion.enable();
			superficie.enable();
		} else {
			datosRegistrales.disable();
			refCatastral.disable();
			poblacion.disable();
			superficie.disable();
		}
*/
	};

	tipo.on('select',desactivarCamposInmueble);
	desactivarCamposInmueble();

	page.add(panelEdicion);
	
</fwk:page>
