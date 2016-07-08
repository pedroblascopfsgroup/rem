<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

var createPanelRevisiones = function() {
//----------------------------------------------------------------------
// Historial de politicas
//----------------------------------------------------------------------
	var width=250;
	var style='text-align:left;font-weight:bolder;width:200;margin:3';

	var cumpleRolEnPolitica = function(perfil){
		for (var i=0;i < app.usuarioLogado.perfiles.length; i++){
			if (perfil==app.usuarioLogado.perfiles[i].id){
				return true;
			}
		}
		return false;
	}

	var esGestor =  cumpleRolEnPolitica(${analisisPolitica.cicloMarcadoPolitica.ultimaPolitica.perfilGestor.id});
	var esSupervisor = cumpleRolEnPolitica(${analisisPolitica.cicloMarcadoPolitica.ultimaPolitica.perfilSupervisor.id});
	
	
	var tituloGestor = new Ext.form.Label({
    	text:'<s:message code="analisisPolitica.comentarioGestor" text="**Comentario Gestor" />'
		,style:'font-weight:bolder; font-size:11'
	}); 
	var comentarioGestor=new Ext.form.TextArea({
		fieldLabel:'<s:message code="analisisPolitica.comentarioGestor" text="**Comentario Gestor"/>'
		,id:'comentarioGestor${analisisPolitica.id}'
		,width:380
		,hideLabel: true
		,labelStyle:style
		,name:'comentarioRevGestor'
		,maxLength: 1024
		<c:if test="${analisisPolitica.comentarioGestor!=null}">
			,value : '<s:message text="${analisisPolitica.comentarioGestor}" javaScriptEscape="true" />'
		</c:if>
		<c:if test="${analisisPolitica.comentarioGestor==null}">
			,value : ''
		</c:if>
		,blankText: 'Campo requerido'
		,readOnly:true
	});
	
	var titulosupervisor = new Ext.form.Label({
   	text:'<s:message code="analisisPolitica.comentarioSupervisor" text="**Comentario Supervisor" />'
	,style:'font-weight:bolder; font-size:11'
	}); 
	
	var comentarioSupervisor=new Ext.form.TextArea({
		fieldLabel:'<s:message code="analisisPolitica.comentarioSupervisor" text="**Comentario Supervisor"/>'
		,id:'comentarioSupervisor${analisisPolitica.id}'
		,width:370
		,hideLabel: true
		,labelStyle:style
		,name:'comentarioRevSupervisor'
		,maxLength: 1024
		<c:if test="${analisisPolitica.comentarioSupervisor!=null}">
			,value : '<s:message text="${analisisPolitica.comentarioSupervisor}" javaScriptEscape="true" />'
		</c:if>
		<c:if test="${analisisPolitica.comentarioSupervisor==null}">
			,value : ''
		</c:if>
		,blankText: 'Campo requerido'
		,readOnly:true
	});
	<c:if test="${!verAnalisis}">
	    var btnModificar = 	new Ext.Button({
			text: '<s:message code="analisisPersona.modificar" text="**Modificar" />',
			iconCls: 'icon_edit',
			handler: function(){
				var win = app.openWindow({
					flow: 'politica/editarRevision'
					,title: '<s:message code="analisisOperacion.editar" text="**Editar Análisis" />'
					,closable:true
					,params:{idAppSeleccionado:${analisisPolitica.id}, esGestor:esGestor, esSupervisor:esSupervisor}
					,width: 650
				});
				win.on(app.event.CANCEL,function(){win.close();});
				win.on(app.event.DONE,
					function(){
						win.close();
						refrescarRevision();
					}
				);
			}
		});
	</c:if>
	var panelItems = 
	       [{
				layout:'form'
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
				,items:[tituloGestor,comentarioGestor]
			}
			,{
				layout:'form'
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
				,items:[titulosupervisor,comentarioSupervisor]
			}];
	<c:if test="${!verAnalisis}">
		if (esGestor || esSupervisor ){
			panelItems[panelItems.length] = {
					bodyStyle:'padding:5px;cellspacing:10px'
					,border:false
					,items:[btnModificar]
				}
		}
	</c:if>
	<c:if test="${!verAnalisis}">
		var refrescarRevision = function() {
			panelRev.load({
				url: app.resolveFlow('politica/revisionGesSupData')
				,params:{id:${analisisPolitica.id}}
			});
		};
	</c:if>
	var panelRev = new Ext.form.FormPanel({
			 autoHeight: true
	        ,autoWidth: true
	        ,border:true
	        ,bodyStyle: 'padding:4px'
			,style:'margin-top:8px'
	        ,layout: 'table'
	        ,layoutConfig: {columns:2}
	        ,items: panelItems
    });

	return panelRev;
};