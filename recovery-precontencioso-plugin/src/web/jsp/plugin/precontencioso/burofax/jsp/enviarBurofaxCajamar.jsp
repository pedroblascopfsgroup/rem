<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>

	<sec:authentication var="user" property="principal" />
	var arrayIdEnvios='${arrayIdEnvios}';
	var arrayIdContrato='${arrayIdContrato}';
	
	var certificado = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.precontencioso.grid.burofax.requiereCertificado" text="**Requiere Certificado" />'
		,name:'certificado'
        ,checked:false
        ,readOnly:true
	});
	
	
   
	var arrayIdBurofax='${arrayIdBurofax}';
    var arrayIdDirecciones='${arrayIdDirecciones}';
    var comboEditable='${comboEditable}';
    
   <c:if test="${comboEditable}">
   
	<pfsforms:ddCombo name="tipoBurofax"  
		labelKey="plugin.precontencioso.grid.burofax.tipoBurofax" 
 		label="**Tipo Burofax" value="${idTipoBurofax}" dd="${listaTipoBurofax}" 
		propertyCodigo="id" propertyDescripcion="descripcion" obligatory="true"/> 
		
  </c:if>
  
  <c:if test="${!comboEditable}">
  	<pfsforms:textfield name="tipoBurofaxNoEditable"
			labelKey="plugin.precontencioso.grid.burofax.tipoBurofax" label="**Tipo Burofax"
			value="${descripcionTipoBurofax}" readOnly="true" width="150"/>	
			
			
   var tipoBurofax = new Ext.form.TextField({
		name : 'tipoBurofax'
		,value : "${idTipoBurofax}"
		,fieldLabel : 'email'
		,visible:false
	});
  </c:if>
  

	<%-- Combo Propietarias --%>

	var propietariasRecord = Ext.data.Record.create([
		{name : 'codigo'},
		{name: 'descripcion'}
	]);

	var propietariasStore = page.getStore({
		flow: 'liquidaciondoc/obtenerPropietarias',
		reader: new Ext.data.JsonReader({
			root: 'propietarias'
		}, propietariasRecord)
	});

	var comboPropietarias = new Ext.form.ComboBox({
		store: propietariasStore,
		displayField: 'descripcion',
		valueField: 'codigo',
		mode: 'local',
		allowBlank: false,
		forceSelection: true,
		triggerAction: 'all',
		disabled: false,
		width: 380,
		editable: true,
		emptyText:'<s:message code="rec-web.direccion.form.seleccionar" text="**Seleccionar" />',
		fieldLabel: '<s:message code="plugin.precontencioso.liquidaciones.generar.entidad" text="**Entidad propietaria" />'
	});
	
	comboPropietarias.on('afterrender', function(combo) {
		propietariasStore.webflow();
	});

	<%-- Combo Localidades Firma --%>

	var localidadesRecord = Ext.data.Record.create([
		{name: 'descripcion'}
	]);

	var localidadesStore = page.getStore({
		flow: 'liquidaciondoc/obtenerLocalidadesFirma',
		reader: new Ext.data.JsonReader({
			root: 'localidadesFirma'
		}, localidadesRecord)
	});

	var comboLocalidades = new Ext.form.ComboBox({
		store: localidadesStore,
		displayField: 'descripcion',
		valueField: 'descripcion',
		mode: 'local',
		allowBlank: false,
		forceSelection: true,
		triggerAction: 'all',
		disabled: false,
		width: 150,
		editable: true,
		emptyText:'<s:message code="rec-web.direccion.form.seleccionar" text="**Seleccionar" />',
		fieldLabel: '<s:message code="plugin.precontencioso.docInstancia.centroRecuperacion" text="**Centro de recuperaci&oacute;n" />'
	});
	
	comboLocalidades.on('afterrender', function(combo) {
		localidadesStore.webflow();
	});

	var notario = new Ext.form.TextField({
		name : 'notario'
		,width: 380
		,allowBlank : true
		,value : '<s:message text="${dtoDoc.notario}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.notario" text="**Notario" />'
	});  
	
	var manual = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.precontencioso.grid.burofax.procesadoManual" text="**Procesado manual" />'
		,name:'manual'
        ,checked:false
        ,readOnly:true
	});
	
	var bottomBar = [];

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			var mask=new Ext.LoadMask(panelEdicion.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
			if (tipoBurofax.getValue() == '' || tipoBurofax.getActiveError() != '') {
				Ext.Msg.alert(fwk.constant.alert, '<s:message code="plugin.precontencioso.enviar.burofax.errorTipoBur" text="** Tipo burofax obligatorio" />');
				return;
			}else if (comboPropietarias.getValue() == '' || comboPropietarias.getActiveError() != '') {
				Ext.Msg.alert(fwk.constant.alert, '<s:message code="plugin.precontencioso.enviar.burofax.errorEntidadPropietaria" text="** Entidad propietaria obligatoria" />');
				return;
			}else if (comboLocalidades.getValue() == '' || comboLocalidades.getActiveError() != '') {
				Ext.Msg.alert(fwk.constant.alert, '<s:message code="plugin.precontencioso.docInstancia.faltaLocalidadFirma" text="** Debe informar el centro de recuperaci&oacute;" />');
				return;
			}else {
				mask.show();
				page.webflow({
					flow: 'burofaxcm/guardarEnvioBurofax', 
					params : {arrayIdEnvios:arrayIdEnvios,arrayIdContrato:arrayIdContrato,certificado:certificado.getValue(),idTipoBurofax:tipoBurofax.getValue(),arrayIdDirecciones:arrayIdDirecciones,
						arrayIdBurofax:arrayIdBurofax,comboEditable:comboEditable, 
						codigoPropietaria: comboPropietarias.getValue(), localidadFirma: comboLocalidades.getValue(), notario: notario.getValue(), manual:manual.getValue()},
					success: function ( result, request ) {
						if(result.msgError==''){
							mask.hide();
							page.fireEvent(app.event.DONE);
						}else{
							mask.hide();
							Ext.Msg.show({
								title: fwk.constant.alert,
								msg: result.msgError,
								buttons: Ext.Msg.OK
							});
						}
					}
				});
			}
		}
	});
	
	var btnCancelar = new Ext.Button({
       text:  '<s:message code="app.cancelar" text="**Cancelar" />'
       <app:test id="btnCancelarAnalisis" addComa="true" />
       ,iconCls : 'icon_cancel'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
      		page.fireEvent(app.event.CANCEL);
     	}
    });
	
	bottomBar.push(btnGuardar);
	bottomBar.push(btnCancelar);
	
	<c:if test="${comboEditable}">
		var panelEdicion=new Ext.form.FormPanel({
			autoHeight:true
			,width:700
			,bodyStyle:'padding:10px;cellspacing:20px'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items : [certificado,tipoBurofax,comboPropietarias,comboLocalidades,notario,manual]
			,bbar:bottomBar
		});
	</c:if>
	
	<c:if test="${!comboEditable}">
		var panelEdicion=new Ext.form.FormPanel({
			autoHeight:true
			,width:700
			,bodyStyle:'padding:10px;cellspacing:20px'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items : [certificado,tipoBurofaxNoEditable,comboPropietarias,comboLocalidades,notario,manual]
			,bbar:bottomBar
		});
	</c:if>
	
	page.add(panelEdicion);

</fwk:page>