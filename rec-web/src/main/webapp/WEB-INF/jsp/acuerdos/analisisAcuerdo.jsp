<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
//----------------------------------------------------------------
// Inicio actuaciones Realizadas
//----------------------------------------------------------------

var crearAnalisis=function(){
	var labelStyle='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:120px;'
	var labelStyleArea='font-weight:bolder;'
	var labelStyleTextField='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:160px'	
	var style='margin-bottom:1px;margin-top:1px';
	
	
	var comboRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);

	var conclusionCombo = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.analisis.conclusionCombo" text="**Conclusión" />'
		,value : '${acuerdo.analisisAcuerdo.ddConclusionTituloAcuerdo.descripcion}'
		,name : 'conclusion'
		,labelStyle:labelStyle
	});

	var observacionesTitulos = new Ext.form.TextArea({
		fieldLabel:'<s:message code="acuerdo.analisis.observaciones" text="**Observaciones"/>'
		,width:250
		,labelStyle:labelStyleArea
		,readOnly:true
		<app:test id="observacionesTitulos" addComa="true"/>
	});

	observacionesTitulos.setValue('<s:message text="${acuerdo.analisisAcuerdo.observacionesTitulos}" javaScriptEscape="true" />');

	var titulosFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuaciones.titulos" text="**Titulos"/>'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 2 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
		 	{items:[conclusionCombo]}
		 	,{items:[observacionesTitulos]}
		]
		,doLayout:function() {
				var margin = 80;
				var parentSize = app.contenido.getSize(true);
				this.setWidth(parentSize.width-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	//FIN TITULOS 
	
	
	//CAPACIDAD DE PAGO
	
	var cambioCombo = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.analisis.cambio" text="**Cambio" />'
		,value : '${acuerdo.analisisAcuerdo.ddAnalisisCapacidadPago.descripcion}'
		,name : 'cambioCombo'
		,labelStyle:labelStyle
	});
	
	var aumento = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.analisis.aumento" text="**Aumento" />'
		,value : '${acuerdo.analisisAcuerdo.ddAnalisisCapacidadPago.descripcion}'
		,name : 'cambioCombo'
		,labelStyle:labelStyle
	});
	
	aumento.setValue('${acuerdo.analisisAcuerdo.importePago}');

	var observacionesCapacidadDePago = new Ext.form.TextArea({
		fieldLabel:'<s:message code="acuerdo.analisis.observaciones" text="**Observaciones"/>'
		,width:250
		,readOnly:true
		,labelStyle:labelStyleArea
		<app:test id="observacionesCapPago" addComa="true"/>
	});

	observacionesCapacidadDePago.setValue('<s:message text="${acuerdo.analisisAcuerdo.observacionesPago}" javaScriptEscape="true" />');

	var capacidadDePagoFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuaciones.capacidadDePago" text="**Capacidad de Pago"/>'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 2 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
		 	{items:[cambioCombo, aumento]}
		 	,{items:[observacionesCapacidadDePago]}
		]
		,doLayout:function() {
				var margin = 80;
				var parentSize = app.contenido.getSize(true);
				this.setWidth(parentSize.width-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
	//FIN CAPACIDAD DE PAGO
		
	//SOLVENCIA
		
	var cambioSolvenciaCombo= new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.analisis.cambio" text="**Cambio" />'
		,value : '${acuerdo.analisisAcuerdo.ddCambioSolvenciaAcuerdo.descripcion}'
		,name : 'cambioSolvenciaCombo'
		,labelStyle:labelStyle
	});
	
	var aumentoSolvencia = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="acuerdo.analisis.aumento" text="**Aumento" />'
		,value : '${acuerdo.analisisAcuerdo.importeSolvencia}'
		,name : 'aumentoSolvencia'
		,labelStyle:labelStyle
	});
	

	var observacionesSolvencia = new Ext.form.TextArea({
		fieldLabel:'<s:message code="acuerdo.analisis.observaciones" text="**Observaciones"/>'
		,width:250
		,readOnly:true
		,labelStyle:labelStyleArea
		<app:test id="observacionesSolvencia" addComa="true"/>
	});

	observacionesSolvencia.setValue('<s:message text="${acuerdo.analisisAcuerdo.observacionesSolvencia}" javaScriptEscape="true" />');

	var solvenciaFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuaciones.solvencia" text="**Solvencia"/>'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,viewConfig : { columns : 2 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
		 	{items:[cambioSolvenciaCombo, aumentoSolvencia]}
		 	,{items:[observacionesSolvencia]}
		]
		,doLayout:function() {
				var margin = 80;
				var parentSize = app.contenido.getSize(true);
				this.setWidth(parentSize.width-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
	//FIN SOLVENCIA
	<c:if test="${puedeEditar}">
		var btnEditAnalisis = new Ext.Button({
	       text:  '<s:message code="app.editar" text="**Editar" />'
	       <app:test id="btnEditAnalisis" addComa="true" />
	       ,iconCls : 'icon_edit'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	      	       var w = app.openWindow({
		              title:'<s:message code="acuerdos.actuaciones.analisis" text="**Analisis"/>'
			          ,flow : 'acuerdos/editaAnalisisAcuerdo'
			          ,closable:false
					  ,width:420
			          ,params : {idAcuerdo:${acuerdo.id}, readOnly:"false"}
			       });
			       w.on(app.event.DONE, function(){
			          w.close();
			            page.fireEvent(app.event.DONE);          		          
			       });
			       w.on(app.event.CANCEL, function(){ w.close(); });
	     	}
	    });
	</c:if>
	//El que contiene todo
	return {
		title:'<s:message code="acuerdos.actuaciones.analisis" text="**Analisis"/>'
		,autoHeight:true
		,autoWidth:true
		,border:true
		,xtype:'fieldset'
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop'}
		,items : [
		 	titulosFieldSet, capacidadDePagoFieldSet, solvenciaFieldSet
		 	<c:if test="${puedeEditar}">
		 		, btnEditAnalisis
		 	</c:if>
		]
		,doLayout:function() {
				var margin = 50;
				var parentSize = app.contenido.getSize(true);
				this.setWidth(parentSize.width-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	}   
   
 };

//----------------------------------------------------------------
//Fin Actuaciones Realizadas
//----------------------------------------------------------------