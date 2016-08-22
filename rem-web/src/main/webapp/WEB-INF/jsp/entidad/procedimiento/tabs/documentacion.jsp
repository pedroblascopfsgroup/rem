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
  var panel=new Ext.Panel({
    autoHeight:true
    ,title:'<s:message code="procedimiento.documentacion.titulo" text="**Documentacion" />'
    ,bodyStyle:'padding:10px'
    ,xtype:'fieldset'
    ,style:'padding-right:10px'
    ,nombreTab : 'docRequerida'
  });  

  panel.getProcedimientoId = function(){
    return entidad.get("data").id;
  }

  var docPanel=new Ext.Panel({
    title:'<s:message code="procedimiento.documentacion.titulotexthtml" text="**Documentacion requerida" />'
    ,height:300
    //,width:400
    ,autoWidth:true
        ,autoScroll:true
    ,html:'<div id="entidad-procedimiento-tipoProcedimiento"></div>'
  });

  var fechaRecopilacion = new Ext.ux.form.StaticTextField({
    fieldLabel:'<s:message code="procedimiento.documentacion.fechaRecopilacion" text="**Fecha recopilacion" />'
    <app:test id="fechaRecopilacion" addComa="true" />
    ,labelStyle:'font-weight:bolder;width:250px'
    ,name:'fechaRecopilacion'
    ,value:''
  });

  var fechaRecepcionDocumentacion = new Ext.ux.form.StaticTextField({
    fieldLabel:'<s:message code="procedimiento.documentacion.fechaRecepcionDocumentacion" text="**Fecha recopilacion" />'
    <app:test id="fechaRecepcionDocumentacion" addComa="true" />
    ,labelStyle:'font-weight:bolder;width:250px'
    ,name:'fechaRecepcionDocumentacion'
    ,value:''
  });
  
  var tituloobservaciones = new Ext.form.Label({
     text:'<s:message code="procedimiento.documentacion.observaciones" text="**Observaciones" />'
  ,style:'font-weight:bolder; font-size:11'
  }); 
  var observacionesRecopilacion = new Ext.form.TextArea({
      fieldLabel:'<s:message code="procedimiento.documentacion.observaciones" text="**Observaciones" />'
      <app:test id="observacionesRecopilacion" addComa="true" />
      ,name: 'observacionesRecopilacion'
      ,hideLabel:true
      ,value:''
      ,width: 710
      ,height:200
      //,autoWidth:true
      ,maxLength: 500
      ,readOnly:true
      ,labelStyle:'font-weight:bolder'
  });

  var btnEditar=new Ext.Button({
    text:'<s:message code="procedimiento.documentacion.recopilada" text="**Recopilada" />'
    ,iconCls:'icon_edit'
    ,handler:function(){
      var w = app.openWindow({
        flow:'procedimientos/recopilarDocProcedimiento'
        ,closable:true
        ,width:600
        ,title : '<s:message code="procedimiento.documentacion.modificarRecopilacion" text="**Modificar informacion recopilacion" />'
        ,params:{idProcedimiento:panel.getProcedimientoId()}
      });
      w.on(app.event.DONE, function(){
          w.close();
          refrescar();
      });
      w.on(app.event.CANCEL, function(){ 
          w.close(); 
      });
        }
  });
  
  var panelCampos = new Ext.form.FormPanel({
    border:false
    ,autoHeight:true
    ,items:[{
        layout : 'table'
        ,layoutConfig:{columns:2}
        ,border : false
        ,defaults : {xtype: 'fieldset', autoHeight: true, border: false ,cellCls: 'vtop', bodyStyle: 'padding:2px'}
        ,items:[
            { items : fechaRecopilacion ,columnWidth:.5}
            ,{ items : fechaRecepcionDocumentacion ,columnWidth:.5}
            ,{items:tituloobservaciones,colspan:2}
            ,{items:observacionesRecopilacion,colspan:2}
	  ]
      }]
  });

  var panelRecopilacion = new Ext.form.FieldSet({
    title:'<s:message code="procedimiento.documentacion.informacionRecopilacion" text="**Informacin de recopilacin" />'
    ,border:true
    ,autoHeight:true
    ,autoWidth:true
    ,defaults : {border:false }
    ,monitorResize: true
    ,items:[    
      {items:panelCampos}
      <c:if test="${esSupervisor}">
        ,{items: btnEditar}
      </c:if>
    ]
  });

  var refrescar = function(){
    panelCampos.load({
      url : app.resolveFlow('procedimientos/recopilarDocProcedimientoData')
      ,params : {idProcedimiento:panel.getProcedimientoId()}
    });
  };

  panel.getValue = function(){
  }

  panel.setValue = function(){
  var data = entidad.get("data");
        var d = data.documentacion;
  
   //convertimos a html en 2 pasos puesto que el html viene escapado en JSON
   var doc=document.getElementById('entidad-procedimiento-tipoProcedimiento');
   doc.innerHTML= d.tipoProcedimiento;
   doc.innerHTML=doc.textContent || doc.innerText || "";

   fechaRecopilacion.setValue(d.fechaRecopilacion);
   fechaRecepcionDocumentacion.setValue(d.fechaRecepcionDocumentacion);
   observacionesRecopilacion.setValue(d.observacionesRecopilacion);
  }


  panel.add(docPanel);
  panel.add(panelRecopilacion );

  return panel;

})
