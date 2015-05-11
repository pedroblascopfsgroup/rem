<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<fwk:page>
		
	var texto = '<s:message code="plugin.mejoras.asuntos.textoInstrucciones" text="**Texto instrucciones" />';
	
	var textoListaVacia = '<s:message code="plugin.mejoras.asuntos.textoListaVacia" text="**Texto Lista Vacía" />';
		
	var procedimiento = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);

	var optionsListProcedimientosStore = page.getStore({
		reader: new Ext.data.JsonReader({
			root : 'data'
	      }, procedimiento)
	     }); 


	var cargaCombo = function() {
	     var listadoProcedimientosJSON = <json:array name="data" items="${listadoProcedimientos}" var="rec">
		<json:object>
			<json:property name="id" value="${rec.idProcedimiento}"/>
			<json:property name="descripcion" value="${rec.nombreAsunto}"/>
		</json:object>
	     </json:array>
	     optionsListProcedimientosStore.loadData({data:listadoProcedimientosJSON});
	}
	cargaCombo.defer(1);

	var comboProcedimientos = new Ext.form.ComboBox({
		store:optionsListProcedimientosStore
		,displayField:'descripcion'
		,valueField:'id'
		,mode: 'local'
		,width: 300
		,resizable: true
		,forceSelection: true
		,editable: false
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.mejoras.asuntos.cmbProcedimientos" text="**Procedimientos" />'
	});
	
	var TipoAct = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsActuacionesStore = page.getStore({
	       flow: 'revisionprocedimiento/getListTipoActuacionData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoActuaciones'
	    }, TipoAct)	       
	});

	var comboTipoActuacion = new Ext.form.ComboBox({
		store:optionsActuacionesStore
		,displayField:'descripcion'
		,valueField:'id'
		,mode: 'remote'
		,width: 300
		,resizable: true
		,forceSelection: true
		,disabled: true
		,editable: false
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.mejoras.asuntos.cmbTipoActuacion" text="**Tipo actuacion" />'
	});
		
	 var TipoProd = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsProcedimientosStore = page.getStore({
	       flow: 'revisionprocedimiento/getListTipoProcedimientoData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoProcedimientos'
	    }, TipoProd)	       
	});			
	
	var comboTipoProcedimiento = new Ext.form.ComboBox({
		store:optionsProcedimientosStore
		,displayField:'descripcion'
		,valueField:'id'
		,mode: 'remote'
		,width: 300
		,resizable: true
		,forceSelection: true
		,editable: false
		,disabled: true
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.mejoras.asuntos.cmbTipoProcedimiento" text="**Tipo actuacion" />'
	}); 
	
	var TipoTar = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsTareasStore = page.getStore({
	       flow: 'revisionprocedimiento/getListTipoTareaData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoTareas'
	    }, TipoTar)	       
	});			
	
	var comboTipoTarea = new Ext.form.ComboBox({
		store:optionsTareasStore
		,displayField:'descripcion'
		,valueField:'id'
		,mode: 'remote'
		,width: 300
		,resizable: true
		,forceSelection: true
		,editable: false
		,disabled: true
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.mejoras.asuntos.cmbTipoTarea" text="**Tipo actuacion" />'
	}); 
	
 
	var editor = new Ext.form.HtmlEditor({
		id:'note'
		,readOnly:true
		,width: 460
		,height: 250
		,enableColors: false
       	,enableAlignments: false
       	,enableFont:false
       	,enableFontSize:false
       	,enableFormat:false
       	,enableLinks:false
       	,enableLists:false
       	,enableSourceEdit:false		
		,html:''});
	
	comboProcedimientos.on('select', function(){
		comboTipoActuacion.reset();
		comboTipoProcedimiento.reset();
		comboTipoTarea.reset();
		editor.setValue('');
		comboTipoActuacion.setDisabled(false);
		comboTipoProcedimiento.setDisabled(true);
		comboTipoTarea.setDisabled(true);
	});	
			
	comboTipoActuacion.on('select', function(){
		optionsProcedimientosStore.webflow({'idTipoAct': comboTipoActuacion.getValue()}); 
		comboTipoProcedimiento.reset();
		comboTipoTarea.reset();
		editor.setValue('');
		comboTipoProcedimiento.setDisabled(false);
		comboTipoTarea.setDisabled(true);
	});						
	
	comboTipoProcedimiento.on('select', function(){
		optionsTareasStore.webflow({'idTipoPro': comboTipoProcedimiento.getValue()}); 
		comboTipoTarea.reset();
		editor.setValue('');
		comboTipoTarea.setDisabled(false);
	});
	
	
		
	comboTipoTarea.on('select', function(){
		Ext.Ajax.request({
		url: page.resolveUrl('revisionprocedimiento/getInstruccionesData')
		,params: {idTipoTar:comboTipoTarea.getValue()}
		,method: 'POST'
		,success: function (result, request){
				editor.setValue('');
				var r = Ext.util.JSON.decode(result.responseText);
				var h = r.label;
				editor.setValue(r.label);
			}
		});
		
	});
			
	function processResult(opt){
	   if(opt == 'no'){
	      //page.fireEvent(app.event.CANCEL);
	   }
	   if(opt == 'yes'){
	      Ext.Ajax.request({
				url: page.resolveUrl('revisionprocedimiento/saveRevisionData')
				,method: 'POST'
				,params:{
      				   idActuacion:comboTipoActuacion.getValue()
      				   ,idProcedimiento:comboProcedimientos.getValue()
      				   ,idTipoProcedimiento:comboTipoProcedimiento.getValue()
      				   ,idTarea:comboTipoTarea.getValue()
      				   ,instrucciones:editor.getValue()
      				   ,idAsunto:'${idAsunto}'
      				}
				,success: function (result, request){
					 Ext.MessageBox.show({
			            title: 'Guardado',
			            msg: '<s:message code="plugin.mejoras.asunto.GuardadoCorrecto" text="**GuardadoCorrecto" />',
			            width:300,
			            buttons: Ext.MessageBox.OK
			        });
					page.fireEvent(app.event.DONE);
				}
				,error: function(){
					Ext.MessageBox.show({
			           title: 'Guardado',
			           msg: '<s:message code="plugin.mejoras.asunto.ErrorGuardado" text="**Error guardado" />',
			           width:300,
			           buttons: Ext.MessageBox.OK
			       });
					page.fireEvent(app.event.CANCEL);
				} 
			});
	   }
	}
	
	Ext.ns("Hulas.ux");
		Hulas.ux.line = Ext.extend(Ext.Component, {
	  autoEl: 'hr'
	});

	Ext.reg('line', Hulas.ux.line);
	
	var proAntiguo = "";
	var proNuevo = "";
	var rec = "";
	
		
	var btnAceptar = new Ext.Button({
       text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
       		var index=0;
       		if(comboProcedimientos.selectedIndex!='-1'){
       			index=comboProcedimientos.selectedIndex;
      		}
      		
      		proAntiguo = optionsListProcedimientosStore.getAt(index).get(comboProcedimientos.displayField);
			proNuevo = optionsProcedimientosStore.getAt(comboTipoProcedimiento.selectedIndex).get(comboTipoProcedimiento.displayField);
 		
       		Ext.Msg.show({
			   title:'Confirmación',
			   msg: 'Ha decidido que el procedimiento '+proAntiguo+' sea reorganizado a '+proNuevo+'. ¿Está seguro de continuar?',
			   buttons: Ext.Msg.YESNO,
			   animEl: 'elId',
			   width:450,
			   fn: processResult,
			   icon: Ext.MessageBox.QUESTION
			});
       		
     	}		
	});
	
	var btnCancelar = new Ext.Button({
	       text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	      		page.fireEvent(app.event.CANCEL);
	     	}
	});
			    
 
	var panelEdicion =  new Ext.Container({
		height:300
		,layout: 'form'<%-- 
		,style:'border: none'
		,hideBorders: true --%>
		,items : [comboProcedimientos, {
    				xtype: 'line'
  					}, comboTipoActuacion, comboTipoProcedimiento, comboTipoTarea]
	});	
	
	
	 var panelContenedorEditor = new Ext.Container({
	 	height:300<%-- 
		,style:'border: none'
		,hideBorders: true --%>
	 	,items :[editor]
	 });
	 
	  var columnas = new Ext.form.FieldSet({
		autoHeight:'true'
		,layout: 'table'
		,border:false
		,width:950
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop'}
		,items : [{
		     columnWidth:.20,style:'margin-top:10px',items:[panelEdicion]
		    },{
		     columnWidth:.200,style:'margin-top:10px',items:[panelContenedorEditor]
		    }]
	 }); 
	 
	 var panelContenedor = new Ext.Panel({
	 	height:400
	 	,layout : 'column'
		,viewConfig : { columns : 2 }
		,items : [	
		<c:if test="${fn:length(listadoProcedimientos) > 0}">{html :texto,border:false, width:925,maxLength:3500, style:'margin: 5px'},</c:if>	
		<c:if test="${fn:length(listadoProcedimientos) == 0}">{html :textoListaVacia,border:false, width:925,maxLength:3500, style:'margin: 5px;color:#FF0000;'},</c:if>		
			columnas]
		,bbar:[btnAceptar, btnCancelar]
	 });

	    
   	page.add(panelContenedor);
   	optionsListProcedimientosStore.on('load', function(store, data, options){
			if(optionsListProcedimientosStore.getCount()==1){		
				var text = store.getAt(0).get(comboProcedimientos.valueField);
  				//var value = store.data[0].get(comboProcedimientos.valueField);
			
				comboProcedimientos.setValue(text);
				comboTipoActuacion.setDisabled(false);				
			}
	    });

</fwk:page>	