<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	var labelStyle='font-weight:bolder;width:100';
	var style='margin-bottom:1px;margin-top:1px';
	var id = new Ext.form.Hidden({
		id:'cobroPago.id'
		,value:'${cobroPago.id}'
	});
	var dictDDEstadoCobroPago = <app:dict value="${estado}" />; 

	var comboDDEstadoCobroPago = app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,root: 'diccionario'
	    ,data: dictDDEstadoCobroPago
		,labelStyle:labelStyle
		,name : 'cobroPago.estado'
		,fieldLabel : '<s:message code="cobroPago.estado" text="**estado"/>'
		,width : 200
		,editable : true
		//, forceSelection : true
		<c:if test="${cobroPago.estado!=null}" >
			,value:'${cobroPago.estado.codigo}'
		</c:if>
	});

	
	var dictDDTipoCobroPago = <app:dict value="${tipo}" />;
	
	var comboDDTipoCobroPago = app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,root: 'diccionario'
	    ,data: dictDDTipoCobroPago
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="cobroPago.tipo" text="**Tipo"/>'
		,width : 200
		,editable : true
		, forceSelection : true
		<c:if test="${cobroPago.subTipo!=null}" >
		,value:'${cobroPago.subTipo.tipoCobroPago}'
		</c:if>
	});
	
	var subTipo = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsDDSubtipoCobroPagoStore = page.getStore({
	       flow: 'asuntos/buscarSubtipoCobroPago'
	      // ,params: {id:comboDespachos.getValue()}
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'subtipos'
	    }, subTipo)
	       
	});
	
	var comboDDSubtipoCobroPago = new Ext.form.ComboBox({
		store:optionsDDSubtipoCobroPagoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'local'
		,editable: false
		,triggerAction: 'all'
		,readOnly:true
		//,forceSelection : true
		,labelStyle:labelStyle
		,width:200
		//,name:'cobroPago.subTipo'
		,resizable:true
		,style:style
		,fieldLabel : '<s:message code="cobroPago.subTipo" text="**subTipo"/>'
		
	});
	
	
	var recargarComboSubtipo = function(){
		//optionsGestoresStore.webflow({id:comboDespachos.getValue()});
		//comboDDTipoCobroPago.reset();
		optionsDDSubtipoCobroPagoStore.webflow({tipo:comboDDTipoCobroPago.getValue()});
		comboDDSubtipoCobroPago.clearValue();
		//comboGestores.enable();
		//comboDDSubtipoCobroPago.focus();
		//comboSupervisores.enable();
	}
	
	var bloquearComboSubtipo = function(){
		comboDDSubtipoCobroPago.disable();
		comboDDSubtipoCobroPago.reset();
		comboDDTipoCobroPago.disable();
		comboDDTipoCobroPago.reset();
		
	}
	
	//comboDDTipoCobroPago.on('focus',bloquearComboSubtipo);
	
	comboDDTipoCobroPago.on('change',recargarComboSubtipo);
	
	
	
	
	var procedimientos={"procedimientos":<json:array name="procedimientos" items='${procedimientos}' var="rec" >
		<json:object>
			<json:property name="id" value="${rec.id}"/>
			<json:property name="procedimiento" value="${rec.nombreProcedimiento}"/>
		
		</json:object>
	</json:array>};

	
	var procedimientoStore = new Ext.data.JsonStore({
		 fields: ['id', 'procedimiento']
		,root: 'procedimientos'
		,data : procedimientos
	});

	var comboProcedimientos = new Ext.form.ComboBox({
		store:procedimientoStore
		,displayField:'procedimiento'
		,valueField:'id'
		,mode: 'local'
		,editable: false
		,triggerAction: 'all'
		,labelStyle:labelStyle
		,width:200
		//,name:'procedimiento'
		,resizable:true
		,style:style
		,fieldLabel : '<s:message code="cobroPago.procedimiento" text="**procedimiento"/>'
		<c:if test="${cobroPago.procedimiento!=null}" >
		,value:'${cobroPago.procedimiento.id}'
		</c:if>
	});
	
	
	var fecha = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="cobroPago.fecha" text="**fecha" />'
		,name:'cobroPago.fecha'
		,style:'margin:0px'
		,labelStyle:labelStyle
		,value: '<fwk:date value="${cobroPago.fecha}" />'
	});
	
	
	var importePago  = app.creaNumber('cobroPago.importe',
		'<s:message code="cobroPago.importe" text="**Importe" />',
		'${cobroPago.importe}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${cobroPago.importe!=null}" >
			,value:'${cobroPago.importe}'
			</c:if>
			
		}
	);	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			var subtipo=comboDDSubtipoCobroPago.getValue();
			var estado=comboDDEstadoCobroPago.getValue();
			page.submit({
				eventName : 'update'
				,formPanel : panelEdicion
				,params:{
					id:'${cobroPago.id}'
					,idAsunto:'${idAsunto}'
					,'cobroPago.subTipo':subtipo
					//,'cobroPago.estado':estado
					,procedimiento:comboProcedimientos.getValue()
				}
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
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
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
			{ xtype : 'errorList', id:'errL' }
			,{ 
			border : false
			,layout : 'table'
			,viewConfig : { columns : 2 }
			,defaults :  {layout:'form', autoHeight : true, border : false,width:400 }
			,items : [
			{ items : [ id,comboDDEstadoCobroPago,comboDDTipoCobroPago,comboDDSubtipoCobroPago,comboProcedimientos,fecha,importePago], style : 'margin-right:10px' }
			]
		}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});
	
	if(${cobroPago.subTipo!=null}){
		var setSubTipoValue = function (){
		
			comboDDSubtipoCobroPago.setValue("${cobroPago.subTipo.codigo}");
			comboDDSubtipoCobroPago.enable();
			optionsGestoresStore.un('load',setSubTipoValue);
		}
		optionsDDSubtipoCobroPagoStore.on('load',setSubTipoValue);
		optionsDDSubtipoCobroPagoStore.webflow({tipo:'${cobroPago.subTipo.tipoCobroPago.codigo}'});	
	}
	
	
	g_combo = comboDDSubtipoCobroPago;
	g_panel = panelEdicion;	
	page.add(panelEdicion);
</fwk:page>

