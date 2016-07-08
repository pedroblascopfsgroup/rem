<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>

	var labelStyle='font-weight:bolder;width:100px'
	//var labelStyleTextField='font-weight:bolder;width:160px'	
	var style='';
	
	var comboRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	//TITULOS
	var conclusionDic = <app:dict value="${conclusion}"/>;

	//store generico de combo diccionario
	var conclusionStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : conclusionDic
	});
	
	

	var conclusionCombo = app.creaCombo({
				name:'conclusion'
				<app:test id="editConclusionCombo" addComa="true" />
				,hiddenName:'conclusionCombo'
				,store: conclusionStore,value: '${acuerdo.analisisAcuerdo.ddConclusionTituloAcuerdo.codigo}'
				,emptyText:'----'
				,labelStyle:labelStyle
				,fieldLabel : '<s:message code="acuerdo.analisis.conclusionCombo" text="**Conclusión" />'
	});
	var tituloobservaciones = new Ext.form.Label({
   	text:'<s:message code="acuerdo.analisis.observaciones" text="**Observaciones" />'
	,style:labelStyle
	}); 
	var observacionesTitulos = new Ext.form.TextArea({
		width:330
		//,height:100
		,maxLength:2000
		<app:test id="editObservacionesTitulos" addComa="true"/>	
	});
	
	observacionesTitulos.setValue('${acuerdo.analisisAcuerdo.observacionesTitulos}');

	var titulosFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuaciones.titulos" text="**Titulos"/>'
		,autoHeight:true
		,width:500
		,items : [	conclusionCombo,tituloobservaciones,{items:observacionesTitulos,border:false,style:'margin-top:5px'}]
	});
	//FIN TITULOS 
	
	
	//CAPACIDAD DE PAGO
	
	var capacidadDic = <app:dict value="${capacidad}"/>;

	//store generico de combo diccionario
	var capacidadStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : capacidadDic
	});
	var tituloobservacionesCapPago = new Ext.form.Label({
   		text:'<s:message code="acuerdo.analisis.observaciones" text="**Observaciones" />'
		,style:labelStyle
	}); 
	
	var cambioCombo = app.creaCombo({
				name:'cambioCombo'
				<app:test id="editCambioCombo" addComa="true" />
				,hiddenName:'cambioStore'
				,store: capacidadStore
				,value: '${acuerdo.analisisAcuerdo.ddAnalisisCapacidadPago.codigo}'
				,emptyText:'----'
				,labelStyle:labelStyle
				,fieldLabel : '<s:message code="acuerdo.analisis.cambio" text="**Cambio" />'
	});

	var aumento  = app.creaNumber('aumento',
		'<s:message code="acuerdo.analisis.aumento" text="**Aumento" />',
		'',
		{	
			labelStyle:labelStyle
			,allowDecimals: false
			,allowNegative: false
			,maxLength:14
			,autoCreate : {tag: "input", type: "text",maxLength:"14", autocomplete: "off"}
		}
	);
	
	aumento.setValue('${acuerdo.analisisAcuerdo.importePago}');

	var observacionesCapacidadDePago = new Ext.form.TextArea({
		width:330
		//,height:100
		,maxLength:2000
		<app:test id="editObservacionesCapPago" addComa="true"/>	
	});
	
	observacionesCapacidadDePago.setValue('${acuerdo.analisisAcuerdo.observacionesPago}');

	var capacidadDePagoFieldSet = new Ext.form.FieldSet({
		autoHeight:'true'
		,width:350
		,title:'<s:message code="acuerdos.actuaciones.capacidadDePago" text="**Capacidad de Pago"/>'
		,items : [
		 	cambioCombo, aumento,tituloobservacionesCapPago,{items:observacionesCapacidadDePago,border:false,style:'margin-top:5px'}
		]
	});
	
	//FIN CAPACIDAD DE PAGO
		
	//SOLVENCIA
	
	var cambioDic = <app:dict value="${cambio}"/>;
	
	var tituloobservacionesSolv = new Ext.form.Label({
   		text:'<s:message code="acuerdo.analisis.observaciones" text="**Observaciones" />'
		,style:labelStyle
	}); 

	//store generico de combo diccionario
	var cambioSolvenciaStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : cambioDic
	});
	
	var cambioSolvenciaCombo = app.creaCombo({
				name:'cambioSolvenciaCombo'
				<app:test id="editCambioSolvenciaCombo" addComa="true" />
				,hiddenName:'cambioSolvenciaStore'
				,store:cambioSolvenciaStore
				,value: '${acuerdo.analisisAcuerdo.ddCambioSolvenciaAcuerdo.codigo}'
				,emptyText:'----'
				,labelStyle:labelStyle
				,fieldLabel : '<s:message code="acuerdo.analisis.cambio" text="**Cambio" />'
	});
	
	var aumentoSolvencia  = app.creaNumber('aumentoSolvencia',
		'<s:message code="acuerdo.analisis.aumento" text="**Aumento" />',
		'',
		{	
			labelStyle:labelStyle
			,allowDecimals: false
			,allowNegative: false
			,maxLength:14
			,autoCreate : {tag: "input", type: "text",maxLength:"14", autocomplete: "off"}
		}
	);
	
	aumentoSolvencia.setValue('${acuerdo.analisisAcuerdo.importeSolvencia}');

	var observacionesSolvencia = new Ext.form.TextArea({
		width:330
		,maxLength:2000
		<app:test id="editObservacionesSolvencia" addComa="true"/>	
	});
	
	observacionesSolvencia.setValue('${acuerdo.analisisAcuerdo.observacionesSolvencia}');

	var solvenciaFieldSet = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuaciones.solvencia" text="**Solvencia"/>'
		,autoHeight:true
		,border:true
		,items : [
			cambioSolvenciaCombo, aumentoSolvencia,tituloobservacionesSolv
			,{items:observacionesSolvencia,border:false,style:'margin-top:5px'}
		]
	});
	
	//FIN SOLVENCIA

	var btnGuardarAnalisis = new Ext.Button({
       text:  '<s:message code="app.guardar" text="**Guardar" />'
       <app:test id="btnGuardarAnalisis" addComa="true" />
       ,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
			if (!observacionesSolvencia.validate() || !observacionesCapacidadDePago.validate() || !observacionesTitulos.validate()) {
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="acuerdos.conclusiones.observaciones.error"/>');
			}
			else {				
	      		page.webflow({
	      			flow:'acuerdos/guardarAnalisisAcuerdo'
	      			,params:{
	      				 idAcuerdo:${acuerdo.id}
	      				,conclusionTitulos:conclusionCombo.getValue()
	      				,observacionesTitulos:observacionesTitulos.getValue()
	      				,cambioCapPago:cambioCombo.getValue()
	      				,aumentoCapPago:aumento.getValue()
	      				,observacionesCapPago:observacionesCapacidadDePago.getValue()
	      				,cambioSolvencia:cambioSolvenciaCombo.getValue()
	      				,aumentoSolvencia:aumentoSolvencia.getValue()
	      				,observacionesSolvencia:observacionesSolvencia.getValue()
	      			}
	      			,success: function(){
	            		   page.fireEvent(app.event.DONE);
	            	}
	      		});
			}
     	}
    });

    var btnCancelarAnalisis = new Ext.Button({
       text:  '<s:message code="app.cancelar" text="**Cancelar" />'
       <app:test id="btnCancelarAnalisis" addComa="true" />
       ,iconCls : 'icon_cancel'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
      		page.fireEvent(app.event.CANCEL);
     	}
    });

	//El que contiene todo
	var fieldSetAnalisis = new Ext.form.FieldSet({
		autoHeight:true
		,border:false
		//,bodyStyle:'padding:5px;cellspacing:20px;'
		
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:true}
		,items : [
		 	capacidadDePagoFieldSet,solvenciaFieldSet,titulosFieldSet 
		 	
		]
	});
	
	var panelAlta = new Ext.form.FormPanel({
		bodyStyle : 'padding:10px'
		,layout:'anchor'
		,autoHeight : true
		,items : [
		 	{ xtype : 'errorList', id:'errL' }
		 	,{
		 		autoHeight:true
		 		,border:false
				,defaults :  {layout:'form', autoHeight : true, border : true,width:370 }
		 		,items:[
		 			capacidadDePagoFieldSet,solvenciaFieldSet,titulosFieldSet 
		 		]
		 	}
		]
		,bbar : [
			btnGuardarAnalisis,btnCancelarAnalisis
		]
	});
	
	page.add(panelAlta);
</fwk:page>
