<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	var realizadas = Ext.data.Record.create([
          {name : 'id'}
         ,{name : 'tipoActuacion'}
         ,{name : 'fecha'}
         ,{name : 'resultado'}
         ,{name : 'actitud'}
         ,{name : 'observaciones'}
      ]);
    
	var actuacionesRealizadasStore = page.getStore({
        flow: 'propuestas/getPropuestasRealizadasByExpedienteId'
        ,storeId : 'actuacionesRealizadasStore'
        ,reader : new Ext.data.JsonReader(
            {root:'actuaciones'}
            , realizadas
        )
   });  
	
	entidad.cacheStore(actuacionesRealizadasStore);

   var cmActuacionesRealizadas = new Ext.grid.ColumnModel([
   	   {dataIndex : 'id', hidden:true}
      ,{header : '<s:message code="acuerdos.actuaciones.tipo" text="**Tipo Actuación" />', dataIndex : 'tipoActuacion'}
      ,{header : '<s:message code="acuerdos.actuaciones.fecha" text="**Fecha" />', dataIndex : 'fecha'}
      ,{header : '<s:message code="acuerdos.actuaciones.resultado" text="**Resultado" />', dataIndex : 'resultado'}
      ,{header : '<s:message code="acuerdos.actuaciones.actitud" text="**Actitud" />', dataIndex : 'actitud'}
      ,{header : '<s:message code="acuerdos.actuaciones.observaciones" text="**Observaciones" />', dataIndex : 'observaciones'}
   ]);

   <sec:authorize ifAllGranted="EDITAR_GYA">
	   var btnEditActuacion = new Ext.Button({
	       text:  '<s:message code="app.editar" text="**Editar" />'
	       <app:test id="EditActuacionBtn" addComa="true" />
	       ,iconCls : 'icon_edit'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
				var rec = actuacionesRealizadasGrid.getSelectionModel().getSelected();
				if(!rec) {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="acuerdos.actuaciones.listado.sinSeleccion" text="**Debe seleccionar una actuación para editar." />');
				} else {
					var w = app.openWindow({
						flow : 'acuerdos/editActuacionesRealizadasExpediente'
						,width:600
						,title : '<s:message code="app.agregar" text="**Agregar" />'
						,params : {idExpediente:entidad.get("data").id, idActuacion:rec.get('id')}
					});
					w.on(app.event.DONE, function(){
						w.close();
						recargarActuacionesRealizadas();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
	      }
	   });
   	
    
	   var btnAltaActuacion = new Ext.Button({
	       text:  '<s:message code="app.agregar" text="**Agregar" />'
	       <app:test id="AltaActuacionBtn" addComa="true" />
	       ,iconCls : 'icon_mas'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	       		var w = app.openWindow({
					flow : 'acuerdos/editActuacionesRealizadasExpediente'
					,width:600
					,title : '<s:message code="app.agregar" text="**Agregar" />'
					,params : {idExpediente:entidad.get("data").id}
				});
				w.on(app.event.DONE, function(){
					w.close();
					recargarActuacionesRealizadas();
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
	      }
	   });
   </sec:authorize>
   
   var heightActuacionesRealizadasGrid = 384;
   
   <sec:authorize ifAllGranted="ACTUACIONES_EXPLORAR_GESTANA_EXP">
   		heightActuacionesRealizadasGrid = 162;
   </sec:authorize>
   
   
   	var actuacionesRealizadasGrid = new Ext.grid.GridPanel({
   	 	title : '&nbsp;'<app:test id="actuacionesGrid" addComa="true" /> 
		,store:actuacionesRealizadasStore
		,cm:cmActuacionesRealizadas 
		,cls:'cursor_pointer'
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,style:'padding:50px;'
		,autoWidth:true
		,height:heightActuacionesRealizadasGrid 
		,bbar : [<sec:authorize ifAllGranted="EDITAR_GYA"> 
 	        	btnAltaActuacion,btnEditActuacion 
 	        </sec:authorize>]
	});


	var fieldSetActuacionesRealizadas = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuaciones.titulo" text="**Actuaciones Realizadas"/>'
		,autoHeight:true
		,width:575
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false, style:'margin:4px;width:97%',border:true}
		,items : [
		 	actuacionesRealizadasGrid
		]
	});

   actuacionesRealizadasGrid.on('layout', function() {
		//fwk.log('visible: '+this.isVisible());
		if(this.isVisible()){
			var parentSize = app.contenido.getSize(true);
			this.setWidth(parentSize.width-40);//el  -10 es un margen
			Ext.grid.GridPanel.prototype.doLayout.call(this);
		}
	});
	
	var explorar = Ext.data.Record.create([
          {name : 'id'}
         ,{name : 'codTipoSolucionAmistosa'}
         ,{name : 'tipoSolucionAmistosa'}
         ,{name : 'codSubtipoSolucion'}
         ,{name : 'subtipoSolucion'}
         ,{name : 'valoracion'}
         ,{name : 'observaciones'}
         ,{name : 'isActivo'}
      ]);
	
	var actuacionesStore = page.getStore({
        flow: 'propuestas/getPropuestasExplorarByExpedienteId'
        ,storeId : 'actuacionesStore'
        ,reader : new Ext.data.JsonReader(
            {root:'actuaciones'}
            , explorar
        )
   });  
	
	entidad.cacheStore(actuacionesStore);

   var cmActuacionesAExplorar = new Ext.grid.ColumnModel([
   	   {dataIndex: 'id', hidden:true}
   	  ,{dataIndex: 'codTipoSolucionAmistosa', hidden:true}
      ,{header : '<s:message code="acuerdos.actuacionesAExplorar.tipoSolucionAmistosa" text="**Tipo Solición Amistosa" />', dataIndex : 'tipoSolucionAmistosa', width:120}
   	  ,{dataIndex: 'codSubtipoSolucion', hidden:true}
      ,{header : '<s:message code="acuerdos.actuacionesAExplorar.subtipoSolucion" text="**Subtipo Solución" />', dataIndex : 'subtipoSolucion', width:120}
      ,{header : '<s:message code="acuerdos.actuacionesAExplorar.valoracion" text="**Valoración" />', dataIndex : 'valoracion', width:140}
      ,{header : '<s:message code="acuerdos.actuacionesAExplorar.observaciones" text="**Observaciones" />', dataIndex : 'observaciones', width:120}
   	  ,{dataIndex: 'isActivo', hidden:true}
   ]);
   
  <sec:authorize ifAllGranted="EDITAR_GYA">
	   var btnEditActuacionAExplorar = new Ext.Button({
	       text:  '<s:message code="app.editar" text="**Editar" />'
	       <app:test id="btnEditActuacionAExplorar" addComa="true" />
	       ,iconCls : 'icon_edit'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
				var rec = actuacionesAExplorarGrid.getSelectionModel().getSelected();
				if(!rec) {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="acuerdos.actuaciones.listado.sinSeleccion" text="**Debe seleccionar una actuación para editar." />');
				} else {
					var w = app.openWindow({
						flow : 'acuerdos/editActuacionesAExplorarExpediente'
						,width:570
						,title : '<s:message code="app.agregar" text="**Agregar" />'
						,params : {idExpediente:entidad.get("data").id, idActuacion:rec.get('id'), codSubtipoSolucion:rec.get('codSubtipoSolucion')}
					});
					w.on(app.event.DONE, function(){
						w.close();
						recargarActuacionesExplorar();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
	       }
	   });
   </sec:authorize>
   
   var actuacionesAExplorarGrid = new Ext.grid.GridPanel({
            title : '&nbsp;'
         <app:test id="actuacionesGrid" addComa="true" />
         ,store:actuacionesStore
		 ,cm:cmActuacionesAExplorar
		 ,cls:'cursor_pointer'
		 ,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"} 
         ,style:'padding:50px'
         ,maxHeight:150
         ,height:125
         ,forceFit:true
         ,autoWidth:true
         ,autoHeight:true
		 ,margin:90
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
         ,bbar : [
	        <sec:authorize ifAllGranted="EDITAR_GYA">
	        	btnEditActuacionAExplorar
	        </sec:authorize>
	     ]
   });
     

   actuacionesAExplorarGrid.on('rowclick', function(grid, rowIndex, e) {
   		var rec = grid.getStore().getAt(rowIndex);
		if(rec.get('isActivo')=='false') {
			btnEditActuacionAExplorar.disable();
		} else {
			btnEditActuacionAExplorar.enable();
		}
   });

   var fieldSetActuaciones = new Ext.form.FieldSet({
		title:'<s:message code="acuerdos.actuacionesAExplorar.titulo" text="**Actuaciones A Explorar"/>'
		,autoHeight:true
		,width:575
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false, style:'margin:4px;width:97%',border:true}
		,items : [
		 	actuacionesAExplorarGrid
		]
	});
	
	var labelStyle='font-weight:bolder;width:150px';
	
	var tipoAyuda = new Ext.ux.form.StaticTextField({
		 fieldLabel:'<s:message code="expedientes.consulta.tabgestion.tipoayuda" text="**Tipo Ayuda"/>'
		,name:'tipoAyudaDescripcion'
		,labelStyle:labelStyle
		,value:'${expediente.aaa.tipoAyudaActuacion.descripcion}'
	});
	
	var titulotipoAyuda = new Ext.form.Label({ 
   	text:'<s:message code="expedientes.consulta.tabgestion.descayuda" text="**Descripcion Ayuda"/>'
	,style:'font-weight:bolder; font-size:11;'
	});
	
	var descAyuda=new Ext.form.TextArea({
		fieldLabel:'<s:message code="expedientes.consulta.tabgestion.descayuda" text="**Descripcion Ayuda"/>'
		,width:435
		,height:125
		,hideLabel:true
		,readOnly: true
		,name:'descripcionTipoAyudaActuacion'
		,maxLength: 1024
		,value : '<s:message text="${expediente.aaa.descripcionTipoAyudaActuacion}" javaScriptEscape="true" />'
		<app:test id="campoDescripcion" addComa="true"/> 
	});
	
	
	
	var causasImpago=new Ext.ux.form.StaticTextField({
		fieldLabel:'<s:message code="expedientes.consulta.tabgestion.causasimpago" text="**Causa Impago" />'
		,value:'${expediente.aaa.causaImpago.descripcion}'
		,labelStyle:labelStyle
		,name:'causasImpago'
	});
	
	var titulocomentarios = new Ext.form.Label({
   	text:'<s:message code="expedientes.consulta.tabgestion.comentarios" text="**Comentarios"/>'
	,style:'font-weight:bolder; font-size:11;'
	}); 
	
	var comentarios=new Ext.form.TextArea({
		fieldLabel:'<s:message code="expedientes.consulta.tabgestion.comentarios" text="**Comentarios"/>'
		,width:435
		,height:125
		,hideLabel:true
		,maxLength: 1024
		,readOnly: true
		,name:'comentariosSituacion'
		,value : '<s:message text="${expediente.aaa.comentariosSituacion}" javaScriptEscape="true" />'
		 <app:test id="campoComentario" addComa="true"/> 
	});

	labelObs = new Ext.form.Label({
	   	text:'<s:message code="expedientes.consulta.tabgestion.revision.observaciones" text="**Observaciones:"/>'
		,style:'font-weight:bolder;font-family:tahoma,arial,helvetica,sans-serif;font-size:11px;'
	});

	var revision = new Ext.form.TextArea({
		name: 'revision'
		,value: ''
		,width: 1000
		,height: 125
		,labelStyle: labelStyle
		,style:'margin-top:5px'
		,readOnly: true
		,hideLabel: true
	});
	
	var formGestion = new Ext.form.FormPanel({
		border:false
		,autoHeight:true
		,items:[tipoAyuda, titulotipoAyuda, descAyuda, causasImpago, titulocomentarios, comentarios]
	});
	
	var formRevision = new Ext.form.FormPanel({
		border:false
		,autoHeight:true
		,items:[labelObs,revision]
	});

	var panelGestion = new Ext.form.FieldSet({
		title:'<s:message code="expedientes.consulta.tabgestion.revision" text="**Revisión"/>'
		,border:true
		,style:'padding:5px'
		,height:437
		,width:450
		,defaults : {border:false }
		,monitorResize: true
		,items:[formGestion]
	});
	
	var panelRevision = new Ext.form.FieldSet({
		title:'<s:message code="expedientes.consulta.tabgestion.revision" text="**Revisión"/>'
		,border:true
		,style:'padding:5px'
		,height:200
		,defaults : {border:false }
		,monitorResize: true
		,items:[formRevision]
	});

	var panel = new Ext.Panel({
			autoHeight:true
			,autoWidth:true
			,layout:'table'
			,title:'<s:message code="expedientes.consulta.tabgestion.titulo" text="**Gestion y Analisis"/>'
			,layoutConfig:{columns:2}
			,style:'margin-right:20px;margin-left:10px'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[fieldSetActuacionesRealizadas, <sec:authorize ifAllGranted="ACTUACIONES_EXPLORAR_GESTANA_EXP"> fieldSetActuaciones,</sec:authorize> panelRevision]}
					,{layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[panelGestion]}
					,{colspan:2,items:[panelRevision]}
			]
			,nombreTab : 'tabGestionyAnalisis'
	});
	
	panel.getCodExpediente = function(){
		return entidad.get("data").cabecera.codExpediente;
	}
	
	<sec:authorize ifAllGranted="EDITAR_GYA">
	var btnEditarGyA = new Ext.Button({
           	text: '<s:message code="app.editar" text="**Editar" />'
           	,border:false
           	,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
           	,handler:function(){
                var w = app.openWindow({
                    flow : 'expedientes/editaGestionyAnalisisPropuesta'
                    ,width:650
                    ,title : '<s:message code="expedientes.consulta.tabgestion.edicion" text="**Editar Gestion Analisis y Propuesta" />' 
                    ,params : {id:entidad.getData("gestion").aaa,
                    		   expId: entidad.getData("id")}
                  });
                  w.on(app.event.DONE, function(){
                    w.close();
                    refrescarGestionyAnalisis();
                  });
                  w.on(app.event.CANCEL, function(){ w.close(); });
             }
	});	
	</sec:authorize>
	
	var btnEditarRevision;
	<sec:authorize ifAllGranted="EDITAR_GYA_REV">
		btnEditarRevision = new Ext.Button({
				text: '<s:message code="app.editar" text="**Editar" />'
				,border:false
				,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
				,handler:function(){
				var w = app.openWindow({
				  flow : 'expedientes/editaGestionyAnalisisRevisionPropuesta'
				  ,width:650
				  ,title : '<s:message code="expedientes.consulta.tabgestion.revision.edicion" text="**Editar Revisión de Gestion Analisis y Propuesta" />' 
				  ,params : {id:entidad.getData("gestion.aaa")}
				});
				w.on(app.event.DONE, function(){
				  w.close();
				  refrescarGestionyAnalisisRev();
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		   }
		});
	</sec:authorize>
	
	var refrescarGestionyAnalisis = function(){
		formGestion.load({
				url : app.resolveFlow('expedientes/tabGestionyAnalisisData')
				,params : {id : entidad.getData("id")}
			});
	};

	var refrescarGestionyAnalisisRev = function(){
		formRevision.load({
				url : app.resolveFlow('expedientes/tabGestionyAnalisisData')
				,params : {id : entidad.getData("id")}
			});
	};
	
	<sec:authorize ifAllGranted="EDITAR_GYA">
    	panelGestion.items.add(btnEditarGyA);
	</sec:authorize>
	
	<sec:authorize ifAllGranted="EDITAR_GYA_REV">
		panelRevision.items.add(btnEditarRevision);
	</sec:authorize>
	
 	panel.getValue = function(){};
	panel.setValue = function(){
    	entidad.cacheOrLoad(data,actuacionesRealizadasStore, {id : panel.getCodExpediente()});
    	entidad.cacheOrLoad(data,actuacionesStore, {id : panel.getCodExpediente()});
    	
		causasImpago.setValue(entidad.getData("gestion.causaImpago"));
		comentarios.setValue(entidad.getData("gestion.comentariosSituacion"));
		tipoAyuda.setValue(entidad.getData("gestion.tipoAyuda"));
    	descAyuda.setValue(entidad.getData("gestion.descripcionTipoAyudaActuacion"));
    	revision.setValue(entidad.getData("gestion.revision"));
    	
    	var perfilGestor = entidad.getData('gestion.idGestorActual');
		var perfilSupervisor = entidad.getData('gestion.idSupervisorActual');
		var estadoExpediente = entidad.getData('gestion.estadoExpediente');
		var estadoItinerario = entidad.getData('gestion.estadoItinerario');

		<sec:authorize ifAllGranted="EDITAR_GYA">
			if ((estadoExpediente == app.estExpediente.ESTADO_ACTIVO) &&
			   (permisosVisibilidadGestorSupervisor(perfilGestor) || permisosVisibilidadGestorSupervisor(perfilSupervisor) ) ) {
				btnAltaActuacion.show();
				btnEditActuacion.show();
				btnEditActuacionAExplorar.show();
				btnEditarGyA.show();
			}else{
				btnAltaActuacion.hide();
				btnEditActuacion.hide();
				btnEditActuacionAExplorar.hide();
				btnEditarGyA.hide();
				panelGestion.setHeight(393);
			}
		</sec:authorize>

		<sec:authorize ifAllGranted="EDITAR_GYA_REV">
			if (estadoExpediente != app.estExpediente.ESTADO_CONGELADO && estadoExpediente != app.estExpediente.ESTADO_CANCELADO){
				if ((estadoExpediente != app.estExpediente.ESTADO_CANCELADO && estadoExpediente != app.estExpediente.ESTADO_BLOQUEADO) && 
					(estadoItinerario==app.estItinerario.ESTADO_RE) && (permisosVisibilidadGestorSupervisor(perfilGestor) || permisosVisibilidadGestorSupervisor(perfilSupervisor) ) ){
					btnEditarRevision.show(); 
				}else{
					btnEditarRevision.hide(); 
				}
			}else{
				btnEditarRevision.hide();
			}
		</sec:authorize>
	}
	
	var recargarActuacionesRealizadas = function (){
		entidad.refrescar();
    	entidad.cacheOrLoad(data,actuacionesRealizadasStore, {id : panel.getCodExpediente()});
	};
	
	var recargarActuacionesExplorar = function (){
		entidad.refrescar();
    	entidad.cacheOrLoad(data,actuacionesStore, {id : panel.getCodExpediente()});
	};
	
	panel.setVisibleTab = function(data){
		return entidad.get("data").toolbar.tipoExpediente != 'REC';
   	}
	
	return panel;
})
