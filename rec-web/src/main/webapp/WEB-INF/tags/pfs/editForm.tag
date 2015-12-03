<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="parameters" required="true" type="java.lang.String"%>
<%@ attribute name="saveOrUpdateFlow" required="true" type="java.lang.String"%>
<%@ attribute name="leftColumFields" required="true" type="java.lang.String"%>
<%@ attribute name="rightColumFields" required="false" type="java.lang.String"%>
<%@ attribute name="centerColumFieldsUp" required="false" type="java.lang.String"%>
<%@ attribute name="centerColumFieldsDown" required="false" type="java.lang.String"%>
<%@ attribute name="detailPanel" required="false" type="java.lang.String"%>

<%@ attribute name="onSuccessMode" required="false" type="java.lang.String"%>
<%@ attribute name="tab_iconCls" required="false" type="java.lang.String"%>
<%@ attribute name="tab_paramName" required="false" type="java.lang.String"%>
<%@ attribute name="tab_paramValue" required="false" type="java.lang.String"%>
<%@ attribute name="tab_titleData" required="false" type="java.lang.String"%>
<%@ attribute name="tab_flow" required="false" type="java.lang.String"%>
<%@ attribute name="tab_type" required="false" type="java.lang.String"%>


<c:choose>
	<c:when test="${onSuccessMode == 'tab'}">
		var ${name}_handler =  function() {
			var p = ${parameters}();
			p.event = "guardar";
			
			Ext.Ajax.request({
				url : page.resolveUrl('${saveOrUpdateFlow}'), 
				params : p,
				method: 'POST',
				success: function ( result, request ) {
					var result = Ext.util.JSON.decode(result.responseText);
					var param = {${tab_paramName}:result.${tab_paramValue}};
					//Ext.MessageBox.alert('Success', 'parametros= ' + param);
					app.openTab(${tab_titleData}.getValue()
						,'${tab_flow}'
						,param
						,{id:'${tab_type}'+result.${tab_paramValue}<c:if test="${tab_iconCls != null}">,iconCls:'${tab_iconCls}'</c:if>});
					page.fireEvent(app.event.DONE);
				}
				<%--,failure: function ( result, request) { 
					Ext.MessageBox.alert('Failed', result.responseText); 
				} --%> 
			});
		};
	</c:when>
	
	<%--  	/* BKREC-1349
			* Alternativa al handler de arriba, la diferencia reside en que en el siguiente handler, mostrar un mensaje de  
		 	* 'Guardando...' cuando esta procesando la operación de guardar, oscureciendo la pantalla. 
		 	* De esta forma el user puede ver que al pulsar el botón Guardar, esta realizando cálculos, y debe esperar. 
		 	*/ --%> 
	<c:when test="${onSuccessMode == 'tabConMsgGuardando'}">
		var ${name}_handler =  function() {
			var p = ${parameters}();
			p.event = "guardar";
			
			
			if(p.tipoTab !=null && p.tipoTab=="altaUsuarios")
			{
				if(p.permiteGuardar != null && ((p.despachoExterno == "" && p.tipoDespacho != "") || (p.despachoExterno != "" && p.tipoDespacho == "")) )
					p.permiteGuardar = false;
			}
			<%-- BKREC-1492 - Este if sirve para controlar si algun campo recibido es erroneo, y asi que no deje guardar el proceso
				En caso de que no existe el parametro 'permiteGuardar' no pasará nada, y seguirá su cauce natural. --%>
			if(p.permiteGuardar == null || p.permiteGuardar) {
				new Ext.LoadMask(panelEdicion.body, {msg:'<s:message code="fwk.ui.form.guardando" text="**Guardando.."/>'}).show();
				
				Ext.Ajax.request({
					url : page.resolveUrl('${saveOrUpdateFlow}'), 
					params : p,
					method: 'POST',
					success: function ( result, request ) {
						var result = Ext.util.JSON.decode(result.responseText);
						var param = {${tab_paramName}:result.${tab_paramValue}};
						//Ext.MessageBox.alert('Success', 'parametros= ' + param);
						app.openTab(${tab_titleData}.getValue()
							,'${tab_flow}'
							,param
							,{id:'${tab_type}'+result.${tab_paramValue}<c:if test="${tab_iconCls != null}">,iconCls:'${tab_iconCls}'</c:if>});
						page.fireEvent(app.event.DONE);
					}
	
				});
			}
			else{
				Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.camposObligatorios" text="**Debe rellenar los campos obligatorios." />');
				btnGuardar.setDisabled(false);
       		 	btnCancelar.setDisabled(false);					
			}
		};
	</c:when>
	
	<%--	/** BKREC-1349
			* Alternativa al handler de ABAJO, se ha creado por lo mismo que el de arriba, solo que para este caso es un handler más
			* simple y genérico. 
			* Es decir, para las etiquetas <pfs:editForm ...> que no tengan el parametro onSuccessMode, le añadimos el parametro
			* con el valor tabGenericoConMsgGuardando, para que les salga el mensaje de Guardando... mientras se resuelve la petición.
			*/ --%> 
	<c:when test="${onSuccessMode == 'tabGenericoConMsgGuardando'}">
		var ${name}_handler =  function() {
			var p = ${parameters}();
			
			<%-- Los siguientes 2 if solo funcionan con supervisardespacho.jsp y asociaPerfilUsuario.jsp --%>
			if(p.tipoTab !=null && p.tipoTab=="supervisardespacho")
			{
				if(p.permiteGuardar != null && p.despachoExterno == "")
					p.permiteGuardar = false;
			}
			if(p.tipoTab !=null && p.tipoTab=="asociaPerfilUsuario")
			{
				if(p.permiteGuardar != null && (p.password == "" || p.idsZona == "" || p.idPerfil == ""))
					p.permiteGuardar = false;
			}					
			
			if(p.permiteGuardar == null || p.permiteGuardar) {
				new Ext.LoadMask(panelEdicion.body, {msg:'<s:message code="fwk.ui.form.guardando" text="**Guardando.."/>'}).show();
		
				page.webflow({
					flow: '${saveOrUpdateFlow}'
					,params: ${parameters}
					,success : ${name}_onsuccess
				});
			}
			else{
				Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.camposObligatorios" text="**Debe rellenar los campos obligatorios." />');		
				btnGuardar.setDisabled(false);
       		 	btnCancelar.setDisabled(false);			
			}
		};
		var ${name}_onsuccess = function(){ 
			page.fireEvent(app.event.DONE); 
		};
	</c:when>
	
	<c:otherwise>
	
		var ${name}_handler =  function() {
						page.webflow({
							flow: '${saveOrUpdateFlow}'
							,params: ${parameters}
							,success : ${name}_onsuccess
						});
		};
		var ${name}_onsuccess = function(){ 
			page.fireEvent(app.event.DONE); 
		};
	</c:otherwise>
