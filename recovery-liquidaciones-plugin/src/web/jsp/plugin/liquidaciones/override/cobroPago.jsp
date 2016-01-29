<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@taglib prefix="pfs"  tagdir="/WEB-INF/tags/pfs"%>
<%@taglib prefix="pfsforms"  tagdir="/WEB-INF/tags/pfs/forms"%>
<fwk:page>	
	var labelStyle='font-weight:bolder;width:100';
	var style='margin-bottom:1px;margin-top:1px';
	var id = new Ext.form.Hidden({
		id:'liqCobroPago.id'
		,value:'${liqCobroPago.id}'
	});
	
	var dictDDEstadoCobroPago = <app:dict value="${estado}" />; 

	var comboDDEstadoCobroPago = app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,root: 'diccionario'
	    ,data: dictDDEstadoCobroPago
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="cobroPago.estado" text="**estado"/>'
		,width : 550
		,editable : true
		<c:if test="${liqCobroPago.estado!=null}" >
			,value:'${liqCobroPago.estado.codigo}'
		</c:if>
	});

	 
	var dictDDTipoCobroPago = <app:dict value="${tipo}" />;
	
	 var dictDDTipoCobroPago = new Ext.data.JsonStore({
        fields: ['codigo', 'descripcion']
        ,root: 'diccionario'
        ,data : dictDDTipoCobroPago
        });
	
	var comboDDTipoCobroPago = app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,store: dictDDTipoCobroPago
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="cobroPago.tipo" text="**Tipo"/>'
		,width : 550
		,editable : true
		, forceSelection : true
		<c:if test="${liqCobroPago.subTipo!=null}" >
		<%--,value:'${liqCobroPago.subTipo.tipoCobroPago}'--%>
		,value:'Genérico'
		</c:if>
	});
	
	var subTipo = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsDDSubtipoCobroPagoStore = page.getStore({
	       flow: 'asuntos/buscarSubtipoCobroPago'
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
		,readOnly:false
		,labelStyle:labelStyle
		,width:550
		,resizable:true
		,style:style
		,fieldLabel : '<s:message code="cobroPago.subTipo" text="**subTipo"/>'
		
	});
	
	var recargarComboSubtipo = function(){
		optionsDDSubtipoCobroPagoStore.webflow({tipo:comboDDTipoCobroPago.getValue()});
		comboDDSubtipoCobroPago.clearValue();
	}
	
	var bloquearComboSubtipo = function(){
		comboDDSubtipoCobroPago.disable();
		comboDDSubtipoCobroPago.reset();
		comboDDTipoCobroPago.disable();
		comboDDTipoCobroPago.reset();
		
	}
	
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
		,width:550
		,resizable:true
		,style:style
		,fieldLabel : '<s:message code="cobroPago.procedimiento" text="**procedimiento"/>'
		<c:if test="${liqCobroPago.procedimiento!=null}" >
		,value:'${liqCobroPago.procedimiento.id}'
		</c:if>
	});
	
	var dictDDOrigenCobro = <app:dict value="${origenCobro}" />; 

	var comboDDOrigenCobro = app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,root: 'diccionario'
	    ,data: dictDDOrigenCobro
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="plugin.liquidaciones.cobroPago.origenCobro" text="**Origen cobro"/>'
		,width : 550
		<c:if test="${liqCobroPago.origenCobro!=null}" >
		,value:'${liqCobroPago.origenCobro.codigo}'
		</c:if>
		,editable : true
		
	});
	
	var dictDDModalidadCobro = <app:dict value="${modalidadCobro}" />; 

	var comboDDModalidadCobro = app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,root: 'diccionario'
	    ,data: dictDDModalidadCobro
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="plugin.liquidaciones.cobroPago.modalidadCobro" text="**Modalidad cobro"/>'
		,width : 550
		<c:if test="${liqCobroPago.modalidadCobro!=null}" >
		,value:'${liqCobroPago.modalidadCobro.codigo}'
		</c:if>
		,editable : true
		
	});
	
	var fecha = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="cobroPago.fecha" text="**fecha" />'
		,name:'liqCobroPago.fecha'
		,style:'margin:0px'
		,labelStyle:labelStyle
		,value: '<fwk:date value="${liqCobroPago.fecha}" />'
	});
	
	var importePago  = app.creaNumber('liqCobroPago.importe',
		'<s:message code="cobroPago.importe" text="**Importe" />',
		'${liqCobroPago.importe}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${liqCobroPago.importe!=null}" >
			,value:'${liqCobroPago.importe}'
			</c:if>
		}
	);	
	
	var observaciones=new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.liquidaciones.cobroPago.observaciones" text="**Observaciones" />'
		,width:550
		,height:80
		,maxLength:500
		,style:style
		,labelStyle:labelStyle
	    ,name: 'liqCobroPago.observaciones'
		,value:'${liqCobroPago.observaciones}'
	});
	
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
					id:'${liqCobroPago.id}'
					,idAsunto:'${idAsunto}'
					,'liqCobroPago.subTipo':subtipo
					,'liqCobroPago.estado':estado
					,procedimiento:comboProcedimientos.getValue()
					,contrato:comboContratos.getValue()
					,origenCobro:comboDDOrigenCobro.getValue()
					,modalidadCobro:comboDDModalidadCobro.getValue()
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
	
	<pfs:defineParameters name="pcontratos" paramId=""
		idProcedimiento="comboProcedimientos"
	/>
	
	<pfsforms:remotecombo 
		name="comboContratos" 
		dataFlow="plugin.liquidaciones.contratosData" 
		labelKey="plugin.liquidaciones.cobropago.control.comboContratos" 
		displayField="codigo" 
		root="contratos" 
		label="**Contratos" 
		value="${liqCobroPago.contrato.id}" 
		valueField="id"
		width="550"
		parameters="pcontratos"/>
	comboContratos.labelStyle = labelStyle;
	
	var enableDisableContratos = function(){
		if (comboDDSubtipoCobroPago.getValue() == 'EC'){
			comboContratos.enable();
		}else{
			comboContratos.disable();
		}
		
		if(comboContratos.getValue() != ''){
			comboContratos.reload(false);
			comboContratos.enable();
		}
	};
	
	comboDDSubtipoCobroPago.on('select',function(){
		enableDisableContratos();
	});
 	comboProcedimientos.on('select',function (){comboContratos.reload()});
	
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
			,defaults :  {layout:'form', autoHeight : true, border : false,width:680 }
			,items : [
			{ items : [ id,comboDDEstadoCobroPago,comboDDTipoCobroPago,comboDDSubtipoCobroPago,comboProcedimientos,comboContratos,comboDDOrigenCobro,comboDDModalidadCobro,fecha,importePago,observaciones], style : 'margin-right:10px' }
			]
		}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});
	
	if(${liqCobroPago.subTipo!=null}){
		var setSubTipoValue = function (){
			comboDDSubtipoCobroPago.setValue("${liqCobroPago.subTipo.codigo}");
			comboDDSubtipoCobroPago.enable();
		}
		optionsDDSubtipoCobroPagoStore.on('load',setSubTipoValue);
		optionsDDSubtipoCobroPagoStore.webflow({tipo:'${liqCobroPago.subTipo.tipoCobroPago.codigo}'});	
	}
	
	g_combo = comboDDSubtipoCobroPago;
	g_panel = panelEdicion;	
	
	enableDisableContratos();
	page.add(panelEdicion);
</fwk:page>

