<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	<pfs:hidden name="tPorce" value="${tPorce}"/>
	<pfs:hidden name="NMBBien" value="${idBien}"/>

	var radio = new Ext.form.RadioGroup({
		vertical: false
		,items: [
			 {boxLabel: '<s:message code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionPersona.docId" text="**Documento" />', name: 'field', inputValue: 'docId', checked:true}
			,{boxLabel: '<s:message code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionPersona.nombre" text="**Nombre" />', name: 'field', inputValue: 'nombre'}
			,{boxLabel: '<s:message code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionPersona.apellido1" text="**Apellido1" />', name: 'field', inputValue: 'apellido1'}
			,{boxLabel: '<s:message code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionPersona.apellido2" text="**Apellido2" />', name: 'field', inputValue: 'apellido2'}
		]
	});

	var field = 'docId';

	radio.on('change',function(){
		dsclientes.baseParams.field = radio.getValue().getGroupValue();
	});
	
	var dsclientes = new Ext.data.Store({
		autoLoad : true
		,baseParams: {limit:10, start:0, field:field, query:''}
		,proxy: new Ext.data.HttpProxy({
			url : page.resolveUrl('editbien/getClientesPaginados')
		})
		,reader : new Ext.data.JsonReader({
 			root : 'clientes'
			,totalProperty : 'total'
			,id : 'id'
			},['id','docId','descripcion']
		) 
	});
	
	var cliente = new Ext.form.ComboBox({
	     store: dsclientes
		,displayField: 'descripcion'
		,hiddenName: 'cliente'
		,valueFiedl: 'id'
		,typeAhead: false
		,loadingText: '<s:message code="plugin.bienes.formGestor.buscando" text="**Espere ..." />'
		,width: 400
		,fieldLabel : '<s:message code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionPersona.cliente" text="**Cliente" />'
		,pageSize: 10
		,hideTrigger: false
		,mode: 'local'
	});

	var selectedCliente = {
		value: ''
		,setValue: function(v){
			this.value = v;
		}
		,getValue: function(){
			return this.value;
		}
	};
	
	cliente.on('afterrender',function(combo){combo.mode = 'remote'});
	
	cliente.on('select',function(){
		var v = cliente.value;
		var i = dsclientes.find('descripcion',v);
		var rec = dsclientes.getAt(i);
		selectedCliente.setValue(rec.get('id'));
	});
	
	var busqCliente = new Ext.form.FieldSet({
		title: '<s:message code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionPersona.seleccionCliente" text="**Seleccione cliente" />'
		,autoWidth: true
		,items: [radio, cliente]
	});
	
	var NMBparticipacion = app.creaInteger(
		'bien.participacion'
		, '<s:message code="plugin.mejoras.bienesNMB.participacion" text="**Participacion" />' + ' (' + tPorce.getValue() + ')' 
		, '${NMBbien.participacion}'
		, {	autoCreate : {
				tag: "input"
				, type: "text",maxLength:"3"
				, autocomplete: "off"
		 	}
			, maxLength:3
			, maxengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener más de 3 dígitos" arguments="3" />'
			, labelStyle:'width:150px'
			, allowBlank: false
		}
	);
		
	var validarForm = function() {
		if(NMBparticipacion.getValue() == null || NMBparticipacion.getValue()== '' ){
			return false;
		} 
		return true;
	}
	
	var validarPorcentaje = function() {
		if (eval(NMBparticipacion.getValue()) + eval(tPorce.getValue()) > 100) {
			return false;
		}
		return true;
	}
	
	
	var getParametros = function() {
	 	var p = {};
	 	p.NMBparticipacion=NMBparticipacion.getValue();
	 	p.NMBBien=NMBBien.getValue();
	 	p.persona=selectedCliente.getValue();
	 	return p;
	}
	 
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function() {
			if(validarForm()){
				if(validarPorcentaje()){
					var p = getParametros();
					Ext.Ajax.request({
						url : page.resolveUrl('editbien/saveParticipacionBien'), 
						params : p,
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						}
					});
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**La suma de los porcentaje excede el 100%." code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionPersona.porcentajeExcedido"/>');
				}
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionPersona.camposObligatorios"/>');
			}
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
						,layoutConfig:{columns:1}
						,border:false
						,bodyStyle:'padding:5px;cellspacing:20px;'
						,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
						,items:	[{
									layout:'form'
									,bodyStyle:'padding:5px;cellspacing:10px'
									,items:[busqCliente, NMBparticipacion]
									,columnWidth:.5
								}]
				}]
		,bbar : [btnCancelar,btnGuardar]
	});

	page.add(panelEdicion);

</fwk:page>
