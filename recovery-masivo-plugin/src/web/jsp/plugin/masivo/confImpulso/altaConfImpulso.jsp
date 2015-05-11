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
	<c:if test="${confImpulso==null}">
		<c:set var="modificar" value="false"/>
	</c:if>
	<c:if test="${confImpulso!=null}">
		<c:set var="modificar" value="true"/>
	</c:if>
	
	
	<pfsforms:ddCombo name="idTipoJuicio"
		labelKey="plugin.masivo.confImpulso.busqueda.tipoJuicio"
		label="**Tipo de procedimiento" dd="${tiposJuicio}"
		value="${confImpulso.tipoJuicio.id}"
		propertyCodigo="id" propertyDescripcion="descripcion" 
		width="200"/>	
		
	var TipoTar = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsTareasStore = page.getStore({
	       flow: 'msvconfimpulsoautomatico/consultaTareasProcedimiento'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoTareas'
	    }, TipoTar)	       
	});		

	
	<c:if test="${!modificar}">
	var idTareaProcedimiento = new Ext.form.ComboBox({
		store:optionsTareasStore
		,valueField:'id'
		,displayField:'descripcion'
		,name:'idTareaProcedimiento'
		,mode: 'local'
		,editable:false
		,triggerAction: 'all'
		,width : 230
		,fieldLabel : '<s:message code="plugin.masivo.confImpulso.busqueda.tareaProcedimiento" text="**Tarea" />'
	});
	</c:if>
	
	<c:if test="${modificar}">
		var idTareaProcedimiento = app.creaText("idTareaProcedimiento","<s:message code="plugin.masivo.confImpulso.busqueda.tareaProcedimiento" text="**Tarea" />",
			"${confImpulso.tareaProcedimiento.descripcion}",{
			width : 230
		});
	</c:if>
	
	
	idTipoJuicio.on('select', function(){
		Ext.Ajax.request({
			url: page.resolveUrl('msvconfimpulsoautomatico/consultaTareasProcedimiento')
			,params: {idTipoJuicio:idTipoJuicio.getValue()}
			,method: 'POST'
			,success: function (result, request){
				optionsTareasStore.webflow({'idTipoJuicio': idTipoJuicio.getValue()}); 
			}
			,error: function(result, request){
			}
			,failure: function(result, request){
			}
		}); 
	});
		
 	
	var conProcurador = new Ext.form.ComboBox({
		store: ["SI", "NO"]
		,name:'conProcurador'
		,mode: 'local'
		,editable:false
		,triggerAction: 'all'
		,width:60
		,value: '<c:if test="${confImpulso.conProcurador == true}">SI</c:if><c:if test="${confImpulso.conProcurador != true}">NO</c:if>'
		,fieldLabel : '<s:message code="plugin.masivo.confImpulso.busqueda.conProcurador" text="**Con Procurador" />'
		,allowBlank: false
	});
	
 	<pfsforms:ddCombo name="idDespachoExterno"
		labelKey="plugin.masivo.confImpulso.busqueda.despacho"
		label="**Despacho" value="${confImpulso.despacho.id}" dd="${despachos}" propertyCodigo="id"
		propertyDescripcion="despacho" obligatory="true" />
	
	var cartera = new Ext.form.ComboBox({
				store: ${carteras}
				,name: 'cartera'
				,mode: 'local'
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code='plugin.masivo.confImpulso.busqueda.cartera' text='**Cartera' />'
				,value:'${confImpulso.cartera}'
	});
		
	var operUltimaResol = new Ext.form.ComboBox({
		store: ["<", "<=", "=", ">=", ">"]
		,name:'operUltimaResol'
		,mode: 'local'
		,editable:false
		,triggerAction: 'all'
		,width:60
		,value: '${confImpulso.operUltimaResol}'
		,fieldLabel : '<s:message code="plugin.masivo.confImpulso.busqueda.operUltimaResol" text="**Fecha de última resolución recibida" />'
		,allowBlank: false
	});
	
	<pfsforms:numberfield name="numDiasUltimaResol" labelKey="plugin.masivo.confImpulso.busqueda.numDiasUltimaResol"
		label="**días" value="${confImpulso.numDiasUltimaResol}" allowDecimals="false" allowNegative="false" obligatory="true" />

	var operUltimoImpulso = new Ext.form.ComboBox({
		store: ["<", "<=", "=", ">=", ">"]
		,name:'operUltimoImpulso'
		,mode: 'local'
		,editable:false
		,triggerAction: 'all'
		,width:60
		,value: '${confImpulso.operUltimoImpulso}'
		,fieldLabel : '<s:message code="plugin.masivo.confImpulso.busqueda.operUltimoImpulso" text="**Fecha del último impulso" />'
		,allowBlank: false
	});
	
	
	<pfsforms:numberfield name="numDiasUltimoImpulso" labelKey="plugin.masivo.confImpulso.busqueda.numDiasUltimoImpulso"
		label="**días" value="${confImpulso.numDiasUltimoImpulso}" allowDecimals="false" allowNegative="false" obligatory="true" />

	var _handler =  function() {
		<c:if test="${!modificar}">
		panelEdicionExtendido.getForm().items.items[1].setValue(panelEdicionExtendido.getForm().items.items[3].getValue());
		</c:if>
		panelEdicionExtendido.getForm().submit(
		{	
		    clientValidation: true,
			url: '/'+app.getAppName()+'/msvconfimpulsoautomatico/guardaConfImpulso.htm',
			 success: function(form, action) {
			 	debugger;
			<c:if test="${modificar}">
				Ext.Msg.alert('<s:message code="plugin.masivo.confImpulso.busqueda.ok" text="**¡Guay!" />',
					'<s:message code="plugin.masivo.confImpulso.busqueda.resultadoOK" text="**Guardado correctamente" />');
			</c:if>
		       panelEdicionExtendido.container.unmask();
		       page.fireEvent(app.event.DONE);
		    },
		    failure: function(form, action) {
		    	panelEdicionExtendido.container.unmask();
		        switch (action.failureType) {
		            case Ext.form.Action.CLIENT_INVALID:
		                Ext.Msg.alert('Error', 'Debe rellenar los campos obligatorios.');
		                break;
		            case Ext.form.Action.CONNECT_FAILURE:	            	
		                Ext.Msg.alert('Error', 'Error de comunicación');
		                break;
		       }
		    }
		});
	};

	var btnGuardar = new Ext.Button({
		text : 'Guardar'
		,iconCls : 'icon_ok'
		,handler : _handler
	});

	
	var btnCancelar= new Ext.Button({
		text : 'Cancelar'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.CANCEL); }
	});

	var panelEdicion = new Ext.form.FieldSet({
		autoHeight : true
		,width: 680
        ,title:'<s:message code="plugin.masivo.confImpulso.busqueda.seleccionRegla" text="****Selección de regla" />'
        ,defaults : {layout:'form',border: false,bodyStyle:'padding:0px'} 
		,border : true
		,items : [
			{   autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,defaults : {xtype : 'fieldset', border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:1px'}
				,items:[{items: [  {xtype:'hidden',name:'id',value:'${confImpulso.id}'},{xtype:'hidden',name:'idTarea'}, idTipoJuicio,idTareaProcedimiento ]}
						,{items: [ conProcurador,idDespachoExterno,cartera ]}
				]
			}
		]
	});
	
	var panelEdicionPlazos = new Ext.form.FieldSet({
		autoHeight : true
		,width: 680
        ,title:'<s:message code="plugin.masivo.confImpulso.busqueda.seleccionPlazo" text="****Selección de plazo" />'
        ,defaults : {layout:'form',border: false,bodyStyle:'padding:0px'} 
		,border : true
		,items : [
			{   autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,defaults : {xtype : 'fieldset', border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:1px'}
				,items:[{items: [ operUltimaResol,operUltimoImpulso ]}
						,{items: [ numDiasUltimaResol,numDiasUltimoImpulso ]}
				]
			}
		]
	});

	<c:if test="${modificar}">
		idTipoJuicio.disabled = true;
		idTareaProcedimiento.disabled = true;
		conProcurador.disabled = true;
		idDespachoExterno.disabled = true;
		cartera.disabled = true;
	</c:if>
	
	var panelEdicionExtendido = new Ext.form.FormPanel({
		autoHeight : true
        ,defaults : {layout:'form',border: false,bodyStyle:'padding-top:10px'} 
		,border : true
		,items : [
			{   autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:1}
				,border:false
				,defaults : {xtype : 'fieldset',autoWidth : true, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:0px'}
				,items:[{items: [ panelEdicion, panelEdicionPlazos ]}]
			}
		]
		,bbar : [
			btnGuardar<c:if test="${!modificar}">, btnCancelar</c:if>
		]
	});	

	page.add(panelEdicionExtendido);
	
</fwk:page>	