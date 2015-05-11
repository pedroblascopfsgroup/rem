<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>


<fwk:page>
	var labelStyle='font-weight:bolder;width:150';
	var lista='${lista}';
	var nombre='autoprorrogaMasivaTareas';
	var scope = '${scope}';
	var paramBusquedaJSON = '${paramBusquedaJSON}';
	var paramBusqueda =  Ext.decode(paramBusquedaJSON);
	
	var label = new Ext.form.Label({
	   	text:'<s:message code="solicitarprorroga.descripcion" text="**Solicitar prorroga" />'
		,height:20
		,style:'padding:10px'
	});
	
	//combo 
	//var labelCombo='<s:message code="solicitarprorroga.motivo" text="**Seleccione el motivo" />';
	/**Combo Causa**/
	var combo = app.creaCombo({
		data : <app:dict value="${causas}" />
		,name : 'codigoCausa'
		//,allowBlank : false
		,fieldLabel : '<s:message code="solicitarprorroga.motivo" text="**Seleccione el motivo" />'
		,labelStyle:'font-weight:bolder'
	});
		
	
	<%--		
	var endDate = new Date(fechaVencimiento.substring(6),(fechaVencimiento.substring(3,5))-1,fechaVencimiento.substring(0,2));	
	 
	var maxDate = endDate;
	//maxDate = maxDate.add(Date.DAY,${plazo});
	
	
	var fueraRango = false;
	if (today.getTime() > endDate.getTime()+86400000){	
		fueraRango = true;	
	}
	--%>	
	var today = new Date();
	var plazo = ('${appProperties.pluginBusquedaTareasDiasPlazoMaximo}' == '' ? 90 : 0${appProperties.pluginBusquedaTareasDiasPlazoMaximo});			
	var maxDate = today.add(Date.DAY,plazo);
	
	//date chooser para solicitar prorroga
	var txtFecha = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="plugin.busquedaTareas.solicitarprorroga.fecha" text="**Nueva fecha de Revisión" />'
		,labelStyle:'font-weight:bolder'
		,minValue : today
		//dias maximo de prorroga
		,maxValue : maxDate
		,name:'fechaPropuesta'	
		//,value:endDate   //TODO: Descomentar para activar que se abra el calendario por la primera fecha posible
	});
	
	var titulodescripcion = new Ext.form.Label({
		   	text:'<s:message code="solicitarprorroga.detalle" text="**Detalle" />'
			,style:'font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
			});
			
	var txtFechaError = new Ext.form.Label({
	   	text:'<s:message code="solicitarprorroga.errorFecha" text="**La tarea está vencida y no es posible solicitar una prorroga para ella" />'
		,style:'color:red;font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
		,hidden: true
	});			
			
	var descripcion = new Ext.form.TextArea({
		width:500
		,height:150
		,bodyStyle:'padding-top:5px'
		,hideLabel: true
		,maxLength:3500
		,fieldLabel:'<s:message code="solicitarprorroga.detalle" text="**Detalle" />'
		,labelStyle:"font-weight:bolder"
		,name:'descripcionCausa'
		
	});
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){page.fireEvent(app.event.CANCEL);}
	});
	 
	var validarForm = function (){
		if (!panelEdicion.getForm().isValid()){
			return false;
		}
		if (combo.getValue()==null || combo.getValue()==''){
			return false;
		}
		if (txtFecha.getValue()==null || txtFecha.getValue()==''){
			return false;
		}
		return true;
	}
	
	<%--
	<pfs:defineParameters name="parametros" paramId="" 
		codigoCausa="combo"
		fechaPropuesta="txtFecha"
		descripcionCausa="descripcion"
		nombre="nombre"
		lista="lista"
		/>--%>
	
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if (validarForm()){
				msgEspere=Ext.MessageBox.wait('<s:message code="plugin.busquedaTareas.solicitarprorroga.generando" text="**Prorrogando tareas" />','<s:message code="plugin.busquedaTareas.solicitarprorroga.espere" text="**Espere" />');
				
				paramBusqueda.lista = lista;				
				paramBusqueda.nombre = nombre;
				paramBusqueda.codigoCausa = combo.getValue();
				paramBusqueda.fechaPropuesta=app.format.dateRenderer(txtFecha.getValue());
				paramBusqueda.descripcionCausa=descripcion.getValue();
				paramBusqueda.scope = scope;
				
				Ext.Ajax.request({
    				url: page.resolveUrl('btaautoprorrogamasiva/operacionProrrogaMasiva')
   					,params: paramBusqueda
  					,method: 'POST'
   					,success: function (result, request){
        				var r = Ext.util.JSON.decode(result.responseText);
       					 if(r.success) {
       					 	 msgEspere.hide();
	       					 Ext.Msg.alert('<s:message code="plugin.busquedaTareas.prorrogarTareas" text="**Prorrogar tareas" />',
	       					 '<s:message code="plugin.busquedaTareas.prorrogarTareas.resultadoProrrogaMasiva" text="**Se han generado las prorrogas de las tareas correctamente con : {0} tareas prorrogadas y {1} fallos producidos {2}" arguments="'+r.resultado.cantidad+','+r.resultado.errores+','+r.resultado.observaciones+'"/>');
	       					 page.fireEvent(app.event.DONE);
	       				} else {
		       				Ext.Msg.alert('<s:message code="plugin.busquedaTareas.prorrogarTareas" text="**Prorrogar tareas" />',
	       					 '<s:message code="plugin.busquedaTareas.prorrogarTareas.resultadoProrrogaMasiva.fail" text="**No se ha podido realizar la operación"/>');
	       					page.fireEvent(app.event.CANCEL);
	       				}
   					 }
   					 ,error : function (result, request){
	   					 Ext.Msg.alert('<s:message code="plugin.busquedaTareas.prorrogarTareas" text="**Prorrogar tareas" />',
       					 '<s:message code="plugin.busquedaTareas.prorrogarTareas.resultadoProrrogaMasiva.fail" text="**No se ha podido realizar la operación"/>');
       					 page.fireEvent(app.event.CANCEL);
       					 }
       				,failure: function (response, options){
						Ext.Msg.alert('<s:message code="plugin.busquedaTareas.prorrogarTareas" text="**Prorrogar tareas" />',
       					 '<s:message code="plugin.busquedaTareas.prorrogarTareas.resultadoProrrogaMasiva.fail_arg" text="**No se ha podido realizar la operación. {0}" arguments="'+response.statusText+'"/>');
       					 page.fireEvent(app.event.CANCEL);
       					 }
				});
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="errores.todosLosDatosObligatorios"/>' + ' y el plazo máximo para la autoprórroga es de ' + plazo + ' días.');
			}
		}
	});
	
	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,border : false
		,layoutConfig:{columns:2}
		,bodyStyle:'padding:5px'
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{  border : false
				,autoHeight:true
				,xtype:'fieldset'
				,defaults :  {layout: 'form' }
				,items : [combo,txtFecha,titulodescripcion,descripcion
					]
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});	
	page.add(panelEdicion);
	
	
</fwk:page>	