</c:choose>

var btnGuardar = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : ${name}_handler
	});

	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="pfs.tags.editform.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.CANCEL); }
	});

	var panelEdicion = new Ext.Panel({
		autoHeight : true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			<c:if test="${centerColumFieldsUp != null}">
			, { layout:'form'
				,border:false
				,defaults:{xtype:'fieldset',bodyStyle:'padding-left:30px',border:false}
				,bodyStyle:'padding-left:20px; padding-top:10px; padding-bottom:0px;'
				,items:[${centerColumFieldsUp}]}
			</c:if>
			,{   autoHeight:true
				,layout:'table'
				<c:if test="${rightColumFields != null}">,layoutConfig:{columns:2}</c:if>
				<c:if test="${rightColumFields == null}">,layoutConfig:{columns:1}</c:if>
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype : 'fieldset',autoWidth : true, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
				,items:[{items: [${leftColumFields}]}
						<c:if test="${rightColumFields != null}">,{items: [${rightColumFields}]}</c:if>
				]
			}
			<c:if test="${centerColumFieldsDown != null}">
			, {  layout:'form'
				,border:false
				,defaults:{xtype:'fieldset',bodyStyle:'padding-left:30px',border:false}
				,bodyStyle:'padding-left:20px; padding-bottom:10px;'
				,items:[${centerColumFieldsDown}]}
			</c:if>
			<c:if test="${detailPanel != null}">
			, ${detailPanel}
			</c:if>
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});	

	<c:if test="${detailPanel != null}">
	${detailPanel}_Store.webflow(${detailPanel}_store__params);
	</c:if>
	page.add(panelEdicion);